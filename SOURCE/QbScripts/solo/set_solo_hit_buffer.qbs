script({
	int player = 1;
	int $00000000 = 1; // hit or miss, i guess they never mi- kill me please
}) {

formattext(checksumname=array,'solo_hit_buffer_p%d',d=%player);
if (%player == 1)
{
	num = (*last_solo_index_p1 + 1); // stupid compensation for detecting which notes are in solo
	change(last_solo_index_p1 = %num);
	getarraysize({
		qbkeyref $00000000 = solo_hit_buffer_p1;
		// easy pointer hack :P
		// thanks starsequencebonus script
		// also why can't i use % in this >:(
	});
}
elseif (%player == 2)
{
	num = (*last_solo_index_p2 + 1);
	change(last_solo_index_p2 = %num);
	getarraysize({
		qbkeyref $00000000 = solo_hit_buffer_p2;
	});
}

i = 1;
repeat(%array_size - 1)
{
	SetArrayElement(
		arrayname=%array,
		globalarray,
		index=(%i-1), // test[i-1] = test[i]
		newvalue=(*%array[%i]));
	i = (%i + 1);
}
SetArrayElement(
	arrayname=%array,
	globalarray,
	index=(%array_size-1),
	newvalue=%$00000000);

}