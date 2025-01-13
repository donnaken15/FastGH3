
script animate_helper_arrows
	if (<direction> = up)
		generic_menu_up_or_down_sound \{up}
		if ScreenElementExists \{id = arrow_up}
			arrow_up ::DoMorph \{Scale = (1.8, 1.5) time = 0.1}
			arrow_up ::DoMorph \{Scale = (1.375, 1.0) time = 0.1}
		endif
	else
		generic_menu_up_or_down_sound \{down}
		if ScreenElementExists \{id = arrow_down}
			arrow_down ::DoMorph \{Scale = (1.8, 1.5) time = 0.1}
			arrow_down ::DoMorph \{Scale = (1.375, 1.0) time = 0.1}
		endif
	endif
endscript
