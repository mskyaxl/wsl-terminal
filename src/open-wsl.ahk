#NoTrayIcon
#NoEnv

; Read ini file {{{1
ini_file = %A_ScriptDir%\etc\wsl-terminal.conf
IniRead, title, %ini_file%, config, title, "        "
IniRead, shell, %ini_file%, config, shell, "bash"
IniRead, use_tmux, %ini_file%, config, use_tmux, 0
IniRead, mintty_options, %ini_file%, config, mintty_options,
IniRead, icon, %ini_file%, config, icon,
IniRead, distro, %ini_file%, config, distro,
IniRead, keep_wsl_running, %ini_file%, config, keep_wsl_running, 0

if (mintty_options == "ERROR") {
    mintty_options =
}


; Prepare mintty_base and wslbridge2_base {{{1
icon_path = %A_ScriptFullPath%
if (icon != "" && FileExist(icon)) {
    icon_path = %icon%
}

distro_option := ""
if (distro != "ERROR") {
    distro_option = -d %distro%
}

mintty_path = "%A_ScriptDir%\bin\mintty"
mintty_base = %mintty_path% -i "%icon_path%" --rootfs=// --configdir "%A_ScriptDir%\etc" 
wslbridge2_base = --WSLmode -e /bin/wslbridge2 %distro_option% -e SHELL=%shell% -e LANG -e WSL_HOST_IP
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

    Run, %mintty_base% %mintty_options% -t "%arg%"  %wslbridge2_base% -l %shell% -c ./"%filename%"
    ExitApp
} else if (exe_name != "open-wsl" && exe_name != "cmd") {
    ; editor
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

    Run, %mintty_base% %mintty_options% -t "%filepath%" %wslbridge2_base% "%exe_name%" %options% %filename%

    Loop, 5 {
        WinActivate, %filepath%
        if (WinActive(filepath)) {
            break
        }

        Sleep, 50
    }

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
wslbridge2_options := ""
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
            MsgBox, 0x10, , Require additional wslbridge2 options arg.
            ExitApp, 1
        }

        wslbridge2_options := args[i]
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
        wslbridge2_options = %wslbridge2_options% -W "%change_directory%"
    }

    Run, %mintty_base% %mintty_options% -t "%user_command%" %wslbridge2_base% %wslbridge2_options% %shell% -c "%user_command%"
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
opts = %wslbridge2_options%

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
    opts = %opts% -W "%change_directory%"
}

if (cmd != "") {
    lnk_args = %mintty_base% %mintty_options% -t "%title%" %wslbridge2_base% %opts% %cmd%
    lnk_args := StrReplace(lnk_args, mintty_path)

    FileCreateShortcut, %A_ScriptDir%\bin\mintty.exe, %A_ScriptDir%\wsl-terminal.lnk, %A_WorkingDir%, %lnk_args%, wsl-terminal temp shortcut, %icon_path%
    Run, %A_ScriptDir%\wsl-terminal.lnk

    ;Run, %mintty_base% %mintty_options% -t "%title%" %wslbridge2_base% %opts% %cmd%
}

; Activate window {{{1

if (activate_window || use_tmux) {
    Loop, 5 {
        WinActivate, %title%
        if (WinActive(title)) {
            break
        }

        Sleep, 50
    }
}

if (keep_wsl_running) {
    Process, Exist, sleep

    if (ErrorLevel == 0) {
        Run, "%bash_exe%" -c 'exec sleep 10000000d', , Hide
    }
}
