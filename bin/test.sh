#!/bin/bash

if [[ -z "${OPENAI_API_KEY}" ]]; then
    echo "The environment variable OPENAI_API_KEY is not set. Exiting."
    exit 1
fi

docker build -t bugfixer .

docker run -it --rm \
    -e "OPENAI_API_KEY=$OPENAI_API_KEY" \
    -v $PWD/example/bugfix-issue.md:/input.md:ro \
    -v $PWD/example/:/example/:rw \
    bugfixer python workdir/bugfixer.py
