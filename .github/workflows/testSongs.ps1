"Setting configuration"
(@"
[Player]
AutoStart=1
Hyperspeed=5
ExitOnSongEnd=1
NoFail=1
[Launcher]
SongCaching=0
VerboseLog=1
[Logger]
WriteFile=1
FixKeys=1
PrintStruct=1
WarnAsserts=1
[Player1]
Bot=1
Device=3
[Player2]
Bot=1
Device=0
[Misc]
Debug=1

"@)+$env:EXTRACFG > "settings.ini"
"Testing songs:"
$songs = @(
    # ADD RARs WHEN BSDTAR (AND INTERFACE CLASS FFS!!) SUPPORT IS ADDED
	,@("1EQ8rvcxhv-Xq7T0FT62ZLOZ3rR2gcx9O",391.0,0,"[ZIP] Squarepusher - Dark Steering")
	,@("13gt3k5WsiRkIthf9V5i6dAAmFK5poyFX",138.0,0,"[ZIP] Kommisar - Springtime")
	,@("16thK1ivFdKqsxd5TscRVh6DYZcQn23dA",253.7,0,"[SNG] Fearofdark - TABNY (Jarvis)")
	,@("13fI1wSCEZyS8Oq5_V53PSXgt4Tp0PMH1",159.8,1,"[ZIP] Toriena - Future Dreamer")
	,@("10qdz_017Hc4H0-r7pmkiL2fphsO1xrJd",147.0,1,"[ZIP] Hiroaki Sano - Circus Game")
	,@("16Ipd-4SV1IqBzAVDA26P-42tWN4twvL7",201.2,0," [7Z] The Used - Take It Away") # praying no one uses LZMA (ON FREAKING OPUS) because bsdtar doesnt like it, which is ironic to say because 7z is developed on/for windows
	,@("1HiI5Lk2njgSL4svHdjO6omeBV_23KJ4l",188.3,2,"[ZIP] Ellegarden - Acropolis")
	,@("1LchT54oZHpQR8bAK_NK7s44whlzHjdxu",185.9,2,"[ZIP] Sum 41 - Pieces")
	#,@("1C_IN93gV7RqwvJJpJKnPhinRRLFAWh4j",124.0,1,"[ZIP] Mastodon - Crusher Destroyer")
	,@("1_S8trH51h_HHI4M5ov9TFy8THQX1q9Qn",278.0,1,"[ZIP] Nintendo - Rainfall in 1910")
	,@("1k-oNqj-22eTj2iB0vD8Nnk-frHql2AGp", 97.3,1,"[ZIP] Nintendo - Logic Unit")
	,@("117icsuAiERPUsQ8ec3ABcEDFYszRt2R_",120.5,0,"[ZIP] Johnny Booth - Savannah")
	,@("13crHDTRUOx3QRqnSWveKKhthyo-Ll4V9",183.7,0," [7Z] Abnormality - Visions")
	# "BROKEN" MIDI (these comments are a cry for help)
	#,@("1_F-7Hv7YbF-sw9l_tS3FyjRmpKICa8lp"," [7Z] QOTSA - 3's & 7's (Metal Track Pack)")
)
$SONG_URL = 0
$SONG_TIME = 1
$SONG_2PART = 2 # 0 = no 2nd part, 1 = bass, 2 = rhythm
$SONG_NAME = 3
$play_overtime = 0 # total = 3.3 # intro (~1.5s) and end wait (1.8s)
$loading_time = 0.5
$launcher_basetime = 1 # launcher time excluding audio encoding
$exit_grace = 10
function now { return [double]::Parse((Get-Date -UFormat %s)) }
function tailf {
	param([Parameter(Mandatory=$true)]$path)
	# can't break out of until it's deleted
	try {
		Get-Content -Path $path -Encoding UTF8 -Wait -ErrorAction Stop
	} catch { }
}
# end time calculation factors in intro animation and the end delay
# also test random modes every song
for ($i = 0; $i -lt $songs.length; $i++) {
	$song = $songs[$i]
	"**********************       "+($song[$SONG_TIME]).ToString("F2").PadLeft(5)+""+($song[$SONG_NAME].ToString())
	$arg = "dl fastgh3://drive.google.com/uc?id="+($song[$SONG_URL].ToString()) # STUPID CRINGE THING WHY
	Out-Null > "launcher.txt"
	Out-Null > "output.txt"
	$why = sajb -Init ([ScriptBlock]::Create("Set-Location '$pwd'")) -ArgumentList $arg -ScriptBlock {
		# CAN'T HAVE THE LAUNCHER PROCESS DIRECTLY BE A PART OF THE RUNNER'S
		# EXECUTION PROBABLY BECAUSE OF THE KEY INTERRUPT THING!!!!!!!!!!
		# thonk: https://www.reddit.com/r/PowerShell/comments/8n8d8e
		$estAudCT = ($song[$SONG_TIME] / 317) # basing off rainfall in 1910 (275.38(songtime)/0.87(convtime)), encoded as opus
		$runtime = now
		$launcher = start -PassThru -Wait ".\FastGH3.exe" -WorkingDirectory "." -Args $args[0]
		$convtime = (now - $runtime)
		"Launcher time: "+($ltime = $launcher.ExitTime - $launcher.StartTime).ToString()
		if ($launcher.ExitCode -ne 0) {
			"Launcher returned non-zero code: "+$launcher.ExitCode.ToString()
		}
		sleep 2
		del "launcher.txt" -Force
		$estpt = ($loading_time+$song[$SONG_TIME]+$exit_grace)
		$game = Get-Process -Name "game.exe"
		if ($game) {
			$game | Wait-Process -PassThru -Timeout $estpt -ErrorAction SilentlyContinue -ErrorVariable to
			$gametime = (now - $runtime - $estAudCT - $launcher_basetime) # 3 iq: grep for creating process text
			# forgot: how am i even going to know when a crash occurs
			if (-not $game.HasExited) {
				kill -Name "game.exe" -Force
				"Game did not exit within the expected time period ("+$estpt.ToString()+")"
			}
        } else {
			"Game cannot be found running, WHY"
		}
		sleep 2
		del "output.txt" -Force
		sleep 15
	}
	tailf "launcher.txt"
	tailf "output.txt"
	$why | Wait-Job
	$why | Receive-Job
}
