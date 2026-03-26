---
name: session-resume
description: Resumes a previous session by reading memory and summarizing in-progress work. Use when starting a new session, or when asked to "pick up where we left off", "what was I working on", or "resume".
---

# Session resume

## Step 1: read memory

Read `.claude/memory/MEMORY.md`. Then read each memory file it references in parallel.

If `.claude/memory/MEMORY.md` does not exist or has no entries, stop: `✅ No in-progress work found. Start a new task.`

## Step 2: summarize

For each memory entry, output:

**In progress:** one-line description of the task
**Context:** one or two sentences on where things stand and what was decided
**Next action:** the specific thing to do first

## Step 3: offer cleanup

After summarizing, list each entry by number and ask which to remove:

`Remove any completed entries? Reply with numbers (e.g. 1, 3) or 'none'.`

For each entry the user marks for removal, delete the memory file and remove its line from `MEMORY.md`.
