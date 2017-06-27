#!/bin/bash

cygwin_version="2.8.0-1"
mintty_version="2.7.8-0"
wslbridge_version="0.2.2"
cbwin_version="0.13"

set -e

# wget tar xz gzip unzip p7zip

type wget >/dev/null && \
    type tar >/dev/null && \
    type xz >/dev/null && \
    type gzip >/dev/null && \
    type unzip >/dev/null && \
    type 7z >/dev/null || {
    echo "Error: please install tar/xz-utils/gzip/unzip/p7zip-full in WSL first."
    echo "Run 'apt install wget tar xz-utils gzip unzip p7zip-full' with root manually."
    exit 1
}

mkdir -p build && cd build

wget -nc http://mirrors.kernel.org/sourceware/cygwin/x86_64/release/cygwin/cygwin-${cygwin_version}.tar.xz
wget -nc http://mirrors.kernel.org/sourceware/cygwin/x86_64/release/mintty/mintty-${mintty_version}.tar.xz
wget -nc https://github.com/rprichard/wslbridge/releases/download/${wslbridge_version}/wslbridge-${wslbridge_version}-cygwin64.tar.gz
wget -nc https://github.com/xilun/cbwin/releases/download/v${cbwin_version}/cbwin-bin-${cbwin_version}.zip
wget -nc https://autohotkey.com/download/ahk.zip

rm -rf bin etc usr doc

tar -xvf cygwin-${cygwin_version}.tar.xz \
    usr/bin/cygwin1.dll \
    usr/bin/cygwin-console-helper.exe \
    usr/share/doc/Cygwin

tar -xvf mintty-${mintty_version}.tar.xz usr/bin/mintty.exe usr/share/doc

tar -xvf wslbridge-${wslbridge_version}-cygwin64.tar.gz
cd wslbridge-${wslbridge_version}-cygwin64
mv wslbridge.exe wslbridge-backend ../usr/bin
mkdir -p ../usr/share/doc/wslbridge
mv BuildInfo.txt LICENSE.txt README.md ../usr/share/doc/wslbridge
cd ..
rmdir wslbridge-${wslbridge_version}-cygwin64

unzip cbwin-bin-${cbwin_version}.zip
cd cbwin-bin-${cbwin_version}
mv outbash.exe wcmd wrun wstart ../usr/bin
mv install.sh ../usr/bin/install_cbwin.sh
mkdir -p ../usr/share/doc/cbwin
mv LICENSE README.md ../usr/share/doc/cbwin
cd ..
rmdir cbwin-bin-${cbwin_version}


cp -r ../etc .
rm -rf bin doc
mv usr/bin usr/share/doc .
rm -rf usr

rm -rf ahk && mkdir ahk && cd ahk
unzip ../ahk.zip
