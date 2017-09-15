#NoTrayIcon
#NoEnv

; Default options {{{1
ini_file = %A_ScriptDir%\etc\wsl-terminal.conf
activate_window := False
change_directory := ""
login_shell := False
distribution := ""


; Parse arguments {{{1
argc = %0%
args := []
Loop, %argc% {
    args.Insert(%A_Index%)
}

i := 0
while (i++ < argc) {
    c := args[i]
    if (c == "-a") {
        activate_window := True
    } else if (c == "-C") {
        if (argc < ++i) {
            MsgBox, 0x10, , Require directory arg.
            ExitApp, 1
        }
        change_directory := args[i]
    } else if (c == "-l") {
        login_shell := True
    } else if (c == "-d") {
        if (argc < ++i) {
            MsgBox, 0x10, , Require distribution name arg.
            ExitApp, 1
        }

        distribution := args[i]
    } else if (c == "-h") {
        help =
        (
            Usage: open-wsl [OPTION]...

            -a: activate an existing wsl-terminal window, if use_tmux=1, attach the running tmux session.
            -l: ignores current path and starts terminal in your home directory (doesn't work with tmux).
            -C dir: change directory to dir.
            -d distribution: switch distribution.
        )
        MsgBox, %help%
        ExitApp
    }
}


; Read ini file {{{1
IniRead, title, %ini_file%, config, title, "        "
IniRead, shell, %ini_file%, config, shell, "bash"
IniRead, use_cbwin, %ini_file%, config, use_cbwin, 0
IniRead, use_tmux, %ini_file%, config, use_tmux, 0
IniRead, attach_tmux_locally, %ini_file%, config, attach_tmux_locally, 0
IniRead, icon, %ini_file%, config, icon, ""


; Find bash.exe {{{1
bash_exe = %A_WinDir%\sysnative\bash.exe
if (!FileExist(bash_exe)) {
    bash_exe = %A_WinDir%\system32\bash.exe
} if (!FileExist(bash_exe)) {
    MsgBox, 0x10, , Ubuntu-on-Windows must be installed.
    ExitApp, 1
}

; Switch distribution {{{1
if (distribution != "") {
    Run, % StrReplace(bash_exe, "bash.exe", "wslconfig.exe") " /s " distribution
}


; Find icon {{{1
icon_string = -i "%A_ScriptFullPath%"
if (icon != "" && FileExist(icon)) {
    icon_string = -i "%icon%"
}


; Build command line {{{1
cmd = %shell%
opts = -t -e SHELL="%shell%"

if (activate_window && WinExist(title)) {
    cmd =
} else if (!use_tmux) {
    if (login_shell) {
        cmd = %shell% -l
        if (!change_directory) {
            change_directory = ~
        }
    }
} else {
    if (WinExist(title)) {
        cmd =
        Run, "%bash_exe%" -c 'tmux new-window -c "$PWD"', , Hide
    } else if (activate_window) {
        if (attach_tmux_locally) {
            opts = %opts% -e USE_TMUX=1 -e ATTACH_ONLY=1
        } else {
            cmd = %shell% -c "tmux a 2>/dev/null && exit || cd && exec tmux"
        }
    } else {
        if (attach_tmux_locally) {
            opts = %opts% -e USE_TMUX=1
        } else {
            cmd = %shell% -c 'tmux new-window -c "$PWD" \`; a 2>/dev/null || tmux'
        }
    }
}

if (change_directory) {
    opts = %opts% -C "%change_directory%"
}

if (cmd) {
    Run, "%A_ScriptDir%\bin\mintty" %icon_string% -t "%title%" -e /bin/wslbridge %opts% %cmd%
}


; Activate window {{{1
Loop, 5 {
    WinActivate, %title%
    if (WinActive(title)) {
        break
    }

    Sleep, 50
}

if (use_cbwin) {
    Process, Exist, outbash.exe

    if (ErrorLevel = 0) {
        Run, "%A_ScriptDir%\bin\outbash" --outbash-session -c 'exec sleep 10000000d', , Hide
    }
} else if (use_tmux) {
    ; Run a sleep to avoid tmux being killed.
    Process, Exist, sleep

    if (ErrorLevel = 0) {
        Run, "%bash_exe%" -c 'exec sleep 10000000d', , Hide
    }
}
