classifier_name = 'GPBTSVM';
classifier_epsilon = 1e-05;
init_random = 42;
classifier_labels = [-1, -1, 1, -1, -1, 1, -1, -1, 1, 1, 1];
classifier_tube_epsilon = 0.01;
classifier_accuracy = 0.0001;
kernel_data_train = {'ATATCAATAACGGACAACGACCTTTAACCGTTTCGCAGACCGTCTCCGGTAGGTATGCCC', 'GTGGGAACCAGCCCATTGATTTAGTGGCGAGACCGAGTAAATGCAGTTGAAACACCTGTG', 'AGCGCTCCTAGGTTTATGGAGTTCACTGCACCTGCGATCCCGGGCCAGAGTTCCAGTACT', 'TAGAATTTATCCGATGAAAAGTAAGTCCGCAGGGGGACAAGTTGAATGGTGTAGTCGCTA', 'GAGAACTAATGTAGAAGGTCCCTCCCGCTCTAGTATCTGCACAAACTAAGAAATTCGGGG', 'GCACTGTTAGGTTGATATTCGCCCTTTATGCACTGGCGACGATAGCGAATCTTACGTTGT', 'ATTACACTCACTGCATTCAAAGTCTCGGACGACGTCTCTGTCGGCAAATAAGCGATTTCT', 'AAAGCGACGCGATGAAGTCCTGCCAGCTCCGTTCGGCACATCTGGGACAGCTAACTGCGA', 'TGCGATAGAGTGGTACATCGGAACCAATTCCAGTAATGAGCCTTCTCTCTTATTTATTCT', 'AAGGGATAAAGTGTAGCCAGGTCAGATGATGAGCTTTGCTAGGACTTAACTAGAGCTAGA', 'GTATGACAGTAGTTGTGCTCCCTTCCCGATCCAATCACCACGGCCTCCACTAGACTCGAG'};
kernel_name = 'CommUlongString';
classifier_type = 'kernel';
kernel_feature_class = 'string_complex';
kernel_gap = 0;
classifier_sv_sum = 55;
kernel_order = 3;
classifier_alpha_sum = 0.0;
kernel_alphabet = 'DNA';
classifier_C = 1.5;
kernel_feature_type = 'Ulong';
classifier_label_type = 'twoclass';
classifier_num_threads = 1;
classifier_bias = -0.252624466367;
kernel_data_test = {'ATATCGCTAACAATTCTGCGGTCGAAATTTGCACCTGAAACTGTCCATTAGCGTGGAAAA', 'GGATACACCCCTAAAGATGGGAACGAATATTCAAGGTTGAATAAGCTGATCCCACACCTT', 'ACCATGACAGATTCGTGACTGGTTTAGGTGATGACACACGGGTAATATTGTACGCTAGGG', 'CCTATGTGAGTCTCACTCTTCAGCTCCTCCCCGTCGGCCTGGGAGGGCAATCCAAGGGAG', 'AACCAGGTCACTGGAGAGTTGCTGACACCGCAGTGCTTAAGTTTGGAACGGGCGACTGTC', 'CCCTGTATATCCGTACTCACCTTGTCACCATTCGGTTGTGGAAGCAGAGGTCAGTTCCTA', 'GCACCGTCTAGATTGTGTGTGAGAGCGAACTCCGGCCATACAATAACAATTTTGATTTGA', 'TGTAAATAATATCTGTTAACGTCGATTCCAGGACCGGATGCATTACAGACGGCCGAATAG', 'TCCGTTGAGCCAATCCCTGCACTGGGCTGAAGTCTTAAAGACGGACCGTATGGGCAGGGC', 'TGACTTCTCCTTGTATCAACCCACGCCGTTCGAACTAAATGCGGGATCGACCGATAGTGG', 'GCTCGGCCCTTGGTAAGTTCACACTATCGACATTCATCAGTAATAAGTCTGATCCGCAAC', 'TGTCCAACTTTATCATGACCGCTACCGCGTTTTGTCCCCCTCAGAAACCTGCCCTAATCA', 'ATTGCGTTATAAGCTAGTTACGATTAAATACCGAATTTACGCTGATTAGCCAGTGAGCTC', 'AATCTACCTTACAGCTTCCTTACCAAAGCAATTCCTAACACTGCTAAGGACGGGCACATC', 'CTCCTTGAGTAATATCCATCGGGTGCTGCATCGCAGACGCGTTAAGTTTCCCAATAAATG', 'GTCGAATTCCGAAACTCAGTAACGGTTTGCATCAGCGGCTCCGGTCGATCGAACTGTCCA', 'TATTTGGTAGACAACCGAGAGGGGCTCCGAGGCAATGACGTAATAATGCAAATCGTCAGT'};
classifier_classified = [-1.20698306, -0.400158071, -0.0869014579, -0.0375701037, -0.53776473, 0.180229265, -0.461436718, -0.684758639, -0.746317332, -0.27932745, -0.50498626, -0.517202436, 0.183208746, -0.278322258, -0.234490136, -0.896750557, -0.896042662];
kernel_arg0_use_sign = 'False';
kernel_seqlen = 60;
kernel_reverse = 'False';