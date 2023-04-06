
script mod_startup
	element = 0.0
	array = []
	begin
		AddArrayElement <...>
	repeat 400
	avg_delta = <array>
	
	Wait \{1 gameframe}
	CreateScreenElement \{ Type = TextElement parent = root_window font = #"0xc0becb74" id = fps_text text = 'FPS:' Pos = (90.0,700.0) font_spacing = 2 just = [left bottom] internal_just = [left bottom] rgba = [255 255 255 255] Scale = 1 alpha = 1 z_priority = 1000 }
	GetArraySize \{avg_delta}
	Wait \{1 gameframe}
	time_since_refresh = 0.0
	// wtf
	SetScreenElementProps id = fps_text pos = (180.0,700.0) text = ''
	i = 0
	begin
		GetDeltaTime \{ignore_slomo}
		time_since_refresh = (<time_since_refresh> + <delta_time>)
		SetArrayElement arrayname=avg_delta index=<i> newvalue=<delta_time>
		Increment \{i}
		mod a=<i> b=<array_size>
		i = <mod>
		if (<time_since_refresh> >= (1.0/60.0))
			avg <avg_delta>
			value = (1/<avg>)
			CastToInteger \{value}
			FormatText textname = text '%d / %f' d = <value> f = $fps_max
			SetScreenElementProps id = fps_text text = <text>
			time_since_refresh = 0.0
		endif
		Wait \{1 gameframe}
	repeat
endscript
mod_info = {
	name = 'FPS Display'
	author = 'donnaken15'
}

script Sum
	getarraysize \{#"0x00000000"}
	sum = 0.0
	i = 0
	begin
		sum = (<sum> + (<#"0x00000000">[<i>] * 1.0))
		Increment \{i}
	repeat <array_size>
	return sum = <sum>
endscript
script Avg
	Sum <#"0x00000000">
	getarraysize \{#"0x00000000"}
	return avg = (<sum> / <array_size>)
endscript
