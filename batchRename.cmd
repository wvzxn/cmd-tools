::         Name: batchRename v1.1i
::       Author: wvzxn // https://github.com/wvzxn/
::  
::  Description: Rename item by query in folder and subfolders.
::               Drag'n'Drop is supported.
::                       Find: Files/Folders to find (wildcard, regex is not supported)
::               Replace this: The characters to find (regex)
::                         By: The characters to replace them with (regex)

@echo off
for /f "usebackq delims=" %%A in (` findstr /b /c:"::  " "%~f0" `) do echo %%A
echo.
set /p "a=Find: "
set /p "b=Replace this: "
set /p "c=By: "

:loop
if exist "%~1" ( set "d=%~f1") else ( set "d=%~dp0")
powershell "gci '%d%' -filter '%a%' -recurse|rni -NewName {$_.name -replace '%b%','%c%'}"
shift
if exist "%~1" ( goto:loop)
pause