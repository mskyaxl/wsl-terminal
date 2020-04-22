#!/bin/bash
set -e


./prepare.sh &&
../build/ahk/Compiler/Ahk2Exe.exe /in ../src/open-wsl.ahk /out ../build/open-wsl.exe /icon ../icons/terminal.ico &&
../build/ahk/Compiler/Ahk2Exe.exe /in ../src/open-wsl.ahk /out ../build/run-wsl-file.exe /icon ../icons/script.ico && 
../build/ahk/Compiler/Ahk2Exe.exe /in ../src/open-wsl.ahk /out ../build/vim.exe /icon ../icons/text.ico &&
../build/ahk/Compiler/Ahk2Exe.exe /in ../src/open-wsl.ahk /out ../build/emacs.exe /icon ../icons/text.ico &&
./package.sh && 
echo Build succeeded. && 
exit

echo Build failed. && 
echo failed
exit 1
