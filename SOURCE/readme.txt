
	-- FastGH3 --
	- Repo info -

I don't have much to say here, except give a list
of things required for building this manually.

The script in this folder configure-repo.bat
can help to automate the handling of the following:

Required software:
* Visual Studio 2015 + Visual C#	-	for building projects
* Node (>=12.2.0) or Bun (>=1.1.0)	-	for generating a file used for storing resources (hack)
* Git / Cygwin / MSYS2 / win-bash	-	for version control and/or running build scripts
Optional software:
* UPX or mpress
* NSIS
* stripreloc

Projects:
* FastGH3 Launcher:
	- Converts charts
	- Interface for settings
* FastGH3 qb.pak
	- High level game code / scripts
* FastGH3 zones / global.pak
	- Assets, such as textures, fonts, and sounds
	- Requires extra tools for specific assets:
		* BMFont / mkfonts - font generator / BMFont converter
		* imggen - Converts to image container for game
		* buildtex - Generates a container for highway sprites
* GH3+
	- Plugin library
	- Hacks/applies patches to the internal code of the Guitar Hero 3 EXE
	- Contains code for extending the engine, such as:
		* Taps, hopo chords, open notes, and open sustains
		* Custom functions that the game scripts can interface with
		* Script debugger (half broken)
		* Fixes for note limit and song time limit
		* Modifiers, such as all taps, all strums, double notes
* c128ks
	- Audio converter
	- Processes audio faster than the command line directly
	- Uses:
		* SoX or FFMPEG
		* Helix MP3 encoder, direct source included
* Installer
	- Requires NSIS
