
/*script destroy_server_list_create_match_dialog
	create_match_dialog_unfocus
	destroy_menu \{menu_id = server_list_create_match_dialog_menu}
	if ScreenElementExists \{id = create_match_dialog_container}
		DestroyScreenElement \{id = create_match_dialog_container}
	endif
endscript

script create_match_dialog_select_create
	destroy_server_list_create_match_dialog
	ui_flow_manager_respond_to_action \{action = response_create_selected create_params = {menu_type = create_match}}
endscript

script create_match_dialog_select_cancel
	destroy_server_list_create_match_dialog
	ui_flow_manager_respond_to_action \{action = response_cancel_selected}
endscript

script create_match_dialog_select_back
	destroy_server_list_create_match_dialog
	ui_flow_manager_respond_to_action \{action = go_back}
endscript

script create_match_dialog_focus
	LaunchEvent \{Type = unfocus target = search_results_vmenu}
	LaunchEvent \{Type = focus target = server_list_create_match_dialog_vmenu}
endscript

script create_match_dialog_unfocus
	LaunchEvent \{Type = unfocus target = server_list_create_match_dialog_vmenu}
	LaunchEvent \{Type = focus target = search_results_vmenu}
endscript*///
dots_array = [
	" "
	"."
	". ."
	". . ."
]

script animate_dots
	num_dots = 0
	begin
		FormatText textname = new_text "%a" a = ($dots_array [<num_dots>])
		<id> ::SetProps text = <new_text>
		if (<num_dots> = 3)
			<num_dots> = 0
		else
			<num_dots> = (<num_dots> + 1)
		endif
		wait \{0.5 Second}
	repeat
endscript
