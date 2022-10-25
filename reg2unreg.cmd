:: reg2unreg v1.0
:: Author: wvzxn // https://github.com/wvzxn/
@echo off
if not exist "%~1" ( goto:eof )
setlocal EnableDelayedExpansion
:i
echo.
echo ====  %~dp1%~n1_un%~x1  ====
echo.
echo Windows Registry Editor Version 5.00>> "%~dp1%~n1_un%~x1"
for /f "usebackq delims=" %%A in (` powershell "gc '%~1'|%%{if($_ -like '`[HKEY*'){echo $_}}"`) do (
    set "i=%%A"
    set i=!i:^[HKEY=^[-HKEY!
    echo !i!>> "%~dp1%~n1_un%~x1"
    echo !i!
)
echo.
echo ====  end  ====
echo.
shift
if exist "%~1" ( goto:i )
pause