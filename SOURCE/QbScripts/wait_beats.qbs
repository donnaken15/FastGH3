script({
	int $00000000 = 1;
}) {

//printf('%b',b=%$00000000);
repeat(%$00000000)
{
	last_beat_flip = *beat_flip;
	repeat
	{
		cur_beat_flip = *beat_flip;
		if (%last_beat_flip != %cur_beat_flip)
		{
			//printf('bar');
			break;
		}
		wait(1,gameframe);
	}
}
return;

}