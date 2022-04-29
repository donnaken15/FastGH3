script()
{

pos = (0.0, 0.0);

player = 1;
repeat(*current_num_players)
{
	FormatText(checksumname = container_id, 'gem_containerp%i', i = %player);
	SetScreenElementProps(id=%container_id,pos=%pos);
	//FormatText(checksumname = player_status, 'player%i_status', i = %player);
	//FormatText(textname = player_text, 'p%i', i = %player, AddToStringLookup);
	nointro_hud_move(morph_time = 0.0001);
	player = (%player + 1);
}

}