#NoTrayIcon
#NoEnv

args = %0%
title := "        "

if (args = 1 && WinExist(title))
{
    WinActivate, %title%
    Exit
}
else
{
    WinClose, %title%

    if (args = "1")
    {
        Run, %A_ScriptDir%\bin\mintty -t "%title%" -e /bin/wslbridge.exe -e USETMUX=1 -t zsh
    }
    else
    {
        drive := SubStr(A_WorkingDir, 1, 1)
        StringLower, drive, drive
        dir := "/mnt/" drive StrReplace(SubStr(A_WorkingDir, 3), "\", "/")

        Run, %A_ScriptDir%\bin\mintty -t "%title%" -e /bin/wslbridge.exe -e USETMUX=1 -ePASSDIR="%dir%" -t zsh
    }

    Loop, 5
    {
        if (WinActive(title))
        {
            break
        }

        WinActivate, %title%
        Sleep, 50
    }
}
