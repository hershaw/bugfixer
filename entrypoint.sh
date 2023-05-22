#!/bin/sh -l

echo "============================="
echo $1
echo "============================="

echo $1 > input.json

python bugfixer.py
