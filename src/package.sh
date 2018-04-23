#!/bin/bash

set -e

[[ -e .debug ]] && {
    mkdir -p wsl-terminal
    cd wsl-terminal
    cp -r ../build/{bin,etc} .
    cp -r ../{*.exe,tools,cmdtool} ../../VERSION .
    exit
}

rm -rf wsl-terminal
mkdir -p wsl-terminal
cd wsl-terminal
cp -r ../build/{bin,etc,doc} .
cp -r ../{*.exe,tools,cmdtool} ../../VERSION .
cp -r ../../{LICENSE,README.md} doc/
rm -f ../*.exe
cd ..

version="$(cat ../VERSION)"

rm -f ../wsl-terminal-${version}.7z
7z a ../wsl-terminal-${version}.7z wsl-terminal
rm -f ../wsl-terminal-${version}.zip
7z a ../wsl-terminal-${version}.zip wsl-terminal

rm -rf ../output && cp -r wsl-terminal ../output

# fatty
cd wsl-terminal
cp ../build/fatty/bin/fatty.exe bin/mintty.exe
cp ../build/fatty/bin/*.dll bin/
cp -r ../build/fatty/doc/ doc/fatty
rm -r etc/lang
cp -r ../build/fatty/etc/lang etc/
rm -r doc/mintty
mv etc/minttyrc etc/fattyrc
cd ..

mv wsl-terminal wsl-terminal-tabbed

rm -f ../wsl-terminal-tabbed-${version}.7z
7z a ../wsl-terminal-tabbed-${version}.7z wsl-terminal-tabbed
rm -f ../wsl-terminal-tabbed-${version}.zip
7z a ../wsl-terminal-tabbed-${version}.zip wsl-terminal-tabbed

rm -r wsl-terminal-tabbed
