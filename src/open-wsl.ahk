#NoTrayIcon
#NoEnv

; Read ini file {{{1
ini_file = %A_ScriptDir%\etc\wsl-terminal.conf
IniRead, title, %ini_file%, config, title, "        "
IniRead, shell, %ini_file%, config, shell, "bash"
IniRead, use_cbwin, %ini_file%, config, use_cbwin, 0
IniRead, use_tmux, %ini_file%, config, use_tmux, 0
IniRead, attach_tmux_locally, %ini_file%, config, attach_tmux_locally, 0
IniRead, icon, %ini_file%, config, icon,
IniRead, distro_guid, %ini_file%, config, distro_guid,

; Prepare mintty_base and wslbridge_base {{{1
icon_option = -i "%A_ScriptFullPath%"
if (icon != "" && FileExist(icon)) {
    icon_option = -i "%icon%"
}

distro_option := ""
if (distro_guid != "ERROR") {
    distro_option = --distro-guid %distro_guid%
}

mintty_base = "%A_ScriptDir%\bin\mintty" --wsl --rootfs=/ --configdir "%A_ScriptDir%\etc" %icon_option%
wslbridge_base = -e /bin/wslbridge %distro_option% -e SHELL="%shell%"

; Run as run-wsl-file or any editor {{{1
SplitPath, A_ScriptName, , , , exe_name
if (exe_name == "run-wsl-file") {
    arg = %1%
    SplitPath, arg, filename, dir
    SetWorkingDir, %dir%

    Run, %mintty_base% -t "%arg%" %wslbridge_base% -t ./"%filename%"
    ExitApp
} else if (exe_name != "open-wsl") {
    argc = %0%
    filepath := %argc%
    flag := ""

    Loop, % argc - 1 {
        flag .= " " %A_Index%
    }

    SplitPath, filepath, filename, dir
    SetWorkingDir, %dir%

    if (InStr(filename, " ")) {
        filename = "%filename%"
    }

    Run, %mintty_base% -t "%filepath%" %wslbridge_base% -t "%exe_name%" %flag% %filename%
    ExitApp
}

; Parse arguments {{{1
argc = %0%
args := []
Loop, %argc% {
    args.Insert(%A_Index%)
}

activate_window := False
change_directory := ""
distro := ""
login_shell := False
wslbridge_flags := ""

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
            MsgBox, 0x10, , Require distro name arg.
            ExitApp, 1
        }

        distro := args[i]
    } else if (c == "-b") {
        if (argc < ++i) {
            MsgBox, 0x10, , Require additional wslbridge flags arg.
            ExitApp, 1
        }

        wslbridge_flags := args[i]
    } else if (c == "-h") {
        help =
        (
        Usage: open-wsl [OPTION]...
          -a: activate an existing wsl-terminal window, if use_tmux=1, attach the running tmux session.
          -l: start terminal in your home directory (doesn't work with tmux).
          -C dir: change directory to dir.
          -d distro: switch distros.
          -b "flags": pass additional flags to wslbridge.
          -h: show help.
        )
        MsgBox, %help%
        ExitApp
    }
}

; Find bash.exe {{{1
bash_exe = %A_WinDir%\sysnative\bash.exe
if (!FileExist(bash_exe)) {
    bash_exe = %A_WinDir%\system32\bash.exe
} if (!FileExist(bash_exe)) {
    MsgBox, 0x10, , WSL(Windows Subsystem for Linux) must be installed.
    ExitApp, 1
}

; Switch distro {{{1
if (distro != "") {
    Run, % StrReplace(bash_exe, "bash.exe", "wslconfig.exe") " /s " distro
}

; Build command line {{{1
cmd = %shell%
opts = %wslbridge_flags% -t

if (activate_window && WinExist(title)) {
    cmd =
} else if (!use_tmux) {
    if (login_shell) {
        cmd = %shell% -l
        if (change_directory == "") {
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

if (change_directory != "") {
    opts = %opts% -C "%change_directory%"
}

if (cmd) {
    Run, %mintty_base% -t "%title%" %wslbridge_base% %opts% %cmd%
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

    if (ErrorLevel == 0) {
        Run, "%A_ScriptDir%\bin\outbash" --outbash-session -c 'exec sleep 10000000d', , Hide
    }
} else if (use_tmux) {
    ; Run a sleep to avoid tmux being killed.
    Process, Exist, sleep

    if (ErrorLevel == 0) {
        Run, "%bash_exe%" -c 'exec sleep 10000000d', , Hide
    }
}
