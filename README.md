# bugfixer

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
        uses: hershaw/bugfixer@v24
        with:
          issue_md: ${{ github.event.issue.body }}
          openai_api_key:  ${{ secrets.openai_api_key }}
      - name: Create Pull Request
        uses: peter-evans/create-pull-request@v5
```
