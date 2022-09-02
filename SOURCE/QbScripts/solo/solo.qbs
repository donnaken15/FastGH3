script({
	//int note_count = 100;
	qbkey part = guitar;
}) {

// stupid event caller won't pass actual specified time but when exactly this spawns

if (*game_mode == p2_battle)
{
	return;
}

FormatText(checksumname=scripts,'%d_scripts',d=(*current_song));
scripts = *%scripts;


// TODO: FIND SOMEWHERE TO RESET THESE VALUES
/*
if (%player == 1)
{
	change(note_index_p1 = 0);
}
elseif (%player == 2)
{
	change(note_index_p2 = 0);
}
*/

// have to do this complicated BS
getarraysize(%scripts);
k = 0;
repeat(%array_size)
{
	scr = (%scripts[%k]);
	printf('scr: %d, time: %c',d=(%scr.scr),c=(%scr.time));
	printf('%a == %b',a=(%scr.scr),b=solo);
	printf('%a <  %b',a=%time,b=(%scr.time));
	// 1003.50 >= 1000 because %$#@ you - neversoft
	if ((%scr.time >= %time && %scr.time < (%time+100/*stupid*/)) && (%scr.scr) == solo)
	{
		printf('i think its this one'); // :/
		// get real due time
		time = (%scr.time);
		break;
	}
	k = (%k + 1);
}

i = 1;
repeat(*current_num_players)
{
	FormatText(checksumName=player_status, 'player%d_status', d = %i);
	if (%part == (*%player_status.part))
	{
		printf('player%d_status', d = %i);
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
		printf('first note of solo: %d',d=(%solo_first_note * 3));
		printf('%d/%e',d=(%time),e=(%song_array[%solo_first_note]));
		printf('streak: %d',d=(*%player_status.current_run));
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
		printf('first note index:',d=(%current_first_note * 3));
		//            first solo note, first playable note
		note_index = (%note_index + %current_first_note + /*wtf*/3);
		// count notes hit before this executed
		printf('note index: %d, solo note: %e',d=(%note_index),e=(%solo_first_note));
		earlyhits = ((%note_index - %solo_first_note)*3);
		printf('early hits: %d',d=(%earlyhits));
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
				if (%hit_buffer[(%array_size-1)] == 1)
				{
					j = (%j + 1);
					printf('hit one early');
				}
				jj = (%jj + 1);
			}
		}
		printf('0');
		// find matching soloend in fastgh3_scripts
		getarraysize(%scripts);
		k = 0;
		endtime = (%time + 5000);
		repeat(%array_size)
		{
			// soloend.params.part == %part then endtime = soloend.time
			scr = (%scripts[%k]);
			if (%scr.time >= %time &&
				%scr.scr == soloend)
			{
				part2 = guitar;
				tmpval = (%scr.params); // why
				if (StructureContains(structure=%tmpval,part))
				{
					part2 = (%tmpval.part);
				}
				if (checksumequals(a=%part,b=%part2))
				{
					endtime = (%scr.time);
					printf('found soloend');
					break;
				}
			}
			k = (%k + 1);
		}
		// while ([i*3] < soloend.time)
		getarraysize(song_array);
		k = %solo_first_note;
		printf('k: %k',k=(%k));
		repeat(((%array_size-%k)*3))
		{
			if (%song_array[%k] >= (%endtime) || %k > %array_size)
			{
				break; 
			}
			k = (%k + 3);
		}
		k = (%k - %solo_first_note);
		k = (%k*3);
		k = (%k+1); // wtf
		printf('k: %k',k=%k);
		if (%i == 1) // tedious because neversoft
		{
			// how do i change global stuff using formattext checksum
			change(solo_active_p1 = 1);
			change(last_solo_hits_p1 = %j);
			change(last_solo_total_p1 = %k);
		}
		elseif (%i == 2)
		{
			change(solo_active_p2 = 1);
			change(last_solo_hits_p2 = (%j+1)); // wtf
			change(last_solo_total_p2 = %k);
		}
		solo_ui_create(player=%i);
	}
	i = (%i + 1);
}

}