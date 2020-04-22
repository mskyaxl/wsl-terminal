#!/bin/bash
#this will run in cygwin environment
export PATH=/bin

make -j
strip src/fatty.exe

mkdir -p fatty/{bin,doc,etc/lang}
cp bin/fatty.exe fatty/bin
cp /bin/{cyggcc_s-seh-1.dll,cygstdc++-6.dll,cygwin-console-helper.exe,cygwin1.dll} fatty/bin
cp VERSION LICENSE* README.md fatty/doc
cp lang/*.po fatty/etc/lang
