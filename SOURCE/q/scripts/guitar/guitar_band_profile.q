Musician_Profiles = [
	{
		name = 'Axel'
	}
]
Demo_Musician_Profiles = [
]
download_musician_profiles = [
]

script get_musician_profile_size
	GetArraySize \{$#"0xdc911d21"}
	size = (<array_Size>)
	if GlobalExists \{name = download_musician_profiles Type = array}
		GetArraySize \{$#"0x6cadf63f"}
		size = (<array_Size> + <size>)
	endif
	return array_Size = <size>
endscript

script get_musician_profile_struct
	GetArraySize \{$#"0xdc911d21"}
	if (<index> < <array_Size>)
		return profile_struct = ($Musician_Profiles [<index>])
	else
		return profile_struct = ($download_musician_profiles [(<index> - <array_Size>)])
	endif
endscript
