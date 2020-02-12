#!/bin/bash

set -e

cygwin_version="3.1.2-1"
mintty_version="3.1.0-1"
fatty_version="r2549.ee7e4a1-1"
wslbridge2_version="0.5"

# wget tar xz gzip p7zip

type wget >/dev/null && \
    type tar >/dev/null && \
    type xz >/dev/null && \
    type gzip >/dev/null && \
    type 7z >/dev/null || {
    echo "Error: please install tar/xz-utils/gzip/p7zip-full in WSL first."
    echo "Run 'apt install wget tar xz-utils gzip p7zip-full' with root manually."
    exit 1
}

mkdir -p build && cd build

wget -nc http://mirrors.kernel.org/sourceware/cygwin/x86_64/release/cygwin/cygwin-${cygwin_version}.tar.xz
wget -nc http://mirrors.kernel.org/sourceware/cygwin/x86_64/release/mintty/mintty-${mintty_version}.tar.xz
wget -nc https://github.com/goreliu/fatty-prebuilds/releases/download/${fatty_version}/fatty-${fatty_version}.7z
wget -nc https://github.com/Biswa96/wslbridge2/releases/download/v${wslbridge2_version}/wslbridge2_cygwin_x86_64.7z
wget -nc https://autohotkey.com/download/ahk.zip

rm -rf bin etc usr doc

tar -xvf cygwin-${cygwin_version}.tar.xz \
    usr/bin/cygwin1.dll \
    usr/bin/cygwin-console-helper.exe \
    usr/share/doc/Cygwin

tar -xvf mintty-${mintty_version}.tar.xz usr/bin/mintty.exe usr/share/doc usr/share/mintty/lang
7z x -y fatty-${fatty_version}.7z fatty/bin/{fatty.exe,cyggcc_s-seh-1.dll,cygstdc++-6.dll} fatty/doc fatty/etc/lang


7z x -y wslbridge2_cygwin_x86_64.7z -ousr/bin
rm usr/bin/rawpty.exe
mkdir -p usr/share/doc/wslbridge2
wget -nc https://raw.githubusercontent.com/Biswa96/wslbridge2/v${wslbridge2_version}/LICENSE -Ousr/share/doc/wslbridge2/LICENSE

cp -r ../etc .
rm -rf bin doc
mv usr/bin usr/share/doc .
mv usr/share/mintty/lang etc/
rm -rf usr

rm -rf ahk && mkdir ahk && cd ahk
7z x -y ../ahk.zip
cd ..

cat > "doc/wsl-terminal home.url" <<EOF
[InternetShortcut]
URL=https://goreliu.github.io/wsl-terminal/
EOF
