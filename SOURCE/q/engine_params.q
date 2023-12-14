control_pelvis_offset_assert = 0
control_pelvis_max_offset = 2.5
control_pelvis_render_offset = 0

script ToggleControlPelvisRender
    if ($control_pelvis_render_offset = 0)
        Change \{control_pelvis_render_offset = 1}
    else 
        Change \{control_pelvis_render_offset = 0}
    endif
endscript
engine_startup_params = [
    {
        Platform = Xenon
        target_ntsc_framerate = 144
        gpu_vsync_time_interval = 8
        pool_text_instances = 10000
        num_sound_instances = 512
        num_stream_resources = 6
        max_sound_entries = 1536
        max_sound_busses = 512
        max_sound_effects = 64
        sound_memory_size = 26214400
        max_cscript_instances_per_script = 200
        primary_ring_buffer_size = 0
        secondary_ring_buffer_size = 2048
        segment_size = 8
        framebuffer_width = 1280
        cpu_skinning_buffer_size = 12288
        cpu_skinning_buffer_history = 4
        screenspace_width = 1280
        screenspace_height = 720
        default_far_plane_distance = 0
        jobq_worker_count = 1
        jobq_worker_config = [
            3
            5
            2
        ]
        havok_jobq_worker_count = 1
        havok_jobq_worker_config = [
            0
        ]
        cull_smallobj = 0.0
        hardware_letterbox = FALSE
        max_dyn_nodes = 2000
        max_static_nodes = 4800
        max_other_nodes = 800
        main_buff_misc_size = 700
    }
]
memory_startup_params = [
    {
        Platform = Xenon
        pool_sizes = [
            500
            1000
            2000
            2000
            2000
            1000
            2000
            13000
            3000
            200
            200
            200
            500
            500
            500
            2000
            100
            1000
            100
            600
            200
            500
            3000
            500
            100
            100
            100
            300
            100
            100
            100
            500
        ]
    }
]

script screen_setup_standard
	SetScreen \{Aspect = 1.3333334 angle = camera_fov letterbox = 0}
	Change \{current_screen_mode = standard_screen_mode}
	printf \{'change to standard'}
endscript

script screen_setup_widescreen
	SetScreen \{Aspect = 1.7777778 angle = $widescreen_camera_fov letterbox = 0}
	Change \{current_screen_mode = widescreen_screen_mode}
	printf \{'change to widescreen'}
endscript

script screen_setup_letterbox
	SetScreen \{Aspect = 1.7777778 angle = $widescreen_camera_fov letterbox = 1}
	Change \{current_screen_mode = letterbox_screen_mode}
	printf \{'change to letterbox'}
endscript
