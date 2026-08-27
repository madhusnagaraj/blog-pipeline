# blog/method/: the craft canon, as loaded dependencies

`blog/voice/` says how a post should *sound*. `blog/method/` says how the thinking underneath
it should be *built*. Both are loaded by the pipeline agents, same way, every run.

These files encode published craft literature so the pipeline stops rediscovering it per post.
Each names its source so a claim can be checked.

| File | Governs | Source |
|---|---|---|
| `problem-formulation.md` | topic → question → problem → claim; the argument skeleton | Booth, Colomb, Williams, Bizup & FitzGerald, *The Craft of Research*, 5th ed. (U. Chicago, 2024); Toulmin, *The Uses of Argument* (1958) |
| `syntopical.md` | reading a whole literature and finding the seam | Adler & Van Doren, *How to Read a Book*, level 4 |
| `structure.md` | shape of the piece, and sentence-level placement | Schimel, *Writing Science* (OUP, 2012); Gopen & Swan, *American Scientist* 78(6), 1990 |
| `transforming-gate.md` | the check that separates an essay from a summary | Bereiter & Scardamalia, *The Psychology of Written Composition* (1987) |

## Who loads what

- `blog-researcher` → `problem-formulation.md` + `syntopical.md`
- `blog-drafter` → `structure.md`
- `blog-critic` → `problem-formulation.md` (skeptic lens) + `structure.md` (voice-editor lens)
- `blog-reviser` → whichever the critiques cite
- `/blog-pipeline` orchestrator → `transforming-gate.md`, run itself at the end of `revise`

## House rule
These files obey `blog/voice/standing-instructions.md` too, including its formatting rules.
