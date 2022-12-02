::         Name: sandbox2here v1.0i
::       Author: wvzxn // https://github.com/wvzxn/
::  Description: The script creates a correct copy of 'DefaultBox'.

@echo off
if not "%1"=="am_admin" ( powershell start -verb runas '%0' 'am_admin "%~1" "%~2"' & exit )
for /f "usebackq delims=" %%A in (` findstr /b /c:"::  " "%~f0" `) do echo %%A
echo.
set "SB_C=%SystemDrive%\Sandbox\%username%\DefaultBox\drive\C"
set "SB_ProgramData=%SystemDrive%\Sandbox\%username%\DefaultBox\user\all"
set "SB_User=%SystemDrive%\Sandbox\%username%\DefaultBox\user\current"
pause
xcopy "%SB_C%" "%~dp0C" /s /i
xcopy "%SB_ProgramData%" "%~dp0C\ProgramData" /s /i
md "%~dp0C\Users\"
xcopy "%SB_User%" "%~dp0C\Users\(Name)" /s /i
pause