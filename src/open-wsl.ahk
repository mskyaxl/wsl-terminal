#NoTrayIcon
#NoEnv

args = %1%
IniRead, title, %A_ScriptDir%\etc\wsl-terminal.conf, config, title, "        "

if (args = "-a" && WinExist(title))
{
    WinActivate, %title%
    Exit
}
else
{
    IniRead, shell, %A_ScriptDir%\etc\wsl-terminal.conf, config, shell, "bash"
    IniRead, one_instance, %A_ScriptDir%\etc\wsl-terminal.conf, config, one_instance, 0

    if (one_instance)
    {
        WinClose, %title%
    }

    if (args = "-a")
    {
        Run, %A_ScriptDir%\bin\mintty -t "%title%" -e /bin/wslbridge.exe -e USE_TMUX=1 -e ATTACH_ONLY=1 -t "%shell%"
    }
    else
    {
        Run, %A_ScriptDir%\bin\mintty -t "%title%" -e /bin/wslbridge.exe -e USE_TMUX=1 -t "%shell%
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
