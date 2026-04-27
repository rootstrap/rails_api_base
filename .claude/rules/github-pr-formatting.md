# GitHub PR Creation Guide

This is the single source of truth for creating pull requests. `.claude/commands/create-pr.md` references this file.

## Step 0: Check PR Size

**ALWAYS run the `pr-size-checker` agent before creating a PR.** This agent analyzes the diff and recommends whether the PR should be split into smaller ones (target: ~400 added lines max per PR).

- If the agent recommends splitting, present the split plan to the user and ask how to proceed
- Only continue with PR creation after the user confirms (either as-is or after splitting)
- Skip this step only if the user explicitly asks to skip size checking

## Step 1: Read the Official Template

**ALWAYS start by reading `.github/PULL_REQUEST_TEMPLATE.md`**

```bash
cat .github/PULL_REQUEST_TEMPLATE.md
```

Every PR must include ALL sections from the template. Do not skip sections — fill with `* N/A` if not applicable.

## Step 2: Fill Each Section

The template has six sections: **Board**, **Description**, **Notes**, **Tasks**, **Risk**, **Preview**.

### Board

- A link to the ticket this PR closes, in the form `* [Ticket #123](https://link-to-ticket)`
- If there is no ticket, write `* N/A` and explain why in the Description (e.g., dependency bump, hotfix, internal cleanup)

### Description

- Concise summary of what changed and **why**
- For dependency bumps, mention the from/to versions and any notable upstream changes (e.g., breaking changes, CVE fixes)
- For Rails upgrades, link the release notes or upgrade guide
- Reference any related PRs by number (e.g., "depends on #1234", "follow-up to #1230")

### Notes

- Anything reviewers should know that doesn't fit elsewhere: caveats, deferred work, follow-ups, manual steps required after merge
- If none, write `* N/A`

### Tasks

Use checkboxes (`- [ ]` / `- [x]`) to enumerate the work this PR does. Tick the boxes for items already completed in the PR; leave any deferred items unchecked and mention them in **Notes**.

```markdown
- [x] Add `UserProfile` model + migration
- [x] Add `Api::V1::UserProfilesController` with `index`/`show`
- [x] Add request specs covering happy path and 404
- [ ] Wire up `update`/`destroy` (deferred to follow-up)
```

### Risk

- One short line about the blast radius of the change
- For trivial changes: `* Low — isolated to <area>`
- For migrations / data changes: state the rollback plan explicitly
- For dependency bumps: note whether the upstream changelog flagged breaking changes

### Preview

- Sample `curl` requests + responses for new/changed endpoints
- Console output for changed jobs / rake tasks
- Screenshots or GIFs (rare in an API repo, but useful for any rendered output)
- `* N/A` for changes with no observable surface (refactors, internal cleanup)

## Step 3: Create the PR

```bash
gh pr create --title "[{TICKET-ID}] {Concise description}" --body "{BODY}" --base main
```

**Title format:**

- **If there is a ticket**, prefix the title with `[TICKET-ID]` (e.g., `[RS-123] Add user profile endpoints`). The same ticket should also be linked in the **Board** section.
- **If there is no ticket** (dependency bumps, hotfixes, internal cleanup), drop the prefix and use just the description (e.g., `Upgrade Rails to 8.1.3`, `Security: Update erb gem to patch CVE-2026-41316`).

Keep the title under 70 characters; details belong in the body.


---

## Formatting Rules

### Markdown List Spacing Bug

GitHub collapses the spacing between two lists separated only by a blank line, making the boundary invisible. Always insert an HTML comment `<!--- --->` (with its own blank lines) between adjacent list groups.

**Insert a separator whenever any of these transitions occur — even across headings or bold lines:**

| Transition | Example trigger |
|---|---|
| Plain bullets → task-list checkboxes | `- item` followed by `- [ ] checkbox` |
| Task-list checkboxes → plain bullets | reverse of above |
| Plain bullets → plain bullets (two logical groups) | two bullet groups split by a blank line |
| Task-list → task-list (different logical groups) | e.g., separate verification groups |
| Heading / bold paragraph → list | e.g., `#### Tasks` followed by `- [ ] …` |
| Standalone link/paragraph → list | anything non-list followed by list inside the same section |

**Rule of thumb:** if two list-shaped blocks end up in the same section with only blank lines between them, separate them.

```markdown
- Item 1
- Item 2

<!--- --->

- [ ] Checkbox 1
- [ ] Checkbox 2
```

```markdown
**Migration:**
- [ ] Step A
- [ ] Step B

<!--- --->

**Endpoint:**
- [ ] Step C
- [ ] Step D
```

**Mandatory pre-flight before `gh pr create` / `gh pr edit --body`:** re-read the body end-to-end with this table in mind. Missing separators is a recurring mistake — never skip this check.

### Code Blocks

Don't unnecessarily escape backticks in code blocks.

### Tasks Format

Always use checkboxes for task lists, with sub-bullets when grouping related items:

```markdown
- [x] Run the migration on a fresh DB
- Verify the new endpoint:
  - [x] `GET /api/v1/foo` returns 200
  - [x] `POST /api/v1/foo` validates required params
```

---

## Making Changes to Existing PRs

Use `gh` CLI:

```bash
gh pr edit {PR_NUMBER} --body "{NEW_BODY}"
gh pr edit {PR_NUMBER} --add-label "label-name"
```
