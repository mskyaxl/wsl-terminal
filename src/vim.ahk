#NoTrayIcon
#NoEnv

arg = %1%

SplitPath, arg, filename, dir
SetWorkingDir, %dir%

SplitPath, A_ScriptName, , , , editor

Run, %A_ScriptDir%\bin\mintty -i "%A_ScriptFullPath%" -t "%arg%" -e /bin/wslbridge -t "%editor%" "%filename%"
