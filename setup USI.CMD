::  setup USI.CMD v1.0
::  
::  [Author]
::    wvzxn | https://github.com/wvzxn/
::  
::  [Description]
::    Addon for USI.CMD.
::    Commands:
::      [1] Copy Sandboxie content to the current folder
::      [2] Delete junk (all except [regex])
::      [3] Download USI.CMD / regTool.cmd
::      [4] Get and replace commands for USI.CMD [regex]

@echo off
title setup USI.CMD
call :testFolderName exit
setlocal EnableDelayedExpansion
call :setGlobalVar

:menu
for /f "usebackq delims=" %%A in (` findstr /b /c:"::  " "!f0!" `) do echo %%A
echo.
call:userPrompt
if not "!KEY:~0,1!"=="D" ( exit )
if "!KEY!"=="D1" ( call:1)
if "!KEY!"=="D2" ( call:2)
if "!KEY!"=="D3" ( call:3)
if "!KEY!"=="D4" ( call:4)
cls
goto:menu

:1
if exist C (
    echo ^[^^!^] ^"!dp0!C^" folder exists
    pause
    exit /b 0
)
set "SB_C=%SystemDrive%\Sandbox\%username%\DefaultBox\drive\C"
set "SB_ProgramData=%SystemDrive%\Sandbox\%username%\DefaultBox\user\all"
set "SB_User=%SystemDrive%\Sandbox\%username%\DefaultBox\user\current"
xcopy "!SB_C!" "!dp0!C" /s /i
xcopy "!SB_ProgramData!" "!dp0!C\ProgramData" /s /i
xcopy "!SB_User!" "!dp0!C\Users\(Name)" /s /i
pause
exit /b 0

:2
call:regex
if "!r!"=="" ( exit /b 0 )
powershell "(gci '!dp0!C' -recurse|?{-not($_.psIsContainer)}).fullname|?{($_ -replace [regex]::escape('!dp0!'),'') -notmatch '!r!'}|sort|%%{write-host '[-] ' -nonewline;echo $_;ri $_ -force}"
for /f "usebackq delims=" %%A in (` powershell "(gci '!dp0!C' -recurse|?{-not($_.psIsContainer)}|?{($_.name -match 'unins.*?\.') -or ($_.fullname -match '((Microsoft\\Windows\\Start.?Menu)|(\\Desktop\\.+?\.lnk))')}).fullname|sort" `) do (
    echo ^[-^] %%A
    del /f /q "%%A"
)
echo ^[-^] Empty folders...
for /f "delims=" %%A in (' dir "!dp0!" /ad/b/s ^| sort /r ') do rd "%%A" 2>nul
pause
exit /b 0

:3
echo ^[1^] - Download USI.CMD
echo ^[2^] - Download regTool.cmd
call:userPrompt
if not "!KEY:~0,1!"=="D" ( exit /b 0 )
if "!KEY!"=="D1" (
    powershell -executionpolicy bypass -command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;iwr 'https://raw.githubusercontent.com/wvzxn/universal-symlink-installer/master/usi.cmd' -outFile '!dp0!lf';gc '!dp0!lf'|sc '!dp0!USI.CMD';ri '!dp0!lf'"
)
if "!KEY!"=="D2" (
    powershell -executionpolicy bypass -command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;iwr 'https://raw.githubusercontent.com/wvzxn/cmd-tools/master/regTool.cmd' -outFile '!dp0!reglf';gc '!dp0!reglf'|sc '!dp0!regTool.cmd';ri '!dp0!reg'"
)
echo ^[+^] Done!
pause
exit /b 0

:4
if exist "usi.cmd" (
    ren "usi.cmd" "usi_.cmd"
    findstr /b /v /c:"::: " "usi_.cmd" >"USI.CMD"
    del /q "usi_.cmd"
)
if "!r!"=="" ( call:regex)
for /f "usebackq delims=" %%A in (` powershell "gci '!dp0!C' -recurse|?{$_.name -match '!r!'}|?{$_.fullname -notmatch '\\C\\.*?(!r!).*?\\.*?(!r!)'}|%%{$_.fullname -replace [regex]::escape('!dp0!'),''}|sort" `) do (
    echo ::: %%A
    echo ::: %%A>> "USI.CMD"
)
pause
exit /b 0

:testFolderName
for %%A in (.) do set "a=%%~nA"
set "a=%a:'=@%"
set "a=%a:!=@%"
set "a=%a:^=@%"
set "a=%a:&=@%"
set "a=%a:[=@%"
set "a=%a:]=@%"
setlocal EnableDelayedExpansion
set "a=!a:%%=@!"
for /f "usebackq delims=" %%A in (` powershell "'!a!' -match '\@'"`) do set "b=%%A"
setlocal DisableDelayedExpansion
if "%b%"=="True" (
	echo The folder name contains forbidden characters !@%%^^^&^[^]'
	pause
	%*
)
exit /b

:regex
echo example: ^(some.?thing^)^|^(another\d*?thing^)
set /p "r=[regex]: "
exit /b 0

:setGlobalVar
set "dp0=%~dp0"
set "f0=%~f0"
set "________=[=============================================================]"
cd /d "!dp0!"
exit /b

:centerText
set "a=%~1"
set "b=!a:'=@!"
powershell "$a='!b!'.length;$l=(63-$a)/2;for($i=1;$i -le $l;$i++){Write-Host -nonewline ' '}"
echo !a!
exit /b

:userPrompt
for /f "usebackq delims=" %%K in (` powershell "[Console]::ReadKey($true).Key" `) do set "KEY=%%K"
exit /b