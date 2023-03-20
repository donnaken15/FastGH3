
script RunRemoteScript_ExecuteAndReturnResult\{LocalCallback = NULL}
	if NOT GotParam \{scriptname}
		script_assert \{"Expected a ScriptName!"}
		return
	endif
	if GotParam \{objID}
		printf \{"Running game script requested by debugger on object..."}
		<objID> ::<scriptname> <params>
	else
		printf \{"Running game script requested by debugger ..."}
		<scriptname> <params>
	endif
	if NOT checksumequals a = <LocalCallback> b = NULL
		printf \{"Debugger requested a callback, sending..."}
		RemoveParameter \{params}
		RemoveParameter \{objID}
		RemoveParameter \{scriptname}
		RunRemoteScript scriptname = <LocalCallback> params = {<...> LocalCallback = NULL}
	endif
endscript

script CopyCameraLocationToClipboard
	GetCamOffset
	SendToClipboard <...>
endscript

script SendToClipboard
	RunRemoteScript scriptname = printstruct params = {<...> SendToClipboard}
endscript

script SendToWindow
	RunRemoteScript scriptname = printstruct params = {<...> SendToWindow}
endscript
