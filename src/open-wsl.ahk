#NoTrayIcon
#NoEnv

; Read ini file {{{1
ini_file = %A_ScriptDir%\etc\wsl-terminal.conf
IniRead, title, %ini_file%, config, title, "        "
IniRead, shell, %ini_file%, config, shell, "bash"
IniRead, use_cbwin, %ini_file%, config, use_cbwin, 0
IniRead, use_tmux, %ini_file%, config, use_tmux, 0
IniRead, mintty_options, %ini_file%, config, mintty_options,
IniRead, icon, %ini_file%, config, icon,
IniRead, distro_guid, %ini_file%, config, distro_guid,
IniRead, keep_wsl_running, %ini_file%, config, keep_wsl_running, 0

if (mintty_options == "ERROR") {
    mintty_options =
}

; Prepare mintty_base and wslbridge_base {{{1
icon_option = -i "%A_ScriptFullPath%"
if (icon != "" && FileExist(icon)) {
    icon_option = -i "%icon%"
}

distro_option := ""
if (distro_guid != "ERROR") {
    distro_option = --distro-guid %distro_guid%
}

mintty_base = "%A_ScriptDir%\bin\mintty" --wsl --rootfs=// --configdir "%A_ScriptDir%\etc" %icon_option%
wslbridge_base = -e /bin/wslbridge %distro_option% -e SHELL="%shell%" -e LANG

; Run as run-wsl-file or any editor {{{1
SplitPath, A_ScriptName, , , , exe_name
if (exe_name == "run-wsl-file") {
    arg = %1%

    if (arg == "") {
        MsgBox, Open .sh/.py/.pl/... with %exe_name%.exe to run it in WSL.
        ExitApp
    }

    SplitPath, arg, filename, dir
    SetWorkingDir, %dir%

    Run, %mintty_base% -t "%arg%" %wslbridge_base% -t ./"%filename%"
    ExitApp
} else if (exe_name != "open-wsl" && exe_name != "cmd") {
    argc = %0%
    filepath := ""
    filename := ""
    options := ""

    if (argc > 0) {
        filepath := %argc%

        Loop, % argc - 1 {
            options .= " " %A_Index%
        }

        SplitPath, filepath, filename, dir
        SetWorkingDir, %dir%

        if (InStr(filename, " ")) {
            filename = "%filename%"
        }
    }

    Run, %mintty_base% -t "%filepath%" %wslbridge_base% -t "%exe_name%" %options% %filename%
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
wslbridge_options := ""
user_command := ""

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
    } else if (c == "-W") {
        if (argc < ++i) {
            MsgBox, 0x10, , Require directory arg.
            ExitApp, 1
        }

        SetWorkingDir, % args[i]
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
            MsgBox, 0x10, , Require additional wslbridge options arg.
            ExitApp, 1
        }

        wslbridge_options := args[i]
    } else if (c == "-B") {
        if (argc < ++i) {
            MsgBox, 0x10, , Require additional mintty options arg.
            ExitApp, 1
        }

        mintty_options .= " " args[i]
    } else if (c == "-c") {
        if (argc < ++i) {
            MsgBox, 0x10, , Require command arg.
            ExitApp, 1
        }

        user_command := args[i]
    } else if (c == "-e") {
        if (argc < ++i) {
            MsgBox, 0x10, , Require command arg.
            ExitApp, 1
        }

        user_command := shell " -c """ args[i]
        while (++i <= argc) {
            user_command .= " " args[i]
        }
        user_command .= """"
        StringReplace, user_command, user_command, `", `\`", All
    } else if (c == "-h") {
        help =
        (
        Usage: open-wsl [OPTION]...
          -a: activate an existing wsl-terminal window.
              if use_tmux=1, attach the running tmux session.
          -l: start terminal in your home directory (doesn't work with tmux).
          -c "command": run command (e.g. -c "echo a b; echo c; cat").
          -e commands: run commands (e.g. -e echo a b; echo c; cat).
          -C dir: change directory to a WSL dir (e.g. /home/username).
          -W dir: change directory to a Windows dir (e.g. c:\Users\username).
          -d distro: switch distros.
          -b "options": pass additional options to wslbridge.
          -B "options": pass additional options to mintty.
          -h: show help.
        )
        MsgBox, %help%
        ExitApp
    }
}

if (user_command != "") {
    if (change_directory != "") {
        wslbridge_options = %wslbridge_options% -C "%change_directory%"
    }

    Run, %mintty_base% %mintty_options% -t "%user_command%" %wslbridge_base% %wslbridge_options% -t %shell% -c "%user_command%"
    ExitApp
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
cmd =
opts = %wslbridge_options% -t

if (activate_window && WinExist(title)) {
} else if (!use_tmux) {
    if (login_shell) {
        cmd = %shell% -l
        if (change_directory == "") {
            change_directory = ~
        }
    } else {
        cmd = %shell%
    }
} else {
    if (WinExist(title)) {
        Run, "%bash_exe%" -c 'tmux new-window -c "$PWD"', , Hide
    } else {
        cmd = %shell%
        opts = %opts% -e USE_TMUX=1

        if (activate_window) {
            opts = %opts% -e ATTACH_ONLY=1
        }
    }
}

if (change_directory != "") {
    opts = %opts% -C "%change_directory%"
}

if (cmd != "") {
    Run, %mintty_base% %mintty_options% -t "%title%" %wslbridge_base% %opts% %cmd%
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
} else if (keep_wsl_running) {
    Process, Exist, sleep

    if (ErrorLevel == 0) {
        Run, "%bash_exe%" -c 'exec sleep 10000000d', , Hide
    }
}
