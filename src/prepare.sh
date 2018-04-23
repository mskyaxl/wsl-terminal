#!/bin/bash

set -e

cygwin_version="2.10.0-1"
mintty_version="2.8.5-0"
fatty_version="r1842.4e91950-2"
wslbridge_version="0.2.4"

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
wget -nc https://github.com/rprichard/wslbridge/releases/download/${wslbridge_version}/wslbridge-${wslbridge_version}-cygwin64.tar.gz
wget -nc https://autohotkey.com/download/ahk.zip

rm -rf bin etc usr doc

tar -xvf cygwin-${cygwin_version}.tar.xz \
    usr/bin/cygwin1.dll \
    usr/bin/cygwin-console-helper.exe \
    usr/share/doc/Cygwin

tar -xvf mintty-${mintty_version}.tar.xz usr/bin/mintty.exe usr/share/doc usr/share/mintty/lang
7z x -y fatty-${fatty_version}.7z fatty/bin/{fatty.exe,cyggcc_s-seh-1.dll,cygstdc++-6.dll} fatty/doc fatty/etc/lang

tar -xvf wslbridge-${wslbridge_version}-cygwin64.tar.gz
cd wslbridge-${wslbridge_version}-cygwin64
mv wslbridge.exe wslbridge-backend ../usr/bin
mkdir -p ../usr/share/doc/wslbridge
mv BuildInfo.txt LICENSE.txt README.md ../usr/share/doc/wslbridge
cd ..
rmdir wslbridge-${wslbridge_version}-cygwin64

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
