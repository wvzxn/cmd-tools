::         Name: batchRename v1.0
::       Author: wvzxn // https://github.com/wvzxn/
::  Description: The script will rename by query in current folder and subfolders.
::               
::               Find         = Files/Folders to find (wildcard, regex is not supported)
::               Replace this = The characters to find (regex)
::               To           = The characters to replace them with. (regex)

@echo off
for /f "usebackq delims=" %%A in (` findstr /b /c:"::  " "%~f0" `) do echo %%A
echo.
set /p "a=Find: "
set /p "b=Replace this: "
set /p "c=To: "
if not exist "%~1" (
    powershell "gci '%~f0' -filter '%a%' -recurse|rni -NewName {$_.name -replace '%b%','%c%'}"
    pause
    exit
)
:loop
powershell "gci '%~f1' -filter '%a%' -recurse|rni -NewName {$_.name -replace '%b%','%c%'}"
shift
if exist "%~1" ( goto:loop)
pause