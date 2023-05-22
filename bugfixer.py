import json

from langchain.chat_models import ChatOpenAI
from langchain.schema import (
    # AIMessage,
    HumanMessage,
    SystemMessage
)


SYSTEM_MESSAGE = """
You are a helpful AI assistant that debugs code and produces
the fixed code in a JSON output. You try to keep your
solutions as simple as possible while still fixing the bug.

All of your responses will be fed directly into python's
json.parse() so ensure that your responses allow for this
without raising an error.
"""


MODEL_NAME = 'gpt-3.5-turbo'


def _call_llm(llm: ChatOpenAI, message: str):
    return llm.predict_messages([
        SystemMessage(content=SYSTEM_MESSAGE),
        HumanMessage(content=message),
    ])


def get_file_contents(llm: ChatOpenAI, issue_md: str, prefix: str):
    prompt = f"""
    {issue_md}
    ==================
    Given the above bug ticket, output a JSON list of strings
    that represents the filepaths to all relevant files mentioned
    in the format of:

    ["<insert file path 1>", "<insert file path 2>", "..."]
    """
    file_list = json.loads(_call_llm(llm, prompt).content)
    contents = {}
    for filename in file_list:
        print('opening', filename)
        with open(f'{prefix}/{filename}') as f:
            contents[filename] = f.read()
    return contents


def fix_bugs(llm: ChatOpenAI, issue_md: str, file_contents: dict):

    file_contents_json = json.dumps(file_contents)

    prompt = f"""
Given the following JSON dictionary of file names and their respective
contents, each containing one or more bugs:

{file_contents_json}

And the following natural language hints written in markdown about the
nature of the bugs in each file:

=================================Begin hints
{issue_md}
=================================End hints

Please use your programming knowledge and the provided hints to fix the bugs in
each file. Then return a JSON dictionary with the same format, where each files
contents has been corrected. Ensure that the result is safe for JSON
parsing/dumping.
"""
    print(prompt)
    output = _call_llm(llm, prompt).content

    print('Response ===============================')
    print(output)
    print('End response ===============================')

    return json.loads(output)


def main(issue_md):
    llm = ChatOpenAI(model_name=MODEL_NAME)
    file_contents = get_file_contents(llm, issue_md, '.')
    fixed_bugs = fix_bugs(llm, issue_md, file_contents)
    for filepath, fixed_contents in fixed_bugs.items():
        print('fixing', filepath)
        print(fixed_contents)
        with open(filepath, 'w') as fh:
            fh.write(fixed_contents)


if __name__ == '__main__':
    with open('/tmp/input.md') as f:
        issue_md = f.read()
    main(issue_md)
