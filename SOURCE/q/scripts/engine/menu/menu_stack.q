
script menu_stack_push\{menu_params = {}}
	if NOT GotParam \{menu_script}
		ScriptAssert \{"need menu_script=some_script plz"}
	endif
	menu_stack_push_or_pop_menu <...> func = push
	if NOT GotParam \{no_create}
		menu_stack_create_latest
	endif
endscript

script menu_stack_pop
	menu_stack_push_or_pop_menu \{func = pop}
	if NOT GotParam \{no_create}
		menu_stack_create_latest
	endif
endscript

script menu_stack_create_latest
	if menu_stack_can_pop_menu
		if NOT GotParam \{no_destroy}
			if ScreenElementExists \{id = current_menu_anchor}
				DestroyScreenElement \{id = current_menu_anchor}
			endif
		endif
		menu_stack_get_local_stack
		pop \{menu_script}
		pop \{menu_params}
		<menu_script> <menu_params>
		return \{true}
	else
		printf \{"No menu to create in menu_stack_create_latest!"}
		return \{FALSE}
	endif
endscript

script menu_stack_clear
	root_window ::RemoveTags \{[menu_stack]}
endscript

script menu_stack_can_pop_menu
	menu_stack_get_local_stack
	if CanPop \{menu_script}
		return \{true}
	else
		return \{FALSE}
	endif
endscript

script menu_stack_get_local_stack
	root_window ::GetSingleTag \{menu_stack}
	return param_stacks = <menu_stack>
endscript

script menu_stack_push_or_pop_menu\{func = push}
	menu_stack_get_local_stack
	printf \{"--- menu_stack_push_or_pop_menu"}
	<func> menu_script
	<func> menu_params
	menu_stack_clear
	root_window ::SetTags menu_stack = <param_stacks>
endscript
