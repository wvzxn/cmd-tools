:: regTool v1.0
:: Author: wvzxn // https://github.com/wvzxn/
@echo off
if not exist "%~1" ( echo works only with drag'n'drop& timeout 4 1>nul& goto:eof)
setlocal EnableDelayedExpansion
echo 1^) Replace 'HKEY_USERS' --^> 'HKEY_CURRENT_USER'
echo 2^) Create Uninstall Reg-file
set /p "cmnd=:"
if not "!cmnd!"=="1" ( if not "!cmnd!"=="2" ( goto:eof))

if "!cmnd!"=="1" (
    set "a=%~dp1%~n1_currentUser%~x1"
    set "b=$a=gc '%~1'; $a -replace '(\[HKEY_USERS\\.*?\\)(.*)','[HKEY_CURRENT_USER\$2'"
) else (
    set "a=%~dp1%~n1_uninstall%~x1"
    if "%~n1"=="1" ( set "a=%~dp12%~x1")
    set "b=gc '%~1'|select -index 0; gc '%~1'|%%{if($_ -like '`[HKEY*'){$_ -replace '(\[)(HKEY.*)','$1-$2'}}"
)
echo.
echo ====  !a!  ====
echo.
:i
for /f "usebackq delims=" %%A in (` powershell "!b!"`) do (
    set "i=%%A"
    echo !i!>> "!a!"
    echo !i!
)
echo.
echo ====  end  ====
echo.
shift
if exist "%~1" ( goto:i)
pause