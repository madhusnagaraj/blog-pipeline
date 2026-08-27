---
name: land-worktree
description: >-
  Check a worktree's work and land it onto main (commit, rebase, fast-forward main, push to a
  verified-private origin). Use whenever the user wants to "add this to main", "land this",
  "merge my worktree", "finish this worktree", "ship this branch", or "push to main". Trigger
  even if the user only says "land it" or "add to main" without naming a worktree; if we're in
  a `.claude/worktrees/` branch, this is the skill.
---

# Land a worktree onto main

For repos that do work in throwaway git worktrees under `.claude/worktrees/`. This skill takes
the work in the current worktree, checks it, and lands it on `main` cleanly, then syncs the
remote. It is deliberately conservative: it stops rather than force anything, and it never
pushes to a remote it cannot confirm is private (built for private writing/notes repos; if the
repo is intentionally public, push by hand after landing).

Do the steps in order. Steps 1–2 are read-only; step 3 mutates history, so **get the user's
go-ahead after showing them the check.**

## 1. Check — show what will land

If the repo's `CLAUDE.md` defines a pre-land inventory or reconcile step (e.g. reconciling a
content manifest against a live site), run it first so the manifest is honest before it becomes
a commit.

Then show what is about to move onto main:

```bash
git status --short
git diff --stat HEAD
git log --oneline main..HEAD   # commits this branch will add (may be empty if all work is uncommitted)
```

Summarize for the user: which files changed and the branch/main state.

## 2. Confirm

Landing rewrites history (rebase) and updates `main`. Show the summary and ask the user to
confirm before proceeding. If they want to adjust the commit message or exclude a file, do
that first.

## 3. Land

Run the bundled script from **inside the current worktree**. It commits, rebases onto main,
fast-forwards main (in the main worktree), and pushes to origin only if it can confirm the
remote is private:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/skills/land-worktree/scripts/land.sh" "<commit message>"
```

Flags:
- `--no-push` — land on local `main` only; never contact the remote.
- `--cleanup` — remove this worktree after a successful land.

Write a real commit message that describes the work, not "wip".

## Why it is built this way (so you can reason about failures)

- **It refuses to push to a non-private remote.** The script checks
  `gh repo view --json isPrivate`; anything other than `true` (public, or unknown because `gh`
  is missing) means it updates `main` locally and skips the push with a loud warning. For a
  private-by-design repo that is the safe default, not a bug to work around.
- **Rebase, then fast-forward.** Feature worktrees are usually behind `main` (other worktrees
  merge first). Rebasing the branch onto `main` and fast-forwarding keeps history linear and
  avoids merge commits. If the rebase conflicts, the script aborts it and lands nothing —
  resolve the branch against `main` by hand, then re-run. Never let the repo sit mid-rebase.
- **The main worktree must be clean.** `main` is checked out in the primary worktree, not here.
  The script updates it there and refuses if it has uncommitted changes, so two streams of work
  never get mixed into one commit.
- **Confirm before step 3.** Everything before it is reversible; the commit/rebase/push is
  where real changes happen. That is the one place to pause for a human.
