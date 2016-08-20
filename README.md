# wsl-terminal

wsl-terminal is a terminal emulator for Windows Subsystem for Linux (WSL), contains [mintty](http://mintty.github.io/), [wslbridge](https://github.com/rprichard/wslbridge), [cbwin](https://github.com/xilun/cbwin), and some useful tools.

## Screenshot

![screenshot](https://raw.githubusercontent.com/wiki/goreliu/wsl-terminal/images/wsl-terminal.png)

## Usage

Download from https://github.com/goreliu/wsl-terminal/releases

Run `open-wsl.exe` to open a WSL terminal in current directory (need to be on a local NTFS volume, [more details](https://github.com/rprichard/wslbridge)).

Run `tools/add-open-wsl-here-menu.js` to add a `Open WSL Here` context menu to explorer.exe (run `tools/remove-open-wsl-here-menu.js` to remove it).

If you are using Total Commander, read [Use wsl-terminal with Total Commander](https://github.com/goreliu/wsl-terminal/wiki/Use-wsl-terminal-with-Total-Commander).

`run-wsl-file.exe` can run any .sh(and any others like .py/.pl/.php) script files in wsl-terminal, support `Open With` context menu in explorer.exe.

`vim.exe` can open any text file in vim(in wsl-terminal), support `Open With` context menu in explorer.exe.

Run `outbash-daemon.js` to start a outbash.exe daemon, read security warning in https://github.com/xilun/cbwin before run it. (If no need of `outbash.exe`, run a sleep in background to avoid all WSL processes(include tmux) being killed, more details in `outbash-daemon.js`.)

`bin/{wrun/wstart/wcmd}` are used to run Windows programs (if outbash-deamon.js has been started):

Install:

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

$ wcmd example.bat

## Run with CreateProcess() ##
$ wrun notepad example.txt

## Run with cmd /C start ##
$ wstart example.txt

## Kill outbash.exe ##
$ wrun taskkill /f /im outbash.exe
```

More details: https://github.com/xilun/cbwin

mintty tips: https://github.com/mintty/mintty/wiki/Tips

wslbridge usage: https://github.com/rprichard/wslbridge

## Config

`etc/wsl-terminal.conf` is wsl-terminal config file.
```
[config]
title="        "
shell=bash
use_tmux=0
```

`etc/minttyrc` is mintty config file.

## Param

open-wsl.exe -a: activate an existing wsl-terminal window, if use_tmux=1, attach the running tmux session.

## Known issues

[Sometimes tmux hangs.](https://github.com/goreliu/wsl-terminal/issues/1)

## Build

Run `build.bat`, make sure wget/tar/xz/gzip/unzip/p7zip are installed in WSL.

## License

[Cygwin DLL](https://www.cygwin.com/): https://cygwin.com/licensing.html

[mintty](http://mintty.github.io/): GPLv3+

[wslbridge](https://github.com/rprichard/wslbridge): MIT

[cbwin](https://github.com/xilun/cbwin): MIT

[wsl-terminal](https://github.com/goreliu/wsl-terminal): MIT
