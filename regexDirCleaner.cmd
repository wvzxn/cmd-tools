:: regexDirCleaner v1.0
:: Author: wvzxn // https://github.com/wvzxn/
:: Description: The script will delete everything except what you specify as regex.
@echo off
if not exist "%~1" ( echo works only with drag'n'drop& timeout 4 2>nul& goto:eof)
echo Enter regex command
set /p "cmnd=:"
:i
echo.
echo ====  %~1%  ====
set "a=%~1"
set b=%a:\=\\%
set "pwsh=(gci '%~1' -att !d -recurse).fullname|?{$_ -notmatch '(.*%b%\\)(%cmnd%)'}"
if not "%cmnd%"=="" ( for /f "usebackq delims=" %%A in (` powershell "%pwsh%"`) do del /q "%%A")
for /f "usebackq delims=" %%A in (`" dir "%~1" /ad/b/s | sort /r "`) do rd "%%A" 2>nul
shift
if exist "%~1" ( goto:i)
pause