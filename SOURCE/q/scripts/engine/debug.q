METRIC_TIME = 1
METRIC_ARENAUSAGE = 2
METRIC_TOTALPOLYS = 4
METRIC_POLYSPROC = 8
METRIC_VERTS = 16
METRIC_RESOURCEALLOCS = 32
METRIC_TEXTUREUPLOADS = 64
METRIC_VU1 = 128
METRIC_DMA1 = 256
METRIC_DMA2 = 512
METRIC_VBLANKS = 1024
METRIC_DRAWTIME = 2048
METRIC_IHANDLERTIME = 4096
METRIC_SKYCACHE = 8192
METRIC_VIDEOMODE = 16384
METRIC_VRAMUSAGE = 32768
METRIC_MEMUSED = 65536
METRIC_MEMFREE = 131072
METRIC_REGIONINFO = 262144
Show_Warnings = 1
Show_Zone_budget_Warnings = 1
no_render_metrics = 0
DebugScriptPrintf = 0
DebugPausedObjects = 0
DebugPausedObjectsComponentToCheck = Model
DebugGaps = 0
AssertWhenGlobalsChangeType = 0

script controlpadmotion_debug_create
	if NOT ScreenElementExists \{id = controlpadmotion_debug}
		CreateScreenElement \{Type = Element3d parent = root_window id = controlpadmotion_debug Model = 'HUD_arrow/HUD_Arrow.mdl' CameraZ = -1 Scale = 1.0 Active_Viewport = 0 Pos = (120.0, 360.0)}
	endif
endscript

script controlpadmotion_debug_kill
	if ScreenElementExists \{id = controlpadmotion_debug}
		DestroyScreenElement \{id = controlpadmotion_debug}
	endif
endscript

script PrintVec
	if GotParam \{vec}
		GetVectorComponents <vec>
		printf "(%x, %y, %z)" X = <X> y = <y> z = <z>
	endif
endscript
