---
name: vibe-check
description: Vibe check a Jira ticket (e.g. /vibe-check PROJ-150, or just /vibe-check for the ticket already in this session). Uses the ticket content already in the conversation when it is there (for example after /bruh or an earlier Jira read), and only fetches from Jira if it is missing or the user asks to refresh. Classifies it as query-only, data bug, or API/code bug, and proposes the next step. Read-only, changes nothing.
model: sonnet
disable-model-invocation: true
---

# /vibe-check [TICKET-KEY] [refresh]

Read-only. Never edit files, commit, push, run SQL, or post to Jira unless the user asks.

1. **Get the ticket, from this session first.** Don't call Jira if you don't have to.
   - **Which ticket:** the key the user gave. With no key, use the ticket most recently discussed or fetched in this session (from `/bruh`, `/let-it-cook`, an earlier read, or the user pasting it). If there is none, ask which ticket.
   - **Already in the conversation?** Look back for that ticket's summary, description, status, assignee and **all** comments. If they are there, use them as they are and don't fetch. Say in one line what you are using, e.g. "Using DATA-159 as already read in this session."
   - **Fetch only what is missing.** If only part is there (say the description but no comments, or the output was truncated), fetch just the missing part with the Atlassian tools (e.g. comments only), not the whole ticket again.
   - **Fetch the whole ticket** only if nothing usable is in the conversation, the earlier content was lost (for example after a compact), or the user asks to **refresh** or says the ticket changed. Then read: summary, description, status, assignee, linked issues, and ALL comments (oldest to newest).
   - Note anything already tried or ruled out.
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
- **Source:** from this session, partly refreshed (say which part), or fetched fresh
- **Ticket:** one-line summary + status
- **What's been tried:** from comments (or "nothing yet")
- **Type:** query / data bug / API bug / unclear, and why, in one line
- **Related in repo:** files, scripts, or PRs found (or "none")
- **Next step:** the SQL file + command, or the code location

Never put an em dash (the long dash) in the output. Use a comma, colon, full stop or brackets instead.
