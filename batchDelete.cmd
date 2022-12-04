::         Name: batchDelete v1.1
::       Author: wvzxn // https://github.com/wvzxn/
::  Description: Delete items by query in current folder and subfolders.
::               If the regex command is empty, the script will delete empty folders recursively.
::  
::               regex: - The regex string
::  
::               Include/Exclude mode:
::                  [1] - delete everything that matches the regex string
::                  [2] - delete everything that not matches the regex string
::  
::               File Name/Full Path mode:
::                  [1] - the regex string matches only the file name
::                  [2] - the regex string matches full path to the file

@echo off
setlocal EnableDelayedExpansion
for /f "usebackq delims=" %%A in (` findstr /b /c:"::  " "%~f0" `) do echo %%A
echo.
set /p "c=regex: "
set /p "b=Include/Exclude mode: "
set /p "a=File Name/Full Path mode: "

if "%a%"=="1" ( set "prop=name") else ( set "prop=fullname")
if "%b%"=="1" ( set "not=") else ( set "not=not")

:loop
if exist "%~1" ( set "d=%~f1\") else ( set "d=%~dp0")
if not "%a%"=="1" ( set "r=.*%d:\=\\%")
if not "%c%"=="" (
    powershell "gci '!d!' -file -recurse|?{"$^($_.!prop!^)" -!not!match '!r!!c!'}|ri -force"
) else (
    for /f "usebackq delims=" %%A in (`" dir "%~1" /ad/b/s | sort /r "`) do rd "%%A" 2>nul
)
shift
if exist "%~1" ( goto:loop)
pause