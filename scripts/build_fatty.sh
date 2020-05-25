#!/bin/bash
#this will run in WSL environment
set -e

current_path="$(pwd)"
scriptpath="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $scriptpath
cd ..

mkdir -p build/fatty_build && cd build/fatty_build

if [ ! -d fatty ]; then
  git clone --depth 1 https://github.com/paolo-sz/fatty.git
fi

cd fatty
#remove any links as cygwin cannot handle links properly
for link in $(find src/ -type l)
do
  loc="$(dirname "$link")"
  file="$(readlink "$link")"
  rm $link
  cp "src/$file" "$loc"
done
pwd
#build using cygwin
/mnt/c/cygwin64/bin/bash.exe -c ../../../scripts/compile_fatty.sh

version=$(printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"-1)
rm -f ../../fatty-$version.7z
7z a ../../fatty-$version.7z fatty

cd $current_path