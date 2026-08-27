---
description: Run the blog pipeline — backlog, capture drain, and stage advancement (idea → voiced draft → publish-ready draft). Stops at draft; the human publishes.
argument-hint: "[scout | inbox | new \"<idea>\" | next [slug] | status <slug>]"
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, Skill
---

# /blog-pipeline — orchestrator

You drive the blog pipeline for the blog described in `blog/config.md` (name, URL, audience,
publish target). If `blog/` does not exist, stop and tell the user to run `/blog-setup` first.

The manifest `blog/pipeline.md` is the single source of truth (a Markdown table). Every idea
has a `track` and a `stage`. You run only the stages that the idea's track requires, and you
**always stop at a publish-ready draft — never Publish.**

## Hard rules (non-negotiable)
- **Never publish.** No clicking Publish / "Send to everyone now". Close any publish flow via Cancel.
- **Login is the user's job.** Never enter credentials into any site (AI chat, editor, anything).
- **De-identify gate.** Before any draft/evidence informs public output, grep-scan for org /
  product / internal handles / repo slugs / account ids. Zero hits. Add the personal-views
  disclaimer if `blog/voice/standing-instructions.md` calls for one.
- **Browser is one shared resource.** Run browser-driving stages (`blog-illustrator`,
  `blog-substack-builder`, `blog-cross-model-critic`) one at a time, never in parallel.
- Every generative agent must load `blog/voice/` so output is in the author's voice, **and**
  `blog/method/` so the argument underneath is built to the craft canon (problem formulation,
  syntopical reading, OCAR, reader expectation). Voice wins on any conflict.

## Argument: `$ARGUMENTS`

Parse the first token as the sub-command:

### (no args) → show the backlog
Read `blog/pipeline.md`. Print a compact table grouped by stage, and for each idea show the
**next actionable stage** given its `track`. Recommend what to pick up next.

### `scout` → generate new ideas when the well is dry
1. Dispatch `blog-idea-scout` **2–3× IN PARALLEL**, one per lens — `news`, `discourse`,
   `archive` (pass the lens in the prompt; each returns 5–7 ranked candidates, already
   deduped against the manifest). Skip the `archive` lens if the project has no local
   archive of prior writing/notes.
2. Synthesize the panel: merge, drop cross-panel dupes and anything an existing manifest
   row covers, rank by delta (can we add a real experiment/build/contrarian read?) then
   timeliness.
3. Present the shortlist to the user (title · angle · why now · track). **The user picks**
   which to keep — scouting proposes, the human disposes.
4. For each keeper: append the raw line to `blog/inbox.md`'s captured section, then drain
   it into the manifest exactly as `inbox` does (slug, `stage = inbox`,
   `captured = scout <today>`).

### `inbox` → drain captured ideas into the manifest
1. Read `blog/inbox.md` (lines below the marker).
2. Optionally drain any external capture source named in `blog/config.md` (e.g. a Notion
   page via the Notion MCP, a notes file) — collect items not already in the manifest.
   Capture is one-way: never destructively mark items done in the external source.
3. For each new idea: assign a kebab-case `slug`, add a manifest row with `track` left blank
   (decided at research) and `stage = inbox`, `captured = <source> <today>`. Dedupe against
   existing slugs/titles. Append externally captured lines to `blog/inbox.md`'s captured
   section so there is a local record.
4. Report what was added.

### `new "<idea>"` → register and immediately research
1. Add a manifest row (`slug`, `title`, `stage = inbox`, `captured = session <today>`).
2. Create `blog/posts/<slug>/`.
3. Immediately run the **research** stage (below) for it.

### `next [slug]` → advance one stage
If no slug, pick the most advanced not-blocked idea (or ask which). Determine the current
`stage` and `track`, run the **single** next stage, update the manifest row, and report.

### `status <slug>` → detail
Print the full row + the contents of `blog/posts/<slug>/` (which artifacts exist).

## The stages (dispatch the matching subagent; update the manifest after each)

Common spine runs for every track. The optional middle runs only for the noted tracks.

| Stage | Subagent | Runs for | Produces |
|---|---|---|---|
| research | `blog-researcher` | all | `posts/<slug>/brief.md`; sets `track` |
| experiment | `blog-experimenter` | `thesis` | `experiment/` + `evidence.md` |
| build | `blog-experimenter` (build mode) | `build` | `project/` (+ key results as evidence) |
| draft | `blog-drafter` | all | `draft.md` (voice + evidence-aware) |
| critique | `blog-critic` ×N (parallel) + `blog-cross-model-critic` (serial) | all | `critiques/*.md` |
| revise | `blog-reviser` | all | revised `draft.md` |
| **gate: transforming** | *(orchestrator, no subagent)* | all | pass/fail in `brief.md` |
| illustrate | `blog-illustrator` | all | `diagrams/` |
| substack-draft | `blog-substack-builder` | all | `substack.md` + draft URL |
| publish | — | all | **HUMAN ONLY.** Stop here; tell the user what's left. |

### Critique stage detail
1. Run the **Claude panel**: dispatch `blog-critic` 3–4× IN PARALLEL, one per lens —
   `skeptic`, `domain-expert`, `naive-reader`, `voice-editor` (pass the lens + draft path in
   the prompt). Collect into `critiques/claude-panel.md`.
2. Then run `blog-cross-model-critic` (serial; needs the shared browser) for real
   outside-model reads (e.g. Gemini + ChatGPT) → `critiques/<model>.md`. If the browser
   isn't available / not logged in, note it and proceed with the Claude panel only.

### Transforming gate detail (runs at the end of `revise`)
Full policy: `blog/method/transforming-gate.md`. You run this yourself; no subagent.

Compare `brief.md` against the revised `draft.md` and answer: **name at least one thing the brief
stated or assumed that the finished draft no longer claims, and what forced the change** (the
evidence, a critique, or the writing itself). Record it in `brief.md` under
`## What changed while writing`.

Passing: the claim got smaller (scope, conditions, population), a stated assumption turned out
unsupported, or the mechanism changed even though the conclusion held. Wording changes alone do
not pass.

On failure:
- `research` / `thesis` / `build` → **BLOCK.** Leave `stage = revised`. Report which brief claim
  survived to the draft unchanged and say plainly the piece is currently knowledge-telling
  (a summary). The author decides whether to dig further or ship anyway.
- `explainer` → **WARN.** Record `no belief change: distillation piece` and advance. For an
  explainer the contribution is the explanation, so stable beliefs are expected.
- An `explainer` that fails twice running → flag it. The track may have been chosen to route
  around the gate rather than because the piece is genuinely distillation.

### Stage gating by track
- `research`  → research → draft → critique → revise → **[gate]** → illustrate → substack-draft
- `explainer` → same as research (illustrate may carry more weight; gate warns instead of blocks)
- `thesis`    → research → **experiment** → draft → critique → revise → **[gate]** → illustrate → substack-draft
- `build`     → research → **build** → draft → … (rest of spine, gate included)

## After every stage
Update the idea's `stage` (and `track`/`links` if changed) in `blog/pipeline.md`, then tell the
user the new state and the next recommended action. Keep the manifest tidy and committed-friendly.
