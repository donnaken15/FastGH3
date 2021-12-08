script() {
printstruct({
	numbers: [0,1,2,3,4,5,6,7,8,9],
	text: ['text #1','text #2','text #3','text #4','text #5'],
	t2ext: ["wide text #1","wide text #2","wide text #3","wide text #4","wide text #5"],
	bunch_of_keys: [true, false, none, name, GotParam, Seconds, Wait, CompositeObjectExists],
	floaties: [0.3333,0.6666,1.2345,1000.55001,999.321,1.32118361729611,6.023010023],
	structs: [
		{
			text: 'hello! im player 1!',
			notes: 12345,
			score: 13371337
		},
		{
			text: 'and im player 2!',
			notes: 56530,
			score: 666
		}
	]
});
}
