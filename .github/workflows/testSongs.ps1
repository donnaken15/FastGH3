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
WarnAsserts=0
[Player1]
Bot=1
Device=3
[Player2]
Bot=1
Device=0
[GFX]
Borderless=1
[Misc]
Debug=1

"@)+$env:EXTRACFG > "settings.ini"
"Testing songs:"
$songs = @(
    # ADD RARs WHEN BSDTAR (AND INTERFACE CLASS FFS!!) SUPPORT IS ADDED
	,@("1k-oNqj-22eTj2iB0vD8Nnk-frHql2AGp", 97.3,1,"[ZIP] Nintendo - Logic Unit")
	,@("1_S8trH51h_HHI4M5ov9TFy8THQX1q9Qn",278.0,1,"[ZIP] Nintendo - Rainfall in 1910")
	,@("1LchT54oZHpQR8bAK_NK7s44whlzHjdxu",185.9,2,"[ZIP] Sum 41 - Pieces")
	,@("16H5JbctXz9xDykRTXB0aLQ2YCOjg_CYc",125.1,1,"[ZIP] Sum 41 - Moron")
	,@("16Ipd-4SV1IqBzAVDA26P-42tWN4twvL7",201.2,0," [7Z] The Used - Take It Away") # praying no one uses LZMA (ON FREAKING OPUS) because bsdtar doesnt like it, which is ironic to say because 7z is developed on/for windows
	,@("1HiI5Lk2njgSL4svHdjO6omeBV_23KJ4l",188.3,2,"[ZIP] Ellegarden - Acropolis")
	,@("117icsuAiERPUsQ8ec3ABcEDFYszRt2R_",120.5,0,"[ZIP] Johnny Booth - Savannah")
	,@("13crHDTRUOx3QRqnSWveKKhthyo-Ll4V9",183.7,0," [7Z] Abnormality - Visions")
	#,@("1C_IN93gV7RqwvJJpJKnPhinRRLFAWh4j",124.0,1,"[ZIP] Mastodon - Crusher Destroyer") # 2 chart files, fm/fml
	,@("1EQ8rvcxhv-Xq7T0FT62ZLOZ3rR2gcx9O",391.0,0,"[ZIP] Squarepusher - Dark Steering")
	,@("13n2_rCzeKPOFxHdZ7x_Sj2rp5zGo0xqg",226.9,0,"[ZIP] AFX - Crappy (Roskilde, 1997)")
	,@("13gt3k5WsiRkIthf9V5i6dAAmFK5poyFX",138.0,0,"[ZIP] Kommisar - Springtime")
	,@("10qdz_017Hc4H0-r7pmkiL2fphsO1xrJd",147.0,1,"[ZIP] Hiroaki Sano - Circus Game")
	,@("13fI1wSCEZyS8Oq5_V53PSXgt4Tp0PMH1",159.8,1,"[ZIP] Toriena - Future Dreamer")
	,@("16thK1ivFdKqsxd5TscRVh6DYZcQn23dA",253.7,0,"[SNG] Fearofdark - TABNY (Jarvis)")
	# "BROKEN" MIDI (these comments are a cry for help)
	#,@("1_F-7Hv7YbF-sw9l_tS3FyjRmpKICa8lp"," [7Z] QOTSA - 3's & 7's (Metal Track Pack)")
)
$SONG_URL = 0
$SONG_TIME = 1
$SONG_2PART = 2 # 0 = no 2nd part, 1 = bass, 2 = rhythm
$SONG_NAME = 3
#$play_overtime = 0 # total = 3.3 # intro (~1.5s) and end wait (1.8s)
function tailf {
	param([Parameter(Mandatory=$true)]$path)
	# can't break out of until it's deleted
	try {
		Get-Content -Path $path -Encoding UTF8 -Wait -ErrorAction Stop
	} catch [System.IO.FileNotFoundException] {
		"******* Done reading "+$path
	} catch {
		Write-Host $_.Exception.ToString() -ForegroundColor Red
	}
	# virtualbox is actively trying to ruin my life by failing on this func but not on real PC
}
# end time calculation factors in intro animation and the end delay
# also test random modes every song
for ($i = 0; $i -lt $songs.length; $i++) {
	$song = $songs[$i]
	"**********************       "+($song[$SONG_TIME]).ToString("F2").PadLeft(5)+" "+($song[$SONG_NAME].ToString())
	$arg = "dl fastgh3://drive.google.com/uc?id="+($song[$SONG_URL].ToString()) # STUPID CRINGE THING WHY
	Out-Null > "launcher.txt"
	Out-Null > "output.txt"
	$why = sajb -Init ([ScriptBlock]::Create("Set-Location '$pwd'")) -ArgumentList $arg, $song -ScriptBlock {
		$exit_grace = 10
		$loading_time = 0.5
		$launcher_basetime = 1 # launcher time excluding audio encoding
		function now { return [double]::Parse((Get-Date -UFormat %s)) }
		# CAN'T HAVE THE LAUNCHER PROCESS DIRECTLY BE A PART OF THE RUNNER'S
		# EXECUTION PROBABLY BECAUSE OF THE KEY INTERRUPT THING!!!!!!!!!!
		# thonk: https://www.reddit.com/r/PowerShell/comments/8n8d8e
		$song = $args[1]
		$estAudCT = ($song[1] / 317) # basing off rainfall in 1910 (275.38(songtime)/0.87(convtime)), encoded as opus
		$runtime = now
		$launcher = start -PassThru ".\FastGH3.exe" -WorkingDirectory "." -Args $args[0]
		Register-ObjectEvent -InputObject $launcher -EventName Exited -Action {
			sleep 1
			del "launcher.txt" -Force -ErrorAction SilentlyContinue
		}
		$launcher | Wait-Process
		$convtime = ((now) - $runtime)
		"******* Launcher time: "+($convtime = $launcher.ExitTime - $launcher.StartTime).ToString()
		if ($launcher.ExitCode -ne 0) {
			"Launcher returned non-zero code: "+$launcher.ExitCode.ToString()
		}
		$estpt = ($loading_time+$song[1]+$exit_grace)
		$game = Get-Process -Name "game" # powershell now making me suicidal
		if ($game) {
			$game | Wait-Process -Timeout $estpt -ErrorAction SilentlyContinue -ErrorVariable to
			$gametime = ((now) - $runtime - $estAudCT - $launcher_basetime) # 3 iq: grep for creating process text
			# forgot: how am i even going to know when a crash occurs, i guess by detected playtime...
			if (-not $game.HasExited) {
				kill -Name "game" -Force
				Write-Host ("Game did not exit within the expected time period ("+$estpt.ToString("F1")+")") -ForegroundColor Red
			} else {
				if ($gametime -lt ($estpt - $exit_grace - 3)) {
					Write-Host ("Game exited earlier than expected ("+$gametime.ToString("F3")+" < "+$estpt.ToString("F1")+")") -ForegroundColor Red
				}
			}
        } else {
			"Game cannot be found running, WHY"
		}
		sleep 0.8
		del "output.txt" -Force -ErrorAction SilentlyContinue
		sleep 7
	}
	tailf "launcher.txt"
	sleep 0.5
	$why | Receive-Job
	tailf "output.txt"
	$why | Receive-Job
	$why | Wait-Job
}
