/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * Written (W) 2009 Soeren Sonnenburg
 * Copyright (C) 2009 Fraunhofer Institute FIRST and Max-Planck-Society
 */
 
/* Remove C Prefix */
%rename(Preprocessor) CPreprocessor;
%rename(SparsePreprocessor) CSparsePreprocessor;
%rename(PCA) CPCA;
%rename(KernelPCACut) CKernelPCACut;
%rename(NormOne) CNormOne;
%rename(LogPlusOne) CLogPlusOne;
%rename(PruneVarSubMean) CPruneVarSubMean;
%rename(RandomFourierGaussPreproc) CRandomFourierGaussPreproc;

%rename(DimensionReductionPreprocessor) CDimensionReductionPreprocessor;
%rename(ClassicMDS) CClassicMDS;
%rename(LocallyLinearEmbedding) CLocallyLinearEmbedding;
%rename(HessianLocallyLinearEmbedding) CHessianLocallyLinearEmbedding;
%rename(LocalTangentSpaceAlignment) CLocalTangentSpaceAlignment;
%rename(LaplacianEigenmaps) CLaplacianEigenmaps;
%rename(Isomap) CIsomap;
%rename(LandmarkIsomap) CLandmarkIsomap;
%rename(ClassicIsomap) CClassicIsomap;
%rename(LandmarkMDS) CLandmarkMDS;

%rename(SortUlongString) CSortUlongString;
%rename(SortWordString) CSortWordString;

/* Include Class Headers to make them visible from within the target language */
%include <shogun/lib/Compressor.h>
%include <shogun/preprocessor/Preprocessor.h>

/* Templates Class SimplePreprocessor*/
%include <shogun/preprocessor/SimplePreprocessor.h>
namespace shogun
{
    %template(SimpleRealPreprocessor) CSimplePreprocessor<float64_t>;
    %template(SimpleUlongPreprocessor) CSimplePreprocessor<uint64_t>;
    %template(SimpleWordPreprocessor) CSimplePreprocessor<uint16_t>;
    %template(SimpleShortPreprocessor) CSimplePreprocessor<int16_t>;
    %template(SimpleBytePreprocessor) CSimplePreprocessor<uint8_t>;
    %template(SimpleCharPreprocessor) CSimplePreprocessor<char>;
}

/* Templates Class StringPreprocessor*/
%include <shogun/preprocessor/StringPreprocessor.h>
namespace shogun
{
    %template(StringUlongPreprocessor) CStringPreprocessor<uint64_t>;
    %template(StringWordPreprocessor) CStringPreprocessor<uint16_t>;
    %template(StringBytePreprocessor) CStringPreprocessor<uint8_t>;
    %template(StringCharPreprocessor) CStringPreprocessor<char>;
}

/* Templates Class DecompressString*/
%include <shogun/preprocessor/DecompressString.h>
namespace shogun
{
    %template(DecompressUlongString) CDecompressString<uint64_t>;
    %template(DecompressWordString) CDecompressString<uint16_t>;
    %template(DecompressByteString) CDecompressString<uint8_t>;
    %template(DecompressCharString) CDecompressString<char>;
}
%include <shogun/preprocessor/SparsePreprocessor.h>
%include <shogun/preprocessor/PCA.h>
%include <shogun/preprocessor/KernelPCACut.h>
%include <shogun/preprocessor/NormOne.h>
%include <shogun/preprocessor/LogPlusOne.h>
%include <shogun/preprocessor/PruneVarSubMean.h>
%include <shogun/preprocessor/RandomFourierGaussPreproc.h>

%include <shogun/preprocessor/DimensionReductionPreprocessor.h>
%include <shogun/preprocessor/ClassicMDS.h>
%include <shogun/preprocessor/LocallyLinearEmbedding.h>
%include <shogun/preprocessor/HessianLocallyLinearEmbedding.h>
%include <shogun/preprocessor/LocalTangentSpaceAlignment.h>
%include <shogun/preprocessor/LaplacianEigenmaps.h>
%include <shogun/preprocessor/Isomap.h>
%include <shogun/preprocessor/LandmarkIsomap.h>
%include <shogun/preprocessor/ClassicIsomap.h>
%include <shogun/preprocessor/LandmarkMDS.h>

%include <shogun/preprocessor/SortUlongString.h>
%include <shogun/preprocessor/SortWordString.h>

