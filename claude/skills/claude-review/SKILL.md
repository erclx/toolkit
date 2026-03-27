---
name: claude-review
description: Reviews all changes since main using the project's reviewer role. Reads REVIEWER.md, CLAUDE.md, REQUIREMENTS.md, and ARCHITECTURE.md for context, then applies the reviewer role to the full diff and outputs a findings report. Use when asked to review changes, run a code review, or check the current branch. Invoke explicitly with /claude-review. Do NOT auto-trigger.
disable-model-invocation: true
---

# Claude review

## Guards

- If `.claude/REVIEWER.md` does not exist, stop: `❌ No REVIEWER.md found. Run \`aitk claude init\` to seed it.`
- If both `git diff --staged` and `git diff main` are empty, stop: `✅ No changes to review.`

## Step 1: read context

Read these in parallel from the project root, skipping any that do not exist:

- `.claude/REVIEWER.md`: reviewer role, severity model, and output format
- `CLAUDE.md`: project type, conventions, and commands
- `.claude/REQUIREMENTS.md`: feature scope and non-goals
- `.claude/ARCHITECTURE.md`: technical design decisions
- `.claude/GOV.md`: governance rules to check changes against

## Step 2: get the diff and changed files

Run these in parallel from the project root:

```bash
git diff --staged
```

```bash
git diff --staged --name-only
```

```bash
git diff main
```

```bash
git diff main --name-only
```

If `git diff --staged` is non-empty, use it as the diff scope and use the `--staged --name-only` list as the file list. Otherwise use `git diff main` and the `main --name-only` list.

## Step 3: read changed files

Read each file from the changed file list. Skip deleted files. Run reads in parallel.

## Step 4: review

Adopt the reviewer role defined in `.claude/REVIEWER.md`. Use `CLAUDE.md`, `REQUIREMENTS.md`, `ARCHITECTURE.md`, and `GOV.md` as project context to inform what is intentional vs problematic. Flag any changes that violate rules defined in `GOV.md`.

Apply the reviewer role to the full diff and the changed file contents. Output structured findings only. Follow the output format defined in `.claude/REVIEWER.md`. Do not fix, rewrite, or suggest refactors outside the scope of a finding.
