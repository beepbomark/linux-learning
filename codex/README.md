# Codex CLI Quick Reference

A practical reference for using Codex in a software repository.

## Quick command index

```bash
codex                                  # Start Codex
codex --help                           # Show available commands and options
codex --version                        # Show the installed version
command -v codex                       # Show which executable is being used
codex mcp list                         # List configured MCP servers
codex mcp add NAME --url URL           # Add an MCP server
codex mcp --help                       # Show MCP command help
npm install -g @openai/codex@latest    # Update an npm installation
```

Always check `codex --help` because commands and options can change between versions.

## Install and update

For a Codex CLI installation managed with npm:

```bash
npm install -g @openai/codex@latest
codex --version
```

If the version does not change, open a new terminal and check which executable is being selected:

```bash
command -v codex
npm list -g --depth=0
```

Do not confuse the Codex CLI with the separate `openai` CLI for direct OpenAI API operations. Use the command that matches the task.

## Start, stop and restart

Start Codex from the repository you want it to work on:

```bash
cd /path/to/project
codex
```

To stop a running CLI session, press `Ctrl-C`. Start it again with `codex`.

After changing MCP, plugin, skill or project configuration, start a new Codex session so the updated tools and instructions are loaded. To restart the Codex desktop app, quit it completely and open it again.

## Work inside a repository

Codex is most useful when started from the correct project directory. Before asking for changes, check the repository state:

```bash
pwd
git status
```

Useful repository commands while working with Codex:

```bash
git diff                              # Review changes
find . -type f -name "*.md"           # Find documentation files
grep -R "pattern" .                  # Search repository text
```

For a complete Linux command reference, see [`Commands/`](../Commands/).

## Project instructions with `AGENTS.md`

Add an `AGENTS.md` file when a repository needs persistent instructions for Codex. It can describe the project, coding conventions, test commands, safety rules and files that should not be changed.

Example:

```markdown
# Project instructions

- Run `./test.sh` after code changes.
- Keep documentation in Markdown.
- Do not modify files under `vendor/`.
```

Keep instructions specific, short and testable. Codex should be able to follow them without guessing.

## Prompt patterns

Give Codex a clear task, scope and verification command:

```text
Inspect this repository and explain its structure. Do not edit files.
```

```text
Add input validation to the user creation function. Keep the existing API,
update the tests, and run the relevant test command.
```

```text
Review the current changes for bugs, security issues and missing tests.
Do not modify files; report findings with file names and line numbers.
```

Useful instructions include:

- `Read the relevant files first and explain your plan.`
- `Only change files under codex/.`
- `Make the smallest complete change.`
- `Run the tests and report the exact result.`
- `Do not modify files; give me a review only.`

## Safe workflow

1. Check the current state with `git status`.
2. Ask Codex to inspect the relevant files.
3. Describe one change at a time.
4. Review the result with `git diff`.
5. Run the relevant tests or checks.
6. Check `git status` again before committing.

Do not paste passwords, API keys or private tokens into prompts. Review commands before approving them, especially commands using `sudo`, deleting files, changing permissions, stopping processes or pushing to a remote.

## MCP servers

MCP servers provide Codex with additional tools or information. List the servers configured for the CLI:

```bash
codex mcp list
```

Add the public OpenAI Developer Docs server:

```bash
codex mcp add openaiDeveloperDocs --url https://developers.openai.com/mcp
```

Discover the options supported by the installed version:

```bash
codex mcp --help
codex mcp add --help
```

MCP configuration can also be kept in:

```text
~/.codex/config.toml
```

For servers that need credentials, use environment variables or a secret manager. Never commit tokens to a project or plugin file. After changing MCP configuration, start a new session and run `codex mcp list` again.

## Plugins and skills

Inside Codex, open the plugin browser with:

```text
/plugins
```

Review a plugin's purpose and permissions before installing it. Skills are reusable instructions; MCP servers expose tools or data; plugins can package skills and MCP configuration together.

Invoke an installed skill by its `$` name:

```text
$skill-creator Help me create a skill for checking Bash scripts.
```

If a plugin or skill is unavailable:

1. Confirm that it is installed.
2. Check the name and spelling.
3. Start a new Codex session.
4. Run `codex mcp list` if it depends on an MCP server.

## Configuration and troubleshooting

Useful locations and commands:

```text
~/.codex/config.toml     User-level Codex configuration
AGENTS.md                Repository or directory instructions
.agents/                 Project-scoped agent resources
.codex/                  Project-specific Codex resources
```

Basic diagnostic sequence:

```bash
command -v codex
codex --version
codex --help
codex mcp list
git status
```

When a tool is missing or behaves unexpectedly, check the executable path, the installed version, MCP configuration and project instructions. Then start a new session before testing again.

## Official references

- [Codex overview](https://developers.openai.com/learn/codex)
- [OpenAI Docs MCP](https://developers.openai.com/learn/docs-mcp)
- [Plugins and skills](https://developers.openai.com/learn/developers-codex-plugin)
- [Linux command references in this repository](../Commands/)
