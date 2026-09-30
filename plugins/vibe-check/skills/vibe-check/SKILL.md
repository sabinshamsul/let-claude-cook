---
name: vibe-check
description: Vibe check a Jira ticket (e.g. /vibe-check PROJ-150). Reads the ticket and all comments, classifies it as query-only, data bug, or API/code bug, and proposes the next step. Read-only, changes nothing.
disable-model-invocation: true
---

# /vibe-check <TICKET-KEY>

Read-only. Never edit files, commit, push, run SQL, or post to Jira unless the user asks.

1. **Read** the ticket with the Atlassian tools: summary, description, status, assignee, linked issues, and ALL comments (oldest → newest). Note anything already tried or ruled out.
2. **Classify** as exactly one:
   - **Query only**: needs data looked up / verified, no fix expected.
   - **Data bug**: wrong/missing rows in the database; fix is a SQL script.
   - **API/code bug**: application logic (an integration, parser, job, or endpoint) is wrong; fix is code.
   - **Unclear**: say what's missing to decide.
3. **Check the repo** for context: search code, `scripts/`, and `docs/` for the ticket key and related names from the ticket. Use graphify (`graphify query`) if `graphify-out/graph.json` exists. Mention any existing fix, script, or PR.
4. **Next step**, by class:
   - Query / data bug → write the SQL to check it as a file under `scripts/` (with a header if the repo's CLAUDE.md asks for one), and give the exact command for the user to run it. Take that command from the repo's CLAUDE.md, README, or docs; if none is documented, say so and give a plain `psql -f /abs/path/to/file.sql`. If this session cannot reach the database, say so; don't try.
   - API/code bug → name the likely file(s) and function(s) with `file:line`, and suggest `/test` to reproduce it first.

## Output (keep it short)
- **Ticket:** one-line summary + status
- **What's been tried:** from comments (or "nothing yet")
- **Type:** query / data bug / API bug / unclear, and why, in one line
- **Related in repo:** files, scripts, or PRs found (or "none")
- **Next step:** the SQL file + command, or the code location

Never put an em dash (the long dash) in the output. Use a comma, colon, full stop or brackets instead.
