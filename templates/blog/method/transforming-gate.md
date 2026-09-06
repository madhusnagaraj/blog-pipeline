# The transforming gate: the check that separates an essay from a summary

Source: Bereiter & Scardamalia, *The Psychology of Written Composition* (1987).

## The theory, in three lines

**Knowledge-telling** is retrieving what you already know on topic cues and transcribing it in
order. It terminates when memory runs out. The output is a summary, and it can be accurate,
well-sourced, and completely inert.

**Knowledge-transforming** is a dialectic between two problem spaces. The **content space**
(what is actually true, is it consistent) and the **rhetorical space** (what will this reader
accept, what does this argument need). Each poses problems to the other. The writer's beliefs
change during composition.

Their sharp point: knowledge-transforming is not a better knowledge-telling. It is a different
definition of the task. A pipeline can execute every other stage perfectly and still ship
knowledge-telling.

The default `voice/standing-instructions.md` already states the conclusion without the theory:
"Synthesis without a defensible original angle is a summary, not an essay."

## Why this pipeline is already built for it

The two spaces map onto existing stages, which is why the gate is cheap to add:

- **Content space pressure** comes from `blog-experimenter` and `evidence.md`. When an evidence
  ledger returns "refuted, as literally written" listing the
  sentences the results contradict, that is the content space forcing a rhetorical revision.
  Textbook knowledge-transforming, produced by tooling.
- **Rhetorical space pressure** comes from the critique panel and the cross-model critics.

What is missing is the check that the dialectic actually happened, rather than both stages
running and neither changing anything.

## The check

Run it after `revise`, comparing the revised `draft.md` against `brief.md`.

> Name at least one thing stated or assumed in `brief.md` that the finished draft no longer
> claims, and say what forced the change (evidence, a critique, or the writing itself).

Record the answer in `brief.md` under a `## What changed while writing` section. If nothing
changed, the piece is knowledge-telling. That may be fine. It depends on the policy below.

## Policy: what happens when the gate fails

### What counts as passing

Any one of these is a real change and passes the gate:

- The claim got smaller. Scope, conditions, or population narrowed.
- A stated assumption turned out to be unsupported.
- The mechanism changed even though the conclusion held.

Only the wording changing does not pass. Rephrasing is not transforming.

A narrowing counts deliberately. Reversal is the rarer and more dramatic case, but the honest
day-to-day output of a working evidence stage is a claim that got smaller, and a gate that only
accepted reversals would fail almost every good post.

### What happens on failure, by track

- **`research` / `thesis` / `build`: BLOCK.** Do not advance to illustrate. Report which claim
  from `brief.md` survived to the finished draft unchanged, and say plainly that the piece is
  currently knowledge-telling. The author decides whether to dig further or ship it anyway.
- **`explainer`: WARN.** Record `no belief change: distillation piece` in `brief.md` under
  "What changed while writing", then advance. For an explainer the contribution is the
  explanation itself, so a stable set of beliefs is the expected outcome, not a failure.

**The escape hatch is watched.** If an `explainer` fails the gate twice running, flag it to the
author: the track may have been chosen to route around the gate rather than because the piece is
genuinely distillation. Track choice at research time now carries weight it did not carry before,
which is the intended cost of scoping the gate this way.

## Where it runs

At the end of the `revise` stage, before `illustrate`. It is a gate, not a stage, so it adds no
new value to the `stage` column in `blog/pipeline.md`. A post that fails on a blocking track stays
at `stage = revised` until the author resolves it.

The orchestrator runs the check itself against `brief.md` and the revised `draft.md`. No subagent
is needed: the comparison is short and the judgment should sit with the orchestrator that already
holds both documents.
