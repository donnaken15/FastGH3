NX_SignInComplete = 0
NX_SignedIn = 0

script StartNetworkPlatform
	if isps3
		printf \{"--- StartNetworkPlatform ---"}
		if NOT CheckForSignIn
			DisplayNetplatformWarning
			begin
				if (1 = $NX_SignInComplete)
					printf \{"--- Sign in is complete ---"}
					break
				endif
				wait \{1 Frame}
			repeat
			if (1 = $NX_SignedIn)
				Change \{NX_SignInComplete = 0}
				Change \{NX_SignedIn = 0}
				printf \{"We are signed in"}
				return \{true}
			else
				Change \{NX_SignInComplete = 0}
				Change \{NX_SignedIn = 0}
				printf \{"We are not signed in"}
				return \{FALSE}
			endif
		endif
	endif
endscript

script NetworkPlatformComplete
	printf \{"NetworkPlatformComplete"}
	Change \{NX_SignInComplete = 1}
	if GotParam \{SignedIn}
		Change \{NX_SignedIn = 1}
	endif
endscript
