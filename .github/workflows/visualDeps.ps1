# my first powershell script i guess, i hate it already
function StopWastingMySpace {
	$dir, $filter = $args
	if (Test-Path -Path $dir) {
		pushd $dir
		if ($?) {
			# stop wasting my space
			compact.exe /c /f /s /a /i /exe:lzx @filter | Select-Object -Last 3
			popd
		}
	}
}
function Free {
	return Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'" | Select-Object @{Name="fs";Expression={$_.FreeSpace/1GB}}, @{Name="ts";Expression={$_.Size/1GB}}
}
$pkg = @(
	,@("Visual C# 2015 Build Tools", "BuildTools_Full.exe", "/q /full /passive /norestart /log C:\tmp.log", $true, $true, 0,
		"https://download.microsoft.com/download/E/E/D/EEDF18A8-4AED-4CE0-BEBE-70A83094FC5A/BuildTools_Full.exe",
		'C:\Program Files (x86)\MSBuild\14.0\Bin', @('*.exe','*.dll'))
	,@(".NET Framework 4.6.2 Targeting Pack for .NET Framework 4.0", "NDP462.exe", "/install /passive /norestart /log C:\tmp.log", $true, $true, 0,
		"https://download.microsoft.com/download/e/e/c/eec79116-8305-4bd0-aa83-27610987eec6/NDP462-DevPack-KB3151934-ENU.exe",
		'C:\Program Files (x86)\Microsoft Visual Studio', @('*.exe','*.dll','*targets','*.txt','*.xml','*.nupkg','*.pdb'))
	,@("Visual C++ 2015 Build Tools", "vc15bt_full.exe",
		"install --add Microsoft.VisualStudio.Component.VC.140 --passive --norestart --nickname stupid --theme Light",
		$env:GH3PLUS, $false, 600, "https://aka.ms/vs/17/release/vs_BuildTools.exe",
		'C:\Program Files (x86)\Microsoft Visual Studio 14.0', @('*.exe','*.h','*.lib','*.cpp','*.hpp','*.dll','*.rc','*.inl','*.pdb','*.obj'))
	,@("Windows 10 SDK", "vc15bt_full.exe", # not enough space to install both at once because i suck
		"install --add Microsoft.VisualStudio.Component.Windows10SDK.18362 --passive --norestart --nickname stupid --theme Light",
		$env:GH3PLUS, $false, 600, "https://aka.ms/vs/17/release/vs_BuildTools.exe")
	,@("DirectX SDK", "DXSDK_Jun10.exe", "/U", $env:GH3PLUS, $false, 600, "https://archive.org/download/dxsdk_jun10/DXSDK_Jun10.exe",
		'C:\Program Files (x86)\Microsoft DirectX SDK (June 2010)', @('*.exe','*.dll','*.lib','*.h','*.sdkmesh','*.mt','*.dds','*.x','*.bmp','*.cpp','*.vcproj','*.vcxproj','*.obj','*.jpg','*.xwb','*.xml'))
	# wish i could exclude features for this one
)
for ($i = 0; $i -lt $pkg.length; $i++) {
	# CHECK IF ALREADY INSTALLED
	if (-not $pkg[$i][3]) {
		continue
	}
	"* "+($pkg[$i][0]).ToString()+':'
	"  - Downloading..."
	iwr -Uri $pkg[$i][6] -OutFile $pkg[$i][1]
	"  - Installing..."
	if ($pkg[$i][4]) {
		Set-Content -Path "C:\tmp.log" -Value "" -Encoding UTF8
		$killorbekilled = sajb `
			-Init ([ScriptBlock]::Create("Set-Location '$pwd'")) `
			-Name Installer -ArgumentList $pkg[$i] -ScriptBlock {
			$vsi = start -PassThru -FilePath $(Convert-Path $args[1]) -Args $args[2] # actual unironic cancer
			if ($args[5] -gt 0) {
				$vsi | Wait-Process -Timeout $args[5] -ErrorAction SilentlyContinue -ErrorVariable to
				if ($to) {
					$vsi | kill -Force
				}
			} else {
				$vsi | Wait-Process
			}
			sleep 2
			del "C:\tmp.log" -Force
		}
		try {
			Get-Content -Path "C:\tmp.log" -Encoding UTF8 -Wait -ErrorAction Stop
		} catch { }
		$killorbekilled | Wait-Job
		$killorbekilled | Receive-Job
	} else {
		start -NoNewWindow -Wait -FilePath $(Convert-Path $pkg[$i][1]) -WorkingDirectory "." -Args $pkg[$i][2]
	}
	$free = Free # function names are case insensitive and this is literally .net scripting, dear god what is this language
	"  - Current space: "+($free.fs).ToString("F3")+"/"+($free.ts).ToString("F3")+"gb"
	"  - Making space..."
	StopWastingMySpace $pkg[$i][7] $pkg[$i][8]
	$free = Free
	"  - Now "+($free.fs).ToString("F3")+"/"+($free.ts).ToString("F3")+"gb"
	del $pkg[$i][1]
	break
}
