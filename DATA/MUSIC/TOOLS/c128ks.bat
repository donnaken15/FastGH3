@echo off
:# Constant 128kbps Stereo encoder
:# for (MP3, WAV, OGG, OPUS)
set ERRORLEVEL=0
if exist %1 goto :out
echo Invalid filename:
echo %1
set ERRORLEVEL=222
goto :EOF

:out
SET LPARAMS=--cbr -b 128 --resample 44100 -m j
SET SPARAMS=-c 2 -r 44100 -S --multi-threaded
SET SOX="%~dp0sox" %1 %SPARAMS%
IF "%~x1" EQU ".wav" (
	%SOX% -t mp3 -C 128 %2
) ELSE (
	IF "%~x1" EQU ".mp3" (
		%SOX% -t mp3 -C 128 %2
	) ELSE (
		IF "%~x1" EQU ".ogg" (
			%SOX% -t mp3 -C 128 %2
		) ELSE (
			:#for opus which is somehow extremely slow on just sox
			%SOX% -t wav - | "%~dp0lame" %LPARAMS% - %2
		)
	)
)

goto :EOF
