
/**///

evalverbose = 0

script eval \{'printf \'no command specified\''}
	printf "] %l" l = <#"0x00000000">
	if NOT evaltokenizer <#"0x00000000">
		printf \{'tokenizer did not return successfully'}
		return false
	endif
	//printstruct <tokens>
	//Block
	//return
	array = [] // nodes
	getarraysize \{tokens}
	i = 0
	begin
		token = (<tokens>[<i>])
		switch (<token>.type)
			case bytecode
				switch (<token>.value)
					case 1 //newline
						if NOT evalparseline <tokens> token_count = <token_count> i = (<i> + 1)
							printf \{'line parser did not return successfully'}
							return \{false}
						endif
						//printstruct <node>
				endswitch
		endswitch
		AddArrayElement array = <array> element = <node>
		Increment \{i}
		if (<i> >= <token_count>)
			break
		endif
	repeat
	RemoveComponent \{tokens}
	
	script_locals = {}
	script_lastresult = #"  invalid  "
	// node values:
	// start_type, line_type, left_op, right_op
	getarraysize \{array}
	i = 0
	begin
		node = (<array>[<i>])
		//printstruct <node>
		switch (<node>.start_type)
			case name
				switch (<node>.line_type)
					case assign
						AddParam {
							structure_name = script_locals
							name = (<node>.left_op) value = (<node>.right_op)
						}
					case call
						evalrun (<node>.left_op) params = (<node>.right_op)
						script_locals = { <script_locals> <returned> }
						script_lastresult = <returned>
				endswitch
			case result
				EmptyScript
		endswitch
		Increment \{i}
	repeat <array_size>
	//printstruct <script_locals>
	
	//if NOT (<script_lastresult> = #"  invalid  ")
	//	printstruct <script_locals>
	//endif
	//Block
	
	return \{true}
endscript

script evalrun
	// isolate parameters returned from scripts being called
	if NOT GotParam \{elevated}
		if NOT GotParam \{params}
			params = {}
		endif
		evalrun elevated #" args " = <params> #"  script to run  " = <#"0x00000000">
		return returned = <returned>
	else
		RemoveFlag \{elevated}
		if NOT ChecksumEquals a = <#"  script to run  "> b = #"printstruct" // WTFFFFFFFFF
			<#"  script to run  "> <#" args ">
		else
			printstruct <#" args ">
		endif
		RemoveComponent \{#"  script to run  "}
		RemoveComponent \{#" args "}
		return returned = <...>
	endif
endscript

script evalparseglobal
	//printstruct <...>
	if (<i> + 1 >= <token_count>)
		printf \{'parser prematurely ended when global pointer wasn\'t followed by a name!!!!!!'}
		return \{false}
	endif
	next_token = (<#"0x00000000">[(<i> + 1)])
	printtoken t = <next_token> i = <i>
	//printstruct <next_token>
	if NOT (<next_token>.type = name)
		printf \{'parser prematurely ended when global pointer wasn\'t followed by a name!!!!!!'}
		return \{false}
	endif
	//printstruct true value = (<next_token>.value) i = (<i> + 1)
	return true value = (<next_token>.value) i = (<i> + 1)
endscript

script evalparseexpr \{depth = 0 debug = $evalverbose}
	expression_value = 0
	operator = 0
	operation = 0
	mode = 0
	printf 'expression evaluating ('
	begin
		// don't know what the order of operations in qscript is
		// but i can somehow imagine if comparison isolates
		// the two values around it, somehow this random scenario came to mind
		// if without parentheses, this (4+5=5) could be executed as (4+(5=5))
		skip = 0
		token = (<#"0x00000000">[<i>])
		if (<token>.type = bytecode)
			operator = (<token>.value)
			if NOT (<operator> >= 7 & <operator> <= 15)
				if NOT (<operator> = 75)
					printf 'invalid or unimplemented bytecode in expression: %a <%b>, skipping' a = (<token>.literal) b = (<token>.value)
					skip = 1
				endif
			endif
		else
			operator = 0
		endif
		if (<skip> = 0)
			printtoken t = <token> i = <i> indent = (<depth> + 1) depth = <depth>
			switch (<mode>)
				// 0 - get lvalue (first)
				// 1 - get operator
				// 2 - get rvalue, apply operator (subsequent values)
				case 0
				case 2
					if (<token>.type = bytecode)
						switch (<token>.value)
							case 15
								if (<mode> = 0)
									printf \{'warning: empty expression'}
								endif
								break
							case 14 // (
								evalparseexpr <#"0x00000000"> token_count = <token_count> i = (<i> + 1) depth = (<depth> + 1)
								i = <t>
							case 75 // $
								evalparseglobal <#"0x00000000"> token_count = <token_count> i = <i>
								value = ($<value>)
								//printstruct <...>
							default
								printf 'invalid operator (mode 0): %a' a = (<token>.literal)
								return false
						endswitch
					else
						value = (<token>.value)
					endif
					if (<mode> = 0)
						expression_value = <value>
					else
						switch <operation>
							case 7
								expression_value = (<expression_value> = <value>)
							case 11
								expression_value = (<expression_value> + <value>)
							case 10
								expression_value = (<expression_value> - <value>)
							case 13
								expression_value = (<expression_value> * <value>)
							case 12
								expression_value = (<expression_value> / <value>)
							case 8
								// uhhhh, will need to put in another expression
								expression_value = (<expression_value>.<value>)
							default
							//case 9
								// uhhhhh
								printf 'oh no (%e)' e = <operation>
								return false
						endswitch
					endif
					printf 'current value = %a' a = <expression_value>
					mode = 1
				case 1
					switch <operator>
						case 7 // =(=)
						case 8 // .
						case 9 // ,
						case 11 // +
						case 10 // -
						case 13 // *
						case 12 // /
							operation = <operator>
						case 15
							break
						default
							printf 'invalid operator (mode 1): %a' a = (<operator>)
							return false
					endswitch
					mode = 2
			endswitch
		endif
		Increment \{i}
	repeat
	printf ')'
	//printstruct <...>
	return true value = <expression_value> t = (<i>)
endscript

script evalparsestruct \{depth = 0 debug = $evalverbose}
	AddParams \{struct = {} brackets = 0}
	token = (<#"0x00000000">[<i>])
	if (<debug>)
		printf 'struct assembling {'
	endif
	if (<token>.type = bytecode & <token>.value = 3)
		brackets = 1
		if (<debug>)
			printf 'got brackets'
		endif
		Increment \{i}
	endif
	;passthru = 0
	type = none
	begin
		skip = 0
		target = #"0x00000000"
		token = (<#"0x00000000">[<i>])
		printtoken t = <token> i = <i> indent = (<depth> + 1) depth = <depth>
		switch (<token>.type)
			case name
				//printf '%t' t = (<token>.value)
				next_token = (<#"0x00000000">[(<i> + 1)])
				// this feels like a tumor i'm writing
				if (<i> + 1 < <token_count> & <next_token>.type = bytecode & <next_token>.value = 7)
					if NOT (<i> + 2 < <token_count>)
						printf 'parser prematurely ended when variable assignment wasn\'t followed by a value!!!!!!'
						break
					endif
					next_token = (<#"0x00000000">[(<i> + 2)])
					//j = (<i> + 3)
					//pad <j> count = 3 pad = ' '
					//printf '%i: token: [%v] <%t>' i = <pad> t = (<next_token>.type) v = (<next_token>.value)
					switch (<next_token>.type)
						case bytecode
							switch (<next_token>.value)
								//case 14
								case 3
								//	type = struct
								//	target = (<token>.value)
								//	value = (<next_token>.value)
								//	i = (<i> + 3)
									evalparsestruct <#"0x00000000"> token_count = <token_count> i = (<i> + 2) depth = (<depth> + 1)
									i = <t>
									target = (<token>.value)
								case 75
									evalparseglobal <#"0x00000000"> token_count = <token_count> i = (<i> + 2)
									target = (<token>.value)
									value = ($<value>)
									i = (<i> + 4)
								case 14
									evalparseexpr <#"0x00000000"> token_count = <token_count> i = (<i> + 3)
									target = (<token>.value)
									i = <t>
									//printstruct <...>
								//case 5
								//	type = array
									//target = (<token>.value)
									//value = (<next_token>.value)
									//i = (<i> + 2)
								default
									printf 'invalid syntax for assignment!!!!!!!!!!!!!'
									break
							endswitch
						case string
						case int
						case float
						case name
						//	type = (<next_token>.type)
							//printstruct <token>
							target = (<token>.value)
							value = (<next_token>.value)
							if (<next_token>.type = string & <next_token>.wide = true)
								RemoveComponent \{value}
								AddParam_WStr name = <target> (<next_token>.value)
								struct = { <struct> <value> }
								skip = 1
							endif
							i = (<i> + 2)
					endswitch
				else
					value = (<token>.value)
				endif
			case string
			case int
			case float
				value = (<token>.value)
				//type = (<token>.type)
				if (<token>.type = string)
					if (<token>.wide = true)
						//printf '/!\ widestring gets ignored by AddParam!!!!! >:('
						AddParam_WStr name = #"0x00000000" (<token>.value)
						struct = { <struct> <value> }
						skip = 1
					endif
				endif
			case bytecode
				switch (<token>.value)
					case 3
						evalparsestruct <#"0x00000000"> token_count = <token_count> i = <i> depth = (<depth> + 1)
						i = <t>
					case 75
						evalparseglobal <#"0x00000000"> token_count = <token_count> i = <i>
						i = (<t> + 2)
						target = #"0x00000000"
						tmp = ($<value>)
						RemoveComponent \{value}
						value = <tmp>
				endswitch
				;if (<token>.value = 44)
				;	passthru = 1
				;endif
				if (<brackets> = 1)
					if (<token>.value = 4)
						break
					endif
					if (<token>.value = 1)
						skip = 1
					endif
				else
					if (<token>.value = 1)
						i = (<i> - 1)
						break
					endif
				endif
		endswitch
		//printf '%t = %v' t = (<token>.value) v = <value>
		if (<skip> = 0)
			AddParam structure_name = struct name = <target> value = <value>
		endif
		Increment \{i}
		if (<i> >= <token_count>)
			if (<brackets> = 1)
				printf 'warning: unclosed brackets'
			endif
			break
		endif
	repeat
	if (<debug>)
		printf '}'
	endif
	//if (<depth> = 0)
		//printstruct <struct>
	//endif
	return value = <struct> t = <i>
endscript

script evalparseline \{debug = $evalverbose}
	//line_type = call
	//line_type = assign
	start_type = none
	t = <i> // current token (continued from other functions)
	i = 0 // current bytecode/item of tokenized line
	// only needed to check first two ops
	// for assignment or function call for now
	begin
		token = (<#"0x00000000">[<t>])
		//pad <t> count = 3 pad = ' '
		//printf '>%i: token: [%v] <%t>' i = <pad> t = (<token>.type) v = (<token>.value)
		printtoken t = <token> i = <i> debug = <debug>
		//printf 'token: %v <%t>' t = (<token>.type) v = (<token>.value)
		//printstruct (<token>.value)
		//printf '%a' a = (<token>.type)
		switch (<token>.type)
			case name
				if (<i> < 3)
					switch <i>
						case 0
							start_type = name
						case 1
							// there needs to be a better way to handle this and be less redundant
							line_type = call
						case 2
							right_op = (<token>.value)
					endswitch
				endif
			case int
			case float
			case string
				switch <i>
					case 0
						start_type = result
					case 1
						line_type = call
					case 2
						right_op = (<token>.value)
				endswitch
			case bytecode
				op = (<token>.value)
				switch <op>
					case 7
						//if (<i> < 2)
							/*if (<i> = 0)
							endif*///
							if (<i> = 1)
								line_type = assign
							else
								printf 'invalid syntax!!!!!!!! (%i)' i = <i>
								return false
							endif
						//endif
					case 14
					case 3
					case 5
					case 75
						switch <op>
							case 14
								evalparseexpr <#"0x00000000"> token_count = <token_count> i = (<i> + 2)
								i = <t>
								right_op = <value>
							case 3
								//evalparsestruct
							case 5
								//evalparsearray
						endswitch
						if (<i> < 3)
							switch <i>
								case 0
									start_type = result
									left_op = <value>
								case 1
									line_type = call
								case 2
									line_type = assign
							endswitch
						endif
					case 1
						if (<i> = 1)
							line_type = call
						endif
						break
					default
						//if IndexOf (<token>.value) array = ($eval_syntax2bytecodes)
						//	literal = ($evaltokens_syntax[<indexof>])
						//else
						//	literal = 'unknown'
						//endif
						printf {
							'unknown bytecode %a!!!!!!!! literal: \'%b\''
							a = <op> b = (<token>.literal)
						}
						return false
				endswitch
			default
				printf {
					'unknown token type %a!!!!!!!! value: \'%b\''
					a = (<token>.type) b = (<token>.value)
				}
		endswitch
		if (<i> = 0)
			left_op = (<token>.value)
		endif
		if ((<line_type> = call | <line_type> = assign) & <i> < 3)
			evalparsestruct <#"0x00000000"> token_count = <token_count> i = (<t>) debug = <debug>
			right_op = <value>
			//printstruct <value>
		endif
		//printstruct (<#"0x00000000">[<t>])
		Increment \{t}
		Increment \{i}
		if (<t> >= <token_count>)
			if (<i> = 1)
				line_type = call
			endif
			break
		endif
	repeat
	if (<debug>)
		printf 'eol'
	endif
	return {
		true
		node = {
			start_type = <start_type>
			line_type = <line_type>
			left_op = <left_op>
			right_op = <right_op>
		}
		i = (<t> - 1) // :/
	}
endscript

script evaltokenizer \{debug = $evalverbose}
	array = [ // tokens
		{
			type = bytecode
			value = 1
		}
	]
	parser_pos = 0
	current_token = ""
	FormatText textname = #"0x00000000" "%a" a = <#"0x00000000">
	StringRemoveTrailingWhitespace \{param = #"0x00000000"}
	// ensure wstring because i imagine expressions won't work when comparing cstring and wstring, or even concat
	StringToCharArray string = <#"0x00000000">
	getarraysize \{char_array}
	parser_text = <char_array>
	parser_size = <array_size>
	RemoveComponent \{char_array}
	RemoveComponent \{array_size}
	RemoveComponent \{#"0x00000000"}
	
	token_count = 1
	matched = none
	new_token = 0
	eof = 0
	literal = ""
	
	WStr = { delegate = LocalizedStringEquals }
	
	ProfilingStart
	// region tokenizer
	// parser_pos = 0
	begin
		begin
			if (<parser_pos> >= <parser_size>)
				eof = 1
				break
			endif
			
			current_char = (<parser_text>[<parser_pos>])
			
			if ArrayContains contains = <current_char> array = ($evaltokens_whitespace)
				if (<new_token> = 1)
					new_token = 0
					break
				endif
				Increment \{parser_pos}
			else
				if (<new_token> = 0)
					new_token = 1
				endif
				break
			endif
		repeat
		
		if (<new_token> = 1)
			if NOT LocalizedStringEquals a = <current_token> b = ""
				printf <current_token>
				current_token = ""
			endif
		endif
		
		if (<eof> = 1)
			break
		endif
		
		matched = none
		// region check what kind of item the current character is
		begin // *
			//if (<matched> = none)
				if LocalizedStringEquals a = <current_char> b = "'"
					matched = string
					string_type = c
					break
				endif
				if LocalizedStringEquals a = <current_char> b = "\""
					matched = string
					string_type = w
					break
				endif
			//endif
			//if (<matched> = none)
				StringToCharArray \{string = $evaltokens_alphabet}
				if ArrayContains contains = <current_char> array = <char_array>
					matched = name
					break
				endif
			//endif
			// comment
			//if (<matched> = none)
				if LocalizedStringEquals a = <current_char> b = "/"
					if (<parser_pos> < <parser_size>)
						Increment \{parser_pos}
						if LocalizedStringEquals a = (<parser_text>[<parser_pos>]) b = "/"
							Increment \{parser_pos}
							begin
								current_char = (<parser_text>[<parser_pos>])
								if (<current_char> = "\\")
									if (<parser_pos> < <parser_size>)
										if (<parser_text>[(<parser_pos>+1)] = "n")
											matched = none
											break
										endif
									endif
								endif
								if (<parser_pos> >= <parser_size>)
									matched = none
									break
								endif
								Increment \{parser_pos}
							repeat
							break
						endif
					endif
				endif
			//endif
			//if (<matched> = none)
				if (<current_char> = "\\")
					Increment \{parser_pos}
					current_char = (<parser_text>[<parser_pos>])
					if (<current_char> = "n")
						matched = bytecode
						value = 1
						//Increment \{parser_pos}
						break
					endif
				endif
			//endif
			//if (<matched> = none)
				StringToCharArray string = ($evaltokens_digits + "-")
				// feels repetitive to have this condition over and over
				// array of token arrays? (trollface)
				if ArrayContains contains = <current_char> array = <char_array>
					//printf <current_char>
					matched = digits
					break
				endif
			//endif
			//if (<matched> = none)
				StringToCharArray string = ($evaltokens_syntax_nosep)
				if IndexOf <WStr> <current_char> array = <char_array>
					matched = bytecode
					value = ($eval_syntax2bytecodes[<indexof>])
					literal = <current_char>
				else
					if ArrayContains contains = <current_char> array = ($evaltokens_syntax)
						matched = bytecode
						//value = ($eval_syntax2bytecodes[<indexof>])
						break
					endif
				endif
			//endif
			;if (<matched> = none)
			;	StringToCharArray \{string = $evaltokens_syntax}
			;	if WStringIsInArray <current_char> array = <char_array>
			;		matched = syntax
			;		break
			;	endif
			;endif
		repeat 1 // *HACK!!1/!/1///!/!/!/1!!!///!
		RemoveComponent \{char_array}
		// endregion
		// region parse the rest of the text until no more characters match the type of text to parse
		switch <matched>
			case name
				name = <current_char>
				Increment \{parser_pos}
				StringToCharArray string = ($evaltokens_alphabet + $evaltokens_digits)
				finish = 0
				begin
					current_char = (<parser_text>[<parser_pos>])
					if (<parser_pos> >= <parser_size>)
						finish = 1
					endif
					if NOT ArrayContains contains = <current_char> array = <char_array>
						finish = 1
					endif
					if (<finish> = 0)
						name = (<name> + <current_char>)
						Increment \{parser_pos}
					endif
					if (<finish> = 1)
						literal = <name>
						ExtendCrc #"0xFFFFFFFF" <name> out = value
						RemoveComponent \{name}
						break
					endif
				repeat // |:|
				RemoveComponent \{char_array}
			case string
				last_char = (<parser_text>[<parser_pos>])
				Increment \{parser_pos}
				if (<string_type> = c)
					delim = "'"
					wide = false
				elseif (<string_type> = w)
					delim = "\""
					wide = true
				endif
				string = ""
				finish = 0
				begin
					current_char = (<parser_text>[<parser_pos>])
					if (<current_char> = <delim>)
						if NOT (<last_char> = "\\")
							finish = 1
						else
							trim <string>
							string = <trim>
							RemoveComponent \{trim}
						endif
					endif
					if (<finish> = 0)
						string = (<string> + <current_char>)
						last_char = (<parser_text>[<parser_pos>])
						Increment \{parser_pos}
					endif
					if (<parser_pos> >= <parser_size>)
						finish = 1
					endif
					if (<finish> = 1)
						literal = (<delim> + <string> + <delim>)
						if (<string_type> = c)
							formattext textname = value '%a' a = <string>
						else
							value = <string>
						endif
						RemoveComponent \{delim}
						RemoveComponent \{last_char}
						RemoveComponent \{string_type}
						RemoveComponent \{string}
						break
					endif
				repeat
				Increment \{parser_pos}
			case bytecode
				if NOT GotParam \{value}
					syntax = ""
					begin
						syntax = (<syntax> + <current_char>)
						Increment \{parser_pos}
						if (<parser_pos> >= <parser_size>)
							break
						endif
						current_char = (<parser_text>[<parser_pos>])
						if NOT ArrayContains contains = <current_char> array = ($evaltokens_syntax)
							break
						endif
					repeat
					literal = <syntax>
					if IndexOf <WStr> <syntax> array = ($evaltokens_syntax)
						value = ($eval_syntax2bytecodes[<indexof>])
					else
						//value = 0
						printf {
							'tokenizer error!!!! @ %a / %b | invalid syntax: "%c"'
							a = <parser_pos> b = <parser_size> c = <syntax>
						}
						return false
					endif
					RemoveComponent \{syntax}
				else
					Increment \{parser_pos}
				endif
			case digits
				// don't exceed 1 for either
				dashes = 0
				dots = 0
				digits = 0
				number = 0
				decimals = 0
				matched = int
				//StringToCharArray string = ("-." + $evaltokens_digits)
				literal = ""
				begin
					current_char = (<parser_text>[<parser_pos>])
					//printf <current_char>
					if ArrayContains contains = <current_char> array = <char_array>
						literal = (<literal> + <current_char>)
						switch <current_char>
							case "-"
								Increment \{dashes}
							case "."
								Increment \{dots}
								number = (<number> * 1.0)
								matched = float
							default
								StringToInteger \{current_char}
								if (<dots> = 0)
									number = ((<number> * 10) + <current_char>)
									Increment \{digits}
								else
									Increment \{decimals}
									MathPow 10 exp = <decimals>
									number = (<number> + (<current_char> / <pow>))
								endif
						endswitch
						if (<dots> > 1 || <dashes> > 1)
							printf {
								'tokenizer error!!!! @ %a / %b | too many dots or dashes in parsed number: "%e" dashes: %c, dots: %d'
								a = <parser_pos> b = <parser_size> c = <dashes> d = <dots> e = <number>
							}
							return false
						endif
					else
						break
					endif
					Increment \{parser_pos}
					if (<parser_pos> >= <parser_size>)
						break
					endif
				repeat
				value = <number>
				if (<dashes> = 1)
					value = (<value> * -1)
				endif
				RemoveComponent \{dashes}
				RemoveComponent \{dots}
				RemoveComponent \{digits}
				RemoveComponent \{decimals}
				//RemoveComponent \{char_array}
				RemoveComponent \{current_char}
				RemoveComponent \{current_char}
			case none
				EmptyScript
			default
				printf 'unknown token!!!!!!! symbol: %a' a = <current_char>
		endswitch
		// endregion
		// save token
		if NOT ChecksumEquals a = <matched> b = none
			AddArrayElement {
				array = <array>
				element = {
					type = <matched>
					value = <value>
					wide = <wide>
					literal = <literal>
				}
			}
			RemoveComponent \{wide}
			RemoveComponent \{literal}
			//printf '%d %e' d = <parser_pos> e = <token_count>
			Increment \{token_count}
		endif
		RemoveComponent \{value}
	repeat <parser_size>
	// endregion
	ProfilingEnd <...> 'evaltokenizer'
	RemoveComponent \{parser_pos} // useless but whatever
	RemoveComponent \{parser_size}
	RemoveComponent \{matched}
	RemoveComponent \{new_token}
	RemoveComponent \{eof}
	//if (<debug>)
	//	printstruct <...>
	//endif
	return true tokens = <array> token_count = <token_count>
endscript

evaltokens_whitespace = [ ]
evaltokens_alphabet = ""
evaltokens_digits = ""
evaltokens_syntax = [ ]
evaltokens_syntax_nosep = ""
eval_syntax2bytecodes = [ ]
evaltokens_keywords = [ ]
eval_kw2bytecodes = [ ]

script decompress_eval
	change evaltokens_whitespace = [ " " "	" "\n" ]
	formattext textname = text "%s" s = 'ABCDEFGHIJKLMNOPRQSTUWXYZabcdefghijklmnopqrstuvwxyz_'
	change evaltokens_alphabet = <text>
	formattext textname = text "%s" s = '0123456789'
	change evaltokens_digits = <text>
	change evaltokens_syntax = [ "=" ":" "." "," "(" ")" "{" "}" "[" "]" "+" "-" "*" "/" "$" "!=" "!" "&" "|" "<" "<=" ">" ">=" "<...>" ]
	change evaltokens_syntax_nosep = "=:.,(){}[]+-*/$"
	// should be named in a way that indicates these are each one character
	// because later part of tokenizer continuously adds up characters
	// until the next char doesn't match the type like whitespace, and
	// that doesn't need to happen for above chars
	change eval_syntax2bytecodes = [ 7 66 8 9 14 15 3 4 5 6 11 10 13 12 75 77 57 58 59 18 19 20 21 44 ]
	change evaltokens_keywords = [ "if" "else" "elseif" "endif" "return" "switch" "endswitch" "case" "default" "begin" "repeat" "not" "break" /*"script" "endscript"*/ ]
	change eval_kw2bytecodes = [ 37 38 39 40 41 60 61 62 63 32 33 57 34 /*35 36*/ ]
endscript

script indent \{1}
	if (<#"0x00000000"> = 0)
		return indent = ''
	endif
	indent = ''
	begin
		indent = (<indent> + '    ')
	repeat <#"0x00000000">
	//RemoveComponent \{#"0x00000000"}
	return indent = <indent>
endscript

script printtoken \{indent = 0 debug = $evalverbose}
	if NOT (<debug>)
		return
	endif
	//if (<t>.type = bytecode)
		//if (<t>.value > 1)
		//	if IndexOf (<t>.value) array = ($eval_syntax2bytecodes)
		//		literal = ($evaltokens_syntax[<indexof>])
		//	else
		//		literal = 'unknown'
		//	endif
		//else
		//	literal = 'newline'
		//endif
		//type = 'bytecode' // display properly because it's not a debug name // now it is ;)
	//else
		//literal = (<t>.value)
		//type = (<t>.type)
	//endif
	pad <i> count = (3) pad = ' '
	indent <indent>
	printf '%n>%i: %v <%t>' n = <indent> i = <pad> t = (<t>.type) v = (<t>.literal)
endscript

// :(
script AddParam_WStr
	#"  name  " = <name>
	#"  value  " = <#"0x00000000">
	RemoveComponent \{name}
	RemoveComponent \{#"0x00000000"}
	if NOT (<#"  name  "> = #"0x00000000")
		FormatText textname = <#"  name  "> "%a" a = <#"  value  ">
	else
		FormatText textname = name "%a" a = <#"  value  ">
		#"0x00000000" = <name>
		RemoveComponent \{name}
	endif
	RemoveComponent \{#"  name  "}
	RemoveComponent \{#"  value  "}
	return value = { <...> }
endscript

script stupid
	// guessing game
	// you'll be stupid too
	switch <name>
		case #"0x00000000"
			EmptyScript
		case test2
			test2 = <#"0x00000000">
		case value
			value = <#"0x00000000">
		case pos
			pos = <#"0x00000000">
		case dims
			dims = <#"0x00000000">
		case scale
			scale = <#"0x00000000">
		case pair
			pair = <#"0x00000000">
		case vector
			vector = <#"0x00000000">
		case name
			name = <#"0x00000000">
			overwrite_name = 1
		default
			printf \{'unknown name for my stupid hack in struct string parsing'}
			printf <name>
	endswitch
	if NOT (<overwrite_name> = 1)
		RemoveComponent \{name}
	else
		RemoveComponent \{overwrite_name}
	endif
	return value = {<...>}
endscript
