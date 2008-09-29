accuracy = 1e-08;
dm_train = [2.22507386e-308, 0.833381733, 0.767618497, 0.876646946, 0.851213423, 0.799675047, 0.710804646, 0.826847302, 0.68071896, 0.914497016, 0.861793616;0.833381733, 2.22507386e-308, 0.768476365, 0.661018264, 0.867959919, 0.876137288, 0.892630694, 0.843593798, 0.731337711, 0.931243512, 0.930129812;0.767618497, 0.768476365, 2.22507386e-308, 0.912336293, 0.710725234, 0.575999421, 0.67391033, 0.743127593, 0.6323067, 0.774008827, 0.711409448;0.876646946, 0.661018264, 0.912336293, 2.22507386e-308, 0.585502179, 0.788171255, 0.981364819, 0.78351022, 0.537920104, 0.614651838, 0.720124368;0.851213423, 0.867959919, 0.710725234, 0.585502179, 2.22507386e-308, 0.586560913, 0.766722652, 0.710157505, 0.445096371, 0.552053937, 0.811648288;0.799675047, 0.876137288, 0.575999421, 0.788171255, 0.586560913, 2.22507386e-308, 0.784730172, 0.710181625, 0.754644486, 0.709972895, 0.830586564;0.710804646, 0.892630694, 0.67391033, 0.981364819, 0.766722652, 0.784730172, 2.22507386e-308, 0.809939311, 0.701335227, 0.723485051, 0.76574823;0.826847302, 0.843593798, 0.743127593, 0.78351022, 0.710157505, 0.710181625, 0.809939311, 2.22507386e-308, 0.70598894, 0.547802999, 0.845591651;0.68071896, 0.731337711, 0.6323067, 0.537920104, 0.445096371, 0.754644486, 0.701335227, 0.70598894, 2.22507386e-308, 0.526752973, 0.678571229;0.914497016, 0.931243512, 0.774008827, 0.614651838, 0.552053937, 0.709972895, 0.723485051, 0.547802999, 0.526752973, 2.22507386e-308, 0.874931881;0.861793616, 0.930129812, 0.711409448, 0.720124368, 0.811648288, 0.830586564, 0.76574823, 0.845591651, 0.678571229, 0.874931881, 2.22507386e-308];
init_random = 42;
name = 'ChebyshewMetric';
data_type = 'double';
dm_test = [0.866413933, 0.879883925, 0.916812651, 0.83208633, 0.59407545, 0.854273911, 0.782113915, 0.933022905, 0.889575325, 0.835412016, 0.918431101, 0.691263388, 0.77709202, 0.730347961, 0.82501498, 0.504548071, 0.862110122;0.581992856, 0.739136258, 0.840662382, 0.791265604, 0.670537692, 0.764363484, 0.858576156, 0.943762176, 0.624565682, 0.852158512, 0.78096389, 0.830848939, 0.707690405, 0.760730908, 0.814630792, 0.559404075, 0.653325233;0.892349464, 0.838059517, 0.798995331, 0.898459911, 0.870459604, 0.817495911, 0.713876625, 0.85078576, 0.847750918, 0.878015931, 0.582889838, 0.612128574, 0.735267612, 0.68976691, 0.690519149, 0.747478073, 0.820285715;0.770772191, 0.789957116, 0.780622328, 0.681059867, 0.847646809, 0.646667909, 0.63211622, 0.591706354, 0.722772915, 0.756438658, 0.620079849, 0.791643949, 0.726440919, 0.803996122, 0.96257097, 0.523081314, 0.809776257;0.740072659, 0.788377573, 0.779042785, 0.506343244, 0.60784151, 0.661996125, 0.839057875, 0.433855929, 0.548056292, 0.581722035, 0.827021504, 0.779667239, 0.724861376, 0.786891063, 0.747928803, 0.47789058, 0.802245944;0.834112401, 0.66753984, 0.712361302, 0.774294873, 0.448247002, 0.693330874, 0.704736063, 0.635756794, 0.786113125, 0.819778869, 0.59502109, 0.8716242, 0.604023643, 0.786915184, 0.713699733, 0.446756614, 0.877066224;0.876900234, 0.890370227, 0.85130604, 0.967488438, 0.452674648, 0.886524438, 0.802646971, 0.903096469, 0.900061627, 0.789451105, 0.486995577, 0.475142373, 0.885444663, 0.884826092, 0.386263861, 0.639950179, 0.960387576;0.727265966, 0.682030056, 0.823675925, 0.667929458, 0.681765936, 0.617336241, 0.814691754, 0.859224015, 0.652637655, 0.591488422, 0.802655383, 0.755301119, 0.690992858, 0.613504109, 0.791145462, 0.631113949, 0.765935772;0.85521081, 0.846396174, 0.671218155, 0.765498486, 0.467321021, 0.603135241, 0.676737971, 0.641471497, 0.807211533, 0.840877277, 0.429516708, 0.719608865, 0.855358977, 0.777870227, 0.682541377, 0.37625865, 0.93030189;0.65297506, 0.801724583, 0.610784269, 0.480137415, 0.714149562, 0.566994504, 0.902341468, 0.701120447, 0.453994777, 0.487660521, 0.890305097, 0.842950832, 0.810687385, 0.733198636, 0.782833679, 0.52081229, 0.885630299;0.875506806, 0.832288222, 0.822953434, 0.734953973, 0.964634723, 0.797430272, 0.840146089, 0.851953945, 0.72209269, 0.795846881, 0.770250903, 0.576027359, 0.768772025, 0.92232521, 0.784694268, 0.841653192, 0.887821426];
data_train = [0.374540119, 0.950714306, 0.731993942, 0.598658484, 0.15601864, 0.15599452, 0.0580836122, 0.866176146, 0.601115012, 0.708072578, 0.0205844943;0.969909852, 0.832442641, 0.212339111, 0.181824967, 0.18340451, 0.304242243, 0.524756432, 0.431945019, 0.29122914, 0.611852895, 0.139493861;0.292144649, 0.366361843, 0.456069984, 0.785175961, 0.199673782, 0.514234438, 0.592414569, 0.0464504127, 0.607544852, 0.170524124, 0.065051593;0.948885537, 0.965632033, 0.808397348, 0.304613769, 0.097672114, 0.684233027, 0.440152494, 0.122038235, 0.49517691, 0.0343885211, 0.909320402;0.258779982, 0.662522284, 0.311711076, 0.520068021, 0.546710279, 0.184854456, 0.969584628, 0.775132823, 0.939498942, 0.89482735, 0.597899979;0.921874235, 0.0884925021, 0.195982862, 0.0452272889, 0.325330331, 0.38867729, 0.271349032, 0.828737509, 0.356753327, 0.28093451, 0.542696083;0.140924225, 0.802196981, 0.0745506437, 0.986886937, 0.772244769, 0.198715682, 0.00552211712, 0.815461428, 0.706857344, 0.729007168, 0.771270347;0.0740446517, 0.358465729, 0.11586906, 0.863103426, 0.623298127, 0.330898025, 0.0635583503, 0.310982322, 0.325183322, 0.729606178, 0.637557471;0.887212743, 0.472214925, 0.119594246, 0.713244787, 0.760785049, 0.561277198, 0.77096718, 0.493795596, 0.522732829, 0.427541018, 0.0254191267;0.107891427, 0.0314291857, 0.636410411, 0.314355981, 0.508570691, 0.907566474, 0.249292229, 0.410382923, 0.755551139, 0.228798165, 0.0769799098;0.289751453, 0.161221287, 0.929697652, 0.80812038, 0.633403757, 0.87146059, 0.803672077, 0.186570059, 0.892558998, 0.539342242, 0.807440155];
feature_class = 'simple';
data_test = [0.8960913, 0.318003475, 0.110051925, 0.227935163, 0.427107789, 0.818014766, 0.860730583, 0.00695213053, 0.510747303, 0.417411003, 0.22210781, 0.119865367, 0.337615171, 0.942909704, 0.323202932, 0.518790622, 0.703018959;0.363629602, 0.971782083, 0.962447295, 0.251782296, 0.497248506, 0.30087831, 0.284840494, 0.0368869474, 0.609564334, 0.502679023, 0.0514787512, 0.278646464, 0.908265886, 0.239561891, 0.144894872, 0.48945276, 0.985650454;0.242055272, 0.672135547, 0.761619615, 0.237637544, 0.728216349, 0.367783133, 0.632305831, 0.633529711, 0.535774684, 0.0902897701, 0.835302496, 0.320780065, 0.18651851, 0.0407751416, 0.590892943, 0.677564362, 0.0165878289;0.512093058, 0.226495775, 0.64517279, 0.174366429, 0.690937738, 0.386735346, 0.936729989, 0.137520944, 0.341066351, 0.113473521, 0.924693618, 0.877339353, 0.257941628, 0.659984046, 0.8172222, 0.555200812, 0.529650578;0.241852291, 0.0931027678, 0.897215758, 0.900418057, 0.633101457, 0.339029791, 0.349209575, 0.725955679, 0.89711026, 0.887086424, 0.779875546, 0.642031646, 0.084139965, 0.161628714, 0.898554189, 0.60642906, 0.00919705162;0.101471543, 0.663501769, 0.00506158385, 0.160808051, 0.548733789, 0.691895198, 0.65196126, 0.224269309, 0.712179221, 0.237249087, 0.325399698, 0.746491405, 0.649632899, 0.84922341, 0.657612892, 0.568308603, 0.0936747678;0.367715803, 0.265202368, 0.243989643, 0.973010555, 0.393097725, 0.892046555, 0.631138626, 0.794811304, 0.502637093, 0.576903885, 0.492517694, 0.195242988, 0.722452115, 0.280772362, 0.0243159664, 0.645472296, 0.177110679;0.940458584, 0.953928577, 0.91486439, 0.3701587, 0.0154566165, 0.928318563, 0.428184148, 0.966654819, 0.963619977, 0.853009455, 0.294448892, 0.385097729, 0.851136672, 0.316922005, 0.169492747, 0.556801262, 0.936154774;0.696029797, 0.57006117, 0.0971764938, 0.615007227, 0.99005385, 0.140084015, 0.518329652, 0.877373072, 0.740768618, 0.697015741, 0.702484084, 0.359491151, 0.293591844, 0.809361155, 0.810113395, 0.867072319, 0.913240553;0.511342399, 0.501516295, 0.798295179, 0.649963931, 0.701966877, 0.795792669, 0.890005342, 0.337995157, 0.375582953, 0.0939819398, 0.578280141, 0.0359422738, 0.465598018, 0.542644635, 0.286541252, 0.590833261, 0.0305002499;0.0373481887, 0.822600561, 0.360190641, 0.127060513, 0.52224326, 0.769993553, 0.215821027, 0.622890476, 0.085347465, 0.0516817212, 0.531354632, 0.540635122, 0.637429901, 0.726091334, 0.975852079, 0.516300348, 0.322956473];
data_class = 'rand';
feature_type = 'Real';