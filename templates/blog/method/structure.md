# Structure: the shape of the piece, and where words go in a sentence

Sources: Joshua Schimel, *Writing Science* (Oxford University Press, 2012) for the arc.
George Gopen & Judith Swan, "The Science of Scientific Writing," *American Scientist* 78(6):550-558
(1990) for the sentence.

## The arc: OCAR

Four elements, shaped like an hourglass.

- **Opening**: wide. The context and the concrete moment. Who cares and why.
- **Challenge**: narrow. The specific problem or question. This is `brief.md`'s Problem section,
  written as a scene rather than a spec.
- **Action**: narrow. What you did, built, measured, or worked through.
- **Resolution**: wide. What it means now that you know.

**The binding constraint: the widths of Opening and Resolution must match.** If the piece opens on
one engineer hitting one wrong number, it cannot resolve on the future of the industry. If it opens
on an industry-wide condition, resolving on one bug is an anticlimax. Mismatched widths are the most
common structural failure, and they read as either over-claiming or fizzling out.

This repo's existing rule "close loops back to the opening thesis" is this constraint. Keep it.

**Movements.** Three to five, separated by `---`, per `blog/voice/standing-instructions.md`. Map
them onto OCAR before drafting; do not discover the arc afterward.

**Paragraph-level.** Same shape, smaller: lead, development, resolution. The lead sentence carries
the paragraph's claim. A paragraph whose point only arrives at the end is a paragraph in the wrong
order.

## The sentence: reader-expectation

Readers decide what a sentence means partly from **where** things sit in it, not only from what it
says. Six checks, applied in the draft and again by the voice-editor critic.

1. **Subject next to verb.** Do not interrupt a grammatical subject and its verb with a long
   qualifier. The reader holds the subject in memory until the verb arrives, and pays for the wait.
2. **Stress position.** The end of a sentence, just before the period, is where the reader
   naturally puts emphasis. Put the thing you want emphasized there. If the sentence trails off
   into a qualifier, the qualifier is what lands.
3. **Topic position.** The start of a sentence is where the reader looks for the link backward.
   Open with old, already-established information; move new information toward the end.
4. **Action in the verb.** If the real action of a sentence is hiding in a noun ("performed an
   evaluation of"), move it into the verb ("evaluated"). Nominalizations flatten prose and hide
   who did what.
5. **Context before new information.** Do not ask the reader to hold a fact before telling them
   why it matters. Frame, then state.
6. **Intended emphasis equals constructed emphasis.** Read the sentence and ask what a reader
   would emphasize given its structure. If that is not what you meant to emphasize, restructure.

These are compatible with the house voice and mostly reinforce it. Short declarative sentences
already satisfy checks 1 and 5. The two-beat aphorism ("Generation got cheap. Verification didn't.")
is check 2 executed deliberately: the load-bearing word sits in the stress position of each beat.

## Where this is checked

- `blog-drafter` maps movements onto OCAR before writing, and verifies opening/resolution width
  match before handing back.
- `blog-critic`, voice-editor lens, runs the six sentence checks and quotes specific violations.
- Neither replaces `blog/voice/standing-instructions.md`. Voice wins on any conflict.
