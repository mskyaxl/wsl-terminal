set PATH=%PATH%;c:\windows\Sysnative

bash -c ./prepare.sh && ^
build\ahk\Compiler\Ahk2Exe.exe /in open-wsl.ahk /out open-wsl.exe /icon icons\terminal.ico && ^
build\ahk\Compiler\Ahk2Exe.exe /in open-wsl.ahk /out run-wsl-file.exe /icon icons\script.ico && ^
build\ahk\Compiler\Ahk2Exe.exe /in open-wsl.ahk /out vim.exe /icon icons\text.ico && ^
bash -c ./package.sh && ^
echo Build succeeded. && ^
exit

echo Build failed.
pause
exit 1
