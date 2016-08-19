#!/bin/bash

version="0.1"

rm -rf wslterminal && mkdir -p wslterminal && cd wslterminal
mv ../build/{bin,doc,etc} .
mv ../*.exe .
cp ../*.js ../*.reg .

cd ..
zip -r wslterminal-${version}.zip wslterminal
rm -rf wslterminal
