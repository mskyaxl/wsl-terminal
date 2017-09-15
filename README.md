# wsl-terminal

A terminal emulator for Windows Subsystem for Linux (WSL), includes [mintty](http://mintty.github.io/), [wslbridge](https://github.com/rprichard/wslbridge), [cbwin](https://github.com/xilun/cbwin), and some other useful tools.

## Screenshot

![screenshot](https://raw.githubusercontent.com/wiki/goreliu/wsl-terminal/images/wsl-terminal-3.png)

[More screenshots.](https://github.com/goreliu/wsl-terminal/wiki/Screenshots)

## Usage

1. [Download here.](https://github.com/goreliu/wsl-terminal/releases)

2. Run `open-wsl.exe` to open a WSL terminal in current directory (need to be on a local NTFS volume, [more details](https://github.com/rprichard/wslbridge)).

3. Run `tools/add-open-wsl-here-menu.js` to add a `Open WSL Here` context menu to explorer.exe (run `tools/remove-open-wsl-here-menu.js` to remove it). If you are using Total Commander, read [Use wsl-terminal with Total Commander](https://github.com/goreliu/wsl-terminal/wiki/Use-wsl-terminal-with-Total-Commander).

4. `run-wsl-file.exe` can run any `.sh` (and any others like `.py/.pl/.php`) script files in wsl-terminal, support `Open With` context menu in explorer.exe.

5. `vim.exe` can open any files in vim (in wsl-terminal), support `Open With` context menu in explorer.exe. `vim.exe` can be renamed to `emacs.exe/nvim.exe/nano.exe/less.exe/...` to open files in `emacs/nvim/nano/less/...`.

## Configuration files

`etc/wsl-terminal.conf` is wsl-terminal config file.
```
[config]
title="        "
shell=bash
use_cbwin=0
use_tmux=0
;icon=
;distro_guid=
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
  -d distro: switch distros.
  -b "flags": pass additional flags to wslbridge.
  -h: show help.
```

See also [mintty params](https://github.com/goreliu/wsl-terminal/wiki/mintty-params) and [wslbridge params](https://github.com/rprichard/wslbridge#usage).

## Switch distros

Use `open-wsl -d distro` to switch distros (Windows 10 Build 16273).

```
# list all distros
> wslconfig /l
Legacy (Default)
Ubuntu

# use Ubuntu (will run wslconfig /s Ubuntu before mintty)
> open-wsl -d Ubuntu

# Ubuntu is the default distro now
> wslconfig /l
Ubuntu (Default)
Legacy
```

Or pass a distro guid to wslbridge.

```
# query distro guids
> reg query HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\

HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss
    DefaultUsername    REG_SZ    goreliu
    DefaultUid    REG_DWORD    0x3e8
    DefaultGid    REG_DWORD    0x3e8
    DefaultDistribution    REG_SZ    {12345678-1234-5678-0123-456789abcdef}

HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\{12345678-1234-5678-0123-456789abcdef}
HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\{47a89313-4300-4678-96ae-e53c41a79e03}

# show details of a guid
> reg query HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\{47a89313-4300-4678-96ae-e53c41a79e03}

HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\{47a89313-4300-4678-96ae-e53c41a79e03}
    State    REG_DWORD    0x1
    DistributionName    REG_SZ    Ubuntu
    Version    REG_DWORD    0x1
    BasePath    REG_SZ    C:\Users\goreliu\AppData\Local\Packages\CanonicalGroupLimited...
    PackageFamilyName    REG_SZ    CanonicalGroupLimited.UbuntuonWindows_79rhkp1fndgsc
    KernelCommandLine    REG_SZ    BOOT_IMAGE=/kernel init=/init ro
    DefaultUid    REG_DWORD    0x3e8
    Flags    REG_DWORD    0x7
    DefaultEnvironment    REG_MULTI_SZ    HOSTTYPE=x86_64\0LANG=en_US.UTF-8\0PATH=...

# pass the distro guid to wslbridge
> open-wsl -b "--distro-guid {47a89313-4300-4678-96ae-e53c41a79e03}"

# or set distro guid in etc/wsl-terminal.conf
distro_guid={47a89313-4300-4678-96ae-e53c41a79e03}
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
