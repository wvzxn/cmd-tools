::        Name: regTool v1.0i
::      Author: wvzxn // https://github.com/wvzxn/
:: Description: regTool contains a collection of scripts to work with .reg files.
:: 
::              1) Create .reg with replaced UserID's '[HKEY_USERS*]' --> '[HKEY_CURRENT_USER*]'
::              2) Create Uninstall .reg              '[HKEY_*]'      --> '[-HKEY_*]'
@echo off
if not exist "%~1" ( echo works only with drag'n'drop& timeout 4 1>nul& goto:eof)
setlocal EnableDelayedExpansion
for /f "usebackq delims=" %%A in (` findstr /b :: "%~f0" `) do echo %%A
echo.
set /p "cmnd=Enter the number:"

if "!cmnd!"=="1" (
    set "a=%~dp1%~n1_currentUser%~x1"
    set "b=$a=gc '%~1'; $a -replace '(\[HKEY_USERS\\.*?\\)(.*)','[HKEY_CURRENT_USER\$2'"
    goto:12
)
if "!cmnd!"=="2" (
    set "a=%~dp1%~n1_uninstall%~x1"
    if "%~n1"=="1" ( set "a=%~dp12%~x1")
    set "b=gc '%~1'|select -index 0; gc '%~1'|%%{if($_ -like '`[HKEY*'){$_ -replace '(\[)(HKEY.*)','$1-$2'}}"
    goto:12
)
goto:eof

:12
echo ====  !a!  ====
for /f "usebackq delims=" %%A in (` powershell "!b!"`) do (
    set "i=%%A"
    echo !i!>> "!a!"
    echo !i!
)
shift
if exist "%~1" ( echo.& goto:12)
pause