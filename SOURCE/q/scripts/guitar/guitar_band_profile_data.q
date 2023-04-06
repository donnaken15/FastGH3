musician_body = [
	{
		desc_id = #"0x55cce6ca"
		pak = 'pak\models\guitarists\player\player.pak'
		asset_context = axel_1
	}
]
musician_instrument = [
	{
	}
]
download_musician_body = $nullArray

script get_musician_body_size
	GetArraySize \{musician_body GlobalArray}
	size = (<array_Size>)
	if GlobalExists \{name = download_musician_body Type = array}
		GetArraySize \{download_musician_body GlobalArray}
		size = (<array_Size> + <size>)
	endif
	return array_Size = <size>
endscript

script get_musician_body_struct
	GetArraySize \{musician_body GlobalArray}
	if (<index> < <array_Size>)
		return info_struct = ($musician_body [<index>])
	else
		return info_struct = ($download_musician_body [(<index> - <array_Size>)])
	endif
endscript
download_musician_instrument = $nullArray

script get_musician_instrument_size
	GetArraySize \{musician_instrument GlobalArray}
	size = (<array_Size>)
	if GlobalExists \{name = download_musician_instrument Type = array}
		GetArraySize \{download_musician_instrument GlobalArray}
		size = (<array_Size> + <size>)
	endif
	return array_Size = <size>
endscript

script get_musician_instrument_struct
	GetArraySize \{musician_instrument GlobalArray}
	if (<index> < <array_Size>)
		return info_struct = ($musician_instrument [<index>])
	else
		return info_struct = ($download_musician_instrument [(<index> - <array_Size>)])
	endif
endscript
