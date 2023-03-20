BussTree = {
	Master = {
		User_Sfx = {
			UI = {
				LeafNodes = [
					Front_End
					pause_menu
					UI_Star_Power
					UI_Battle_Mode
					Wrong_Notes_Player1
					Wrong_Notes_Player2
				]
			}
			LeafNodes = [
				Default
				Test_Tones
				Encore_Events
				BinkCutScenes
				Practice_Band_Playback
				Training_VO
			]
		}
		User_Band = {
			Band_Balance = {
				LeafNodes = [
					Band_Playback
					Single_Player_Rhythm_Playback
					Music_FrontEnd
					Music_Setlist
					Countoffs
				]
			}
		}
		User_Guitar = {
			Guitar_Balance = {
				Guitar_Balance_First_Player = {
					LeafNodes = [
						First_Player_Lead_Playback
					]
				}
				Guitar_Balance_Second_Player = {
					LeafNodes = [
						Second_Player_Lead_Playback
						Second_Player_Rhythm_Playback
					]
				}
			}
			LeafNodes = [
				Test_Tones_DSP
				Right_Notes_Player1
				Right_Notes_Player2
			]
		}
	}
}
Default_BussSet = {
	Master = {
		Priority = 5
		vol = -2.5
		pitch = 0
		instance_rule = ignore
		max_instances = 64
	}
	Default = {
		Priority = 5
		vol = -4
		pitch = 0
	}
	Test_Tones = {
		Priority = 5
		vol = 0
		pitch = 0
	}
	User_Sfx = {
		Priority = 1
		vol = 0
		pitch = 0
		instance_rule = ignore
		max_instances = 500
	}
	UI = {
		Priority = 1
		vol = 0
		pitch = 0
	}
	User_Band = {
		Priority = 1
		vol = 0
		pitch = 0
	}
	Band_Balance = {
		Priority = 1
		vol = 0
		pitch = 0
	}
	User_Guitar = {
		Priority = 1
		vol = 0
		pitch = 0
	}
	Guitar_Balance = {
		Priority = 1
		vol = 0
		pitch = 0
	}
	Guitar_Balance_First_Player = {
		Priority = 1
		vol = 0
		pitch = 0
	}
	Guitar_Balance_Second_Player = {
		Priority = 1
		vol = 0
		pitch = 0
	}
	Right_Notes_Player1 = {
		Priority = 1
		vol = -4
		pitch = 0
	}
	First_Player_Lead_Playback = {
		Priority = 1
		vol = 0
		pitch = 0
	}
	Second_Player_Lead_Playback = {
		Priority = 1
		vol = 0
		pitch = 0
	}
	Second_Player_Rhythm_Playback = {
		Priority = 1
		vol = 0
		pitch = 0
	}
	Single_Player_Rhythm_Playback = {
		Priority = 1
		vol = 0
		pitch = 0
	}
	Wrong_Notes_Player1 = {
		Priority = 1
		vol = -3.5
		pitch = 0
	}
	Right_Notes_Player2 = {
		Priority = 1
		vol = -4
		pitch = 0
	}
	Wrong_Notes_Player2 = {
		Priority = 1
		vol = -3.5
		pitch = 0
	}
	Band_Playback = {
		Priority = 1
		vol = 0
		pitch = 0
	}
	Countoffs = {
		Priority = 1
		vol = -7
		pitch = 0
	}
	Practice_Band_Playback = {
		Priority = 1
		vol = -3.0
		pitch = 0
	}
	Front_End = {
		Priority = 1
		vol = -6
		pitch = 0
	}
	pause_menu = {
		Priority = 1
		vol = 0
		pitch = 0
	}
	UI_Star_Power = {
		Priority = 1
		vol = -6
		pitch = 0
	}
	UI_Battle_Mode = {
		Priority = 1
		vol = 0
		pitch = 0
	}
	Crowd = {
		Priority = 1
		vol = -1
		pitch = 0
	}
	Crowd_Beds = {
		Priority = 1
		vol = -7
		pitch = 0
	}
	Crowd_Cheers = {
		Priority = 1
		vol = -6
		pitch = 0
	}
	Crowd_Boos = {
		Priority = 1
		vol = -6
		pitch = 0
	}
	Crowd_Nuetral = {
		Priority = 1
		vol = -6
		pitch = 0
	}
	Crowd_Star_Power = {
		Priority = 1
		vol = 0
		pitch = 0
	}
	Crowd_PreEncore_Building = {
		Priority = 1
		vol = 0
		pitch = 0
	}
	Crowd_PreSong_Intro = {
		Priority = 1
		vol = -6
		pitch = 0
	}
	Crowd_Applause = {
		Priority = 1
		vol = 0
		pitch = 0
	}
	Crowd_Transitions = {
		Priority = 1
		vol = -8
		pitch = 0
	}
	Crowd_Singalong = {
		Priority = 1
		vol = -100
		pitch = 0
	}
	Crowd_W_Reverb = {
		Priority = 1
		vol = 0
		pitch = 0
	}
	Crowd_One_Shots = {
		Priority = 1
		vol = -7.5799999
		pitch = 0
	}
	Music_FrontEnd = {
		Priority = 1
		vol = -11
		pitch = 0
	}
	Music_Setlist = {
		Priority = 1
		vol = -2
		pitch = 0
	}
	Test_Tones_DSP = {
		Priority = 1
		vol = 0
		pitch = 0
	}
	Encore_Events = {
		Priority = 1
		vol = 0
		pitch = 0
	}
	BinkCutScenes = {
		Priority = 1
		vol = -5
		pitch = 0
	}
	Training_VO = {
		Priority = 1
		vol = 0
		pitch = 0
	}
}
Star_Power_BussSet = {
	Right_Notes_Player1 = {
		Priority = 1
		vol = -2.0
		pitch = 0
	}
	Right_Notes_Player2 = {
		Priority = 1
		vol = -2.0
		pitch = 0
	}
}
BattleMode_Thin_BussSet = {
	Right_Notes_Player1 = {
		Priority = 1
		vol = 0
		pitch = 0
	}
	First_Player_Lead_Playback = {
		Priority = 1
		vol = 0
		pitch = 0
	}
	Second_Player_Lead_Playback = {
		Priority = 1
		vol = 0
		pitch = 0
	}
	Second_Player_Rhythm_Playback = {
		Priority = 1
		vol = 0
		pitch = 0
	}
	Single_Player_Rhythm_Playback = {
		Priority = 1
		vol = 0
		pitch = 0
	}
}
AutoWah_BussSet = {
	Right_Notes_Player1 = {
		Priority = 1
		vol = -10
		pitch = 0
	}
}
CrowdSurgeBig_BussSet = {
	Crowd_Beds = {
		Priority = 1
		vol = 3.0
		pitch = 0
	}
}
CrowdSurgeSmall_BussSet = {
	Crowd_Beds = {
		Priority = 1
		vol = 1.0
		pitch = 0
	}
}
CrowdNormal_BussSet = {
	Crowd_Beds = {
		Priority = 1
		vol = -6
		pitch = 0
	}
}
CrowdSingingVolUp_BussSet = {
	Crowd_Singalong = {
		Priority = 1
		vol = -8
		pitch = 0
	}
}
CrowdSingingVolDown_BussSet = {
	Crowd_Singalong = {
		Priority = 1
		vol = -100
		pitch = 0
	}
}
Failed_Song_Pitching_Down_BussSet = {
	Band_Balance = {
		Priority = 1
		vol = -10
		pitch = -8
	}
	Guitar_Balance = {
		Priority = 1
		vol = -10
		pitch = -8
	}
}
