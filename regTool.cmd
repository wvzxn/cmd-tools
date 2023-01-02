::         Name: regTool v1.2
::       Author: wvzxn // https://github.com/wvzxn/
::  
::  Description: regTool contains a collection of scripts to work with .reg files.
::               [1] Create .reg with replaced UserID's: '[*USERS*]' => '[*CURRENT_USER*]'
::               [2] Create Uninstall .reg:              '[HKEY_*]'  => '[-HKEY_*]'
::               [3] Remove unwanted keys from .reg:
::                      Match/Not Match:
::                          [1] - delete everything that matches the regex string
::                          [2] - delete everything that not matches the regex string
::                      regex:
::                          [?] - the regex string

@echo off
if not exist "%~1" ( echo works only with drag'n'drop& timeout 4 1>nul& exit )
setlocal EnableDelayedExpansion
for /f "usebackq delims=" %%A in (` findstr /b /c:"::  " "%~f0" `) do echo %%A
echo.
set /p "cmnd=: "
if "!cmnd!"=="3" (
    set /p "not=: Match/Not Match: "
    if "!not!"=="1" ( set "not=not") else ( set "not=")
    set /p "regex=: regex: "
)

:loop
echo.
set "dp1=%~dp1"
set "f1=%~f1"
set "n1=%~n1"
set "x1=%~x1"
if "!cmnd!"=="1" ( call:1)
if "!cmnd!"=="2" ( call:2)
if "!cmnd!"=="3" ( call:3)
call:process
shift
if exist "%~1" ( goto:loop)
echo.
pause
exit

:1
set "a=!n1!_currentUser"
set "b=$a=gc '!f1!';$a -replace '(\[HKEY_USERS\\S-1.*?\\)(.*)','[HKEY_CURRENT_USER\$2'"
exit /b

:2
set "a=!n1!_uninstall"
if "!n1!"=="1" ( set "a=2")
set "b=$a=gc '!f1!';$a|select -index 0;$a|%%{if($_ -match '\[.*\]'){$_ -replace '(\[)(.*)','$1-$2'}}"
exit /b

:3
set "a=!n1!_new"
set "b=$a=gc '!f1!';$a|select -index 0;foreach($i in $a){if($i -match '\[.*\]'){if($i -!not!match '\[.*!regex!.*\]'){$j=$true;$i}else{$j=$false}}else{if($j){$i}}}"
exit /b

:process
echo ::::::::::::::
echo : Processing : '!n1!!x1!' =^> '!a!!x1!'
echo ::::::::::::::
echo.
if exist "!dp1!!a!!x1!" (
    echo : ^/^^!^\ '!a!!x1!' will be overwritten^^!
    pause
    echo.
    del /q "!dp1!!a!!x1!"
)
for /f "usebackq delims=" %%A in (` powershell "!b!"`) do (
    set "i=%%A"
    if "!i:~0,1!"=="[" ( echo:>> "!dp1!!a!!x1!"& echo.)
    echo !i!>> "!dp1!!a!!x1!"
    echo !i!
)
exit /b