#!/bin/bash

set -e

cd "$(dirname "$0")"

[[ $# == 0 || "$1" == "-h" || "$1" == "--help" ]] && {
    echo -e "Usage: $0 [OPTION]..."\
        "\n  wcmd: run Windows programs with cmd.exe /c."\
        "\n  wstart: run Windows programs with cmd.exe /c start."\
        "\n  wstartex file|url: like wstart, but use WSL file path."\
        "\n  update: check the latest wsl-terminal version, and upgrade it."\
        "\n  killall: kill all WSL process."\
        "\n  install winpty: install Cygwin winpty."\
        "\n  install dash: install Cygwin dash (for debugging)."\
        "\n  install busybox: install Cygwin busybox (for debugging)."

    exit
}

op=$1

if [[ "$1" == wcmd ]]; then
    cd - >/dev/null
    shift
    exec /init /mnt/c/Windows/System32/cmd.exe /c "$@"
elif [[ "$1" == wstart ]]; then
    cd - >/dev/null
    shift
    exec /init /mnt/c/Windows/System32/cmd.exe /c start "" "$@"
elif [[ "$1" == wstartex && -n "$2" ]]; then
    cd - >/dev/null
    shift
    wstart_run='setsid /init /mnt/c/Windows/System32/cmd.exe /c start'

    if [[ "$1" == http* || "$1" == www* ]]; then
        exec $wstart_run "" "$@"
    fi

    dir_name="$(dirname "$1")"
    file_name="$(basename "$1")"

    if [[ "$dir_name" == / ]]; then
        cd /; $wstart_run .; cd - >/dev/null
    elif [[ "$dir_name" == /mnt ]]; then
        cd /; $wstart_run "" "$file_name":; cd - >/dev/null
    else
        shift 2>/dev/null
        cd "$dir_name" && $wstart_run "" "$file_name" "$@"; cd - >/dev/null
    fi
elif [[ "$1" == wpath ]]; then
    type wslpath >/dev/null && {
        echo 'Please use wslpath -w $PWD.'
        exit 1
    }

    if [[ -n "$2" ]]; then
        wpath="$2"
    else
        wpath="$PWD"
    fi

    if [[ "$wpath" == /mnt/* ]]; then
        wpath=${wpath:5:1}:${wpath:6}
        echo ${wpath//\//\\}
    else
        exit 1
    fi
elif [[ "$1" == update ]]; then
    bash -c "$(wget https://raw.githubusercontent.com/mskyaxl/wsl-terminal/master/scripts/install.sh -qO -)" '' -u ${PWD}
    echo OK
    exit
elif [[ "$1" == "killall" ]]; then
    killall sleep wslbridge2-backend bash tmux zsh
elif [[ "$1" == "install" ]]; then
    if [[ "$2" == "dash" ]]; then
        version=0.5.9.1-1
        wget "http://mirrors.ustc.edu.cn/cygwin/x86_64/release/dash/dash-$version.tar.xz" 
        tar -xvf "dash-$version.tar.xz" usr/bin/ash.exe
        cp -v usr/bin/ash.exe bin/dash.exe
        # mintty need a bash.exe if running with no args.
        mv -v usr/bin/ash.exe bin/bash.exe
        rm -rf usr "dash-$version.tar.xz"
        echo OK
    elif [[ "$2" == "busybox" ]]; then
        version=1.23.2-1
        wget "http://mirrors.ustc.edu.cn/cygwin/x86_64/release/busybox/busybox-$version.tar.xz"
        tar -xvf "busybox-$version.tar.xz" usr/libexec/busybox/bin/busybox.exe
        mv -v usr/libexec/busybox/bin/busybox.exe bin/busybox.exe
        rm -rf usr "busybox-$version.tar.xz"
        echo OK
    elif [[ "$2" == "winpty" ]]; then
        wget "https://github.com/rprichard/winpty/releases/download/0.4.3/winpty-0.4.3-cygwin-2.8.0-x64.tar.gz"
        tar -xvf "winpty-0.4.3-cygwin-2.8.0-x64.tar.gz" winpty-0.4.3-cygwin-2.8.0-x64/bin
        mv -v winpty-0.4.3-cygwin-2.8.0-x64/bin/* bin
        rm -rf winpty-0.4.3-cygwin-2.8.0-x64.tar.gz winpty-0.4.3-cygwin-2.8.0-x64
        echo OK
    fi
fi
