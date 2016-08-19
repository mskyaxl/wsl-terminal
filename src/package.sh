#!/bin/bash

version="0.1"

rm -rf wsl-terminal && mkdir -p wsl-terminal && cd wsl-terminal
cp -r ../build/{bin,doc,etc} .
cp ../*.exe ../*.js ../*.reg ../../LICENSE ../../README.md .

cd ..
zip -r ../wsl-terminal-${version}.zip wsl-terminal
