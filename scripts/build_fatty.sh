#!/bin/bash
#this will run in WSL environment
set -e


if [[ ! -d fatty_build ]]; then
    mkdir fatty_build
fi

cd fatty_build

if [[ ! -d fatty ]]; then
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
