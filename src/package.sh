#!/bin/bash

version="0.2.1"

set -e

rm -rf wsl-terminal && mkdir -p wsl-terminal && cd wsl-terminal
cp -r ../build/{bin,etc} .
cp -r ../*.exe ../*.js ../tools ../../LICENSE ../../README.md .

cd ..
7z a ../wsl-terminal-${version}.7z wsl-terminal

cp *.ahk wsl-terminal
rm -rf ../output && mv wsl-terminal ../output
