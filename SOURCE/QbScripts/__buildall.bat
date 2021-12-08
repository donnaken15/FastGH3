@echo off
:# weird
del *.qbscript
FOR %%Q IN (*.qbs) DO ( echo %%Q & qbc %%Q %%Qcript )
del *.qbscriptcript*
pause