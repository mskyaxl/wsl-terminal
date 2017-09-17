# wsl-terminal

A terminal emulator for Windows Subsystem for Linux (WSL), based on [mintty](http://mintty.github.io/) and [wslbridge](https://github.com/rprichard/wslbridge).

[中文页面](https://goreliu.github.io/wsl-terminal/README.zh_CN.html)

## Screenshot

![screenshot](https://raw.githubusercontent.com/wiki/goreliu/wsl-terminal/images/wsl-terminal-3.png)

More screenshots [here](https://github.com/goreliu/wsl-terminal/wiki/Screenshots).

## Usage

1. [Download here.](https://github.com/goreliu/wsl-terminal/releases)

2. Run `open-wsl.exe` to open a WSL terminal in current directory (need to be on a local NTFS volume, [more details](https://github.com/rprichard/wslbridge)).

3. Run `tools/1-add-open-wsl-terminal-here-menu.js` ([help](https://github.com/goreliu/wsl-terminal#tools)) to add a `Open wsl-terminal Here` context menu to `explorer.exe` (Run `tools/1-remove-open-wsl-terminal-here-menu.js` to remove it). If you are using Total Commander, [Use wsl-terminal with Total Commander](https://github.com/goreliu/wsl-terminal/wiki/Use-wsl-terminal-with-Total-Commander) may help you.

4. `run-wsl-file.exe` can run any `.sh` (and any others like `.py/.pl/.php`) script files in wsl-terminal, support `Open With` context menu in explorer.exe.

5. `vim.exe` can open any files with vim (in wsl-terminal), support `Open With` context menu in explorer.exe. `vim.exe` can be renamed to `emacs.exe/nvim.exe/nano.exe/less.exe/...` to open files in `emacs/nvim/nano/less/...`.

## Keyboard shortcuts

`Alt + Enter`: Fullscreen

`Alt + F2`: New window

`Alt + F3`: Search text

`Ctrl + [Shift] + Tab`: Switch window

`Ctrl + =+/-/0`: Zoom

`Ctrl + Click`: Open URL or dir/file under the cursor

## Params

### open-wsl

```
Usage: open-wsl [OPTION]...
  -a: activate an existing wsl-terminal window.
      if use_tmux=1, attach the running tmux session.
  -l: start terminal in your home directory (doesn't work with tmux).
  -c "command": run command.
  -C dir: change directory to dir.
  -d distro: switch distros.
  -b "options": pass additional options to wslbridge.
  -h: show help.
```

### cmdtool

```
Usage: cmdtool [OPTION]...
  update: check the latest wsl-terminal version, and upgrade it.
  killall: kill all WSL processes.
  install cbwin: install cbwin.
```

See also [mintty params](https://github.com/goreliu/wsl-terminal/wiki/mintty-params) and [wslbridge params](https://github.com/rprichard/wslbridge#usage).

## Tools

`tools/1-add-open-wsl-terminal-here-menu.js`: Add `Open wsl-terminal Here` context menu to `explorer.exe`.

`tools/1-remove-open-wsl-terminal-here-menu.js`: Remove `Open wsl-terminal Here` context menu.

`tools/2-add-wsl-terminal-dir-to-path.js`: Add `wsl-terminal` directory to `Path` environment variable.

`tools/2-remove-wsl-terminal-dir-from-path.js`: Remove `wsl-terminal` directory from `Path` environment variable.

`tools/3-write-distro-guids-to-config-file.js`: Write distro guids to `etc/wsl-terminal.conf`.

`tools/4-create-start-menu-shortcut.js`: Create a start menu shortcut to `open-wsl -C ~`.

`tools/4-create-start-menu-shortcut-login-shell.js`: Create a start menu shortcut to `open-wsl -l`.

`tools/4-remove-all-start-menu-shortcuts.js`: Remove all wsl-terminal start menu shortcuts.

Double click any `.js` files to run it. If it was open by any editor, open it with `Microsoft (R) Windows Based Script Host`, or open a `cmd.exe` in `tools` directory and run `wscript xxx.js`.

## Configuration files

`etc/wsl-terminal.conf` is wsl-terminal config file.
```
[config]
title="my title"
shell=bash
use_tmux=0
;icon=
;distro_guid=
```

`etc/themes/*` are theme files, [use themes](https://github.com/goreliu/wsl-terminal/wiki/Use-themes).

`etc/minttyrc` is mintty config file, [mintty tips](https://github.com/mintty/mintty/wiki/Tips).

## Upgrade

Open `open-wsl.exe` in `wsl-terminal` directory, run `./cmdtool update` to check the latest wsl-terminal version and upgrade it. If the download speed is too slow, you can download `wsl-terminal-v{version}.7z` from [releases](https://github.com/goreliu/wsl-terminal/releases) with other tools, and put it into `wsl-terminal` directory, then run `./cmdtool update`.

`wget` and `7z` commands are needed (Ubuntu: `apt install wget p7zip-full`, Archlinux: `pacman -S wget p7zip`) .

Config files won't be overridden, `etc/wsl-terminal.conf` and `etc/minttyrc` will be placed to `etc/wsl-terminal.conf.pacnew` and `etc/minttyrc.pacnew`. Some `.bak` files will be left in `bin`, because they are running, those files will be removed after the next upgrading.

## Use tmux

1. Install tmux in WSL.
2. Set `use_tmux=1` in `etc/wsl-terminal.conf`. And set `attach_tmux_locally=1` if the version number is less than `0.8.1`.
3. Add these lines to `~/.bashrc` (`shell=bash` in config) or `~/.zshrc` (`shell=zsh` in config):

```
[[ -z "$TMUX" && -n "$USE_TMUX" ]] && {
    [[ -n "$ATTACH_ONLY" ]] && {
        tmux a 2>/dev/null || {
            cd && exec tmux
        }
        exit
    }

    tmux new-window -c "$PWD" 2>/dev/null && exec tmux a
    exec tmux
}
```

Then `open-wsl` will use tmux.

## Switch distros

Use `open-wsl -d distro` to switch distros:

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

Or set `distro_guid` in wsl-terminal.conf (Won't change the default distro).

Run `tools/3-write-distro-guids-to-config-file.js` ([help](https://github.com/goreliu/wsl-terminal#tools)), then a msgbox will show the result:

```
result has been written to ..\etc\wsl-terminal.conf:

; Legacy
;distro_guid={12345678-1234-5678-0123-456789abcdef}

; Ubuntu
;distro_guid={47a89313-4300-4678-96ae-e53c41a79e03}

remove the ; before distro_guid to use the distro.
```

If you want to pass the distro_guid to open-wsl in cmdline:

```
# pass the distro guid to wslbridge
> open-wsl -b "--distro-guid {47a89313-4300-4678-96ae-e53c41a79e03}"
```

## Links

[FAQ](https://github.com/goreliu/wsl-terminal/wiki/FAQ)

[TODO](https://github.com/goreliu/wsl-terminal/wiki/TODO)

## Build

Make sure `wget/tar/xz/gzip/p7zip` (Ubuntu: run `apt install wget tar xz-utils gzip p7zip-full`, Archlinux: run `pacman -S wget tar xz gzip p7zip`) are installed in WSL.

Run `build.bat`.

## License

MIT
