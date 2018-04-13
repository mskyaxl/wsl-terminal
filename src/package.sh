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

rm -rf ../output && mv wsl-terminal ../output
