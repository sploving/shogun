import numpy
tt = numpy.genfromtxt('../../../../../data/toy/swissroll_color.dat',unpack=True).T
X = numpy.genfromtxt('../../../../../data/toy/swissroll.dat',unpack=True).T
N = X.shape[1]
preprocs = []

from shogun.Preprocessor import LocallyLinearEmbedding
lle = LocallyLinearEmbedding()
lle.set_k(9)
preprocs.append((lle, "LLE with k=%d" % lle.get_k()))

from shogun.Preprocessor import ClassicMDS
mds = ClassicMDS()
preprocs.append((mds, "Classic MDS"))

from shogun.Preprocessor import LandmarkMDS
lmds = LandmarkMDS()
lmds.set_landmark_number(20)
preprocs.append((lmds,"LMDS with %d landmarks" % lmds.get_landmark_number()))

from shogun.Preprocessor import ClassicIsomap
cisomap = ClassicIsomap()
cisomap.set_k(9)
preprocs.append((cisomap,"K-Isomap with k=%d" % cisomap.get_k()))

from shogun.Preprocessor import LandmarkIsomap
lisomap = LandmarkIsomap()
lisomap.set_landmark_number(500)
lisomap.set_k(9)
preprocs.append((lisomap,"K-LIsomap with k=%d, %d landmarks" % (lisomap.get_k(),lisomap.get_landmark_number())))

from shogun.Preprocessor import HessianLocallyLinearEmbedding
hlle = HessianLocallyLinearEmbedding()
hlle.set_k(6)
preprocs.append((hlle,"Hessian LLE with k=%d" % (hlle.get_k())))

from shogun.Preprocessor import LocalTangentSpaceAlignment
ltsa = LocalTangentSpaceAlignment()
ltsa.set_k(6)
preprocs.append((ltsa,"LTSA with k=%d" % (ltsa.get_k())))

from shogun.Preprocessor import LaplacianEigenmaps
le = LaplacianEigenmaps()
le.set_k(15)
le.set_tau(25.0)
preprocs.append((le,"Laplacian Eigenmaps with k=%d, tau=%d" % (le.get_k(),le.get_tau())))

import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

fig = plt.figure()
swiss_roll_fig = fig.add_subplot(3,3,1,projection='3d')
swiss_roll_fig.scatter(X[0], X[1], X[2], s=10, c=tt, cmap=plt.cm.Spectral)
plt.subplots_adjust(hspace=0.4)

from shogun.Features import RealFeatures

for (i, (preproc, label)) in enumerate(preprocs):
	X = numpy.genfromtxt('../../../../../data/toy/swissroll.dat',unpack=True).T
	features = RealFeatures(X)
	preproc.set_target_dim(2)
	new_feats = preproc.apply_to_feature_matrix(features)
	preproc_subplot = fig.add_subplot(3,3,i+2)
	preproc_subplot.scatter(new_feats[0],new_feats[1], c=tt, cmap=plt.cm.Spectral)
	plt.title(label)
	print preproc.get_name(), 'done'
	
plt.show()
