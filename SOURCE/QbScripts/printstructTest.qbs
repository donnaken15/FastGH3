script({
	int test3 = 123;
	qbkey test2 = no_vram;
	qbkey test5 = fastgh3;
	qbkey hello = $DEADBEFE;
	qbkey $FACEFAC7 = $01234567;
	string $ABCDEF01 = 'AAAAABBBBBCCCCC';
}) {

printstruct({
	int none = 0;
	float none = 123.456;
	string none = 'A';
	wstring none = "A";
	qbkey test2 = no_vram;
});
printstruct({
	int test3 = 123;
	qbkey test2 = no_vram;
	qbkey test5 = fastgh3;
	qbkey hello = $DEADBEFE;
	qbkey $FACEFAC7 = $01234567;
});
printstruct(<...>);

}
