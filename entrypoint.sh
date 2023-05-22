#!/bin/sh -l

echo "============================="
echo $1
echo "============================="

echo $1 > ./input.json

python /workdir/bugfixer.py
