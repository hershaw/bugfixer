#!/bin/sh -l

echo "============================="
echo $1
echo "============================="

echo $1 > ./input.md

export OPENAI_API_KEY=$2

python /workdir/bugfixer.py
