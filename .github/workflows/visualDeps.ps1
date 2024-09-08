# my first powershell script i guess, i hate it already
$pkg = @(
	,@("Visual C# 2015 Build Tools", "BuildTools_Full.exe", "/q /full /passive /norestart /log C:\tmp.log", $true, $true, 0,
		"https://download.microsoft.com/download/E/E/D/EEDF18A8-4AED-4CE0-BEBE-70A83094FC5A/BuildTools_Full.exe")
	,@(".NET Framework 4.6.2 Targeting Pack for .NET Framework 4.0", "NDP462.exe", "/install /passive /norestart /log C:\tmp.log", $true, $true, 0,
		"https://download.microsoft.com/download/e/e/c/eec79116-8305-4bd0-aa83-27610987eec6/NDP462-DevPack-KB3151934-ENU.exe")
	,@("Visual C++ 2015 Build Tools", "vc15bt_full.exe",
		"install --add Microsoft.VisualStudio.Component.VC.140,Microsoft.VisualStudio.Component.Windows10SDK.18362 --passive --norestart --nickname stupid --theme Light",
		$env:GH3PLUS, $false, 600, "https://aka.ms/vs/17/release/vs_BuildTools.exe")
	,@("DirectX SDK", "DXSDK_Jun10.exe", "/U", $env:GH3PLUS, $false, 600, "https://archive.org/download/dxsdk_jun10/DXSDK_Jun10.exe")
)
for ($i = 0; $i -lt $pkg.length; $i++) {
	if (-not $pkg[$i][3]) {
		continue
	}
	($pkg[$i][0])+':'
	"Downloading..."
	iwr -Uri $pkg[$i][6] -OutFile $pkg[$i][1]
	"Installing..."
	if ($pkg[$i][4]) {
		$null > "C:\tmp.log"
		$vsi = start -NoNewWindow -FilePath $pkg[$i][1] -WorkingDirectory "." -Args $pkg[$i][2] -PassThru
		$killorbekilled = sajb {
			if ($pkg[$i][5] -gt 0) {
				$vsi | Wait-Process -Timeout $pkg[$i][5] -ErrorAction SilentlyContinue -ErrorVariable to
				if ($to) {
					$vsi | kill -Force
				}
			} else {
				$vsi | Wait-Process
			}
			del "C:\tmp.log" -Force -Confirm
		}
		#Get-Content -Path "C:\tmp.log" -Wait
		$killorbekilled | Wait-Job
	}
}
