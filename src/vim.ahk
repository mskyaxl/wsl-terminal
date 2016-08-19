#NoTrayIcon
#NoEnv

arg = %1%

SplitPath, arg, filename

Run, %A_ScriptDir%\bin\mintty -t "%arg%" -e /bin/wslbridge.exe -t vim "%filename%"
