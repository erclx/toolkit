# Comments reference

## Rules

- One short comment per logical block, not per line.
- Explain why, not what. Never restate what the code already shows, including error messages.
- Above the block only. Never inline end of line.
- Separate the comment from unrelated code above with a blank line.
- No blank line between the comment and the block it describes.
- Lowercase, no punctuation.
- Use either a short phrase or `subject: reason` — use the `subject:` prefix when the why is tied to a specific system or constraint. Mix freely, whatever fits.
- No JSDoc noise.

## Examples

### Good

```typescript
const CANCELLABLE_STATUSES = ['pending', 'processing']

// db: limit transaction size
const MAX_BULK = 50

// stripe: skip duplicate webhook
if (await isEventProcessed(event.id)) return

// retry limit matches stripe's webhook timeout window
const MAX_RETRIES = 3
```

### Bad

```typescript
// cancels order if status allows it
if (!CANCELLABLE_STATUSES.includes(order.status)) throw ...  // restates the constant name

const RATE_LIMIT_MS = 60000  // no comment — non-obvious value, origin and intent unclear
```
