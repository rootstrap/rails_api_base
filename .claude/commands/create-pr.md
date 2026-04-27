# Create PR

Create a pull request following the official template.

**For PR content guidance, see `.claude/rules/github-pr-formatting.md`**

## Workflow

### 1. Check PR Size

Before anything else, run the `pr-size-checker` agent to analyze the diff size.

- If the agent recommends splitting, present the split plan to the user and ask how they'd like to proceed
- Only continue with PR creation after the user confirms (either to proceed as-is or after splitting)

### 2. Prepare Branch

- Check for uncommitted changes or unpushed commits
- If found, ask user if they want to proceed (advise pushing manually due to long pre-push hooks)

### 3. Gather Information

```bash
# Commit log on this branch
git log main..HEAD --oneline

# Files changed
git diff main...HEAD --name-only
```

### 4. Generate PR Description

Follow `.claude/rules/github-pr-formatting.md` to fill each section of the template (Board, Description, Notes, Tasks, Risk, Preview).

### 5. Create PR

```bash
gh pr create --title "[{TICKET-ID}] {Concise description}" --body "{BODY}" --base main
```

If there is no associated ticket, drop the `[TICKET-ID]` prefix and use just the description.

### 6. Amend the Body if Needed

```bash
gh pr edit {PR_NUMBER} --body "{UPDATED_BODY}"
```
