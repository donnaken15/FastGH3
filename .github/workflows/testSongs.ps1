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
	,@("1EQ8rvcxhv-Xq7T0FT62ZLOZ3rR2gcx9O","[ZIP] Squarepusher - Dark Steering")
	,@("13gt3k5WsiRkIthf9V5i6dAAmFK5poyFX","[ZIP] Kommisar - Springtime")
	,@("16Ipd-4SV1IqBzAVDA26P-42tWN4twvL7"," [7Z] The Used - Take It Away")
	# "BROKEN" MIDI (these comments are a cry for help)
	#,@("1_F-7Hv7YbF-sw9l_tS3FyjRmpKICa8lp"," [7Z] QOTSA - 3's & 7's (Metal Track Pack)")
	,@("16thK1ivFdKqsxd5TscRVh6DYZcQn23dA","[SNG] Fearofdark - TABNY (Jarvis)")
	,@("13fI1wSCEZyS8Oq5_V53PSXgt4Tp0PMH1","[ZIP] Toriena - Future Dreamer")
	,@("10qdz_017Hc4H0-r7pmkiL2fphsO1xrJd","[ZIP] Hiroaki Sano - Circus Game")
	,@("117icsuAiERPUsQ8ec3ABcEDFYszRt2R_","[ZIP] Johnny Booth - Savannah")
	,@("13crHDTRUOx3QRqnSWveKKhthyo-Ll4V9"," [7Z] Abnormality - Visions")
)
# also test random modes every song
for ($i = 0; $i -lt $songs.length; $i++) {
	"**********************       "+($songs[$i][1].ToString())
	$arg = "dl fastgh3://drive.google.com/uc?id="+($songs[$i][0].ToString()) # STUPID CRINGE THING WHY
	Out-Null > "launcher.txt"
	Out-Null > "output.txt"
	$why = sajb -Init ([ScriptBlock]::Create("Set-Location '$pwd'")) -ArgumentList $arg -ScriptBlock {
		# CAN'T HAVE THE LAUNCHER PROCESS DIRECTLY BE A PART OF THE RUNNER'S
		# EXECUTION PROBABLY BECAUSE OF THE KEY INTERRUPT THING!!!!!!!!!!
		# thonk: https://www.reddit.com/r/PowerShell/comments/8n8d8e
		start -Wait ".\FastGH3.exe" -WorkingDirectory "." -Args $args[0]
		sleep 5
		del "launcher.txt" -Force
		Wait-Process -Name "game.exe" -Timeout 600 -ErrorAction SilentlyContinue -ErrorVariable to
		# forgot: how am i even going to know when a crash occurs
		if (-not $to) {
			kill -Name "game.exe" -Force
		}
		sleep 2
		del "output.txt" -Force
		sleep 15
	}
	try {
		Get-Content -Path "launcher.txt" -Encoding UTF8 -Wait -ErrorAction Stop
	} catch { }
	try {
		Get-Content -Path "output.txt" -Encoding UTF8 -Wait -ErrorAction Stop
	} catch { }
	$why | Wait-Job
	$why | Receive-Job
}
