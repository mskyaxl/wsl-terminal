#NoTrayIcon
#NoEnv

arg = %1%
SplitPath, arg, filename, dir
SetWorkingDir, %dir%

Run, %A_ScriptDir%\bin\mintty -t "%arg%" -e /bin/wslbridge.exe -t ./"%filename%"
