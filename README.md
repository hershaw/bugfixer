# bugfixer

Automatically fix simple bugs using LLMs. It's pretty cool.

Be sure to set your repository action permissins: https://github.com/peter-evans/create-pull-request#workflow-permissions
And create the OPENAI_API_KEY repository secret.


Create an issue in your repo with the following format:

```
## Relevant files

- script.py
- run_image_resizer.sh

## Bug description

In script.py the trailing slash on the s3 bucket should be stripped
before anything is uploaded. That way we can avoid paths such as
s3://example-bucket/hello//image.JPG.

## Proposed fix

In script.py, when processing the s3 url, strip out a trailing slash
as early as possible in the script.
```

Then use the action like this to fix bugs and make a PR:

```
on:
  issues:
    types:
      - opened

jobs:
  bugfixer:
    runs-on: ubuntu-latest
    name: Use AI to fix simple bugs and make a PR
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Inputs
        run: echo "${{ github.event.issue.body }}"
      - name: Bugfixer
        id: bugfixer
        uses: hershaw/bugfixer@v38
        with:
          issue_md: ${{ github.event.issue.body }}
          openai_api_key:  ${{ secrets.openai_api_key }}
      - name: Create Pull Request
        uses: peter-evans/create-pull-request@v5
        with:
          title: "Bugfixer for Issue ${{ github.event.issue.number }}: ${{ github.event.issue.title }}"
          branch: "bugfixer/${{ github.event.issue.number }}"
```

## Architecture

This project consists of a Dockerfile and a Python script. The Dockerfile creates a container with Python 3.11 and installs all necessary dependencies. The Python script, bugfixer.py, uses OpenAI's GPT-3.5-turbo model to automatically fix bugs in files relevant to the issue at hand.

## Deployment

To use this action, create a new issue in your repository with a description of the bug and relevant files. Be sure to use the correct format specified in the README. Once the issue is created, this action will automatically run and create a pull request with the fixed code.
