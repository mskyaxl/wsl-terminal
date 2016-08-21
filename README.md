# wsl-terminal

A terminal emulator for Windows Subsystem for Linux (WSL), includes [mintty](http://mintty.github.io/), [wslbridge](https://github.com/rprichard/wslbridge), [cbwin](https://github.com/xilun/cbwin), and some other useful tools.

## Screenshot

![screenshot](https://raw.githubusercontent.com/wiki/goreliu/wsl-terminal/images/wsl-terminal-2.png)

[More screenshots.](https://github.com/goreliu/wsl-terminal/wiki/Screenshots)

## Usage

[Download here.](https://github.com/goreliu/wsl-terminal/releases)

Run `open-wsl.exe` to open a WSL terminal in current directory (need to be on a local NTFS volume, [more details](https://github.com/rprichard/wslbridge)).

Run `tools/add-open-wsl-here-menu.js` to add a `Open WSL Here` context menu to explorer.exe (run `tools/remove-open-wsl-here-menu.js` to remove it).

If you are using Total Commander, read [Use wsl-terminal with Total Commander](https://github.com/goreliu/wsl-terminal/wiki/Use-wsl-terminal-with-Total-Commander).

`run-wsl-file.exe` can run any .sh(and any others like .py/.pl/.php) script files in wsl-terminal, support `Open With` context menu in explorer.exe.

`vim.exe` can open any text file in vim(in wsl-terminal), support `Open With` context menu in explorer.exe.

## Run Windows programs in WSL

Run `outbash-daemon.js` to start a outbash.exe daemon, read [security warning](https://github.com/xilun/cbwin#security-warning) before running it. (If no need of `outbash.exe`, run a sleep(or a cat) in background to avoid all WSL processes (include tmux) being killed, more details in `outbash-daemon.js`.)

`bin/{wrun/wstart/wcmd}` are used to run Windows programs (if outbash-deamon.js has been started). Open open-wsl.exe, run this command to install `wrun/wstart/wcmd`:

```
cd bin && ./install_cbwin.sh
```

Usage:

```
## Run with cmd /C ##
$ wcmd ping 127.0.0.1

Pinging 127.0.0.1 with 32 bytes of data:
Reply from 127.0.0.1: bytes=32 time<1ms TTL=128
...

## Run a .bat/.cmd file ##
$ wcmd example.bat

## Run with CreateProcess() ##
$ wrun notepad example.txt

## Run with cmd /C start ##
$ wstart example.txt

## Run a powershell command ##
$ wrun powershell -c ps

## Kill outbash.exe ##
$ wrun taskkill /f /im outbash.exe
```

[More details about cbwin.](https://github.com/xilun/cbwin)

## Configuration files

`etc/wsl-terminal.conf` is wsl-terminal config file.
```
[config]
title="        "
shell=bash
use_tmux=0
```

`usr/share/mintty/themes/` are theme files, [use themes](https://github.com/goreliu/wsl-terminal/wiki/Use-themes).

`etc/minttyrc` is mintty config file, [mintty tips](https://github.com/mintty/mintty/wiki/Tips).

## Keyboard shortcuts

`Alt + Enter`: Fullscreen

`Alt + F2`: New window

`Ctrl + [Shift] + Tab`: Switch window

`Ctrl + =+/-/0`: Zoom

## Params

```
open-wsl.exe
    -a: activate an existing wsl-terminal window, if use_tmux=1, attach the running tmux session.
```

[mintty params.](https://github.com/goreliu/wsl-terminal/wiki/mintty-params)

[wslbridge params.](https://github.com/rprichard/wslbridge#usage)

## Known issues

[Sometimes tmux hangs.](https://github.com/goreliu/wsl-terminal/issues/1)

[FAQ](https://github.com/goreliu/wsl-terminal/wiki/FAQ)

## Build

Run `build.bat`, make sure wget/tar/xz/gzip/unzip/p7zip are installed in WSL.

## License

[Cygwin DLL](https://www.cygwin.com/): https://cygwin.com/licensing.html

[mintty](http://mintty.github.io/): GPLv3+

[wslbridge](https://github.com/rprichard/wslbridge): MIT

[cbwin](https://github.com/xilun/cbwin): MIT

[wsl-terminal](https://github.com/goreliu/wsl-terminal): MIT
