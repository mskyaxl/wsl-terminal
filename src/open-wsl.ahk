#NoTrayIcon
#NoEnv

args = %1%
IniRead, title, %A_ScriptDir%\etc\wsl-terminal.conf, config, title, "        "
IniRead, shell, %A_ScriptDir%\etc\wsl-terminal.conf, config, shell, "bash"
IniRead, use_cbwin, %A_ScriptDir%\etc\wsl-terminal.conf, config, use_cbwin, 0
IniRead, use_tmux, %A_ScriptDir%\etc\wsl-terminal.conf, config, use_tmux, 0
IniRead, attach_tmux_locally, %A_ScriptDir%\etc\wsl-terminal.conf, config, attach_tmux_locally, 0
IniRead, icon, %A_ScriptDir%\etc\wsl-terminal.conf, config, icon, ""

bash_exe = %A_WinDir%\sysnative\bash.exe
if (!FileExist(bash_exe))
{
    bash_exe = %A_WinDir%\system32\bash.exe
}
if (!FileExist(bash_exe))
{
    MsgBox, 0x10, , Ubuntu-on-Windows must be installed.
    ExitApp, 1
}

icon_string = -i "%A_ScriptFullPath%"
if (icon != "" && FileExist(icon))
{
    icon_string = -i "%icon%"
}

cmd = %shell%
opts = -t -e SHELL="%shell%"
if (args = "-a" && WinExist(title))
{
    cmd =
}
else if (!use_tmux)
{
    if (args = "-l")
    {
        cmd = %shell% -c "cd; %shell% -l"
    }
}
else
{
    if (WinExist(title))
    {
        cmd =
        Run, "%bash_exe%" -c 'tmux new-window -c "$PWD"', , Hide
    }
    else if (args = "-a")
    {
        if (attach_tmux_locally)
        {
            opts = %opts% -e USE_TMUX=1 -e ATTACH_ONLY=1
        }
        else
        {
            cmd = %shell% -c "tmux a 2>/dev/null && exit || cd && exec tmux"
        }
    }
    else
    {
        if (attach_tmux_locally)
        {
            opts = %opts% -e USE_TMUX=1
        }
        else
        {
            cmd = %shell% -c 'tmux new-window -c "$PWD" \`; a 2>/dev/null || tmux'
        }
    }
}
if (cmd)
{
    Run, "%A_ScriptDir%\bin\mintty" %icon_string% -t "%title%" -e /bin/wslbridge %opts% %cmd%
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
        Run, "%A_ScriptDir%\bin\outbash" --outbash-session -c 'exec sleep 10000000d', , Hide
    }
}
else if (use_tmux)
{
    ; Run a sleep to avoid tmux being killed.
    Process, Exist, sleep

    if (ErrorLevel = 0)
    {
        Run, "%bash_exe%" -c 'exec sleep 10000000d', , Hide
    }
}
