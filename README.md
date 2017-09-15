# wsl-terminal

A terminal emulator for Windows Subsystem for Linux (WSL), includes [mintty](http://mintty.github.io/), [wslbridge](https://github.com/rprichard/wslbridge), [cbwin](https://github.com/xilun/cbwin), and some other useful tools.

## Screenshot

![screenshot](https://raw.githubusercontent.com/wiki/goreliu/wsl-terminal/images/wsl-terminal-3.png)

[More screenshots.](https://github.com/goreliu/wsl-terminal/wiki/Screenshots)

## Usage

1. [Download here.](https://github.com/goreliu/wsl-terminal/releases)

2. Run `open-wsl.exe` to open a WSL terminal in current directory (need to be on a local NTFS volume, [more details](https://github.com/rprichard/wslbridge)).

3. Run `tools/add-open-wsl-here-menu.js` to add a `Open WSL Here` context menu to explorer.exe (run `tools/remove-open-wsl-here-menu.js` to remove it). If you are using Total Commander, read [Use wsl-terminal with Total Commander](https://github.com/goreliu/wsl-terminal/wiki/Use-wsl-terminal-with-Total-Commander).

4. `run-wsl-file.exe` can run any .sh (and any others like .py/.pl/.php) script files in wsl-terminal, support `Open With` context menu in explorer.exe.

5. `vim.exe` can open any text files in vim (in wsl-terminal), support `Open With` context menu in explorer.exe. `vim.exe` can be renamed to `emacs.exe/nvim.exe/nano.exe/...` to open files in `emacs/nvim/nano/...`.

## Configuration files

`etc/wsl-terminal.conf` is wsl-terminal config file.
```
[config]
title="        "
shell=bash
use_cbwin=0
use_tmux=0
```

`usr/share/mintty/themes/` are theme files, [use themes](https://github.com/goreliu/wsl-terminal/wiki/Use-themes).

`etc/minttyrc` is mintty config file, [mintty tips](https://github.com/mintty/mintty/wiki/Tips).

## Keyboard shortcuts

`Alt + Enter`: Fullscreen

`Alt + F2`: New window

`Alt + F3`: Search text

`Ctrl + [Shift] + Tab`: Switch window

`Ctrl + =+/-/0`: Zoom

`Ctrl + Click`: Open URL or dir/file under the cursor

## Params

```
Usage: open-wsl [OPTION]...
  -a: activate an existing wsl-terminal window, if use_tmux=1, attach the running tmux session.
  -l: start terminal in your home directory (doesn't work with tmux).
  -C dir: change directory to dir.
  -d distribution: switch distribution.
  -h: show help.
```

[mintty params.](https://github.com/goreliu/wsl-terminal/wiki/mintty-params)

[wslbridge params.](https://github.com/rprichard/wslbridge#usage)

## Switch distro

Use `wslconfig` in `cmd.exe` to switch distro (Build 16273).

```
> wslconfig /?
Performs administrative operations on Windows Subsystem for Linux

Usage:
    /l, /list [/all] - Lists registered distributions.
        /all - Optionally list all distributions, including distributions that
               are currently being installed or uninstalled.
    /s, /setdefault <DistributionName> - Sets the specified distribution as the default.
    /u, /unregister <DistributionName> - Unregisters a distribution.


> wslconfig /l
Legacy (Default)
Ubuntu

> wslconfig /s Ubuntu

> wslconfig /l
Ubuntu (Default)
Legacy
```

## Known issues

[FAQ](https://github.com/goreliu/wsl-terminal/wiki/FAQ)

## Build

Run `build.bat`, make sure wget/tar/xz-utils/gzip/p7zip-full (apt install wget tar xz-utils gzip p7zip-full) are installed in WSL.

## License

[Cygwin DLL](https://www.cygwin.com/): https://cygwin.com/licensing.html

[mintty](http://mintty.github.io/): GPLv3+

[wslbridge](https://github.com/rprichard/wslbridge): MIT

[cbwin](https://github.com/xilun/cbwin): MIT

[wsl-terminal](https://github.com/goreliu/wsl-terminal): MIT
