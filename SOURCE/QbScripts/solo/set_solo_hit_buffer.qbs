script({
	int player = 1;
	int $00000000 = 1;
}) {

formattext(checksumname=array,'solo_hit_buffer_p%d',d=%player);
if (%player == 1)
{
	getarraysize({
		qbkeyref $00000000 = solo_hit_buffer_p1;
		// easy pointer hack :P
		// thanks starsequencebonus script
		// also why can't i use % in this >:(
	});
}
elseif (%player == 2)
{
	getarraysize({
		qbkeyref $00000000 = solo_hit_buffer_p2;
	});
}

hit_buffer = *%array;
i = 1;
SetArrayElement(
	arrayname=%array,
	globalarray,
	index=(%array_size-1),
	newvalue=%$00000000);
//printf('a');
repeat(%array_size - 1)
{
	SetArrayElement(
		arrayname=%array,
		globalarray,
		index=(%i-1), // test[i-1] = test[i]
		newvalue=(*%array[%i]));
	//printf('%d',d=(*%array[%i]));
	i = (%i + 1);
}

}