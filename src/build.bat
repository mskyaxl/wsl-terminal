set PATH=%PATH%;c:\windows\Sysnative

bash -c ./prepare.sh && ^
build\ahk2exe\Ahk2Exe.exe /in run-wsl-file.ahk /out run-wsl-file.exe /icon icons\script.ico && ^
build\ahk2exe\Ahk2Exe.exe /in open-wsl.ahk /out open-wsl.exe /icon icons\terminal.ico && ^
build\ahk2exe\Ahk2Exe.exe /in vim.ahk /out vim.exe /icon icons\text.ico && ^
bash -c ./package.sh && ^
echo Build succeeded. && ^
pause && ^
exit

echo Build failed.
pause
exit 1
