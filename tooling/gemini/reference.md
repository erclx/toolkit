# Tooling Gemini reference

## Overview

The gemini stack seeds `.gemini/settings.json` with a baseline model config into a project.

## Settings

- Config: `.gemini/settings.json` at root.
- Model: `gemini-2.5-flash` (default seed, user-owned after init).
- Gitignored — local override, never commit.

## GEMINI.md

The seed drops a `GEMINI.md` at the project root. Gemini CLI reads this file automatically as context for every session.

The template includes:

- `# Project`: one-line description of the repo
- `## Key paths`: key directories and their purpose
- `## Behavior`: two rules that ground command execution:
  - For any command that produces a FINAL COMMAND block, always show PREVIEW first
  - On short affirmation or clear intent to proceed, execute the FINAL COMMAND immediately without re-explaining or re-previewing

Fill in the project description and key paths after seeding. The behavior section is pre-populated and should not be modified.

## Gitignore

- `# Gemini` — `.gemini/.tmp/`, `.gemini/settings.json`
