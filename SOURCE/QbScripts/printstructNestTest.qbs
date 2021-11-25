script() {
int*pos = [64, 128];
printstruct({
	string dummy = 'foo! uhm... *kick*';
	struct a_struct = {
		struct another = {
			struct more = {
				string $00000000 = 'end of the road pal';
			};
		};
		int $00000000 = 123;
		string id = 'ABC';
		struct params = {
			qbkey $00000000 = AddToLookup;
			string $00000000 = 'The quick brown fox jumped over the big lazy dog.';
			int length = 55555;
		};
	};
	vector2 pos = (64.0, 128.5555);
	wstring $00000000 = "this is a wide string, with no actual unicode chars, as every other string in the entire game doesnt (maybe)";
	vector3 pos = (1.333333, 2.6666666, 4.0);
	//array blurb = ['Blurb #1','Blurb #2','Blurb #3','Blurb #4','Blurb #5'];
	qbkey platform = Xenon;
	//qbkey bunch_of_keys = [true, false, none, name, GotParam, Seconds, Wait, CompositeObjectExists];
	int bot_play = 1;
});
}
