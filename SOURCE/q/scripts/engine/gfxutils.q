ISOLATE_2D_RENDER = 1
pix_output = 0

script HiResScreenshot\{Scale = 1}
	if CutsceneFinished \{name = cutscene}
		PauseGame
		GetCurrentCameraObject
	else
		PlayIGCCam \{name = hires_cutscene_hack interrupt_current play_hold}
		wait \{1 gameframes}
		GetSkaterCamAnimParams \{name = hires_cutscene_hack}
		<cameraid> = <cam_object_id>
	endif
	<cameraid> = <camid>
	printstruct <...>
	<i> = 0
	wait \{30 frames ignoreslomo}
	printf \{"11111111111111111111111111111111111111"}
	begin
		<j> = 0
		begin
			printf \{"222222222222222222222222222222222"}
			FormatText textname = text 'hi_res_screen_%a_%b_' a = <i> b = <j>
			sub = ((<i> * <Scale>)+ <j>)
			<cameraid> ::SetSubFrustum res = <Scale> subImage = <sub>
			wait \{16 Frame ignoreslomo}
			ScreenShot FileName = <text>
			wait \{16 frames ignoreslomo}
			<j> = (<j> + 1)
		repeat <Scale>
		<i> = (<i> + 1)
	repeat <Scale>
	<cameraid> ::SetSubFrustum res = 1 subImage = 0
	root_window ::DoMorph \{alpha = 1}
	if GotParam \{Do2D}
		if isXenon
			Change \{ISOLATE_2D_RENDER = 1}
			wait \{3 frames}
			<i> = 0
			begin
				<j> = 0
				begin
					FormatText textname = text 'hi_res_screen_2d_%a_%b_' a = <i> b = <j>
					sub = ((<i> * <Scale>)+ <j>)
					<cameraid> ::SetSubFrustum res = <Scale> subImage = <sub>
					wait \{16 frames}
					ScreenShot FileName = <text>
					wait \{16 frames}
					<j> = (<j> + 1)
				repeat <Scale>
				<i> = (<i> + 1)
			repeat <Scale>
			<cameraid> ::SetSubFrustum res = 1 subImage = 0
			Change \{ISOLATE_2D_RENDER = 0}
		endif
	endif
	if CutsceneFinished \{name = cutscene}
		UnPauseGame
	else
		KillSkaterCamAnim \{name = hires_cutscene_hack}
	endif
endscript

script SpawnHiResScreenshot
	SpawnScriptLater HiResScreenshot params = <...>
endscript

script CubeMapScreenshots
endscript

script SpawnCubeMapScreenshots
endscript

script lock_cam_top_down
endscript

script lock_cam_cube_dir
endscript
