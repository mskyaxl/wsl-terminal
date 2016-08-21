#NoTrayIcon
#NoEnv

arg = %1%

SplitPath, arg, filename, dir
SetWorkingDir, %dir%

SplitPath, A_ScriptName, , , , editor

Run, %A_ScriptDir%\bin\mintty -t "%arg%" -e /bin/wslbridge -t "%editor%" "%filename%"
