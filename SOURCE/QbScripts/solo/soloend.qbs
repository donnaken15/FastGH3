script() {

change(solo_active = 0);

num = (*player1_status.score + (*last_solo_hits / *solo_bonus_pts));
change(structurename=player1_status,score = %num);

num1 = *last_solo_hits;
num2 = *last_solo_total;
solo_ui_end(*last_solo_hits,*last_solo_total);
change(last_solo_hits = 0);
change(last_solo_total = note_count);

}