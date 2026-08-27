# Problem formulation: topic to question to problem to claim

Source: Booth, Colomb, Williams, Bizup & FitzGerald, *The Craft of Research*, 5th ed.
(University of Chicago Press, 2024). Argument skeleton after Toulmin, *The Uses of Argument* (1958).

The pipeline's briefs have historically jumped from **topic** straight to **thesis**. The two
intervening moves are what separate a post that is merely correct from one that is needed.

## The four steps (do all four, in order)

**1. Topic.** What the piece is about. "Agent evals." Not yet interesting to anyone.

**2. Question.** What you do not know about it. "How do you catch an agent failure that a clean
trajectory hides?" A question is answerable. A topic is not.

**3. Problem.** The question plus its cost. This is the step that gets skipped. State it in two
parts:
   - **Condition:** what is currently true and unsatisfactory.
   - **Cost:** what it specifically costs the reader to not know the answer. Who is worse off,
     and how. Not "readers would find this interesting." Something concrete goes wrong.

   If you cannot name a cost, the piece is a summary. Say so in the brief and either find the
   cost or drop the idea. This is the "So what?" test, and it is the whole point of the step.

**4. Claim.** The answer to the question, stated so it could be wrong. Prefer the narrowest
version the evidence supports (this repo's existing rule, unchanged).

## The argument skeleton

Every claim in a post carries these. Name them in the brief so the drafter and critics can find them.

- **Claim**: what you are asserting.
- **Reasons**: why it follows.
- **Evidence**: the numbers, transcripts, or sources. In this repo, usually `evidence.md`.
- **Warrant**: the unstated general principle that licenses moving from *this evidence* to
  *this claim*. Almost always the weakest joint in a technical post, and almost never written
  down. Write it down.
- **Qualifier**: the scope limit ("on this fixture", "for tool-shaped failures", "measured once").
- **Acknowledgment and response**: the strongest objection, stated fairly, then answered.

The warrant is the load-bearing one. Example: evidence is "the same error appears on four models."
Claim is "this failure is invariant to model capability." The warrant is "four models spanning
this capability range are representative of the capability axis." That warrant is arguable, and
if the post does not state it, a hostile reader states it for you.

## What this adds to `brief.md`

Two new required sections, before the thesis:

```
## Problem
Condition: <what is true now and unsatisfactory>
Cost: <what it concretely costs the reader not to know this>

## Argument skeleton
Claim: ...
Reasons: ...
Evidence: ...
Warrant: ...            <- the principle licensing evidence -> claim
Qualifier: ...
Strongest objection + response: ...
```

The existing "narrowest defensible thesis", "delta", and "what's real / what isn't yet" sections
stay exactly as they are. `Qualifier` and the honesty ledger overlap by design; keep both, since
one is per-claim and the other is per-post.
