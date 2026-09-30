# let-claude-cook 🧑‍🍳

> *Jimmy Cooks, but it's your agent.* Skills that let Claude cook. Don't interrupt it.

A [Claude Code](https://code.claude.com) plugin marketplace.

## Install

```bash
claude plugin marketplace add sabinshamsul/let-claude-cook
claude plugin install bruh@let-claude-cook
claude plugin install vibe-check@let-claude-cook
```

Or from inside a Claude Code session:

```
/plugin marketplace add sabinshamsul/let-claude-cook
/plugin install bruh@let-claude-cook
/plugin install vibe-check@let-claude-cook
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

## Try a plugin without installing

```bash
git clone https://github.com/sabinshamsul/let-claude-cook
claude --plugin-dir ./let-claude-cook/plugins/bruh
```

## License

MIT
