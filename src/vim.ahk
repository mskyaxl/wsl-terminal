#NoTrayIcon
#NoEnv

argc = %0%
filepath := %argc%
flag := ""

Loop, % argc - 1 {
    flag .= " " %A_Index%
}

SplitPath, filepath, filename, dir
SetWorkingDir, %dir%

SplitPath, A_ScriptName, , , , editor

if (InStr(filename, " ")) {
    filename = "%filename%"
}

Run, %A_ScriptDir%\bin\mintty -i "%A_ScriptFullPath%" -t "%filepath%" -e /bin/wslbridge -t "%editor%" %flag% %filename%
