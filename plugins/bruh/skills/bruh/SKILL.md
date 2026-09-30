---
name: bruh
description: Explain the latest output in plain English. Turns the most recent retrieved content in the conversation (tickets, comments, pull requests, database query results, logs, errors, diffs, or a long technical answer) into a short, jargon-free summary a non-engineer can follow, using ELI5 explanations and tables where they help, while keeping the correct technical terms and explaining them. Use only when the user invokes /bruh by name, optionally followed by what to summarise (e.g. "/bruh comment 22736", "/bruh the PR").
disable-model-invocation: true
---

# /bruh: explain it like I'm five, but get it right

The user wants the most recent substantive output turned into something they
can understand at a glance and repeat to someone else. Plain words first,
correct terms second, never the other way round.

## 1. Pick what to summarise

- **If the user named something** after `/bruh` (a comment number, a PR, "the
  query result", "the error"), summarise exactly that.
- **Otherwise**, summarise the most recent *substantive* output in the
  conversation, retrieved content first (ticket comments, PR descriptions,
  review comments, query results, logs, error messages, diffs), and failing
  that your own last long technical answer.
- Use what is already in the conversation. Only fetch again if the content is
  not there or was truncated, and say so if you had to.
- If there is genuinely nothing to summarise, ask one short question: what
  should I explain?

## 2. Write the summary in this shape

Skip any section that has nothing in it. Keep the order.

**The short version**: one or two sentences. What happened, and whether it
is good news, bad news, or still in progress.

**In plain English**: the ELI5. Short sentences. Where it genuinely helps,
use one everyday analogy (a guest list, a queue, a filing cabinet, a
recipe), then stop; do not stack analogies.

**The details, in a table**: whenever there is more than one of something:
several comments, people, steps, dates, before/after values, status per
item. Typical columns: *who / when / what they said*, *step / status / who
owns it*, *expected / actual*. Keep IDs, numbers, names and dates exactly
as they appear in the source.

**Words you'll see**: only if technical terms appeared. Keep the real term
(people will search for it and hear it in meetings) and explain it in one
plain line:

| Term | What it means |
| --- | --- |
| merged | the change is accepted into the main code; it is *not* live yet |

**What this means / what's next**: who needs to do what, and what is
blocked on what. If nothing is needed, say so.

**Watch out**: anything that contradicts something else, anything that is a
claim rather than something checked, anything that looks done but isn't.
Say plainly which is which ("the ticket says X, but the database shows Y").

## 3. Rules

- **No jargon without an explanation.** Every technical term is either
  replaced with plain words or kept and explained the first time.
- **Correct, not dumbed down.** Simplify the words, never the facts. Do not
  round numbers, merge separate events, or drop an important caveat to make
  it read nicer.
- **Don't invent.** If the source does not say it, neither do you. Mark
  guesses as guesses.
- **Say who said it.** "Jacky's dry run found…", "the database shows…", "the
  PR claims…", so the reader knows what is verified and what is reported.
- **Be short.** As short as it can be while still complete. No preamble, no
  "great question", no recap of what you are about to do.
- **Don't take actions.** `/bruh` only explains. Do not post, edit, commit or
  run anything that changes state. Offer next steps; don't do them.
- **No em dashes.** Never put an em dash (the long dash) in the output. Use a
  comma, colon, full stop or brackets instead.
