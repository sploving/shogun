/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * Written (W) 2011 Sergey Lisitsyn
 * Copyright (C) 2011 Berlin Institute of Technology and Max-Planck-Society
 */

#include <shogun/preprocessor/LaplacianEigenmaps.h>
#ifdef HAVE_LAPACK
#include <shogun/preprocessor/DimensionReductionPreprocessor.h>
#include <shogun/mathematics/arpack.h>
#include <shogun/mathematics/lapack.h>
#include <shogun/lib/common.h>
#include <shogun/lib/FibonacciHeap.h>
#include <shogun/mathematics/Math.h>
#include <shogun/io/SGIO.h>
#include <shogun/distance/EuclidianDistance.h>
#include <shogun/lib/Signal.h>

using namespace shogun;

CLaplacianEigenmaps::CLaplacianEigenmaps() :
		CDimensionReductionPreprocessor(), m_k(3), m_tau(1.0)
{
}

CLaplacianEigenmaps::~CLaplacianEigenmaps()
{
}

bool CLaplacianEigenmaps::init(CFeatures* features)
{
	return true;
}

void CLaplacianEigenmaps::cleanup()
{
}

SGMatrix<float64_t> CLaplacianEigenmaps::apply_to_feature_matrix(CFeatures* features)
{
	// shorthand for simplefeatures
	CSimpleFeatures<float64_t>* simple_features = (CSimpleFeatures<float64_t>*) features;
	ASSERT(simple_features);

	// get dimensionality and number of vectors of data
	int32_t dim = simple_features->get_num_features();
	ASSERT(m_target_dim<=dim);
	int32_t N = simple_features->get_num_vectors();
	ASSERT(m_k<N);

	// loop variables
	int32_t i,j;

	// compute distance matrix
	CDistance* distance = new CEuclidianDistance(simple_features,simple_features);
	SGMatrix<float64_t> W_sgmatrix = distance->get_distance_matrix();
	// shorthand
	float64_t* W_matrix = W_sgmatrix.matrix;
	delete distance;

	// init heap to use
	CFibonacciHeap* heap = new CFibonacciHeap(N);
	float64_t tmp;
	// for each object
	for (i=0; i<N; i++)
	{
		// fill heap
		for (j=0; j<N; j++)
			heap->insert(j,W_matrix[i*N+j]);

		// rearrange heap with extracting ith object itself
		heap->extract_min(tmp);

		// extract nearest neighbors, takes ~O(k*log n), and change sign for them
		for (j=0; j<m_k; j++)
			W_matrix[i*N+heap->extract_min(tmp)] *= -1.0;

		// remove all 'positive' distances and change 'negative' ones to positive
		for (j=0; j<N; j++)
		{
			if (W_matrix[i*N+j]>0.0)
				W_matrix[i*N+j] = 0.0;
			else
				W_matrix[i*N+j] *= -1.0;
		}
		
		// clear heap to reuse
		heap->clear();
	}
	delete heap;
	// make distance matrix symmetric with mutual kNN relation
	for (i=0; i<N; i++)
	{
		// check only upper triangle
		for (j=i; j<N; j++)
		{
			// make kNN relation symmetric
			if (W_matrix[i*N+j]!=0.0 || W_matrix[j*N+i]==0.0)
			{
				W_matrix[j*N+i] = W_matrix[i*N+j];
			}
			if (W_matrix[j*N+i]!=0.0 || W_matrix[i*N+j]==0.0)
			{
				W_matrix[i*N+j] = W_matrix[j*N+i];
			}
			
			if (W_matrix[i*N+j] != 0.0)
			{
				// compute heat, exp(-d^2/tau)
				tmp = CMath::exp(-CMath::sq(W_matrix[i*N+j])/m_tau);
				W_matrix[i*N+j] = tmp;
				W_matrix[j*N+i] = tmp;
			}
		}
	}

	// compute D
	float64_t* D_diag_vector = SG_CALLOC(float64_t, N);
	for (i=0; i<N; i++)
	{
		for (j=0; j<N; j++)
			D_diag_vector[i] += W_matrix[i*N+j];
	}

	// W = -W
	for (i=0; i<N*N; i++)
		if (W_matrix[i]>0.0)
			W_matrix[i] *= -1.0;
	// W = W + D
	for (i=0; i<N; i++)
		W_matrix[i*N+i] += D_diag_vector[i];

	#ifdef HAVE_ARPACK
		// using ARPACK DS{E,A}UPD
		int eigenproblem_status = 0;
		float64_t* eigenvalues_vector = SG_MALLOC(float64_t,m_target_dim+1);
		arpack_dsaupd(W_matrix,D_diag_vector,N,m_target_dim+1,"LA",3,false,0.0,eigenvalues_vector,W_matrix,eigenproblem_status);
		ASSERT(eigenproblem_status==0);
		SG_FREE(eigenvalues_vector);
	#else
		// using LAPACK DSYGVX
		// requires 2x memory because of dense rhs matrix usage
		int eigenproblem_status = 0;
		float64_t* eigenvalues_vector = SG_MALLOC(float64_t,N);
		float64_t* rhs = SG_CALLOC(float64_t,N*N);
		// fill rhs with diag (for safety reasons zeros will be replaced with 1e-3)
		for (i=0; i<N; i++)
			rhs[i*N+i] = D_diag_vector[i]!=0 ? D_diag_vector[i] : 1e-3;
		wrap_dsygvx(1,'V','U',N,W_matrix,N,rhs,N,1,m_target_dim+2,eigenvalues_vector,W_matrix,&eigenproblem_status);
		ASSERT(eigenproblem_status==0);
		SG_FREE(rhs);
		SG_FREE(eigenvalues_vector);
	#endif /* HAVE_ARPACK */
	SG_FREE(D_diag_vector);

	SGMatrix<float64_t> new_features = SGMatrix<float64_t>(m_target_dim,N);
	// fill features according to used solver
	for (i=0; i<m_target_dim; i++)
	{
		for (j=0; j<N; j++)
		{
			#ifdef HAVE_ARPACK
				new_features.matrix[j*m_target_dim+i] = W_matrix[j*(m_target_dim+1)+i+1];
			#else
				new_features.matrix[j*m_target_dim+i] = W_matrix[(i+1)*N+j];
			#endif
		}
	}
	W_sgmatrix.destroy_matrix();

	simple_features->set_feature_matrix(new_features);
	return simple_features->get_feature_matrix();
}

SGVector<float64_t> CLaplacianEigenmaps::apply_to_feature_vector(SGVector<float64_t> vector)
{
	SG_NOTIMPLEMENTED;
	return vector;
}

#endif /* HAVE_LAPACK */
