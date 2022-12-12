::         Name: regTool v1.1
::       Author: wvzxn // https://github.com/wvzxn/
::  Description: regTool contains a collection of scripts to work with .reg files.
::  
::               1) Create .reg with replaced UserID's '[HKEY_USERS*]' --> '[HKEY_CURRENT_USER*]'
::               2) Create Uninstall .reg              '[HKEY_*]'      --> '[-HKEY_*]'
::               3) Remove unwanted keys from .reg (regex)

@echo off
if not exist "%~1" ( echo works only with drag'n'drop& timeout 4 1>nul& exit )
setlocal EnableDelayedExpansion
for /f "usebackq delims=" %%A in (` findstr /b /c:"::  " "%~f0" `) do echo %%A
echo.
set /p "cmnd=: "

:loop
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
pause
exit

:1
set "a=!dp1!!n1!_currentUser!x1!"
set "b=$a=gc '!f1!';$a -replace '(\[HKEY_USERS\\.*?\\)(.*)','[HKEY_CURRENT_USER\$2'"
exit /b

:2
set "a=!dp1!!n1!_uninstall!x1!"
if "!n1!"=="1" ( set "a=!dp1!2!x1!")
set "b=gc '!f1!'|select -index 0;gc '!f1!'|%%{if($_ -like '`[HKEY*'){$_ -replace '(\[)(HKEY.*)','$1-$2'}}"
exit /b

:3
set /p "regex=What to keep (regex): "
set "a=!dp1!!n1!_fixed!x1!"
set "b=$a=gc '!f1!';$a|select -index 0;foreach($i in $a){if($i -match '\[.*\]'){if($i -match '\[.*!regex!.*\]'){$j=$true;$i}else{$j=$false}}else{if($j){$i}}}"
exit /b

:process
echo ====  !a!  ====
for /f "usebackq delims=" %%A in (` powershell "!b!"`) do (
    set "i=%%A"
    echo !i!>> "!a!"
    echo !i!
)
exit /b