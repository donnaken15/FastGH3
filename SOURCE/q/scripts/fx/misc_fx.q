jowBlue = 717488127
jowGreen = 771697407
jowOrange = -6149377
jowRed = -15061505
jowYellow = -3267073

/*script JOW_Stars
	printf \{"*******************************************************************"}
	printf <...>
	printf \{"*******************************************************************"}
endscript*/

script SafeGetUniqueCompositeObjectID\{preferredID = safeFXID01}
	if NOT GotParam \{objID}
		GetUniqueCompositeobjectID preferredID = <preferredID>
		return uniqueID = <uniqueID>
	endif
	i = 0
	FormatText textname = index '%i' i = <i>
	ExtendCrc <preferredID> <index> out = preferredID
	begin
		MangleChecksums a = <preferredID> b = <objID>
		if NOT ObjectExists id = <mangled_ID>
			return uniqueID = <preferredID>
		else
			i = (<i> + 1)
			FormatText textname = index '%i' i = <i>
			ExtendCrc <preferredID> <index> out = preferredID
		endif
	repeat
endscript
