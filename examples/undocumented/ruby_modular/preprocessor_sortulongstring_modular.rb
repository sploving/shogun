# this was trancekoded by the awesome trancekoder
require 'narray'
require 'modshogun'
require 'load'
require 'pp'

traindna = LoadMatrix.load_dna('../data/fm_train_dna.dat')
testdna = LoadMatrix.load_dna('../data/fm_test_dna.dat')

parameter_list = [[traindna,testdna,4,0,False,False],[traindna,testdna,3,0,False,False]]

def preprocessor_sortulongstring_modular(fm_train_dna=traindna,fm_test_dna=testdna,order=3,gap=0,reverse=False,use_sign=False)



	charfeat=StringCharFeatures(DNA)
	charfeat.set_features(fm_train_dna)
	feats_train=StringUlongFeatures(charfeat.get_alphabet())
	feats_train.obtain_from_char(charfeat, order-1, order, gap, reverse)

	charfeat=StringCharFeatures(DNA)
	charfeat.set_features(fm_test_dna)
	feats_test=StringUlongFeatures(charfeat.get_alphabet())
	feats_test.obtain_from_char(charfeat, order-1, order, gap, reverse)

	preproc=SortUlongString()
	preproc.init(feats_train)
	feats_train.add_preprocessor(preproc)
	feats_train.apply_preprocessor()
	feats_test.add_preprocessor(preproc)
	feats_test.apply_preprocessor()

	kernel=CommUlongStringKernel(feats_train, feats_train, use_sign)

	km_train=kernel.get_kernel_matrix()
	kernel.init(feats_train, feats_test)
	km_test=kernel.get_kernel_matrix()
	return km_train,km_test,kernel


end
if __FILE__ == $0
	print 'CommUlongString'
	preprocessor_sortulongstring_modular(*parameter_list[0])

end
