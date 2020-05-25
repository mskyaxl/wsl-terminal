#!/bin/bash

# set -e


__blue="\033[01;34m"
__green="\033[01;32m"
__red="\033[01;31m"
__nc="\033[0m"


pack_wsl_tabbed=0
pack_wsl=1

usage() {
      echo "Usage:"
      echo "    prepare.sh -h                 Display this help message."
      echo "    prepare.sh -a                 Prepares binaries for wsl-terminal and wsl-terminal-tabbed."
      echo "    prepare.sh -t                 Prepares binaries only for wsl-terminal-tabbed(cygwin needed)."
      echo "    prepare.sh                    Prepares binaries only for only wsl-terminal."
}

pack_wsl_terminal() {
    printf "creating wsl-terminal package..."
    cd wsl-terminal
    echo Emojis=openmoji > etc/minttyrc
    cd ..

    rm -f ../release/wsl-terminal-${version}.7z > /dev/null 2>&1
    7z a ../release/wsl-terminal-${version}.7z wsl-terminal > /dev/null 2>&1
    rm -f ../release/wsl-terminal-${version}.zip > /dev/null 2>&1
    7z a ../release/wsl-terminal-${version}.zip wsl-terminal > /dev/null 2>&1

    rm wsl-terminal/etc/minttyrc
    rm -r wsl-terminal/etc/lang
    rm -r wsl-terminal/doc/mintty
    rm -r wsl-terminal/etc/Emojis

    printf "${__green}✔${__nc}\n"
}

pack_wsl_terminal_tabbed()
{
    printf "creating wsl-terminal-tabbed package..."
    cd wsl-terminal
    cp ../fatty/bin/fatty.exe bin/mintty.exe
    cp ../fatty/bin/*.dll bin/
    cp -r ../fatty/doc/ doc/fatty
    cp -r ../fatty/etc/lang etc/
    cp ../../src/etc/minttyrc etc/fattyrc
    echo "_tabbed" >> VERSION
    cd ..

    mv wsl-terminal wsl-terminal-tabbed

    rm -f ../release/wsl-terminal-tabbed-${version}.7z > /dev/null 2>&1
    7z a ../release/wsl-terminal-tabbed-${version}.7z wsl-terminal-tabbed > /dev/null 2>&1
    rm -f ../release/wsl-terminal-tabbed-${version}.zip > /dev/null 2>&1
    7z a ../release/wsl-terminal-tabbed-${version}.zip wsl-terminal-tabbed > /dev/null 2>&1

    rm -r wsl-terminal-tabbed
    printf "${__green}✔${__nc}\n"
}

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
        pack_wsl_tabbed=1
        pack_wsl=0
      ;;
    a )
        pack_wsl_tabbed=1
        pack_wsl=1
     ;;
    \? )
      echo "Invalid Option: -$OPTARG" 1>&2
      exit 1
      ;;
  esac
done

mkdir -p ../release

cd ../build

version="$(cat ../VERSION)"

[ -e .debug ] && {
    mkdir -p wsl-terminal
    cd wsl-terminal
    cp -r build/{bin,etc} .
    cp -r {*.exe,tools,cmdtool} ../VERSION .
    exit
}

rm -rf wsl-terminal
mkdir -p wsl-terminal

cp -r {bin,etc,doc} wsl-terminal/
cp -r ../src/{tools,cmdtool} ../VERSION  *.exe wsl-terminal/ 
cp -r ../{LICENSE,README.md} wsl-terminal/doc/
rm -f *.exe

if [ $pack_wsl -eq "1" ]; then
    pack_wsl_terminal;
fi

# fatty
if [ $pack_wsl_tabbed -eq "1" ]; then
    pack_wsl_terminal_tabbed;
fi

cd $current_path