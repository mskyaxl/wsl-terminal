@set PATH=%PATH%;c:\windows\Sysnative

@wsl sed -i "s|^shell=.*$|shell=$(getent passwd $(id -un) | awk -F : '{print $NF}')\r|g" ../etc/wsl-terminal.conf
@wsl grep "^shell=" ../etc/wsl-terminal.conf

pause
