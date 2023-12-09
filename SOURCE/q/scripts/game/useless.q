
script EmptyScript
endscript

script nullscript
endscript

script empty_script
endscript

script WhyAmIBeingCalled
	printstruct <...>
	printf 'MY PRESENCE IS RUINING THIS GAME'
endscript

guitarist_info = {}
bassist_info = {}
vocalist_info = {}
drummer_info = {}

Strum_iterator = $EmptyScript
FretPos_iterator = $EmptyScript
FretFingers_iterator = $EmptyScript
WatchForStartPlaying_iterator = $EmptyScript
Drum_iterator = $EmptyScript
Drum_cymbal_iterator = $EmptyScript

/*
#"dict temp array" = [] // grease
script dict
	//change #"dict temp array" = []
	params = { do = test__ pass_index }
	AddParam {
		structure_name = params
		name = #"0x00000000"
		value = {
			c = {a = b}
		}
	}
	ForEachIn <params>
	//printstruct <...>
	//printstruct <...>
	//change #"dict temp array" = []
endscript
script test__
	printstruct <...>
	//AddArrayElement arrayname=#"dict temp array"
endscript
*///


