gh3_songlist = [
	fastgh3
]
download_songlist = [
]
download_songlist_props = {
}
gh3_songlist_props = {
	fastgh3 = {
		checksum = fastgh3
		name = 'fastgh3'
		title = ""
		artist = ""
		year = ""
		artist_text = $artist_text_by
		original_artist = 1
		version = gh3
		leaderboard = 1
		gem_offset = 0
		input_offset = 0
		singer = None
		keyboard = FALSE
		countoff = ''
		rhythm_track = 0
		band_playback_volume = band_volume
		guitar_playback_volume = guitar_volume
		$fastgh3_extra
	}
}
permanent_songlist_props = {
}
fastgh3_meta = {
	title = ''
	author = ''
	album = ''
	year = ''
}
fastgh3_extra = {
}
band_volume = 1.0
guitar_volume = 1.0
artist_text_by = "by"
artist_text_as_made_famous_by = "as made famous by"

script assert_song_data
	printstruct <...>
	ScriptAssert \{'Song not found'}
endscript

script get_song_original_artist\{song = invalid}
	if StructureContains structure = $gh3_songlist_props <song>
		return original_artist = ($gh3_songlist_props.<song>.original_artist)
	endif
	assert_song_data <...>
endscript

script get_song_title
	return song_title = ($fastgh3_meta.title)
endscript

script get_song_prefix\{song = invalid}
	if StructureContains structure = $gh3_songlist_props <song>
		return song_prefix = ($gh3_songlist_props.<song>.name)
	endif
	assert_song_data <...>
endscript

script get_song_artist
	return song_artist = ($fastgh3_meta.author)
endscript

script get_song_artist_text\{song = invalid}
	if StructureContains structure = $gh3_songlist_props <song>
		return song_artist_text = ($gh3_songlist_props.<song>.artist_text)
	endif
	assert_song_data <...>
endscript

script get_song_struct\{song = invalid}
	if StructureContains structure = $gh3_songlist_props <song>
		return song_struct = ($gh3_songlist_props.<song>)
	endif
	assert_song_data <...>
endscript

script get_songlist_size
	GetArraySize \{$gh3_songlist}
	size = (<array_Size>)
	if GlobalExists \{name = download_songlist Type = array}
		GetArraySize \{$download_songlist}
		size = (<array_Size> + <size>)
	endif
	return array_Size = <size>
endscript

script get_songlist_checksum
	GetArraySize \{$gh3_songlist}
	if (<index> < <array_Size>)
		return song_checksum = ($gh3_songlist [<index>])
	else
		return song_checksum = ($download_songlist [(<index> - <array_Size>)])
	endif
endscript

script is_song_downloaded\{song_checksum = schoolsout}
	if StructureContains structure = ($download_songlist_props)<song_checksum>
		FormatText textname = FileName '%s_song.pak' s = (($download_songlist_props.<song_checksum>).name)
		GetContentFolderIndexFromFile <FileName>
		if (<device> = content)
			return \{download = 1 true}
		else
			return \{download = 1 FALSE}
		endif
	else
		return \{download = 0 true}
	endif
endscript

script get_song_rhythm_track\{song = invalid}
	if StructureContains structure = $gh3_songlist_props <song>
		return rhythm_track = ($gh3_songlist_props.<song>.rhythm_track)
	endif
	assert_song_data <...>
endscript
