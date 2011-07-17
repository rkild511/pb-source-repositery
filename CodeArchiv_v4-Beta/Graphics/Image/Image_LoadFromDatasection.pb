; English forum: http://www.purebasic.fr/english/viewtopic.php?t=18730
; Author: netmaestro (updated for PB 4.00 by Andre)
; Date: 17. January 2006
; OS: Windows
; Demo: Yes


; This little source is more a joke, but I put it in the CodeArchive
; to show you how including a picture inside code is possible...


; ---------------------------------------------------------------------
; There are many passages in the bible which describe the antichrist.
; This program takes all of the information given in all the passages
; and uses it to piece together an accurate portrayal of what this
; individual actually looks like. See for yourself the fearsome features...

Restore dimensionstart
Read w.l
Read h.l
numpoints=w*h

Dim col.l(numpoints+1)
Restore imagestart
For i = 0 To numpoints-1
  Read col(i)
Next i

CreateImage(1,w,h)
Sccount=0
StartDrawing(ImageOutput(1))
For i = 0 To w-1
  For j = 0 To h-1
    Plot(i,j,col(ccount))
    ccount+1
  Next j
Next i
StopDrawing()
w=w*3:h*3:ResizeImage(1,w,h)

OpenWindow(0,0,0,w,h,"Worship Me!",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
CreateGadgetList(WindowID(0))
ImageGadget(0,0,0,w,h,ImageID(1))
Repeat
  ev=WaitWindowEvent()
Until ev = #PB_Event_CloseWindow
End

DataSection
  dimensionstart:
  Data.l 50,83
  imagestart:
  Data.l 2764345,3948619,3751240,2435380,2172208,2501173,2435380,2961980,2895930,2633016,2764603,2896190,3225416
  Data.l 3028041,3818078,5134716,5792912,5924767,6122144,6253730,6450852,6188451,6122915,6123171,6188964,6056354
  Data.l 4477067,5662371,6057651,6452162,6780620,6780621,6780365,6780365,6714315,6516676,6450621,6581177,6449842
  Data.l 6253229,6121386,6055592,5990055,5924520,5924520,5924520,5924520,5924774,5924773,5924773,5924774,5858726
  Data.l 5990060,6451129,6517697,6452421,6715081,6780618,6780618,6649289,6648259,6647484,6450101,6187439,6121386
  Data.l 5990567,5858978,5727901,5201811,3952253,3426164,2965613,2965613,3162992,3162990,3162990,3162990,3162990
  Data.l 3228783,3491955,3820920,4149885,4281471,3093310,3619654,3948619,2698552,2172208,2566966,2698552,2961724
  Data.l 2698807,2699577,2700097,3687259,4146273,3685466,4278380,5462916,6055832,6122407,6056612,6122659,6254500
  Data.l 6122917,6122917,6122917,5794209,6187938,4476551,5068696,6187700,6911941,6715334,6846923,6912207,6780112
  Data.l 6910411,6778822,6713538,6450876,6384311,6645683,6448814,6449323,6252198,5924518,5924518,5924518,5924518
  Data.l 5924518,5924518,5990311,6056104,5924777,6056883,6517694,6584005,6452423,6845900,6911437,6911437,6911437
  Data.l 6780364,6451653,6319549,6318261,6186414,5990314,5858724,5661855,5201558,4018046,3426163,3031406,2768235
  Data.l 2965613,3031404,3031404,3162990,3162990,3294576,3491955,3689334,3952506,4018299,3159103,3817033,4277584
  Data.l 2764345,2303794,2830138,2830138,3093310,2764856,3094335,3686992,4345188,4673132,4870514,5002363,5661070
  Data.l 6188190,6451372,6385577,6254245,6122913,6122398,6188191,5727639,5069709,5924762,4674184,4345227,5793453
  Data.l 6846403,6715334,6912459,7043793,6911954,6910928,6779339,6779849,6648772,6516156,6646199,6449330,6317997
  Data.l 6121128,5924518,5924518,5924518,5924518,5924518,5924518,5990311,6056104,6056107,6385594,6846148,6780875
  Data.l 6649548,6845901,6911437,6911437,6911437,6911950,6780874,6648513,6515640,6318000,5990314,5858724,5661855
  Data.l 5201558,4149632,3557750,3162992,2768234,2965612,3031404,3031404,3162990,3162990,3294576,3491955,3623541
  Data.l 3755127,3886713,4474963,4935514,4409170,2632759,2435380,2830138,3224896,3553861,3488323,3554885,3621199
  Data.l 3818844,4805491,5528961,5529739,6056860,6780588,6582957,6451370,6254501,5925535,5661330,5068935,4279419
  Data.l 4674177,5529742,5463953,4279943,5596582,6583484,6517955,6846666,7109586,7109077,6977237,6846163,6780879
  Data.l 6583755,6582981,6646975,6252983,6055857,5924524,5924518,5924518,5924518,5924518,5990311,6056104,6056104
  Data.l 6056103,6122157,6582465,6845897,6912207,6780881,6977488,7043023,6977230,6911437,6846157,6714825,6780099
  Data.l 6713276,6383793,5990314,5858724,5793441,5464730,4478598,3689336,3294578,2702441,2768233,2965611,2965611
  Data.l 3097197,3097197,3162990,3360369,3557748,3623541,3689334,5198686,5001307,4211791,2303794,2830138,3027773
  Data.l 3619654,3751240,4146253,3949644,3358283,3424085,4674164,5463943,5662354,6452134,7044276,7043508,6582956
  Data.l 6451624,6188707,5923986,4213109,3423593,4541818,4871553,5464463,4543369,5596836,6583994,6452419,6846922
  Data.l 7240915,7240663,6912218,6846681,6781141,6584271,6649292,6779335,6385087,6187960,6056627,6253483,5990310
  Data.l 5924518,5924518,5990311,6056104,6056104,6187689,6450866,6779334,6976973,6911953,6780628,6977488,7043023
  Data.l 6977230,6911437,6846157,6714824,6780099,6713276,6383793,5990314,5858724,5793441,5464730,4610184,3821178
  Data.l 3491957,2899820,2834026,2834025,2834025,2965611,2965611,3162990,3360369,3491955,3491955,3491955,5658467
  Data.l 5395295,3947848,2368562,3091773,3553093,3817802,4213073,4212306,3752018,3423321,3817832,5133697,5660302
  Data.l 6055836,6977202,7372478,6912698,6517422,6451109,6319263,4870790,3292011,3489645,4542587,4213619,5003650
  Data.l 4412036,5465253,6451904,6452163,6518473,6979287,6980061,6781912,6781398,6846419,6845648,6976460,7042246
  Data.l 6779074,6516159,6516157,6319031,6121394,5924525,5925035,6055850,6186922,6186922,6384299,6845114,6714572
  Data.l 6911951,6911952,6911952,6911951,6911951,6846158,6780365,6714828,6714824,6714305,6647735,6449839,5924264
  Data.l 5924518,5925027,5596316,4807562,3952764,3426164,2899820,2899050,3226987,3030635,2768490,2769004,3162733
  Data.l 3359856,3425648,3557234,3491955,5724003,5131866,3092282,2565428,3420996,3421767,3884115,3621200,3554132
  Data.l 3949154,4343922,5068166,5397131,5923221,6713514,7372221,7175359,6518198,6517422,6319267,4739717,3160428
  Data.l 3160426,4148086,4872062,3687529,3819629,3688823,5399460,6386369,6255813,6650831,7309280,7375846,6914524
  Data.l 6584787,6584017,6780112,6911181,7042761,6845382,6714053,6714053,6648004,6451136,6254009,6254262,6319026
  Data.l 6318513,6187183,6318768,7042497,6714573,6846415,6911951,6911951,6911951,6911951,6846158,6780365,6780876
  Data.l 6649285,6451387,6384817,6055592,5924264,5924518,6188199,6122660,5333906,4215680,3491957,3031406,2965099
  Data.l 3227244,2899564,2637419,2638189,2965868,2965611,2965611,3097197,3228783,4473936,3816006,2697524,2960955
  Data.l 3290696,2962504,2699851,3094871,4672373,5264770,5265288,5134988,5463697,6121888,6846131,7109824,6583739
  Data.l 6518198,6846387,6187680,3424113,3029095,3292521,4148082,4938365,3359073,2964572,3162987,5794726,6913478
  Data.l 6651598,7178458,7310564,7113702,7245029,6783451,6519252,6584017,6714832,6845902,6780109,6714316,6714316
  Data.l 6648524,6582985,6451651,6386368,6517185,6648257,6648257,6779843,6977480,6780365,6780365,6846158,6846158
  Data.l 6846158,6846158,6846158,6780366,6649289,6386622,5991345,6056361,6055845,6055850,6187689,6188199,6122660
  Data.l 5728665,4478852,3689336,3294578,2965613,2965356,2703212,2375275,2441838,2638444,2506601,2506600,2572394
  Data.l 2900589,3815749,3158076,2368560,3553348,3423307,3225938,3357791,4278901,5330312,5528461,5003914,4939145
  Data.l 5333140,6319785,7044028,7110342,6978756,7307457,7109559,5398165,2963563,2766434,3292773,4411764,4741239
  Data.l 2438224,2767959,3492206,5137306,7111369,6915798,7442401,7311591,6983400,7311851,7245029,6849244,6650580
  Data.l 6583761,6715091,6715091,6583505,6583505,6583251,6583505,6452429,6452682,6583499,6714316,6648523,6714059
  Data.l 6780365,6846158,7043280,7043281,7043281,7109072,7109073,7109073,6780110,6451909,5794995,5728939,6056870
  Data.l 6121890,6121643,6253739,6122406,5925281,5728664,4939402,4149887,3623543,3031406,2637676,2506860,2311022
  Data.l 2179950,2442092,2310249,2310249,2310506,2703723,3289662,2566452,2764343,3686224,4279144,4739444,4871037
  Data.l 5068419,5462406,5397640,5069447,5004937,5464985,6386095,7242179,7111113,7242958,7439562,6583215,4214144
  Data.l 2766949,3292771,4477043,5069689,4674928,1648707,2833241,4280953,4807567,6716348,7311069,7377893,7378668
  Data.l 7312876,7377898,7311591,7442406,6915548,6585815,6716375,6715861,6715091,6714834,6649300,6649556,6649810
  Data.l 6650064,6846417,6977489,6649038,6386125,6583761,6715857,7110870,7242454,7242709,7045337,6979288,7044563
  Data.l 6846412,6122936,5597352,5926058,5991333,5990818,6187433,6384810,6385065,6319527,5991328,5399958,4478854
  Data.l 3755385,2966125,2571885,2572911,2508146,2179952,2245230,2179178,2310249,2375784,2637671,2960954,2830653
  Data.l 3423815,4147812,4871043,5200005,5200004,5397125,5527937,5528709,5397643,5464210,5793698,6254770,7045059
  Data.l 6980040,7045583,7373777,5727392,3292779,2701663,3687522,5266296,5529979,4082531,1319228,2963805,4609152
  Data.l 5398675,5728419,7310550,7575785,7248108,7379434,7575273,7443431,7706859,7180516,6851039,6915037,6716887
  Data.l 6781397,6846418,6649810,6649810,6649810,6649810,6781135,6846670,6649806,6584272,6781908,7111639,7112149
  Data.l 6849486,6849740,6783701,6651601,7045068,6846399,5793447,6056870,6254250,6122664,6122921,6516394,6648237
  Data.l 6582444,6582188,6385580,6057383,4807823,3558263,3097967,2900337,2769778,2507634,2311282,2179441,2113388
  Data.l 2309992,2375268,2505825,2895676,2698816,3686485,4739186,5002627,5134211,5134468,5265797,5527684,5528457
  Data.l 5594769,5792921,6056361,6254516,6912963,7045324,7176913,7438537,5068687,3489641,2898268,3358557,5200760
  Data.l 5661566,3029844,1450815,3293027,5332874,5991070,5136024,6519229,8034533,7510507,7248361,7444715,7444459
  Data.l 7576045,7576045,7246567,7047394,6717658,6716630,6650067,6715603,6649810,6649810,6715347,6584785,6518991
  Data.l 6847695,7439059,7439056,6847171,6254775,6058161,6124207,6123182,5728167,6451376,6187945,6056873,6320304
  Data.l 6715318,6583475,6123181,6188974,6386353,6320303,6254510,6254511,6254765,5071255,3426937,3295350,3097716
  Data.l 2703985,2442098,2311282,2245234,2179181,2244200,2243682,2242654,2633019,3027789,4278122,4936572,4936833
  Data.l 5134211,5200004,5199748,5527432,5725071,5725846,6121120,6384816,6517435,6715075,6979280,7307986,7306433
  Data.l 4607618,3488865,3029079,3226714,5266297,5858944,2700878,1713987,4082286,6582941,6780329,5267352,5858723
  Data.l 7770071,7707626,7117544,7248620,7314157,7314157,7314413,7313388,7048935,6916322,6651865,6453715,6781396
  Data.l 6649553,6649810,6649810,6388436,6652375,7045327,6911936,6582451,6384552,6319269,6582694,6385568,6121368
  Data.l 5923992,6385318,6188712,6452147,6386102,7044031,7372996,7175617,6913215,6650043,6321078,6189749,6254772
  Data.l 6254770,5202589,3426942,3229559,3032180,2703985,2442098,2311282,2179698,2179181,2244200,2111839,2111068
  Data.l 2632764,3290964,4409201,5001856,5200004,5265797,5200004,5265285,5527177,5659536,5923228,6318761,6647992
  Data.l 6648512,6451906,6716109,7373523,7437502,4146294,3356506,3291222,2963285,4542573,5924481,3161173,1253180
  Data.l 4674679,7701422,7306931,5727133,5988765,7769298,7707881,7052264,7183083,7248877,7183341,7183341,7314414
  Data.l 7378926,7246313,6916064,6717658,6847704,6650068,6584018,6978774,6849500,6981596,6189759,5925036,6515880
  Data.l 6646175,6580892,6581402,6186641,5396869,5002886,6253988,6189485,6584505,6320311,6583739,7504585,7899857
  Data.l 7769041,7703248,7045061,6058167,6123446,6320821,5531812,3558787,3229562,3229559,2835828,2507634,2311282
  Data.l 2113647,2047338,2112357,1980253,1979225,2697530,2961477,3685210,4804212,5462916,5528199,5396360,5593484
  Data.l 5527689,5331087,5726626,6253492,6386111,6386369,6452162,6583748,7241421,6911160,3751529,3816021,3881044
  Data.l 3290963,3949663,6054782,3488855,1054773,3687784,7373229,7438519,6055331,5792421,7443675,7249898,6985440
  Data.l 7641319,7707371,7445225,7249129,7380718,7642866,7708143,7312356,7245536,7180007,7178983,7440870,7572192
  Data.l 7506392,6321345,5793201,6515887,6580902,6645408,6580638,6384281,5266567,3225961,3357806,6121376,6385321
  Data.l 6912439,6648502,6122673,6846145,8030934,7704021,7769043,7570637,6648252,6385589,6386356,5794470,4084360
  Data.l 3690111,3426681,2901365,2573427,2245489,2244207,2243946,2308709,2307677,2044503,3553092,3159109,2830153
  Data.l 3949158,5199744,5396613,5396360,5593484,5527689,5331087,5989798,6582458,6517697,6386369,6386369,6386369
  Data.l 7110090,7241148,3818092,3553876,3685202,3291218,4015200,6186368,3423062,791856,2437714,6518174,7636152
  Data.l 6252965,5924519,7706589,7380453,6720210,6916825,7443941,7445225,7183593,7511535,8233206,8825080,8890608
  Data.l 8890604,8759793,8889846,8559345,7506140,6190529,5466289,6385591,7042486,6515618,6646173,6515100,6055318
  Data.l 4542849,2239067,3028585,6121632,5990563,6254506,6320046,5991084,6583225,8031445,7901400,7900629,7833809
  Data.l 7174595,6517175,6517941,5465505,4479118,3953027,3426681,2901365,2573427,2245489,2244207,2243946,2308709
  Data.l 2307677,2044503,3422015,3554376,3027785,3423069,4738937,5331077,5396360,5593484,5527689,5396623,6055591
  Data.l 6714044,6517697,6386369,6452162,6386369,7045066,8031949,5924503,3159639,3423057,3225682,3554649,6186368
  Data.l 3949149,857647,1780293,5400202,7636917,6319524,5860006,7772633,7839203,7178188,6389965,7181026,7576554
  Data.l 7249130,7314412,8035571,8627700,9350901,10074362,9877497,8823534,7637467,6386371,5598130,6453436,7372996
  Data.l 6977201,6318747,6515351,6449561,5857685,4673672,2501983,3818101,6911148,5859234,5596575,5991333,5991594
  Data.l 6452150,8097491,8032986,8163801,8162517,7240389,6780347,6188720,4873368,4347789,3887234,3426938,2835571
  Data.l 2573427,2245489,2375792,2178153,2243172,2307677,2044503,3685184,4607060,3817810,3291738,4607608,5396613
  Data.l 5396360,5593484,5527689,5396623,5923749,6516665,6451904,6386369,6452162,6451905,6452932,6848197,7832254
  Data.l 4343922,3028819,3291475,2699339,4870252,4936046,1252660,1254202,4084852,7439536,6517156,5729443,7707094
  Data.l 7377877,6846651,7376089,7838957,7511018,7249130,7183339,7379437,7576043,7970028,8627185,8888815,7703260
  Data.l 6715337,6911940,7308744,7440841,7373250,6714540,6187670,6515602,6449560,6251933,5133714,2765156,5200009
  Data.l 7371699,5924771,5202073,5333912,5465759,6583989,7900366,7967449,8163802,8031188,7174852,6648505,5596583
  Data.l 4675989,4215946,3755391,3492473,3032950,2573427,2245489,2375792,2178153,2243172,2307677,2044503,3685447
  Data.l 4738645,4343380,3750491,4935032,5462149,5331081,5331339,5266311,5332112,5858470,6385338,6517441,6386369
  Data.l 6386369,6386369,6386113,6517185,7438020,6319006,3094617,3029332,2108485,2503240,4082527,1319734,596529
  Data.l 2834269,6913186,6321312,5532320,7046592,5534126,5993395,7904228,7576809,7314410,6920939,6986475,7182825
  Data.l 7248618,7509993,7771623,7704799,6980306,7242193,7965141,7637715,7309517,7636161,6976677,6449813,6252949
  Data.l 6187413,6253215,5068438,2502755,5397653,7306676,5466266,4939411,4544137,4412299,6056871,8096714,8426969
  Data.l 8360665,7504846,6911942,6451897,5268387,4479380,3953543,3362174,2770553,2508148,2311280,2114413,2376049
  Data.l 2243946,2243172,2242141,2175575,3356229,4277838,4409171,4012894,5065848,5527685,5331081,5134474,4937862
  Data.l 5135248,5595555,6319800,6517698,6386369,6386369,6386369,6517442,6714053,7175622,7043763,3949934,2634577
  Data.l 1779779,1319479,1846332,1846591,1254203,1517895,4150134,5861272,6452395,5794725,5006496,6389180,7377880
  Data.l 7115739,7116258,7380205,7248875,7183080,7183337,7510761,7311070,5862846,6191296,7571667,7964886,7505360
  Data.l 7506122,7570363,6910367,6580885,6252952,6187928,5925020,4476813,2240096,5791904,7175604,5269655,4873617
  Data.l 4149378,3951490,5332890,7767234,8558040,8163028,7307211,6912200,6517949,6057905,4874396,4217229,3428225
  Data.l 2639227,2442356,2311279,2179691,2441585,2309739,2308708,2242141,2241111,3948365,4738645,4738136,4013151
  Data.l 5065848,5527685,5396873,5265805,4937355,4937358,5332637,6254515,6517952,6517955,6386369,6386369,6517699
  Data.l 6649800,6847432,7043772,5200013,2963290,2305613,1318971,1385272,2438473,2504527,2175825,3623534,5992345
  Data.l 6451367,5267611,5071006,5400488,5467824,5731768,5995459,6917078,7247073,7182567,7182824,7181026,5139386
  Data.l 3164813,3493264,5728429,7767242,7701700,7504312,6319519,6318999,6515862,6450585,6450846,5924509,4082053
  Data.l 2437221,6975668,7174838,5334940,4873363,4478343,3885698,4872083,7175098,8031696,7899857,7438797,6780613
  Data.l 6451902,6518204,5926574,4677271,3690630,2901371,2704243,2507374,2507372,2507377,2309739,2374502,2176348
  Data.l 2241110,4277330,4541266,5593445,4276066,5131641,5659271,5593996,5528721,5331348,5134227,5530272,6123693
  Data.l 6583742,6781128,6517698,6517697,6518467,6519241,6519242,6912452,6317994,3620968,2963288,1713476,1648193
  Data.l 2570061,2504526,2307668,3953013,5466001,5923739,5463961,5201564,5136545,5268129,5597865,5861812,5993915
  Data.l 6060741,6653142,6916826,5204668,4149668,3952282,3096710,3754630,6320293,7042726,6449815,6055570,6187669
  Data.l 6385046,6516632,6713765,5924256,3621757,3028847,7633345,7437758,5334431,4609937,4478343,3951490,4477325
  Data.l 6517168,7373766,7504842,7306954,6912199,6780613,6649280,6452665,5268900,3689864,3295102,2966645,3032691
  Data.l 3032946,2704758,2507119,2506087,2176091,2175574,5000540,6053993,5264737,4211297,5198460,5659786,5594766
  Data.l 5595283,5463451,5201049,5267614,6123437,6781378,7307729,7307986,6584778,6387399,6388168,6519241,6715332
  Data.l 6910907,4410748,3555175,2634325,2042182,2766414,2635342,2372945,2767967,4281214,5463702,5661086,5727396
  Data.l 5398948,5530271,5530527,5530788,5794477,5860535,5663676,5466554,5202099,5858490,5464499,4346517,3885695
  Data.l 5464713,6252686,6251661,6318224,6318996,6319509,6648220,7041964,5726367,3160951,3292282,7897291,7700678
  Data.l 5399714,4412559,4214916,3885698,4017030,5924773,6978238,6913987,6848199,6913736,6912711,6780867,6517948
  Data.l 5991598,4083850,3623292,3623289,3886712,3952247,3492984,3098481,2703207,2045275,2175575,5855334,5725288
  Data.l 4475741,4607340,5331591,5529236,5530008,5465240,5136796,4939419,4872604,5727659,7110345,7242962,7704030
  Data.l 7441892,6981340,6585806,6519495,6781892,6846656,5134998,3555700,3160416,2699856,3094354,2897489,2635088
  Data.l 2701404,4412289,4939671,5399204,5661868,5398694,5661090,5924002,5726880,6054570,5594796,5267376,6451137
  Data.l 7240656,6845900,5595571,4675471,3884153,5265284,6252685,6252431,6252431,6449553,6384275,6714020,6976176
  Data.l 5462173,3357053,3622028,8161749,8161747,5465252,4215179,4082565,3951236,3885443,5464219,7043260,6324160
  Data.l 7378903,7904219,6716866,6715074,6714558,6844853,5069458,4084092,4412028,4739961,4936822,4739957,4082543
  Data.l 3163238,2111835,2241625,4409680,3554639,3685983,4936063,5660822,5792416,5727653,5399456,5333918,5136541
  Data.l 4872604,5333158,6649794,7308755,7769566,7704806,7902442,7770598,7177687,6782154,6781636,5990825,3621755
  Data.l 3424108,3292512,2963544,2832214,2635864,3491696,4938895,4676506,4741537,4741284,4741539,5135521,5464740
  Data.l 5661864,5529515,5529523,6385349,7372498,7438546,6188220,4870802,2569566,1845076,4081521,6252685,6317968
  Data.l 6252431,6252174,6252690,7109039,6384554,4804759,3554692,3358600,8424921,9412070,5333410,3622786,3951236
  Data.l 3951236,3885443,4740753,6387380,7378384,9683451,9156079,6783172,6715074,6714302,6779573,5858973,4938374
  Data.l 5003137,5265278,5331068,5199739,4608117,3491433,2440029,2700892,3094849,2699848,3488614,3949945,5530265
  Data.l 5925032,5531048,5203107,5333918,5202078,5069983,5596329,5860278,6650568,7177686,7704806,7771115,7639787
  Data.l 7639013,6914772,6650826,6451896,4017289,3293555,3424875,3095394,2964578,2636385,4084096,4742294,4413854
  Data.l 4215714,4412584,4478632,4872871,5004710,5070504,5332913,5792702,7174100,7701208,6780869,5070244,2633808
  Data.l 530211,1056310,4149354,6187915,6317968,6252431,6252174,6450584,7899588,5661865,4082068,3555981,2569340
  Data.l 7240647,10069744,6188975,3556993,3885442,4477580,4345737,4609422,6718651,9354480,9817599,9487606,7442127
  Data.l 6912453,6780351,6647987,6121631,5660557,5528197,5593474,5724285,5724542,5001847,4015723,3096162,2963294
  Data.l 3292490,2897744,2634076,2964077,5004691,5597092,5203108,4874911,5202332,5333664,5399205,5727659,5860277
  Data.l 6124481,6256327,6388945,7179235,7245547,7244772,6520531,6256584,6517950,5399204,3951747,3556722,3754099
  Data.l 4215164,2505316,4281994,5400485,4677288,4479147,4478638,4413357,4807595,4939178,5070508,5398966,5792706
  Data.l 6515918,7437780,6123449,4347029,1842493,1120298,2502481,4872321,6056078,6317967,6252431,6515602,7898288
  Data.l 8953049,5925553,3753877,3687828,2306170,4345754,9741035,6846905,3556992,4148615,5332889,4872338,4478093
  Data.l 6720188,9685237,9687293,9686778,8232155,7306954,6977731,6582195,6055326,6054288,5790599,5921154,5855101
  Data.l 5855358,5132663,4212845,3424356,3161443,3355462,2370632,2043220,3226991,4804744,5134989,4610186,4675729
  Data.l 5660573,5858211,5661351,5464746,5794480,6058681,6125251,6258128,7114465,7378151,7508203,6783195,6388173
  Data.l 6517960,6122937,5135261,3818622,3754362,5400209,3097200,4150923,6059703,5795518,5664190,5335225,5072053
  Data.l 5597881,6058428,6189243,6122171,6055362,6121163,6385356,5926846,3888277,989249,989753,2963045,4082555
  Data.l 5595011,6581134,6912412,8295616,9150933,9611489,8361433,4544424,3687070,2897800,2701947,8754137,7372995
  Data.l 3688062,4344709,5727390,5399452,4478865,7376578,10999547,10277887,9491197,8368615,7505871,6912455,5729716
  Data.l 5661086,6185363,6250119,6249600,5921150,5593728,4936825,3950958,3228262,4150901,2105137,1580086,2371407
  Data.l 2962522,4342635,4673138,3489896,3753075,5068176,5726366,5661605,5859757,5926064,6058425,6191300,7047899
  Data.l 7114721,7707371,8232435,8296687,7835875,7242456,6254786,4740765,3818883,4675212,5531286,2965361,4413586
  Data.l 7243981,7176664,7242457,6913748,6716369,6979286,6979797,6782417,6387152,6057423,6254034,5925580,5926598
  Data.l 4742569,1450324,595518,3029616,4148610,5068929,6384527,6254740,6321567,6058657,6651565,8757209,8689890
  Data.l 4937644,3621267,2833278,8425174,8754395,4082565,4081281,4806031,5399709,4808087,8165578,11656189,10737407
  Data.l 9688318,8962803,7902424,6782408,5468339,5399454,5988755,6184583,6052992,5790334,5396862,4739703,3753835
  Data.l 3491949,4148834,2500149,2105652,2435647,3422027,5329251,5593709,4278115,3159390,4147327,5200531,5596064
  Data.l 5926060,5991857,5926839,5993922,7113693,7443687,7773418,8364527,9086966,9020404,7111391,5728963,5070251
  Data.l 4872092,5990822,4543627,2635376,4939423,8295905,8426476,8031975,7637216,7374044,7177183,7046622,6982369
  Data.l 6851817,6785769,6718176,5795535,5662662,5925311,4213390,1319769,4017037,4938908,5070221,5661581,5070723
  Data.l 5136517,5202313,4349575,6718134,10203891,6582976,3949980,2964356,8293336,10267381,5464220,3949695,3950722
  Data.l 4346765,4610964,8757711,12378367,11196415,9819386,9293302,8233697,6916301,5733562,5532834,5858197,5857159
  Data.l 5790847,5659776,5396862,4410738,3819628,6057618,6123657,3158334,3355199,3420477,4473932,5856867,5331044
  Data.l 4606821,2698839,3555699,4871819,5267608,5531811,5728940,5729461,5665213,6784728,7641066,7707880,8299496
  Data.l 8758764,6980821,5137864,5400519,6254788,6911938,6582708,5266586,3950728,5859761,8229604,8624621,8427242
  Data.l 8098020,8098020,8033511,7970027,7578350,7251959,7317239,7248105,5928914,5728710,5924287,6055608,5136290
  Data.l 5004200,4150171,4413326,5333646,5333637,5529729,5529989,4349063,7902409,9874928,5398702,4146848,3029639
  Data.l 8227034,10793215,7503548,3818364,3950722,3557249,4084620,9547222,12902908,11655164,9950454,9426427,8827628
  Data.l 7312597,6524872,6323888,5859225,5792392,5726337,5595010,5331070,4410738,5727368,9478339,10138324,3487556
  Data.l 4013898,2829109,4013637,5264728,4804951,4541791,2633551,3358315,4740749,5201821,5399711,5597095,5794482
  Data.l 6058430,6783699,7509225,7838703,8496367,8758509,7638750,7112672,7375330,7834848,7505873,6715576,6911923
  Data.l 6188715,5794478,6321854,7176912,8427749,9085936,9481464,9484023,9353974,9223415,9290236,9421566,9156856
  Data.l 7050461,5994696,6057920,5793717,4676262,3887006,3689880,6058159,6387116,6584745,7702708,7439793,7375546
  Data.l 10665458,9150691,4412068,4675244,3096718,5333165,10332918,10200297,5331352,3556478,3360382,4018827,9876702
  Data.l 12706303,11590140,10015992,9491966,8764912,7184085,6723531,6851775,6452134,6056084,6055308,5331839,5593468
  Data.l 5266045,7966898,10140893,10404840,2830138,2830138,2238001,3553346,4737360,4343886,4080978,2831179,2963298
  Data.l 4543372,5267618,5465249,5531301,5793966,6188987,6782928,7113954,7772400,8496114,9153013,9415415,8363755
  Data.l 7442142,6914256,5993147,4676760,4807825,5334684,3558275,2900344,2901112,3559814,5534633,8562139,9945840
  Data.l 11262719,11197181,11000569,11327996,11194878,10406141,8957423,6126276,4479911,3756447,3821979,3293829,4675993
  Data.l 9349093,10073069,10731508,10929398,11193338,11653119,9481192,5598391,4875185,4611755,2439809,6123186,10661619
  Data.l 9937636,7110329,5532325,5795758,8560854,11391226,11262718,10279421,9688319,8964343,7317464,6921165,6919367
  Data.l 7113147,6846632,6120591,5857414,5988993,6846617,9154001,9618154,10078196,2501173,2369587,2040879,3289919
  Data.l 3947591,3882826,2961989,2699084,2963298,4280199,5004447,5136541,5268641,5662634,5860533,6914769,7180001
  Data.l 7641323,8299244,8627178,6915535,5337275,5402812,5598906,5006505,3032446,2374250,2571113,2833255,2767458
  Data.l 2242395,1651032,3033206,4415120,4941984,6653883,9616871,11132670,11657725,12114939,11852287,10141431,5535166
  Data.l 4020906,4349614,4216993,2964088,3032196,8561379,10338043,10667005,10667514,10602744,10537206,10602491,9154027
  Data.l 6456265,5534396,5467829,2835587,4018574,7109816,8690131,9349350,9086186,8757472,9088742,10211324,10148605
  Data.l 9688574,9622014,7777758,7249873,7117516,7116230,8230083,6713498,6186379,6322067,8627139,9878760,9683444
  Data.l 9947130,2369587,2698552,1975085,3355457,3354945,2698044,2106429,2633038,3687021,4740751,5136032,5202077
  Data.l 5202590,5531046,5531823,6652108,7509220,7707625,8365289,8890858,8626663,7837919,7706077,7243727,5928115
  Data.l 4875673,3625339,2571103,2635089,2042177,2240335,3820145,5267603,4609681,4345749,3557774,5666739,7446485
  Data.l 9816049,11788285,12116223,10339057,6719950,5140418,4416954,3955628,4019099,5007541,5075393,6062539,8036582
  Data.l 9616378,9880570,9749236,9552114,9880315,9419510,7773151,7311317,6259131,3099257,1057102,2505835,7374529
  Data.l 9479915,9218026,8103142,8172269,9095672,9293564,9293052,7843808,7249616,7249359,7577552,8034502,6452893
  Data.l 6650010,8036547,9222625,9617904,9618682,9750780,2698552,2566966,2040622,2829370,2565944,2632252,2500930
  Data.l 2829903,4147314,5003665,5136032,5202078,5136797,5333924,5465772,6454215,7575010,7182049,8036580,9285615
  Data.l 10074104,9483252,8101090,6717638,4546205,3296639,3032941,2043981,1779514,2239546,2767432,3819102,7174815
  Data.l 5661331,4740239,4281231,5271720,5669816,5606076,7908567,10736119,10998271,8695277,7444712,6655458,6852838
  Data.l 7904750,6786016,5470415,5141962,4879048,5735125,7380710,8631283,9092341,9289977,8302570,8103657,8365287
  Data.l 7444685,4218247,2308191,2769518,3493510,6782399,8231383,7510491,6658522,7120353,7121371,6792404,6791121
  Data.l 6855888,7051723,8102348,8429514,8297669,9285590,9354475,9487090,9618678,9685243,9751294,2698552,1777450
  Data.l 2172208,2566966,2764089,3290437,3355721,2894917,3553887,4805766,5267357,5332640,5267616,5399203,5793709
  Data.l 6650050,7442653,6853089,7575521,8297953,9481451,8826345,7179991,6782670,5334701,3163257,2372954,1713983
  Data.l 1319731,1780538,1517364,1383983,5264752,7962280,5266839,4084622,4021394,5602734,5932473,5537979,6196935
  Data.l 7645664,8304366,8368890,8500477,8500477,8500478,8367605,7905772,7050474,5670631,5210600,5275104,5539293
  Data.l 6066650,6594268,7054314,7711729,8236526,7643612,6984136,7707086,7247311,5274553,5209018,5669052,5932482
  Data.l 6459597,6723283,6526668,6592453,7183558,7775176,9351890,11060449,10601706,9485548,9026289,9355510,9684473
  Data.l 9816059,9947644,9881855,1843243,1909036,2566966,2632759,2698553,3093058,3092549,2368573,2435663,4213630
  Data.l 5333150,5332640,5201823,5202080,5727916,6189755,7178967,7246052,7705830,7705571,7836898,7838437,7573986
  Data.l 7374808,6387133,4347276,2570332,1911362,1780282,1846332,2767177,7963283,4738661,7239319,6517154,4610703
  Data.l 3954830,4680609,6326462,6064317,5472952,5408185,6198987,7317229,8172283,8172283,8107003,9026303,9550847
  Data.l 9023483,7708657,6459883,5933288,5934050,6197983,6725091,6528998,6529256,7384307,7713014,8172278,8368114
  Data.l 8039150,7908076,7645676,6398694,6593755,7249104,8035788,8693707,9811923,11520992,12901351,12507371,9880040
  Data.l 9025762,9092590,9290745,9684730,9750266,9750266,9882108,10012926,1974829,2238001,2172208,2040622,2237745
  Data.l 2369078,2500156,2171194,2435663,4147837,5136028,5398433,5333409,5399459,5465000,5926840,6980817,7639011
  Data.l 7902699,7771373,7442923,7442920,7837159,7967197,7440586,4281994,2767455,1977155,1714745,2175297,2635337
  Data.l 6450043,2436414,5332338,7701160,5465234,4282765,5402536,6523076,6986196,7118552,6461906,6265042,6726120
  Data.l 7646966,7712759,7844602,8107001,8697082,8958457,9155579,8498424,7906551,7643377,7643886,8104691,7843827
  Data.l 7646961,7711983,7843824,7646449,7580401,7776749,8039145,8301799,8957669,9613279,10926303,12700391,14739436
  Data.l 15267576,13625595,11259890,9485802,8829419,9092849,9290486,9356537,9618937,9816059,9816059,9750266,9881338
  Data.l 2106415,1974829,1909036,1974829,1843244,1777198,2171447,2171194,2435663,4147838,5136028,5398433,5333409
  Data.l 5399459,5530537,5466290,6849229,8098784,7902438,7640557,7181037,7377129,7705570,7967957,8033483,7505848
  Data.l 5201797,1713983,2175039,2767435,1582394,857893,1186854,3293774,7832739,7701422,6058147,5927598,6851790
  Data.l 7119590,8041461,7647732,7451123,7516664,7648250,7648250,7582457,7319031,6922733,7183334,7116768,7182558
  Data.l 7641566,7575518,7246811,7246812,6920154,7314649,7708117,8101584,8956114,10665695,12703728,13491438,14279664
  Data.l 14410741,14345717,14609403,14675965,13756410,12047599,10405098,9354736,9027319,9092858,9355770,9683962,9881339
  Data.l 9684473,9816059,9816059,9750266,9946872,1974829,1909036,2040622,2106415,2369586,2106416,2303539,2369334
  Data.l 2435142,4212340,5332120,5268386,5267872,5464992,5530530,5399202,6585018,7114451,7443934,7313383,7050729
  Data.l 7247075,7903456,8494039,8689609,8557769,6122911,2371920,2504524,3163736,1978172,1318701,1514281,2105649
  Data.l 6250877,8160172,7241655,6717637,7114459,7972077,8829433,7780082,7058932,7124221,7517439,7713790,7581177
  Data.l 7381748,6854120,6787550,6721494,6918358,6917590,6588877,6588874,6983628,7706317,9152209,11321049,13424614
  Data.l 14936046,15659510,15068919,14214903,13229042,12046320,11389933,10668523,10078184,9355505,9158390,9289975,9355767
  Data.l 9290489,9159676,9225468,9291003,9356540,9488122,9553914,9553914,9553914,9684729,2106415,1777450,1974829
  Data.l 2303794,2435380,2632758,2435380,2501173,2435392,3225179,3818869,4346501,4873362,5202073,5662623,6583468
  Data.l 7440062,7114443,7312340,7378653,7181536,6984673,7707621,8429794,8559832,8296398,6387621,3162210,3161174
  Data.l 5266805,3950943,1845049,1515054,1711659,1646641,2766929,4348031,6981820,8166615,10140142,10864889,9814516
  Data.l 8698866,7975928,7711474,7972847,7773671,7050972,6525139,6851797,7047382,6915540,6785229,8362958,10927321
  Data.l 12899811,13296113,13559541,13361391,12571108,11454428,10141402,9682400,9157863,8566759,8500964,8501991,8568812
  Data.l 8372716,8831220,9027831,9093624,9159417,9159674,9159931,9159931,9159931,9159931,9422842,9488378,9488378
  Data.l 9488378,9619194,1974829,1974829,2106415,2172208,2566966,3027517,2435380,2106416,2106937,2436162,2305096
  Data.l 3094617,3753325,4279929,4806272,6187925,7570605,7901371,8756942,8757720,8429274,8035806,7970012,7772115
  Data.l 7837136,8363469,7178928,3952756,3357788,5922172,6646669,4147301,2437446,1846074,2306380,4345973,5399698
  Data.l 7308988,9876973,10405368,10865147,10339323,9353978,8369145,7775726,7510756,7640801,7442653,7244755,7310793
  Data.l 7705797,9415377,11978467,13098228,12968178,11784930,10471387,9485787,8697825,8106729,8303854,8500974,8370162
  Data.l 8239094,8239352,8633842,8765428,8896758,8962294,8897015,8831479,8897272,8963065,9028601,9094138,9094138
  Data.l 9159931,9159931,9422585,9422585,9488378,9488378,9619194,2106415,2172208,2303794,2369587,2435380,2303794
  Data.l 2303794,2369844,1844273,1976367,2238768,2632506,2830405,3027786,3159371,3488337,3949401,4739942,6648459
  Data.l 7833512,9215683,10991834,11781093,10926299,10860251,11190497,9085894,5729685,3490408,4738157,6316933,6055301
  Data.l 4807028,4150637,5136262,6583204,6912431,7109557,8428501,8301277,9220576,9351907,9090023,9287395,9483489
  Data.l 9876192,9809115,9543893,10267100,10927844,11456746,11523818,10799329,9419483,8237789,7778531,7779305,7845616
  Data.l 7714804,7387127,7649272,8108535,8174071,8371192,8371190,8175604,8569079,8962296,9289720,8831223,8503799
  Data.l 8635128,8700921,8831993,9028345,9028345,9159931,9159931,9356792,9356792,9422585,9488378,9619194,2566966
  Data.l 2698552,2435380,2369587,2171951,2369330,2961467,2961724,2107186,2370354,2435887,2895672,2960955,2961211
  Data.l 3158590,3027004,2829625,2895674,2632506,2633022,3488590,5331307,7831442,10068923,11582935,12701930,12373739
  Data.l 9874125,6189460,4214382,4607340,5265787,5924750,6517405,6451097,6714264,6649499,6980527,8233683,8695775
  Data.l 9089758,9550051,9747942,10535902,11126754,11717863,12045288,11979751,11388901,9877724,8958172,8039646,6860007
  Data.l 7254508,7582960,7714546,7648756,7780599,7912438,7978228,7912693,7847160,8044024,8241143,8175606,7913461
  Data.l 8110327,8438264,8700152,8634871,8569335,8569335,8635128,8766200,9028345,9028345,9094138,9094138,9291257
  Data.l 9291257,9357050,9357050,9488121,2238001,2172208,2238001,2303537,2566195,2566195,2895160,3158589,2961724
  Data.l 2830138,2632760,3027517,2830138,2764345,3027517,2633015,2566710,2565941,2171183,2105389,2302512,2303796
  Data.l 2765120,3095117,4148065,5793148,7241108,7965605,7440294,6124693,5793413,5463939,5791883,5330823,5920895
  Data.l 6381949,5728903,5736116,7122664,6991594,6925801,7057387,7057131,7385574,7581926,7844071,8171752,7909857
  Data.l 7385309,7057122,6795495,6926829,7123186,7254772,7320822,7518201,7583989,7715830,7781624,7781624,7978232
  Data.l 8240120,8240377,8306170,8306170,8568312,8568312,8634362,8634362,8634616,8634871,8634871,8634871,8765944
  Data.l 9028345,9028345,9028345,9028345,9159931,9159931,9159931,9159931,9291257,1974829,2106415,2632759,2632502
  Data.l 2500659,2698038,3355968,3356225,2830138,2567223,2501173,2632759,3356482,4211791,3422275,2961724,2829882
  Data.l 2631734,2763320,2434098,2236720,2499882,2368554,2303536,2238262,2501943,3094077,3225925,3358543,3358803
  Data.l 3423568,3554898,3949142,4343644,5986929,6976141,7970245,7123436,6337273,6336245,6336245,6401782,6401782
  Data.l 6337523,6468595,6861813,7123957,6992881,6862064,6796786,6731251,6993653,7517686,7583736,7583736,7715322
  Data.l 7584246,7650038,7781624,7781624,7978232,8174584,8240377,8306170,8306170,8502776,8502776,8568569,8568569
  Data.l 8568823,8569078,8569078,8634871,8765944,9028345,9028345,9028345,9028345,9094138,9094138,9159931,9159931
  Data.l 9291257,3356739,3159103,2961981,2435123,2500659,2500659,2895417,3684933,2895931,2698552,2632759,2895931
  Data.l 3488068,6119788,6449010,4606549,3750984,3027519,2896190,2764347,3488070,4539726,3553346,3027777,2699587
  Data.l 3093822,4211524,4146507,4607833,5200229,5068131,5398638,5070961,5467004,7047592,9155551,8897017,6730744
  Data.l 6336250,6991607,6926071,7057657,7057657,6796531,6927603,7321077,7648757,7386106,7189244,7451898,7911161
  Data.l 7845622,7517943,7517943,7649529,7649529,7650039,7650038,7715831,7781624,7978232,8174584,8240377,8306170
  Data.l 8306170,8502776,8502776,8502776,8502776,8503030,8503285,8569078,8634871,8765944,9028345,9028345,9028345
  Data.l 9028345,9028345,9028345,9094138,9159931,9291257,3948619,3224639,2501173,2961467,3289918,2829366,2763830
  Data.l 3027002,3027517,2895675,2764088,3619397,3355968,6185581,9606559,8619409,6910849,6320765,6123130,6057080
  Data.l 5859701,5661044,5529460,5661821,5728131,5861000,6585751,6915233,7244973,7377332,7377851,7379910,7514585
  Data.l 7056351,7715057,7452919,6795766,6532854,6664694,6599410,6599410,6730996,6730996,6729978,6795514,7188988
  Data.l 7451132,6992381,6796029,7189754,7649015,7780341,7517943,7517943,7583993,7583993,7650039,7650038,7715831
  Data.l 7781368,7912440,8109048,8174841,8240634,8240634,8502776,8502776,8502776,8502776,8503030,8503285,8569078
  Data.l 8634871,8765944,8962809,8962809,8962809,8962809,9028345,9028345,9094138,9159931,9291257,3224124,3026745
  Data.l 3618882,4013899,2961726,2961466,3027517,3093313,4079694,3618630,2828600,4275275,4340552,6383987,9935006
  Data.l 11054783,8827096,8828382,9091297,9486311,9157090,8104153,7314639,7380432,7446224,7315670,7119580,7121120
  Data.l 7057124,6927082,6860533,6794740,6926583,7057912,6533111,6336247,6402040,6467576,6533112,6467576,6467576
  Data.l 6599162,6599162,6796023,6796023,6927609,6927609,7058425,7189497,7255290,7321083,7321082,7321591,7321591
  Data.l 7321591,7321591,7583993,7649529,7649529,7649529,7715577,7781624,7781624,7781624,7847160,8306170,8306170
  Data.l 8306170,8306170,8437241,8502776,8568569,8634362,8634617,8634871,8634871,8766457,8766457,9028345,9028345
  Data.l 9028345,9028345,9094138
  imageend:
EndDataSection



; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP