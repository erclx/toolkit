# GitHub workflow reference

## Conventions

- Include `workflow_dispatch` on every workflow alongside the primary trigger
- Pin all actions to major version tags (`@v4`, never `@latest` or `@main`)
- Use `runs-on: ubuntu-latest` for all jobs
- Name jobs with emoji + title: `🛡️ Static Checks`, `🧪 Unit Tests`, `📦 Build Check`, `🎭 E2E Tests`, `🚀 Deploy`, `🔍 Code Quality`, `🏷️ Release`, `🔒 Security`
- Run independent jobs in parallel; use `needs` only when there is a data dependency (e.g. a job requires an artifact) or the job is prohibitively expensive relative to its gate
- Job order: static/unit/build run in parallel; e2e gates on build (needs the built extension); release/deploy gates on e2e
- Upload artifacts on `if: failure()` only; set `retention-days: 7`

## Bun stack

- Use `oven-sh/setup-bun@v2` with `bun-version: latest`
- Always install with `bun install --frozen-lockfile`
- Cache Playwright browsers keyed on Playwright version string, never a static key

## Examples

### Incorrect

```yaml
- uses: actions/checkout@latest # unpinned action
- run: bun install # missing --frozen-lockfile
- name: Unit Tests # missing emoji
- needs: [] # e2e not gated behind build (needs built extension artifact)
- uses: actions/upload-artifact@v4 # uploads on every run, not just failure
- key: playwright-browsers # static cache key, never invalidates
```
