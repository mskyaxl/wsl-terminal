set PATH=%PATH%;c:\windows\Sysnative

bash -c ./prepare.sh
build\ahk2exe\Ahk2Exe.exe /in run-wsl-file.ahk /out run-wsl-file.exe /icon %LOCALAPPDATA%\lxss\bash.ico
build\ahk2exe\Ahk2Exe.exe /in open-wsl.ahk /out open-wsl.exe
build\ahk2exe\Ahk2Exe.exe /in vim.ahk /out vim.exe
bash -c ./package.sh

pause
