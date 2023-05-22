#!/bin/sh -l

echo "Hello $1"
time=$(date)
ls -latrh .
echo "time=$time" >> $GITHUB_OUTPUT