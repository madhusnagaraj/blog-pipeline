#!/usr/bin/env bash
# land.sh — commit this worktree's work and land it on main (rebase -> fast-forward), then push.
#
# Safe by design: it refuses to do anything surprising. It will STOP (non-zero exit) rather than
# force, auto-resolve conflicts, or push to a non-private remote. Read the echoes; every mutating
# step announces itself first.
#
# Usage:
#   land.sh "<commit message>"            # commit + land on main + push to private origin
#   land.sh "<commit message>" --no-push  # land on local main only, never push
#   land.sh "<commit message>" --cleanup  # also remove this worktree after a successful land
#
# Run it FROM the feature worktree you want to land (never from the main worktree).
set -euo pipefail

MSG="${1:-}"
PUSH=1
CLEANUP=0
for arg in "${@:2}"; do
  case "$arg" in
    --no-push) PUSH=0 ;;
    --cleanup) CLEANUP=1 ;;
    *) echo "land.sh: unknown flag '$arg'" >&2; exit 2 ;;
  esac
done
if [[ -z "$MSG" ]]; then
  echo "land.sh: a commit message is required as the first argument." >&2
  exit 2
fi

say() { printf '\n\033[1m» %s\033[0m\n' "$*"; }
die() { printf '\n\033[1;31m✗ %s\033[0m\n' "$*" >&2; exit 1; }

# --- 0. Locate this worktree and the main worktree -------------------------------------------
WT="$(git rev-parse --show-toplevel)"
BR="$(git rev-parse --abbrev-ref HEAD)"
[[ "$BR" == "main" ]] && die "You are on 'main'. Run this from the feature worktree you want to land."

MAINWT="$(git worktree list --porcelain | awk '
  /^worktree /{wt=substr($0,10)}
  /^branch refs\/heads\/main$/{print wt; exit}')"
[[ -n "$MAINWT" ]] || die "Could not find the worktree that has 'main' checked out."
say "Feature worktree: $WT (branch: $BR)"
say "Main worktree:    $MAINWT"

# --- 1. Preconditions: main worktree must be clean -------------------------------------------
if [[ -n "$(git -C "$MAINWT" status --porcelain)" ]]; then
  die "The main worktree has uncommitted changes. Clean it before landing, so we never mix work."
fi

# --- 2. Commit this worktree's work ----------------------------------------------------------
if [[ -n "$(git status --porcelain)" ]]; then
  say "Committing your changes on '$BR'"
  git add -A
  git commit -m "$MSG" -m "Co-Authored-By: Claude <noreply@anthropic.com>"
else
  say "No uncommitted changes; using existing commits on '$BR'"
fi

# --- 3. Bring main up to date with origin (fast-forward only) --------------------------------
# Only touches the remote when a push is actually intended (PUSH=1). With --no-push this step
# is skipped entirely, so a missing/unreachable origin never blocks a local-only land.
if [[ "$PUSH" -eq 1 ]] && git remote get-url origin >/dev/null 2>&1; then
  say "Fetching origin"
  if git fetch --quiet origin; then
    if git -C "$MAINWT" rev-parse --verify --quiet origin/main >/dev/null; then
      say "Fast-forwarding local main to origin/main"
      git -C "$MAINWT" merge --ff-only origin/main || die "Local main and origin/main have diverged; resolve by hand."
    fi
  else
    printf '\n\033[1;33m⚠ Could not fetch origin (offline or unreachable). Continuing with a local-only land; push yourself once you can reach the remote.\033[0m\n'
  fi
fi

# --- 4. Rebase this branch onto main, then fast-forward main to it ----------------------------
if [[ -z "$(git rev-parse --verify --quiet main || true)" ]]; then die "No local 'main' branch found."; fi
if [[ -n "$(git log --oneline main.."$BR" 2>/dev/null)" || "$(git rev-parse "$BR")" != "$(git rev-parse main)" ]]; then
  say "Rebasing '$BR' onto main"
  if ! git rebase main; then
    git rebase --abort || true
    die "Rebase hit conflicts. Nothing was landed. Resolve '$BR' against main by hand, then re-run."
  fi
fi

say "Fast-forwarding main to '$BR' (in the main worktree)"
git -C "$MAINWT" merge --ff-only "$BR" || die "main could not fast-forward to '$BR'. Not landing."

# --- 5. Push (only to a verified-private origin) ---------------------------------------------
if [[ "$PUSH" -eq 1 ]] && git remote get-url origin >/dev/null 2>&1; then
  PRIVATE="unknown"
  if command -v gh >/dev/null 2>&1; then
    PRIVATE="$(gh repo view --json isPrivate -q .isPrivate 2>/dev/null || echo unknown)"
  fi
  if [[ "$PRIVATE" == "true" ]]; then
    say "Remote is private — pushing main to origin"
    git -C "$MAINWT" push origin main || die "Push failed."
  else
    printf '\n\033[1;33m⚠ Skipping push: could not confirm origin is PRIVATE (got: %s).\033[0m\n' "$PRIVATE"
    printf '\033[1;33m  main is updated locally. Push yourself only after confirming the remote is private.\033[0m\n'
  fi
elif [[ "$PUSH" -eq 0 ]]; then
  say "Push skipped (--no-push). main is updated locally only."
fi

# --- 6. Optional worktree cleanup ------------------------------------------------------------
if [[ "$CLEANUP" -eq 1 ]]; then
  say "Removing this worktree: $WT"
  cd "$MAINWT"
  git worktree remove "$WT" || printf '\033[1;33m⚠ Could not auto-remove the worktree (uncommitted files?). Remove it manually.\033[0m\n'
fi

say "Done. '$BR' is landed on main."
git -C "$MAINWT" log --oneline -3 main
