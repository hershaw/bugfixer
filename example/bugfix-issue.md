
## Relevant files

- code/script.py
- bin/run.sh

## Bug description

In script.py the trailing slash on the s3 bucket should be stripped
before anything is uploaded. That way we can avoid paths such as
s3://example-bucket/hello//image.JPG.

## Proposed fix

In script.py, when processing the s3 url, strip out a trailing slash
as early as possible in the script.

