#!/bin/bash
set -e

usage() {
      echo "Usage:"
      echo "    build.sh -h                 Display this help message."
      echo "    build.sh -a                 Builds wsl-terminal and wsl-terminal-tabbed."
      echo "    build.sh -t                 Builds only wsl-terminal-tabbed(cygwin is required)."
      echo "    build.sh                    Builds only wsl-terminal."
}

arg=""
curent_path="$(pwd)"
scriptpath="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $scriptpath
while getopts "hta" opt; do
  case ${opt} in
    h )
        usage;
        exit 0
      ;;
    t | a )
      arg=$opt
      ;;
    \? )
      echo "Invalid Option: -$OPTARG" 1>&2
      exit 1
      ;;
  esac
done

./prepare.sh -$arg &&
../build/ahk/Compiler/Ahk2Exe.exe /in ../src/open-wsl.ahk /out ../build/open-wsl.exe /icon ../icons/terminal.ico &&
../build/ahk/Compiler/Ahk2Exe.exe /in ../src/open-wsl.ahk /out ../build/run-wsl-file.exe /icon ../icons/script.ico && 
../build/ahk/Compiler/Ahk2Exe.exe /in ../src/open-wsl.ahk /out ../build/vim.exe /icon ../icons/text.ico &&
../build/ahk/Compiler/Ahk2Exe.exe /in ../src/open-wsl.ahk /out ../build/emacs.exe /icon ../icons/text.ico &&
./package.sh -$arg && 
echo Build succeeded. && 
cd $current_path
exit

echo Build failed. && 
echo failed
cd $curent_path
exit 1
