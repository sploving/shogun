/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * Written (W) 2011 Sergey Lisitsyn
 * Copyright (C) 2011 Berlin Institute of Technology and Max-Planck-Society
 */

#include <shogun/preprocessor/ClassicMDS.h>
#ifdef HAVE_LAPACK
#include <shogun/preprocessor/DimensionReductionPreprocessor.h>
#include <shogun/mathematics/lapack.h>
#include <shogun/mathematics/arpack.h>
#include <shogun/lib/common.h>
#include <shogun/mathematics/Math.h>
#include <shogun/io/SGIO.h>
#include <shogun/distance/EuclidianDistance.h>
#include <shogun/lib/Signal.h>

using namespace shogun;

CClassicMDS::CClassicMDS() : CDimensionReductionPreprocessor()
{
	m_eigenvalues = SGVector<float64_t>(NULL,0,true);
}

CClassicMDS::~CClassicMDS()
{
	m_eigenvalues.destroy_vector();
}

bool CClassicMDS::init(CFeatures* data)
{
	return true;
}

void CClassicMDS::cleanup()
{
}

CSimpleFeatures<float64_t>* CClassicMDS::apply_to_distance(CDistance* distance)
{
	ASSERT(distance);

	SGMatrix<float64_t> new_feature_matrix = embed_by_distance(distance);

	CSimpleFeatures<float64_t>* new_features =
			new CSimpleFeatures<float64_t>(new_feature_matrix);

	return new_features;
}

SGMatrix<float64_t> CClassicMDS::embed_by_distance(CDistance* distance)
{
	ASSERT(distance->get_num_vec_lhs()==distance->get_num_vec_rhs());
	int32_t N = distance->get_num_vec_lhs();

	// loop variables
	int32_t i,j;

	// get distance matrix
	SGMatrix<float64_t> D_matrix = distance->get_distance_matrix();

	// get D^2 matrix
	float64_t* Ds_matrix = SG_MALLOC(float64_t, N*N);
	for (i=0;i<N;i++)
		for (j=0;j<N;j++)
			Ds_matrix[i*N+j] = CMath::sq(D_matrix.matrix[i*N+j]);

	// centering matrix
	float64_t* H_matrix = SG_MALLOC(float64_t, N*N);
	for (i=0;i<N;i++)
		for (j=0;j<N;j++)
			H_matrix[i*N+j] = (i==j) ? 1.0-1.0/N : -1.0/N;

	// compute -1/2 H D^2 H (result in Ds_matrix)
	cblas_dgemm(CblasColMajor,CblasNoTrans,CblasNoTrans,
			N,N,N,1.0,H_matrix,N,Ds_matrix,N,0.0,D_matrix.matrix,N);
	cblas_dgemm(CblasColMajor,CblasNoTrans,CblasNoTrans,
			N,N,N,-0.5,D_matrix.matrix,N,H_matrix,N,0.0,Ds_matrix,N);

	// cleanup
	SG_FREE(D_matrix.matrix);
	SG_FREE(H_matrix);

	// feature matrix representing given distance
	float64_t* replace_feature_matrix = SG_MALLOC(float64_t, N*m_target_dim);
 
	// status of eigenproblem to be solved
	int eigenproblem_status = 0;	
	#ifdef HAVE_ARPACK
	// using ARPACK
		float64_t* eigenvalues_vector = SG_MALLOC(float64_t, m_target_dim);
		// solve eigenproblem with ARPACK (faster)
		arpack_dsaupd(Ds_matrix, NULL, N, m_target_dim, "LM", 1, false, 0.0,
		              eigenvalues_vector, replace_feature_matrix,
		              eigenproblem_status);
		// check for failure
		ASSERT(eigenproblem_status == 0);

		// reverse eigenvectors order
		float64_t tmp;
		for (j=0; j<N; j++)
		{
			for (i=0; i<m_target_dim/2; i++)
			{
				tmp = replace_feature_matrix[j*m_target_dim+i];
				replace_feature_matrix[j*m_target_dim+i] = 
					replace_feature_matrix[j*m_target_dim+(m_target_dim-i-1)];
				replace_feature_matrix[j*m_target_dim+(m_target_dim-i-1)] = tmp;
			}
		}
		// reverse eigenvalues order
		for (i=0; i<m_target_dim/2; i++)
		{
			tmp = eigenvalues_vector[i];
			eigenvalues_vector[i] = eigenvalues_vector[m_target_dim-i-1];
			eigenvalues_vector[m_target_dim-i-1] = tmp;
		}

		// finally construct embedding
		for (i=0; i<m_target_dim; i++)
		{
			for (j=0; j<N; j++)
				replace_feature_matrix[j*m_target_dim+i] *= 
					CMath::sqrt(eigenvalues_vector[i]);	
		}
		
		// set eigenvalues vector
		m_eigenvalues.destroy_vector();
		m_eigenvalues = SGVector<float64_t>(eigenvalues_vector,m_target_dim,true);
	#else /* not HAVE_ARPACK */
		// using LAPACK
		float64_t* eigenvalues_vector = SG_MALLOC(float64_t, N);
		float64_t* eigenvectors = SG_MALLOC(float64_t, m_target_dim*N);
		// solve eigenproblem with LAPACK
		wrap_dsyevr('V','U',N,Ds_matrix,N,N-m_target_dim+1,N,eigenvalues_vector,eigenvectors,&eigenproblem_status);
		// check for failure
		ASSERT(eigenproblem_status==0);
	
		// set eigenvalues vector
		m_eigenvalues.destroy_vector();
		m_eigenvalues = SGVector<float64_t>(m_target_dim);

		// fill eigenvalues vector in backwards order
		for (i=0; i<m_target_dim; i++)
			m_eigenvalues.vector[i] = eigenvalues_vector[m_target_dim-i-1];

		SG_FREE(eigenvalues_vector);

		// construct embedding
		for (i=0; i<m_target_dim; i++)
		{
			for (j=0; j<N; j++)
			{
				replace_feature_matrix[j*m_target_dim+i] = 
				      eigenvectors[(m_target_dim-i-1)*N+j] * CMath::sqrt(m_eigenvalues.vector[i]);
			}
		}
		SG_FREE(eigenvectors);
	#endif /* HAVE_ARPACK else */
	
	// warn user if there are negative or zero eigenvalues
	for (i=0; i<m_eigenvalues.vlen; i++)
	{
		if (m_eigenvalues.vector[i]<=0.0)
		{
			SG_WARNING("Embedding is not consistent (got neg eigenvalues): features %d-%d are wrong",
			           i, m_eigenvalues.vlen);
			break;
		}
	}	
	
	// cleanup
	SG_FREE(Ds_matrix);

	return SGMatrix<float64_t>(replace_feature_matrix,m_target_dim,N);
}

SGMatrix<float64_t> CClassicMDS::apply_to_feature_matrix(CFeatures* features)
{
	CSimpleFeatures<float64_t>* simple_features = (CSimpleFeatures<float64_t>*) features;
	CDistance* distance = new CEuclidianDistance(simple_features,simple_features);

	SGMatrix<float64_t> new_feature_matrix = embed_by_distance(distance);
	simple_features->set_feature_matrix(new_feature_matrix);

	delete distance;

	return new_feature_matrix;
}

SGVector<float64_t> CClassicMDS::apply_to_feature_vector(SGVector<float64_t> vector)
{
	SG_NOTIMPLEMENTED;
	return vector;
}

#endif /* HAVE_LAPACK */
