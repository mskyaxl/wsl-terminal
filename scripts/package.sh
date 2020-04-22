#!/bin/bash

set -e

if [[ ! -d ../release ]]; then
    mkdir -p ../release
fi


cd ../build
[[ -e .debug ]] && {
    mkdir -p wsl-terminal
    cd wsl-terminal
    cp -r build/{bin,etc} .
    cp -r {*.exe,tools,cmdtool} ../../VERSION .
    exit
}

rm -rf wsl-terminal
mkdir -p wsl-terminal
cd wsl-terminal

cp -r ../{bin,etc,doc} .
cp -r ../../src/{tools,cmdtool} ../../VERSION  ../*.exe . 
cp -r ../../{LICENSE,README.md} doc/
rm -f ../*.exe
cd ..

version="$(cat ../VERSION)"
rm -f ../release/wsl-terminal-${version}.7z
7z a ../release/wsl-terminal-${version}.7z wsl-terminal
rm -f ../release/wsl-terminal-${version}.zip
7z a ../release/wsl-terminal-${version}.zip wsl-terminal

rm -rf ../output && cp -r wsl-terminal ../output

# fatty
cd wsl-terminal
cp ../fatty/bin/fatty.exe bin/mintty.exe
cp ../fatty/bin/*.dll bin/
cp -r ../fatty/doc/ doc/fatty
rm -r etc/lang
cp -r ../fatty/etc/lang etc/
rm -r doc/mintty
mv etc/minttyrc etc/fattyrc
echo "_tabbed" >> VERSION
cd ..

mv wsl-terminal wsl-terminal-tabbed

rm -f ../release/wsl-terminal-tabbed-${version}.7z
7z a ../release/wsl-terminal-tabbed-${version}.7z wsl-terminal-tabbed
rm -f ../release/wsl-terminal-tabbed-${version}.zip
7z a ../release/wsl-terminal-tabbed-${version}.zip wsl-terminal-tabbed

rm -r wsl-terminal-tabbed
