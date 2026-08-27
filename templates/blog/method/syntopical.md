# Syntopical reading: how to read a whole literature, not a pile of sources

Source: Adler & Van Doren, *How to Read a Book*, the fourth level of reading.

The research stage's job is not to collect citations. It is to construct the conversation the
sources are collectively having, which exists in none of them individually, and then locate the
seam this post sits on. That construction is the delta.

## The five steps

**1. Find the relevant passages.** You serve your question, not the source's agenda. Skim for
what bears on the problem statement. A source can be excellent and irrelevant.

**2. Bring the authors to common terms.** They do not share vocabulary. You impose one. This is
the step that is always skipped and always the most valuable, because two sources that look like
they disagree often use one word for two things, and two that look like they agree often use two
words for one thing. Produce the terms table (below). It is a required brief artifact.

**3. Get the questions clear.** Frame a short set of questions, in your terms, that every source
answers (or conspicuously does not). Not their questions. Yours.

**4. Define the issues.** An issue is where sources genuinely disagree on one of your questions.
Real disagreements are rarer than they look, and each one is a candidate spine for the post.

**5. Analyze the discussion.** Order the questions and issues so they build. Present the
disagreement fairly before taking a side. If you take a side, the reason has to be visible.

## Required artifact: the common-terms table

Goes in `brief.md`. Three columns minimum.

```
| Source | Their term | Our term | Note |
|---|---|---|---|
| Anthropic evals guide | "grade the outcome" | outcome eval | matches ours |
| Vertex agent eval | "trajectory_precision" | trajectory eval | narrower than ours: tool calls only |
| <archive note> | "<author's coinage>" | <same concept> | author's own prior coinage, reuse it |
```

Two rules for the table:
- **The archive is a source.** Grep the local archive (see `blog/config.md`) and `blog/posts/**`. If the author already
  coined a term, that term wins. Do not re-coin something already published under another name.
- If a source has no row, it did not inform the post. Cut it from Sources.

## Where the delta comes from

After step 4 you can state the delta mechanically: name the question every source answers the
same way, and the corner none of them addresses. If every source answers your questions and none
of them disagree anywhere, there is no seam and the post is distillation, not argument. That is a
legitimate outcome. Say so in the brief and set `track = explainer`, where the contribution is
the explanation itself rather than a new claim.
