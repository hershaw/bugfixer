#!/bin/sh -l

echo "============================="
echo $1
echo "============================="

echo $1 > ./input.md

python /workdir/bugfixer.py
