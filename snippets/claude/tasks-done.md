Read `.claude/TASKS.md` and `.claude/TASKS-ARCHIVE.md`. Before proceeding, re-read the preamble of `TASKS.md` (everything above `## Up next`) to understand the rules for this file.

1. Promote complete tasks. In "Up next", find every `###` block that has at least one checkbox and where all checkboxes are `[x]`:
   - Append the entire block to the bottom of "Done", after all existing entries
   - Remove the block from "Up next"
   - Skip blocks with no checkboxes

2. Archive overflow. Count `###` blocks in "Done". If the count exceeds 10, move the oldest half (rounded down) to the bottom of `.claude/TASKS-ARCHIVE.md` and remove them from "Done".

3. Sync the placeholder. If "Up next" has at least one `###` block with checkboxes (checked or unchecked), remove `### Nothing queued` if present. If "Up next" has no `###` blocks with checkboxes, insert `### Nothing queued` if not already present:

```markdown
### Nothing queued

- No tasks currently
```

Preserve all formatting and content exactly.
