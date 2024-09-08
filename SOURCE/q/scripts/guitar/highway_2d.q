highway_lines = 1152
real_highway_lines = 1024
gHighwayStartFade = 800.0
gHighwayEndFade = 1000.0

script Set2DHighwaySpeed\{speed = -1.0}
	Change StructureName = <player_status> highway_speed = <speed>
	SetScreenElementProps id = <id> MaterialProps = [
		{name = m_velocityV property = <speed>}
		{name = m_tiling property = ($gHighwayTiling)}
	]
endscript

gem_time_table512 = []
rowHeightNormalizedDistance = []
rowHeight = []
time_accum_table = []
heightPerspFact = 1.0009021
heightPerspExp = 1.0015471
sidebar_angle = 0
sidebar_x = 0
sidebar_y = 0
heightPerspFactTable = [
	1.000405
	1.000424
	1.0004179
	1.000417
	1.000417
	1.0004359
	1.0004259
	1.000425
	1.000425
	1.0004441
	1.000438
	1.0004359
	1.0004359
	1.0004549
	1.000446
	1.000445
	1.000445
	1.000464
	1.0004569
	1.0004559
	1.0004559
	1.0004749
	1.0004659
	1.0004649
	1.0004649
	1.000484
	1.000477
	1.0004759
	1.0004759
	1.000495
	1.0004859
	1.0004849
	1.0004849
	1.000504
	1.000497
	1.0004959
	1.0004959
	1.0004959
	1.0005059
	1.0005059
	1.0005059
	1.0005059
	1.000517
	1.0005159
	1.0005159
	1.0005159
	1.000526
	1.000526
	1.000526
	1.000526
	1.000537
	1.000536
	1.000536
	1.000536
	1.0005471
	1.000546
	1.000546
	1.000546
	1.0005569
	1.0005559
	1.0005559
	1.0005559
	1.000567
	1.0005659
	1.0005659
	1.0005659
	1.000577
	1.0005759
	1.0005759
	1.0005759
	1.000587
	1.0005859
	1.0005859
	1.0005859
	1.000597
	1.0005959
	1.0005959
	1.0005959
	1.000607
	1.0006059
	1.0006059
	1.0006059
	1.000617
	1.000616
	1.000616
	1.000616
	1.000627
	1.000626
	1.000626
	1.000626
	1.0006371
	1.000636
	1.000636
	1.000636
	1.0006471
	1.000646
	1.000646
	1.000646
	1.000657
	1.0006559
	1.0006559
	1.000675
	1.000667
	1.0006659
	1.0006659
	1.000685
	1.000677
	1.0006759
	1.0006759
	1.000695
	1.000702
	1.0006859
	1.0006859
	1.000697
	1.000705
	1.0006959
	1.0006959
	1.000707
	1.000706
	1.000706
	1.000706
	1.000717
	1.000716
	1.000716
	1.000716
	1.0007271
	1.000726
	1.000726
	1.0007451
	1.000752
	1.000736
	1.000736
	1.0007471
	1.000746
	1.000746
	1.000746
	1.000757
	1.0007559
	1.0007559
	1.0007559
	1.000767
	1.0007659
	1.0007659
	1.000785
	1.000785
	1.0007759
	1.0007759
	1.000787
	1.0007859
	1.0007859
	1.0007859
	1.000797
	1.000796
	1.000796
	1.000807
	1.000806
	1.000806
	1.000806
	1.0008171
	1.000816
	1.000816
	1.000816
	1.0008421
	1.000826
	1.000826
	1.0008371
	1.000836
	1.000836
	1.000836
	1.000862
	1.000846
	1.000846
	1.000857
	1.0008559
	1.0008559
	1.0008559
	1.000875
	1.0008659
	1.0008659
	1.000877
	1.0008759
	1.0008941
	1.000887
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.000886
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
	1.0009021
]
heightPerspExpTable = [
	1.001062
	1.001062
	1.001062
	1.001062
	1.00107
	1.00107
	1.00107
	1.00107
	1.001081
	1.001081
	1.001081
	1.001081
	1.00109
	1.00109
	1.00109
	1.00109
	1.001101
	1.001101
	1.001101
	1.001101
	1.0011101
	1.0011101
	1.0011101
	1.0011101
	1.001121
	1.001121
	1.001121
	1.001121
	1.001121
	1.0011301
	1.0011301
	1.0011301
	1.0011301
	1.0011411
	1.0011411
	1.0011411
	1.0011411
	1.001151
	1.001151
	1.001151
	1.001151
	1.001161
	1.001161
	1.001161
	1.001161
	1.001171
	1.001171
	1.001171
	1.001171
	1.001181
	1.001181
	1.001181
	1.001181
	1.001191
	1.001191
	1.001191
	1.001191
	1.001201
	1.001201
	1.001201
	1.001201
	1.001211
	1.001211
	1.001211
	1.001211
	1.0012211
	1.0012211
	1.0012211
	1.0012211
	1.0012311
	1.0012311
	1.0012311
	1.0012311
	1.0012411
	1.0012411
	1.0012411
	1.0012411
	1.001251
	1.001251
	1.001251
	1.001251
	1.001261
	1.001261
	1.001261
	1.001261
	1.001271
	1.001271
	1.001271
	1.001271
	1.001281
	1.001281
	1.001281
	1.001281
	1.001291
	1.001291
	1.001291
	1.001291
	1.0013011
	1.0013011
	1.0013011
	1.0013011
	1.0013111
	1.0013111
	1.0013111
	1.0013211
	1.0013211
	1.0013211
	1.0013211
	1.0013311
	1.0013311
	1.0013231
	1.0013311
	1.0013411
	1.0013411
	1.00135
	1.0013411
	1.001351
	1.001351
	1.001351
	1.001351
	1.001361
	1.001361
	1.001361
	1.001361
	1.001371
	1.001371
	1.001371
	1.001381
	1.001381
	1.0013731
	1.001381
	1.0013911
	1.0013911
	1.0014
	1.0013911
	1.0014009
	1.0014009
	1.0014009
	1.0014009
	1.001411
	1.001411
	1.001411
	1.001421
	1.001421
	1.00143
	1.001421
	1.001431
	1.001431
	1.001431
	1.001431
	1.001441
	1.001441
	1.001441
	1.0014509
	1.0014509
	1.00146
	1.0014509
	1.0014609
	1.0014609
	1.0014609
	1.0014609
	1.0014709
	1.0014629
	1.0014709
	1.0014809
	1.0014809
	1.0014809
	1.0014809
	1.001491
	1.001483
	1.001491
	1.001501
	1.001501
	1.001501
	1.001501
	1.001511
	1.00152
	1.001511
	1.001521
	1.001521
	1.001521
	1.001531
	1.001531
	1.0015401
	1.001531
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.001541
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
	1.0015471
]
gHighwayTiling = 0.0
highway_playline = 0
highway_height = 0
highway_top_width = 0.0
widthOffsetFactor = 0.0
highway_fade = 0.0
gem_start_scale = 0.0
gem_end_scale = 0.0
gem_star_scale = 0.0
gem_y_just = 0.0
star_y_just = 0.0
fretbar_start_scale = 0.0
whammy_top_width = 0.0
whammy_top_width_open_note = 0.0
whammy_width_offset = 0.0
sidebar_x_offset = 0.0
sidebar_x_scale = 0.0
sidebar_y_offset = 0.0
sidebar_y_scale = 0.0
starpower_fx_scale = 0.0
nowbar_scale_x = 0.0
nowbar_scale_y = 0.0
string_scale_x = 0.0
string_scale_y = 0.0

script generate_pos_table
	tweaks = [
		gHighwayTiling
		highway_playline
		highway_height
		highway_top_width
		widthOffsetFactor
		highway_fade
		gem_start_scale
		gem_end_scale
		gem_star_scale
		gem_y_just
		star_y_just
		fretbar_start_scale
		whammy_top_width
		whammy_top_width_open_note
		whammy_width_offset
		sidebar_x_offset
		sidebar_x_scale
		sidebar_y_offset
		sidebar_y_scale
		starpower_fx_scale
		nowbar_scale_x
		nowbar_scale_y
		string_scale_x
		string_scale_y
	]
	Ternary ($current_num_players = 1 & $end_credits = 0) a = '1' b = '2'
	GetArraySize \{tweaks}
	index = 0
	begin
		tweak = (<tweaks>[<index>])
		extendcrc <tweak> <ternary> out=val
		change globalname=<tweak> newvalue=($<val>)
		Increment \{index}
	repeat <array_size>
	SetAllWhammyValues \{value = 1.0 Player = 1}
	SetAllWhammyValues \{value = 1.0 Player = 2}
	<hheight> = ($highway_height - 162)
	if (<hheight> < 0)
		<hheight> = 0
	endif
	if (<hheight> > 510)
		<hheight> = 510
	endif
	Change heightPerspFact = ($heightPerspFactTable[<hheight>])
	Change heightPerspExp = ($heightPerspExpTable[<hheight>])
	heightOffsetFactor = $heightPerspFact
	heightOffsetExp = $heightPerspExp
	startY = ($highway_playline - $highway_height)
	rows = $highway_lines
	normal_rows = $real_highway_lines
	height = $highway_height
	rowHeightNormalizationFactor = 0.0
	htx = (640.0 - ($highway_top_width / 2.0))
	gts = ($highway_top_width / 5.0)
	gsx = (<htx> + (<gts> / 2.0)+ (<gts> * 0.0))
	rsx = (<htx> + (<gts> / 2.0)+ (<gts> * 1.0))
	ysx = (<htx> + (<gts> / 2.0)+ (<gts> * 2.0))
	bsx = (<htx> + (<gts> / 2.0)+ (<gts> * 3.0))
	osx = (<htx> + (<gts> / 2.0)+ (<gts> * 4.0))
	hbw = ($highway_top_width + ($highway_top_width * $widthOffsetFactor))
	hbx = (640.0 - (<hbw> / 2.0))
	gbs = (<hbw> / 5.0)
	gex = (<hbx> + (<gbs> / 2.0)+ (<gbs> * 0.0))
	rex = (<hbx> + (<gbs> / 2.0)+ (<gbs> * 1.0))
	yex = (<hbx> + (<gbs> / 2.0)+ (<gbs> * 2.0))
	bex = (<hbx> + (<gbs> / 2.0)+ (<gbs> * 3.0))
	oex = (<hbx> + (<gbs> / 2.0)+ (<gbs> * 4.0))
	Atan2 X = $highway_height y = (<gsx> - <gex>)
	ga = <atan>
	Atan2 X = $highway_height y = (<rsx> - <rex>)
	ra = <atan>
	Atan2 X = $highway_height y = (<ysx> - <yex>)
	ya = <atan>
	Atan2 X = $highway_height y = (<bsx> - <bex>)
	ba = <atan>
	Atan2 X = $highway_height y = (<osx> - <oex>)
	params = {start_y = <startY> end_y = ($highway_playline)}
	SetButtonData array = button_models <params> Color = green angle = <ga> start_x = <gsx> end_x = <gex> left_start_x = <osx> left_end_x = <oex> left_angle = <atan>
	SetButtonData array = button_models <params> Color = red angle = <ra> start_x = <rsx> end_x = <rex> left_start_x = <bsx> left_end_x = <bex> left_angle = <ba>
	SetButtonData array = button_models <params> Color = yellow angle = <ya> start_x = <ysx> end_x = <yex> left_start_x = <ysx> left_end_x = <yex> left_angle = <ya>
	SetButtonData array = button_models <params> Color = blue angle = <ba> start_x = <bsx> end_x = <bex> left_start_x = <rsx> left_end_x = <rex> left_angle = <ra>
	SetButtonData array = button_models <params> Color = orange angle = <atan> start_x = <osx> end_x = <oex> left_start_x = <gsx> left_end_x = <gex> left_angle = <ga>
	SetButtonData array = button_up_models Color = green pos_x = <gex> pos_y = ($highway_playline) left_pos_x = <oex>
	SetButtonData array = button_up_models Color = red pos_x = <rex> pos_y = ($highway_playline) left_pos_x = <bex>
	SetButtonData array = button_up_models Color = yellow pos_x = <yex> pos_y = ($highway_playline) left_pos_x = <yex>
	SetButtonData array = button_up_models Color = blue pos_x = <bex> pos_y = ($highway_playline) left_pos_x = <rex>
	SetButtonData array = button_up_models Color = orange pos_x = <oex> pos_y = ($highway_playline) left_pos_x = <gex>
	Change fretbar_end_scale = ($fretbar_start_scale + ($fretbar_start_scale * $widthOffsetFactor))
	Change gem_end_scale = ($gem_start_scale + ($gem_start_scale * $widthOffsetFactor))
	fe = ($highway_playline - $highway_height)
	fs = (<fe> + $highway_fade)
	Change gHighwayStartFade = <fs>
	Change gHighwayEndFade = <fe>
	stx = (640.0 - ($highway_top_width / 2.0))
	sbx = (640.0 - (<hbw> / 2.0))
	Atan2 X = $highway_height y = (<stx> - <sbx>)
	Change sidebar_angle = <atan>
	vec_x = (<sbx> - <stx>)
	vec_y = $highway_height
	Change sidebar_x = (<sbx> + (<vec_x> * 0.25) - $sidebar_x_offset)
	Change sidebar_y = ($highway_playline + (<vec_y> * 0.25) - ($sidebar_y_offset * 4.2))
	SetArrayElement \{ArrayName = rowHeightNormalizedDistance GlobalArray index = 0 NewValue = 1.0}
	index = 0
	begin
		value = ($rowHeightNormalizedDistance[<index>] * <heightOffsetFactor>)
		MathPow <value> exp = <heightOffsetExp>
		Increment \{index}
		SetArrayElement GlobalArray index = <index> NewValue = <pow> ArrayName = rowHeightNormalizedDistance
	repeat <rows>
	index = 0
	begin
		<rowHeightNormalizationFactor> = (<rowHeightNormalizationFactor> + $rowHeightNormalizedDistance[<index>])
		Increment \{index}
	repeat <normal_rows>
	<rowHeightNormalizationFactor> = (1.0 / <rowHeightNormalizationFactor>)
	index = 0
	begin
		value = ($rowHeightNormalizedDistance[<index>] * <rowHeightNormalizationFactor>)
		SetArrayElement GlobalArray index = <index> NewValue = <value> ArrayName = rowHeightNormalizedDistance
		SetArrayElement GlobalArray index = <index> NewValue = <value> ArrayName = gem_time_table512
		Increment \{index}
	repeat <rows>
	SetArrayElement ArrayName = rowHeight GlobalArray index = 0 NewValue = <startY>
	index = 0
	begin
		value = ($rowHeight[<index>] + (<height> * ($rowHeightNormalizedDistance[<index>])))
		Increment \{index}
		SetArrayElement GlobalArray index = <index> NewValue = <value> ArrayName = rowHeight
	repeat <rows>
	SetArrayElement \{ArrayName = time_accum_table GlobalArray index = 0 NewValue = 0.0}
	index = 0
	begin
		value = ($time_accum_table[<index>] + $gem_time_table512[<index>])
		Increment \{index}
		SetArrayElement GlobalArray index = <index> NewValue = <value> ArrayName = time_accum_table
	repeat <rows>
	SetRowHeightTables
	SetGemConstants
endscript

script generate_move_table \{interval=60 pos_start_orig=0}
	ProfilingStart
	MathPow (<interval>/60.0) exp = 2
	y = 720
	pos_add = -720
	pos_sub = 1.0
	pos_sub_add = (0.0004386 / <pow>)
	intervalth = (1.0/<interval>)
	size = (<interval>*2.5)
	CastToInteger \{size}
	CreateIndexArray <size>
	i = 0
	begin
		<y> = (<y> + (<pos_add> * <intervalth>))
		<pos_add> = (<pos_add> * <pos_sub>)
		<pos_sub> = (<pos_sub> - <pos_sub_add>)
		element = (<y> * 1000.0)
		CastToInteger \{element}
		SetArrayElement arrayname=index_array index=<i> newvalue=<element>
		if (<y> <= <pos_start_orig> || <pos_add> >= -0.002)
			break
		endif
		Increment \{i}
		if (<i> >= <size>)
			break
		endif
	repeat
	ProfilingEnd <...> 'generate_move_table'
	if (<i> >= <size>)
		begin
			printf \{'overshot move table index!!!!!!!!!!!!!'}
		repeat 10
	endif
	//GetArraySize \{index_array}
	//PrintStruct <...>
	return moveTable = <index_array>
endscript



