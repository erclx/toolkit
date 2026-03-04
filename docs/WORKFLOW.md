# Workflow Documents Reference

A concise overview of all documents in the dev workflow, with tool mappings.

> **Session note:** "Session start" = opening a new chat tab (new context window). New message in the same chat = no re-orientation needed. New chat tab = paste in this order: `SESSION.md` → `TASKS.md` → active feature context. Add `REQUIREMENTS.md` + `ARCHITECTURE.md` only when starting a brand new feature.

## File Location

All planning docs live in `.claude/` at the project root. Git tracked, part of the project, not throwaway notes.

> **Setup:** Run `aitk claude init` in a new project to interactively seed this structure.

```
.claude/
├── SESSION.md           ← session system prompt, paste first always
├── REQUIREMENTS.md      ← project goals, non-goals, MVP scope
├── ARCHITECTURE.md      ← technical design decisions and open questions
├── DESIGN.md            ← color, typography, spacing, and motion decisions
├── TASKS.md             ← persistent task tracker, source of truth for progress
└── REVIEW.md            ← review prompt template, copy-paste into fresh chat
```

## Documents

**`SESSION.md`** — System prompt for Claude. Defines role, sync format, output rules, and planning behavior. Paste first every session. Created once per project with Claude chat.

**`REQUIREMENTS.md`** — Project goals, non-goals, MVP scope, tech stack, and constraints. Created before any code with Claude chat.

**`ARCHITECTURE.md`** — Technical design decisions, folder structure, storage shape, and open risks. Created before any code with Claude chat.

**`DESIGN.md`** — Color tokens, typography, spacing, border, and motion decisions. Created before UI implementation with Claude chat.

**`TASKS.md`** — Persistent task tracker. Source of truth for what is in progress, up next, done, and blocked. Updated every session.

**`REVIEW.md`** — Prompt template for per-feature code review. Open it, copy the template, fill in task, plan, and code, paste into a fresh chat.

**`CHANGELOG.md`** — Release notes. Generated with `/release:changelog` after features are done.

## Core Implementation Loop

```
┌─────────────────────────────────────────────────────┐
│  SESSION START (new chat tab)                        │
│  1. SESSION.md           (always, paste first)       │
│  2. TASKS.md             (always)                    │
│  3. REQUIREMENTS.md +    (new feature only)          │
│     ARCHITECTURE.md                                  │
│  Tool: Claude chat                                   │
└──────────────────────┬──────────────────────────────┘
                       │ produces ASCII wireframes (UI features)
                       │ + feature plan + todo list in TASKS.md
                       ▼
┌─────────────────────────────────────────────────────┐
│  INSTALL DEPENDENCIES                                │
│  Run any bun add commands from the feature plan      │
│  Do this before pasting plan to Gemini               │
└──────────────────────┬──────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────┐
│  CODE GENERATION                                     │
│  Paste: master prompt + feature plan + source context│
│  Tool: Gemini pro chat                               │
│  → responds with plan restatement + complete files   │
└──────────────────────┬──────────────────────────────┘
                       │ copy full response
                       ▼
┌─────────────────────────────────────────────────────┐
│  REVIEW                                              │
│  aitk claude review                                  │
│  → reads clipboard + TASKS.md context               │
│  → writes .claude/.tmp/review.md                    │
│  Paste review.md into fresh Gemini chat              │
│  → findings report (critical / should-fix / minor)  │
└──────────────────────┬──────────────────────────────┘
                       │
          ┌────────────┴────────────┐
          │ findings                │ clean
          ▼                         ▼
┌──────────────────────┐  ┌────────────────────────────┐
│ Feed critical/        │  │  APPLY + VERIFY             │
│ should-fix back to    │  │  → /dev:apply               │
│ original Gemini       │  │  → bun run check            │
│ session → fix         │  └──────────────┬─────────────┘
│ Re-run review         │                 │
└──────────┬───────────┘                 │
           └──────────────┬──────────────┘
                          ▼
           ┌──────────────────────────────┐
           │  COMMIT                       │
           │  Mark todos done in TASKS.md  │
           │  → /git:commit                │
           │  → /git:pr                    │
           │  Next feature                 │
           └──────────────────────────────┘

Feedback routing rule:
  verify fails  → Gemini chat (code problem, it has context)
  design fails  → Claude chat (planning problem)
  review finds  → Gemini chat (same implementation session)

Note: Gemini CLI is a file writer only via /dev:apply.
      All planning stays in Claude chat.
      All code generation stays in Gemini pro chat.
      Run aitk gov sync before aitk claude prompt when switching stacks.
```

## Tool Mapping Summary

| Stage                  | Tool              | Command / Note                                                                        |
| ---------------------- | ----------------- | ------------------------------------------------------------------------------------- |
| Scaffold .claude/      | aitk claude       | Interactively seed .claude/ docs and sync .gitignore                                  |
| Planning (all docs)    | Claude chat       | Paste SESSION.md first; add REQUIREMENTS + ARCHITECTURE for new features              |
| Generate master prompt | aitk claude       | `aitk claude prompt` — reads `.cursor/rules/`, writes `.claude/.tmp/master-prompt.md` |
| Code generation        | Gemini pro chat   | Paste master prompt + feature plan + source context                                   |
| Apply file changes     | Gemini CLI        | `/dev:apply` — file writer only, no planning                                          |
| Wrap for review        | aitk claude       | `aitk claude review` — reads clipboard + TASKS.md, writes `.claude/.tmp/review.md`    |
| Feature review         | Fresh Gemini chat | Paste `.claude/.tmp/review.md` — returns findings report                              |
| Fix findings           | Gemini chat       | Paste critical/should-fix back into original session                                  |
| Lint / format / tests  | bun scripts       | `bun run check`                                                                       |
| Escalate design issues | Claude chat       | Paste error + relevant plan context                                                   |
| Commit message         | Gemini CLI        | `/git:commit`                                                                         |
| PR description         | Gemini CLI        | `/git:pr`                                                                             |
| Changelog              | Gemini CLI        | `/release:changelog`                                                                  |
| Install gov rules      | aitk              | `aitk gov install [stack] [path]`                                                     |
| Sync gov rules         | aitk              | `aitk gov sync [path]`                                                                |
| Install standards      | aitk              | `aitk standards install [path]`                                                       |
| Sync standards         | aitk              | `aitk standards sync [path]`                                                          |

> Gov rules apply to code generation and fix failures only.
