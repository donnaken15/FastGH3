donotassertforinfiniteloopsinthesescripts = [
	AVOIDSTATE_STOP
	Ped_RandomWaitAtNode01
	igc_cycle_actor_anims
	z_storyselect_loop_anims
]
blockingfunctions = [
	wait
	Obj_WaitMove
	Obj_WaitRotate
	WaitAnimWalking
	WaitOneGameFrame
	WaitAnimFinished
	Obj_WaitAnimFinished
	DoMorph
	GoalInit_PlayAnim
	fadein_fadeout
	WaitForEvent
	WaitWalkingFrame
	WaitAnimWalkingFrame
	Block
	Skater_WaitAnimFinished
	Ped_WaitAnimFinished
]
