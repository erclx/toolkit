# AI workflow reference

A concise reference for when to reach for which tool, organized by what you're trying to do.

> **Mental model:** Claude chat for planning and prompt generation. Claude Code for implementation and edits. Gemini CLI for deterministic git and release scripts.

## Documents

All planning docs live in `.claude/` at the project root.

```plaintext
.claude/
├── PLANNER.md       ← system prompt for planning sessions
├── REQUIREMENTS.md  ← goals, non-goals, MVP scope
├── ARCHITECTURE.md  ← technical design decisions
├── DESIGN.md        ← color, typography, spacing (UI projects)
├── WIREFRAMES.md    ← ASCII layout sketches (UI projects)
├── TASKS.md         ← persistent task tracker, source of truth
├── REVIEWER.md      ← system prompt for review fallback
└── IMPLEMENTER.md   ← context prompt for implementation sessions
```

Run `aitk claude init` to seed this structure in a new project.

## Scenarios

### New feature

Run `aitk claude prompt` to build the context payload. Work in Claude chat; it holds context across the whole feature so generation, fixes, and follow-ups stay in the same session.

- Generate code, apply it, run `bun run check`, fix failures, iterate until verify passes
- Run `/dev:review` when the implementation feels done; feed critical findings back into the same chat
- For UI work, ask Claude chat to generate edit prompts (it has file context) and paste into Claude Code. Writing the prompt yourself works too if it's simple enough.

When done: `/git:branch` → `/git:stage` → `/docs:sync` → `/git:commit` → `/git:pr`

### UI polish

Screenshot the component, open a Claude chat session, and describe the change. Claude chat generates an edit prompt with the relevant class names or structure tweaks. Paste it into Claude Code. You can also write the edit prompt yourself; Claude Code takes either.

### Quick fix

- Verify failure or isolated bug → continue in Claude chat (it has the implementation context)
- Design or planning conflict → escalate to a new Claude chat session with the relevant plan context
- Fast file edit (TASKS.md, config, renaming) → Claude Code directly, no chat needed

### Review

- Standard: `/dev:review` after the implementation is done
- Fallback (deeper review, fresh context): open a new Claude chat tab, paste `REVIEWER.md` + relevant code

## Feedback routing

```
verify fails  → Claude chat (it has implementation context)
design fails  → new Claude chat session (planning problem)
review finds  → Claude chat (same implementation session)
```

## Prompt generation

`aitk claude prompt` reads `PLANNER.md` and `IMPLEMENTER.md`, injects governance rules from `.cursor/rules/` and context docs, and writes `.tmp/PLANNER.md`, `.tmp/IMPLEMENTER.md`, `.tmp/REVIEWER.md`.

Run `aitk gov sync` first when switching stacks. Run `aitk gov build` to generate a standalone rules file at `.cursor/.tmp/rules.md` for pasting directly into any AI chat, or run `aitk gov install` to install rules for a stack into a target project.

## Gemini CLI commands

Deterministic scripts with zero AI tokens and zero variability.

| Command              | What it does                               |
| -------------------- | ------------------------------------------ |
| `/dev:review`        | Findings report from implementation output |
| `/dev:apply`         | Write files from AI response               |
| `/dev:comment`       | Add comments to source code                |
| `/docs:sync`         | Sync README and docs with codebase changes |
| `/git:branch`        | Generate branch name                       |
| `/git:stage`         | Group staged files for batch commits       |
| `/git:commit`        | Generate commit message                    |
| `/git:pr`            | Generate PR description                    |
| `/git:split`         | Split mixed commits into separate branches |
| `/release:changelog` | Generate changelog from commit history     |
