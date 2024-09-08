"Setting configuration"
(@"
[Player]
AutoStart=1
Hyperspeed=5
ExitOnSongEnd=1
[Launcher]
SongCaching=0
[Player1]
Bot=1
Device=3
[Misc]
Debug=1

"@)+$env:EXTRACFG > "settings.ini"
"Testing songs:"
$songs = @(
	,@("1EQ8rvcxhv-Xq7T0FT62ZLOZ3rR2gcx9O","[ZIP] Squarepusher - Dark Steering")
	,@("13gt3k5WsiRkIthf9V5i6dAAmFK5poyFX","[ZIP] Kommisar - Springtime")
	,@("16Ipd-4SV1IqBzAVDA26P-42tWN4twvL7"," [7Z] The Used - Take It Away")
	,@("1_F-7Hv7YbF-sw9l_tS3FyjRmpKICa8lp"," [7Z] QOTSA - 3's & 7's (Metal Track Pack)")
	,@("16thK1ivFdKqsxd5TscRVh6DYZcQn23dA","[SNG] Fearofdark - TABNY (Jarvis)")
)
for ($i = 0; $i -lt $songs.length; $i++) {
	"* "+($songs[$i][1].ToString())
	$arg = "dl fastgh3://drive.google.com/uc?id="+($songs[$i][0].ToString()) # STUPID CRINGE THING WHY
	start -Wait "FastGH3.exe" -WorkingDirectory "." -Args $arg
	sleep 5
	Wait-Process -Name "game.exe" -Timeout 600 -ErrorAction SilentlyContinue -ErrorVariable to
	if (-not $to) {
		kill -Name "game.exe" -Force
	}
	sleep 15
}