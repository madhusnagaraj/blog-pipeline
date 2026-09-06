---
description: Scaffold the blog/ workspace the blog-pipeline needs — config, backlog manifest, inbox, voice folder, and method canon — then walk the author through filling in their voice.
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion
---

# /blog-setup — scaffold the pipeline workspace

You set up the `blog/` directory that every pipeline agent reads. Run this once per project,
before the first `/blog-pipeline`.

## 1. Check what exists
If `blog/` already exists, list what's there and only create the missing pieces — never
overwrite a file the author already filled in.

## 2. Ask the author (one AskUserQuestion call, or plain questions)
- **Blog name** and **public URL** (if it exists yet).
- **Publish target** — Substack, Ghost, static site, other (the `substack-draft` stage adapts;
  for non-Substack targets it produces paste-ready HTML + instructions instead of driving an
  editor).
- **Audience in one sentence** — who reads this and what do they already know?
- **Idea capture sources** — anywhere ideas already pile up (a Notion page, a notes file, none).

## 3. Scaffold from the plugin templates
Copy from `${CLAUDE_PLUGIN_ROOT}/templates/blog/` into the project's `blog/`:

```
blog/
  config.md        # filled with the answers from step 2
  pipeline.md      # the backlog manifest (empty table)
  inbox.md         # quick-capture file
  .gitignore       # keeps experiment fallout (.env, credentials) out of commits
  voice/           # voice-guide.md, standing-instructions.md, examples.md — TEMPLATES to fill
  method/          # the craft canon — usable as-is, editable
  posts/           # empty; one folder per post slug
```

Fill `config.md` from the answers. Leave the voice templates' TODO markers in place.

## 4. Coach the voice folder (the part that actually matters)
The pipeline's output quality is capped by `blog/voice/`. Tell the author plainly:

- `voice/examples.md` is the highest-leverage file: paste 2–4 **full posts they've written
  and like** (or long emails/docs if they haven't blogged yet). Agents imitate examples far
  better than adjectives.
- `voice/voice-guide.md`: help them fill it now if they have 10 minutes — ask for 3 writers
  they'd steal from, 3 habits they hate in AI prose, and how they open and close pieces.
  Write the guide from their answers; don't make them fill a form.
- `voice/standing-instructions.md`: hard rules (disclaimers, banned punctuation/words, length
  bounds, honesty bar). Suggest sensible defaults and let them edit.

## 5. Finish
Summarize what was created, what still has TODOs, and tell them the first real command:
`/blog-pipeline new "<their first idea>"` or `/blog-pipeline scout`.
