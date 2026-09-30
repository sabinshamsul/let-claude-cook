# let-claude-cook 🧑‍🍳

> *Jimmy Cooks, but it's your agent.* Skills that let Claude cook. Don't interrupt it.

A [Claude Code](https://code.claude.com) plugin marketplace.

## Install

```bash
claude plugin marketplace add sabinshamsul/let-claude-cook
claude plugin install bruh@let-claude-cook
claude plugin install vibe-check@let-claude-cook
claude plugin install receipts@let-claude-cook
claude plugin install lore@let-claude-cook
claude plugin install are-we-cooked@let-claude-cook
claude plugin install mise-en-place@let-claude-cook
```

Or from inside a Claude Code session:

```
/plugin marketplace add sabinshamsul/let-claude-cook
/plugin install bruh@let-claude-cook
/plugin install vibe-check@let-claude-cook
/plugin install receipts@let-claude-cook
/plugin install lore@let-claude-cook
/plugin install are-we-cooked@let-claude-cook
/plugin install mise-en-place@let-claude-cook
```

## Plugins

### `bruh`: explain it like I'm five, but get it right

Your agent just dumped a wall of ticket comments, PR reviews, query results or
stack traces on you. Type `/bruh:bruh` and it turns the latest output into a
short plain-English summary:

- **The short version**: one or two sentences: good news, bad news, or still cooking
- **In plain English**: ELI5, with one everyday analogy where it actually helps
- **Tables**: whenever there's more than one of something: people, steps, dates, before/after
- **Words you'll see**: the correct technical terms, kept and explained (so you can still say them in meetings)
- **What's next**: who needs to do what, and what's blocked
- **Watch out**: what's checked vs. what someone merely claimed, and anything that looks done but isn't

It only explains. It never posts, edits or commits anything, and it only runs
when you type it.

```
/bruh:bruh                    summarise the latest output
/bruh:bruh comment 22736      summarise something specific
```

> **Why `/bruh:bruh`?** Claude Code prefixes every plugin skill with its
> plugin's name, so two plugins can each ship a `bruh` without clashing. Want
> plain `/bruh`? Copy `plugins/bruh/skills/bruh/SKILL.md` to
> `~/.claude/skills/bruh/SKILL.md` instead of installing the plugin.

### `vibe-check`: what kind of problem is this ticket?

Give it a Jira ticket key and it reads the ticket and every comment, then tells you:

- **Ticket**: one-line summary and status
- **What's been tried**: pulled from the comments
- **Type**: query only, data bug, API/code bug, or unclear (and why)
- **Related in repo**: code, scripts or PRs that already mention it
- **Next step**: a SQL file to check the data plus the command to run it, or the likely `file:line` to fix

It's read-only: it never edits, commits, runs SQL or posts to Jira unless you ask.
It needs the Atlassian (Jira) connector, and it takes the command for running SQL
from your repo's `CLAUDE.md` or README, so document it there.

```
/vibe-check:vibe-check PROJ-150
```

### `receipts`: why is the code like this?

Ask why something exists (a threshold, a workaround, a weird branch) and it sends one
investigator per evidence source you have connected, all at once: git and PRs, your
ticket tracker, docs, team chat, monitoring, error tracking, analytics. A synthesizer
then writes one answer where every claim is tagged **Direct**, **Supported**,
**Inferred** or **Speculative**, with citations, plus what nobody could find.

```
/receipts:receipts why do we retry 3 times in fetchPrices?
```

### `lore`: how does this work?

A walkthrough of a subsystem for someone new to it: overview, key concepts, the flow
step by step, where things live, gotchas. Big questions get 2 to 4 explorers tracing
different slices in parallel, then one explainer merges them.

```
/lore:lore how does the nightly price refetch work?
```

### `are-we-cooked`: what could this break?

Before you ship, it looks for breakage outside the diff (data formats, timing,
config, code three hops away), finds the one fact the change is safe because of, and
**proves it by running real code** instead of just claiming it.

```
/are-we-cooked:are-we-cooked            the uncommitted diff
/are-we-cooked:are-we-cooked PR 42
```

### `mise-en-place`: prep the kitchen before cooking

A session-start hook, nothing to type. Every time a session starts in a git repo it:

- builds or refreshes a [graphify](https://pypi.org/project/graphifyy/) code graph in the
  background (code is parsed on your machine, so **no AI tokens**)
- hides `graphify-out/` from git on that machine only (`.git/info/exclude`, never
  `.gitignore`), so it never shows up as a change
- tells Claude to answer code questions with `graphify query` / `explain` / `path` first
  and only open the files the graph points to

Needs graphify installed (`uv tool install graphifyy`). Without it, or outside a git repo,
it quietly does nothing. It builds the graph for the folder the session opens in, not
for every attached repo.

> `receipts`, `lore` and `are-we-cooked` start several sub agents, so they use more
> tokens than a normal question. All three are read-only on your code.
>
> They are adapted from `why`, `how` and `blast-radius` in
> [pstack](https://github.com/cursor/plugins/tree/main/pstack) by Lauren Tan (MIT).
> Each plugin carries the original licence as `LICENSE-pstack`.

## Try a plugin without installing

```bash
git clone https://github.com/sabinshamsul/let-claude-cook
claude --plugin-dir ./let-claude-cook/plugins/bruh
```

## License

MIT
