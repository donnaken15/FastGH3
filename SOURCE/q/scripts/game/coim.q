/*COIM_Priority_Permanent = 0
COIM_Priority_PermanentCleanup = 1
COIM_Priority_NonPermanent = 2
COIM_Priority_DroppedWeapons = 3
COIM_Priority_PedLife_Actor = 4
COIM_Priority_PedLife = 5
COIM_Priority_PedlifeDead = 10
COIM_Priority_Effects = 20
Generic_COIM_Size = 524288
Career_PedLife_COIM_Size = 0
NonCareer_PedLife_COIM_Size = 0
Career_PedLife_XBOX_COIM_Size = 256819
NonCareer_PedLife_XBOX_COIM_Size = 856064
Generic_COIM_BlockAlign = 8192
Generic_XBox_COIM_BlockAlign = 4096
ClassicMode_ReservedCOIMBlocksForPermObjects = 250
COIM_Max_Offscreen_Seconds = 0.5
COIM_Perm_Max_Offscreen_Seconds = 0.5
COIM_Min_Offscreen_Dist = 25.0
COIM_Vehicle_Min_Offscreen_Dist = 32.0
COIM_Min_Scratch_Blocks = 9
Generic_COIM_Params = {
	COIM_Max_Peds_Remove_AtOnce = 2
	COIM_Kill_Relevance = 0.0
	COIM_Max_Distance = 200.0
	COIM_Kill_Priority = $#"0x64b57da2"
	COIM_Initial_Num_Perm_Objects = 36
	COIM_Permanent_Cleanup_Relevance = 0.5
	COIM_Type_ID = Generic
}
Spawner_Cleanup_Relevance_Amount = 0.4
Spawner_Cleanup_Min_Count = 2

script COIM_PreAllocate
	<blocks> = (<size> / $Generic_COIM_BlockAlign)
	if GameModeEquals \{is_classic}
		ReserveCOIMBlocksForPermObjects (<blocks> / 3)
	else
		ReserveCOIMBlocksForPermObjects \{$#"0x504b997b"}
	endif
endscript*/
