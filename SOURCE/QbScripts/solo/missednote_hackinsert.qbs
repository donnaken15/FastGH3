script() {

if ((*%player_status.text) == 'p1')
{
	player = 1;
}
elseif ((*%player_status.text) == 'p2')
{
	player = 2;
}
set_solo_hit_buffer(player=%player,0);

}