::         Name: regexDirCleaner v1.0i
::       Author: wvzxn // https://github.com/wvzxn/
::  Description: The script will delete everything except what you specify as regex.
::               If the regex command is empty, the script will delete only empty folders.

@echo off
if not exist "%~1" ( echo works only with drag'n'drop& timeout 4 >nul& goto:eof)
setlocal EnableDelayedExpansion
for /f "usebackq delims=" %%A in (` findstr /b /c:"::  " "%~f0" `) do echo %%A
echo.
set /p "cmnd=Enter regex command: "
:i
echo ^[%~1^]
set "a=%~1"
set a=!a:\=\\!
if not "!cmnd!"=="" (
    set "pwsh=(gci '%~1' -att ^!d -recurse).fullname|?{$_ -notmatch '(.*!b!\\)(!cmnd!)'}"
    for /f "usebackq delims=" %%A in (` powershell "!pwsh!"`) do del /q "%%A"
)
for /f "usebackq delims=" %%A in (`" dir "%~1" /ad/b/s | sort /r "`) do rd "%%A" 2>nul
shift
if exist "%~1" ( goto:i)
pause