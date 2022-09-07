script({
	qbkey part = guitar;
}) {

// stupid event caller won't pass actual specified time but when exactly this spawns

if (*game_mode == p2_battle)
{
	return;
}

// TODO: FIND SOMEWHERE TO RESET VALUES
// (in transition scripts right now...)
// right now, in certain cases of restarting
// and skipping into a song, notes from previous
// song session get counted

// create routine for if script doesn't spawn from song?

FormatText(checksumname=scripts_name,'%d_scripts',d=(*current_song));
scripts = *%scripts_name;

// have to do this complicated BS
getarraysize(%scripts);
// k = index of fastgh3_scripts array
k = 0;
repeat
{
	// find own script props just for the exact time it was due to spawn
	scr = (%scripts[%k]);
	// 1003.50 >= 1000 because %$#@ you - neversoft
	// this made me want to funny jump off chair and start flying
	// execution time offset is within 0-10ms for me
	// probably tied to framerate
	if ((%scr.time+40) >= (%time) && (%scr.time) < (%time/*stupid*/) && (%scr.scr) == solo)
	{
		// fallback for no param entered
		part2 = guitar;
		if (StructureContains(structure=%scr,params))
		{
			tmpval = (%scr.params);
			if (StructureContains(structure=%tmpval,part))
			{
				part2 = (%tmpval.part);
			}
		}
		// part == part2 && time just about matches
		// so this has to be my script!
		if (checksumequals(a=%part,b=%part2))
		{
			// get real due time
			time = (%scr.time);
			break;
		}
	}
	k = (%k + 1);
	if (%k >= %array_size)
	{
		return;
	}
}
k = (%k + 1);
found_soloend = 0;
endtime = (%time + 5000);
// find matching soloend in fastgh3_scripts
repeat
{
	// soloend.params.part == %part then endtime = soloend.time
	scr = (%scripts[%k]);
	if (%scr.time >= %time &&
		%scr.scr == soloend)
	{
		part2 = guitar;
		if (StructureContains(structure=%scr,params))
		{
			tmpval = (%scr.params); // why
			if (StructureContains(structure=%tmpval,part))
			{
				part2 = (%tmpval.part);
			}
		}
		if (%part == %part2)
		{
			endtime = (%scr.time);
			found_soloend = 1;
			break;
		}
	}
	k = (%k + 1);
	if (%k >= %array_size)
	{
		break;
	}
}
// wrote because general section events (not just section markers) appeared in Soulless 1
// quit if soloend for this script's part can't be found
if (%found_soloend == 0)
{
	return;
}

i = 1;
repeat(*current_num_players)
{
	if (%i == 1)
	{
		change(last_solo_index_p1 = 0);
	}
	elseif (%i == 2)
	{
		change(last_solo_index_p2 = 0);
	}
	FormatText(checksumName=player_status, 'player%d_status', d = %i);
	if (%part == (*%player_status.part))
	{
		gemarrayid = (*%player_status.current_song_gem_array);
		song_array = *%gemarrayid;
		getarraysize(song_array);
		// find index with >= %time
		solo_first_note = 0;
		// while ([i*3] < %time)
		repeat(%array_size)
		{
			if (%song_array[%solo_first_note] >= %time)
			{
				break;
			}
			solo_first_note = (%solo_first_note + 3);
		}
		// current note index
		if (%i == 1)
		{
			note_index = *note_index_p1;
		}
		elseif (%i == 2)
		{
			note_index = *note_index_p2;
		}
		note_index = (%note_index / 3);
		current_first_note = 0;
		if (*current_starttime != 0)
		{
			// find first playable note (if skipped into song)
			starttime = *current_starttime;
			repeat(%array_size)
			{
				if (%song_array[%current_first_note] >= %starttime)
				{
					break;
				}
				current_first_note = (%current_first_note + 3);
			}
		}
		//            first solo note, first playable note
		note_index = (%note_index + %current_first_note + 3);
		// count notes hit before this executed
		earlyhits = ((%note_index - %solo_first_note)*3);
		if (%i == 1)
		{
			hit_buffer = *solo_hit_buffer_p1;
		}
		elseif (%i == 2)
		{
			hit_buffer = *solo_hit_buffer_p2;
		}
		getarraysize(%hit_buffer);
		j = 0;
		jj = 0;
		if (%earlyhits > 0)
		{
			repeat(%earlyhits)
			{
				if (%hit_buffer[(%array_size-1)] == 1 && %song_array[(%note_index-(%jj/3))] >= %time)
				{
					j = (%j + 1);
				}
				jj = (%jj + 1);
			}
		}
		k = 0;
		// while ([i*3] < soloend.time)
		getarraysize(song_array);
		k = %solo_first_note;
		repeat(((%array_size-%k)*3)) // do i need this condition even, because of the below
		{
			if (%song_array[%k] >= (%endtime) || %k > %array_size)
			{
				break; 
			}
			k = (%k + 3);
		}
		k = (%k - %solo_first_note);
		k = (%k*3);
		if (%i == 1) // tedious because neversoft
		{
			// how do i change global stuff using formattext checksum
			change(solo_active_p1 = 1);
			change(last_solo_hits_p1 = %j);
			change(last_solo_index_p1 = %j);
			change(last_solo_total_p1 = %k);
		}
		elseif (%i == 2)
		{
			change(solo_active_p2 = 1);
			change(last_solo_hits_p2 = %j);
			change(last_solo_index_p2 = %j);
			change(last_solo_total_p2 = %k);
		}
		solo_ui_create(player=%i);
	}
	i = (%i + 1);
}

}