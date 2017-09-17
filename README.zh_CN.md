# wsl-terminal

用于 Windows Subsystem for Linux (WSL) 的终端模拟器，基于 [mintty](http://mintty.github.io/) 和 [wslbridge](https://github.com/rprichard/wslbridge)。

[英文页面](https://goreliu.github.io/wsl-terminal/)

## 截图

![screenshot](https://raw.githubusercontent.com/wiki/goreliu/wsl-terminal/images/wsl-terminal-3.png)

查看[更多截图](https://github.com/goreliu/wsl-terminal/wiki/Screenshots)。

## 用法

1. 从[这里](https://github.com/goreliu/wsl-terminal/releases)下载最新版本并解压。

2. 运行 `open-wsl.exe` 可以在当前打开一个 WSL 终端模拟器（当前目录需要在本地的 NTFS 分区上，[原因](https://github.com/rprichard/wslbridge)）。

3. 运行 `tools/1-add-open-wsl-terminal-here-menu.js` ([帮助](https://github.com/goreliu/wsl-terminal/blob/master/README.zh_CN.md#工具)) 来添加一个 `Open wsl-terminal Here` 右键菜单到资源管理器上 (运行 `tools/1-remove-open-wsl-terminal-here-menu.js` 可以将其删除）。 如果你使用 Total Commander, 可以参考 [Use wsl-terminal with Total Commander](https://github.com/goreliu/wsl-terminal/wiki/Use-wsl-terminal-with-Total-Commander) 。

4. `run-wsl-file.exe` 可以在 wsl-terminal 里运行任何 `.sh` （以及任何其他的可执行文件，比如 `.py/.pl/.php` 文件) 脚本文件，你可以在文件打开方式里设置使用它来打开文件。

5. `vim.exe` 可以使用 WSL 中的 vim 打开任何文件 (在 wsl-terminal 中)，支持在打开方式中配置。如果你使用其他编辑器，可以把 `vim.exe` 重命名成  `emacs.exe/nvim.exe/nano.exe/less.exe/...` 等等。

## 快捷键

`Alt + Enter`: 全屏

`Alt + F2`: 新建窗口

`Alt + F3`: 搜索文本

`Ctrl + [Shift] + Tab`: 切换窗口

`Ctrl + =+/-/0`: 缩放

`Ctrl + Click`: 打开光标处的文件、目录名或者网址

## 命令行参数

### open-wsl

```
用法: open-wsl [选项]...
  -a: 激活在运行的 wsl-terminal 窗口。
      如果 use_tmux=1，会 attach 到正在运行的 tmux 会话上。
  -l: 运行一个 login shell（如果 use_tmux=1 则失效）。
  -c "command": 运行 command 中的命令。
  -C dir: 进入到 dir 目录中，dir 是 WSL 中的目录。
  -d distro: 切换发行版。
  -b "options": 传递额外的选项给 wslbridge。
  -h: 显示帮助信息。
```

### cmdtool

```
用法: cmdtool [选项]...
  update: 检查更新，如果有更新可以直接升级。
  killall: 杀死所有的 WSL 进程。
  install cbwin: 安装 cbwin。
```

另外可以参考 [mintty 参数](https://github.com/goreliu/wsl-terminal/wiki/mintty-params) 和 [wslbridge 参数](https://github.com/rprichard/wslbridge#usage)。

## 工具

`tools/1-add-open-wsl-terminal-here-menu.js`: 添加 `Open wsl-terminal Here` 右键菜单到资源管理器上。

`tools/1-remove-open-wsl-terminal-here-menu.js`: 移除 `Open wsl-terminal Here` 右键菜单。

`tools/2-add-wsl-terminal-dir-to-path.js`: 将 `wsl-terminal` 目录添加到 `Path` 环境变量里。

`tools/2-remove-wsl-terminal-dir-from-path.js`: 从 `Path` 环境变量中移除 `wsl-terminal` 目录。

`tools/3-write-distro-guids-to-config-file.js`: 将所有发行版的 guid 写入到配置文件 `etc/wsl-terminal.conf` 中.

`tools/4-create-start-menu-shortcut.js`: 创建一个开始菜单快捷方式，指向 `open-wsl -C ~`。

`tools/4-create-start-menu-shortcut-login-shell.js`: 创建一个开始菜单快捷方式, 指向 `open-wsl -l`。

`tools/4-remove-all-start-menu-shortcuts.js`: 移除所有 wsl-terminal 的开始菜单快捷方式。

双击 `.js` 文件即可运行。如果 `.js` 文件被某个编辑器关联上了，可以用修改打开方式为 `Microsoft (R) Windows Based Script Host`，或者在 `tools ` 目录运行一个 `cmd.exe`，然后用 `wscript xxx.js` 运行对应文件。

## 配置文件

`etc/wsl-terminal.conf` 是 wsl-terminal 的配置文件：

```
[config]
title="my title"
shell=bash
use_tmux=0
;icon=
;distro_guid=
```

`etc/themes/` 目录下的是主题文件，[使用主题](https://github.com/goreliu/wsl-terminal/wiki/Use-themes)。

`etc/minttyrc` 是 mintty 的配置文件， [mintty 帮助](https://github.com/mintty/mintty/wiki/Tips)。

## 升级

在 `wsl-terminal` 里打开 `open-wsl.exe`，然后运行 `./cmdtool update`  可以检查 wsl-terminal 的最新版本然后升级。如果下载速度过慢，可以先使用其他方法从[发布页面](https://github.com/goreliu/wsl-terminal/releases)下载 `wsl-terminal-v{version}.7z` 文件，然后将其放入到 `wsl-terminal` 目录，然后运行 `./cmdtool update`。

该工具依赖 `wget` 和 `7z` 命令（安装方法。Ubuntu: `apt install wget p7zip-full`, Archlinux: `pacman -S wget p7zip`）。

升级过程不会覆盖配置文件，`etc/wsl-terminal.conf` 和 `etc/minttyrc` 会被放置到 `etc/wsl-terminal.conf.pacnew` 和 `etc/minttyrc.pacnew`。升级后 `bin` 目录会残余一些 `.bak` 文件，因为这些文件还在运行，不能被删除。下一次升级时，会将之前的 `.bak` 文件全部删除，你也可以等那些进程退出后手删除那些文件。

## 使用 tmux

1. 在 WSL 里安装 tmux。

2. 在 `etc/wsl-terminal.conf` 中设置 `use_tmux=1`。如果版本号低于 `0.8.1`，还需要添加 `attach_tmux_locally=1` 。

3. 添加如下代码到 `~/.bashrc`（如果配置的是 `shell=bash`）或者 `~/.zshrc`（如果配置的是 `shell=zsh`）：

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

然后 `open-wsl` 就会使用 tmux 了。

## 切换发行版

使用 `open-wsl -d distro` （在 `cmd.exe` 里运行）来切换发行版：

```
# 列出所有发行版
> wslconfig /l
Legacy (默认)
Ubuntu

# 使用 Ubuntu（会运行 wslconfig /s Ubuntu 然后打开 wsl-terminal）
> open-wsl -d Ubuntu

# Ubuntu 已经是默认的发行版了
> wslconfig /l
Ubuntu (默认)
Legacy
```

如果你不想修改默认的发行版，可以在 `etc/wsl-terminal.conf` 里设置 `distro_guid`：

运行 `tools/3-write-distro-guids-to-config-file.js`（[帮助](https://github.com/goreliu/wsl-terminal/blob/master/README.zh_CN.md#工具)），然后会有窗口弹出结果：

```
result has been written to ..\etc\wsl-terminal.conf:

; Legacy
;distro_guid={12345678-1234-5678-0123-456789abcdef}

; Ubuntu
;distro_guid={47a89313-4300-4678-96ae-e53c41a79e03}

remove the ; before distro_guid to use the distro.
```

可以去掉 distro_guid 前边的 ; 来使用对应的发行版。

如果你想通过命令行将 distro_guid 传递给 `open-wsl`：

```
# 将 distro guid 传递给 wslbridge
> open-wsl -b "--distro-guid {47a89313-4300-4678-96ae-e53c41a79e03}"
```

## 链接

[常见问题](https://github.com/goreliu/wsl-terminal/wiki/FAQ)

[开发计划](https://github.com/goreliu/wsl-terminal/wiki/TODO)

## 编译

确保已经在 WSL 里安装了这些 `wget/tar/xz/gzip/p7zip` (安装方法。Ubuntu: `apt install wget tar xz-utils gzip p7zip-full`, Archlinux: `pacman -S wget tar xz gzip p7zip`）。

运行 `build.bat`。

## 许可

MIT
