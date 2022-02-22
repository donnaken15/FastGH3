script({
	qbkey player_status = player1_status;
}) {

leftt = 1;
if(*%player_status.lefthanded_gems == 1)
{
	leftt = 0;
}

change(structurename=%player_status,lefthanded_gems=%leftt);
Wait(0.95,Seconds);
animate_lefty_flip(other_player_status=%player_status);
//Wait(16,frame,ignore_slomo);
change(structurename=%player_status,lefthanded_button_ups=%leftt);

}
