@start /b /wait "" "resourcehacker" -open "%~1" -save "%~1" -action delete VERSIONINFO,, -action delete MANIFEST,,
@:: completely moronic
@call stripreloc /b "%~1"