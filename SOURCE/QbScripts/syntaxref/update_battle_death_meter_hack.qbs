script()
{
	GetSongTimeMs();
	endtime = *end_time;
	starttime = %time;
	if (* current_song == bosstom)
		{ endtime = 197733; }
	elseif (* current_song == bossslash)
		{ endtime = 226504; }
	elseif (* current_song == bossdevil)
		{ endtime = 321466; }
	elseif (* current_song == bossjoe)
		{ endtime = 236950; }
	elseif (* current_song == bosszakk)
		{ endtime = 230783; }
	elseif (* current_song == bossted)
		{ endtime = 183503; }
	endif;
}