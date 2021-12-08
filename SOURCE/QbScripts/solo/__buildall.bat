@echo off
:# weird
del *.qbscript /Q > nul
FOR %%Q IN ( *.qbs ) DO ( echo %%Q & qbc %%Q %%Qcript )
del *.qbscriptcript* /Q > nul
pause