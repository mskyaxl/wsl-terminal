# wsl-terminal

wsl-terminal is a terminal emulator for Windows Subsystem for Linux (WSL), contains [Cygwin DLL](https://www.cygwin.com/), [mintty](http://mintty.github.io/), [wslbridge](https://github.com/rprichard/wslbridge), [cbwin](https://github.com/xilun/cbwin), and some useful tools.

## Usage

Run `open-wsl.exe` to open a WSL terminal in current directory.

Add a `Open wsl here` context menu to explorer.exe, modify path of `open-wsl.exe` in `doc/wsl-terminal/open-wsl-here (modify path first).reg`, and then run it.

```
Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\Directory\Background\shell\open-wsl]
@="Open wsl here"

[HKEY_CLASSES_ROOT\Directory\Background\shell\open-wsl\command]
@="c:\\path\\to\\wsl-terminal\\open-wsl.exe"

[HKEY_CLASSES_ROOT\Folder\shell\open-wsl]
@="Open wsl here"

[HKEY_CLASSES_ROOT\Folder\shell\open-wsl\command]
@="c:\\path\\to\\wsl-terminal\\open-wsl.exe"
```

run-wsl-file.exe can run any .sh(and any others like .py/.pl/.php) script files in wsl-terminal, support `Open With` context menu in explorer.exe.

vim.exe can open any text file in vim(in wsl-terminal), support `Open With` context i menu in explorer.exe.

Run `outbash-daemon.js` to start a outbash.exe daemon, more about outbash.exe: https://github.com/xilun/cbwin

If no need of outbash.exe, run a sleep in background to avoid all WSL processes(include tmux) being killed, more details in `outbash-daemon.js`.

bin/{wrun/wstart/wcmd} are used to run Windows processes, usage: https://github.com/xilun/cbwin

wslbridge usage: https://github.com/rprichard/wslbridge

## Config

`etc\wsl-terminal.conf` is wsl-terminal config file.
```
[config]
title="        "
shell=bash
use_tmux=0
```

`etc/minttyrc` is mintty config file.

## Build

Run `build.bat`, make sure wget/tar/xz/gzip/unzip/zip are installed in WSL.

## License

[Cygwin DLL](https://www.cygwin.com/): https://cygwin.com/licensing.html

[mintty](http://mintty.github.io/): GPLv3+

[wslbridge](https://github.com/rprichard/wslbridge): MIT

[cbwin](https://github.com/xilun/cbwin): MIT

[wsl-terminal](https://github.com/goreliu/wsl-terminal): MIT
