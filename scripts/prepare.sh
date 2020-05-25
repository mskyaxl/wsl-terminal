#!/bin/bash

__blue="\033[01;34m"
__green="\033[01;32m"
__red="\033[01;31m"
__nc="\033[0m"

# set -e

cygwin_version="3.1.5-1"
mintty_version="3.1.6-1"
wslbridge2_version="0.5"
openMoji_version="12.3.0"


prepare_cygwin()
{
    printf "preparing cygwin..."
    wget -nc http://mirrors.kernel.org/sourceware/cygwin/x86_64/release/cygwin/cygwin-${cygwin_version}.tar.xz > /dev/null 2>&1

    tar -xvf cygwin-${cygwin_version}.tar.xz \
        usr/bin/cygwin1.dll \
        usr/bin/cygwin-console-helper.exe \
        usr/share/doc/Cygwin > /dev/null 2>&1
    mkdir -p bin
    mkdir -p doc
    mv usr/bin/* bin/ 
    mv usr/share/doc/* doc/
    rm -rf usr
    printf "${__green}✔${__nc}\n"
}

prepare_mintty()
{
    printf "preparing mintty..."
    wget -nc http://mirrors.kernel.org/sourceware/cygwin/x86_64/release/mintty/mintty-${mintty_version}.tar.xz > /dev/null 2>&1
    tar -xvf mintty-${mintty_version}.tar.xz usr/bin/mintty.exe usr/share/doc usr/share/mintty/lang > /dev/null 2>&1
    mkdir -p bin
    mkdir -p doc
    mv usr/bin/* bin/
    mv usr/share/doc/* doc/
    mkdir -p etc
    mv usr/share/mintty/lang etc -f
    rm -rf usr
    printf "${__green}✔${__nc}\n"
}

prepare_openMoji()
{
    printf "preparing openMoji..."
    wget -nc https://github.com/hfg-gmuend/openmoji/releases/download/${openMoji_version}/openmoji-72x72-color.zip > /dev/null 2>&1
    mkdir -p etc/emojis/openmoji
    7z x -y openmoji-72x72-color.zip -oetc/emojis/openmoji > /dev/null 2>&1

    mkdir -p doc/openmoji
    wget -nc https://raw.githubusercontent.com/hfg-gmuend/openmoji/master/LICENSE.txt -Odoc/openmoji/LICENSE.txt > /dev/null 2>&1
    printf "${__green}✔${__nc}\n"
}

prepare_fatty()
{
    printf "preparing prepare_fatty..."
    ../scripts/build_fatty.sh > /dev/null 2>&1
    7z x -y fatty-*.7z fatty/bin/{fatty.exe,cyggcc_s-seh-1.dll,cygstdc++-6.dll} fatty/doc fatty/etc/lang > /dev/null 2>&1
    printf "${__green}✔${__nc}\n"
}

prepare_wslBridge2()
{
    printf "preparing wslbridge..."
    wget -nc https://github.com/Biswa96/wslbridge2/releases/download/v${wslbridge2_version}/wslbridge2_cygwin_x86_64.7z > /dev/null 2>&1
    7z x -y wslbridge2_cygwin_x86_64.7z -obin > /dev/null 2>&1
    rm bin/rawpty.exe
    mkdir -p doc/wslbridge2
    wget -nc https://raw.githubusercontent.com/Biswa96/wslbridge2/v${wslbridge2_version}/LICENSE -Odoc/wslbridge2/LICENSE > /dev/null 2>&1
    printf "${__green}✔${__nc}\n"
}

prepare_ahk()
{
    printf "preparing autohotkey..."
    wget -nc https://autohotkey.com/download/ahk.zip > /dev/null 2>&1
    rm -rf ahk && mkdir ahk && cd ahk
    7z x -y ../ahk.zip > /dev/null 2>&1
    cd ..
    printf "${__green}✔${__nc}\n"
}


prepare_wsl_tabbed=0
prepare_wsl=1
current_path="$(pwd)"
scriptpath="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd ${scriptpath}
while getopts "hta" opt; do
  case ${opt} in

    h )
        usage;
        exit 0
      ;;
    t )
        prepare_wsl_tabbed=1
        prepare_wsl=0
      ;;
    a )
        prepare_wsl_tabbed=1
        prepare_wsl=1
     ;;
    \? )
      echo "Invalid Option: -$OPTARG" 1>&2
      exit 1
      ;;
  esac
done

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

cd ..
mkdir -p build && cd build

rm -rf bin etc usr doc

prepare_cygwin;


if [ $prepare_wsl -eq "1" ]; then
    prepare_mintty;
    prepare_openMoji;
fi

if [ $prepare_wsl_tabbed -eq "1" ]; then
    prepare_fatty;
fi

prepare_wslBridge2;

cp -r ../src/etc .

prepare_ahk;
mkdir -p doc
cat > "doc/wsl-terminal home.url" <<EOF
[InternetShortcut]
URL=https://mskyaxl.github.io/wsl-terminal/
EOF

cd $current_path