#NoTrayIcon
#NoEnv

args = %1%
IniRead, title, %A_ScriptDir%\etc\wsl-terminal.conf, config, title, "        "
IniRead, shell, %A_ScriptDir%\etc\wsl-terminal.conf, config, shell, "bash"
IniRead, use_cbwin, %A_ScriptDir%\etc\wsl-terminal.conf, config, use_cbwin, 0
IniRead, use_tmux, %A_ScriptDir%\etc\wsl-terminal.conf, config, use_tmux, 0
IniRead, attach_tmux_locally, %A_ScriptDir%\etc\wsl-terminal.conf, config, attach_tmux_locally, 0

if (args = "-a" && WinExist(title))
{
    WinActivate, %title%
}
else if (!use_tmux)
{
    Run, %A_ScriptDir%\bin\mintty -t "%title%" -e /bin/wslbridge -t %shell%
}
else
{
    if (args = "-a" && !WinExist(title))
    {
        if (attach_tmux_locally)
        {
            Run, %A_ScriptDir%\bin\mintty -t "%title%" -e /bin/wslbridge -e USE_TMUX=1 -e ATTACH_ONLY=1 -t %shell%
        }
        else
        {
            Run, %A_ScriptDir%\bin\mintty -t "%title%" -e /bin/wslbridge -t %shell% -c "tmux a 2>/dev/null || tmux"
        }
    }
    else
    {
        if (WinExist(title))
        {
            Run, c:\windows\sysnative\bash -c 'tmux new-window -c "$PWD"', , Hide
            WinActivate, %title%
        }
        else
        {
            if (attach_tmux_locally)
            {
                Run, %A_ScriptDir%\bin\mintty -t "%title%" -e /bin/wslbridge -e USE_TMUX=1 -t %shell%
            }
            else
            {
                Run, %A_ScriptDir%\bin\mintty -t "%title%" -e /bin/wslbridge -t %shell% -c 'tmux new-window -c "$PWD" \; a 2>/dev/null || tmux'
            }
        }
    }
}

Loop, 5
{
    WinActivate, %title%
    if (WinActive(title))
    {
        break
    }

    Sleep, 50
}

if (use_cbwin)
{
    Process, Exist, outbash.exe

    if (ErrorLevel = 0)
    {
        Run, %A_ScriptDir%\bin\outbash --outbash-session -c 'exec sleep 10000000d', , Hide
    }
}
else if (use_tmux)
{
    ; Run a sleep to avoid tmux being killed.
    Process, Exist, sleep

    if (ErrorLevel = 0)
    {
        Run, c:\windows\sysnative\bash -c 'exec sleep 10000000d', , Hide
    }
}
