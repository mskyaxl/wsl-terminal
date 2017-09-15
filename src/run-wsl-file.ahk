#NoTrayIcon
#NoEnv

arg = %1%
SplitPath, arg, filename, dir
SetWorkingDir, %dir%

Run, %A_ScriptDir%\bin\mintty --configdir "%A_ScriptDir%\etc" -i "%A_ScriptFullPath%" -t "%arg%" -e /bin/wslbridge -t ./"%filename%"
