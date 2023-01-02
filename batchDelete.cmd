::         Name: batchDelete v1.2f2
::       Author: wvzxn // https://github.com/wvzxn/
::  
::  Description: Delete items by query in current folder and subfolders.
::               If the regex command is empty, the script will delete empty folders recursively.
::               File Name/Full Path mode:
::                  [1] - the regex string matches only the file name
::                  [2] - the regex string matches full path to the file
::               Match/Not Match:
::                  [1] - delete everything that matches the regex string
::                  [2] - delete everything that not matches the regex string
::               regex:
::                  [?] - the regex string

@echo off
setlocal EnableDelayedExpansion
for /f "usebackq delims=" %%A in (` findstr /b /c:"::  " "%~f0" `) do echo %%A
echo.

set /p "mode=File Name/Full Path mode: "
set /p "not=Match/Not Match: "
set /p "regex=regex: "
if "!not!"=="1" ( set "not=") else ( set "not=not")

:loop
if exist "%~1" ( set "dir=%~f1\") else ( set "dir=%~dp0")
if not "!regex!"=="" ( if "!mode!"=="1" ( call:name) else ( call:path)) else ( call:delEmptyDir)
shift
if exist "%~1" ( goto:loop)
pause
exit

:name
powershell "gci '!dir!' -file -recurse|?{($_.name) -!not!match '!regex!'}|ri -force"
exit /b

:path
powershell "(gci '!dir!' -file -recurse).fullname|?{($_ -replace [regex]::escape('!dir!'),'') -!not!match '!regex!'}|ri -force"
exit /b

:delEmptyDir
for /f "delims=" %%A in (' dir "%~1" /ad/b/s ^| sort /r ') do rd "%%A" 2>nul
exit /b