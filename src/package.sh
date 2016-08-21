#!/bin/bash

version="0.3.1"

set -e

rm -rf wsl-terminal && mkdir -p wsl-terminal && cd wsl-terminal
cp -r ../build/{bin,etc,doc} .
cp -r ../*.exe ../*.js ../tools ../usr ../../LICENSE ../../README.md .

cd ..
rm -f ../wsl-terminal-${version}.7z
7z a ../wsl-terminal-${version}.7z wsl-terminal

cp *.ahk wsl-terminal
rm -rf ../output && mv wsl-terminal ../output
