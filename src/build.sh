#!/bin/bash

# Used by myself.

./prepare.sh &&
    wrun "build\ahk\Compiler\Ahk2Exe.exe /in run-wsl-file.ahk /out run-wsl-file.exe /icon icons\script.ico" &&
    wrun "build\ahk\Compiler\Ahk2Exe.exe /in open-wsl.ahk /out open-wsl.exe /icon icons\terminal.ico" &&
    wrun "build\ahk\Compiler\Ahk2Exe.exe /in vim.ahk /out vim.exe /icon icons\text.ico" &&
    ./package.sh &&
    echo Build succeeded. &&
    exit

echo Build failed.
exit 1
