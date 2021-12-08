script() {
printstruct({
	dummy: 'foo! uhm... *kick*',
	a_struct: {
		another: {
			more: {
				$00000000: 'end of the road pal'
			}
		},
		$00000000: 123,
		id: 'ABC',
		params: {
			$00000000: AddToLookup,
			$00000000: 'The quick brown fox jumped over the big lazy dog.',
			length: 55555
		}
	},
	pos: (64.0, 128.5555),
	$00000000: "this is a wide string, with no actual unicode chars, as every other string in the entire game doesnt (maybe)",
	pos: (1.333333, 2.6666666, 4.0),
	blurb: ['Blurb #1','Blurb #2','Blurb #3','Blurb #4','Blurb #5'],
	platform: Xenon,
	bunch_of_keys: [true, false, none, name, GotParam, Seconds, Wait, CompositeObjectExists],
	bot_play: 1
});
}
