---
name: create-snippet
description: Creates a new snippet file and registers it in snippets.toml. Use when asked to create a snippet, add a snippet, or make a new snippet.
---

# Create snippet

Before creating, read:

- `standards/snippets.md`: authoring conventions, invocation channels, use patterns

## Steps

1. Confirm the slug and full content with the user before writing
2. Write the file to `snippets/<slug>.md`
3. Register the slug in `snippets.toml` under the correct category

## Guards

- If `standards/snippets.md` is not present, stop: `❌ standards/snippets.md not found. Run aitk standards install first.`
- If `snippets/` does not exist, stop: `❌ No snippets/ directory found.`
