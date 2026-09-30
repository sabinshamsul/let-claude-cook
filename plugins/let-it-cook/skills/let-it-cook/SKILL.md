---
name: let-it-cook
description: One command from Jira ticket to reviewed PR. Briefs the ticket (cheap helper), finds the code, makes the smallest fix plus a test, runs tests, gets a fresh-eyes review (max 2 fix rounds), then STOPS for the user's "ship it" before committing, pushing and opening the PR. Then watches the PR and drafts the Jira comment for approval before posting. Use only when the user invokes /let-it-cook by name, e.g. "/let-it-cook DATA-160".
disable-model-invocation: true
---

# /let-it-cook <TICKET-KEY>

Take one Jira ticket from "assigned" to "PR open and watched", with the user stepping in only at two checkpoints: **"ship it"** (commit and PR) and **"post it"** (Jira comment).

The user's CLAUDE.md has their company context (Jira site, repos, tables, how to run SQL, title conventions). Follow it wherever it is more specific than this skill.

## Hard rules

- Never commit, push, open a PR or post to Jira before the matching checkpoint below.
- Never push to the default branch, merge, or approve a PR.
- Never run anything that writes to a database. Never touch production data: use fixtures, samples or staging read-only queries.
- Never skip, delete or weaken a test to get green.
- Keep the diff to what the ticket needs.

## 1. Brief (cheap)

Spawn `let-it-cook:jira-clerk` with `brief <KEY>`. Show the user the brief as returned (it is short).

Then decide by **Type**:
- `code bug`: carry on.
- `data bug` or `query only`: follow the "Running SQL" rules in CLAUDE.md. If this session can reach the database, write the query under `scripts/`, run it read-only, summarise the result with a script, and decide whether it is really a code bug, a data fix (write the fix script for the user to review and run; never run it) or no bug. If this session cannot reach the database, write the SQL file, tell the user to run it in a local session, and stop.
- `unclear`: say what is missing and stop.

## 2. Find the code (cheap)

1. If `graphify-out/graph.json` exists, start with `graphify query "<names from the brief>"`.
2. Otherwise, or if the graph is not enough, spawn the built-in `Explore` sub agent with the brief and ask for: the likely files and functions with `file:line`, the likely root cause in 2 lines, and the command that runs the related tests.
3. Search for existing work: branches, PRs and scripts mentioning the key (both `DATA-150` and `data150` forms). If a fix already exists, stop and report it.

## 3. Fix and test

1. Use the session's assigned branch if it has one; otherwise create `fix/<key in lowercase, no dash>` (e.g. `fix/data160`) from the default branch.
2. Where a cheap test path exists, write a test that fails because of the bug first, and confirm it fails.
3. Make the smallest fix that makes it pass.
4. Run the repo's test command (from its CLAUDE.md or README, or the one `Explore` found). Also run the build and vet or lint if cheap.

## 4. Review (max 2 rounds)

Spawn `let-it-cook:reviewer` with the brief (2 lines) and how to get the diff. Fix every **major** finding, and minors that are quick and clearly right. Re-review once only if you changed code for a major. After 2 rounds, stop fixing and report what is left.

## 5. Checkpoint: "ship it"

Stop and show the user:

- **Ticket:** key and one line
- **Root cause:** 1 to 2 plain lines
- **Fix:** files changed, with `git diff --stat`
- **Tests:** what ran, and pass or fail
- **Review:** major / minor / nit counts, what was fixed, what is left
- **Commit and PR title:** following the CLAUDE.md convention (e.g. `fix(data160): <what it fixes>`)
- **PR description:** a short draft (problem, root cause, fix, tests, review findings, follow-up after deploy)

End with: **Reply "ship it" to commit, push and open the PR, or tell me what to change.** Then wait. Anything other than a clear go-ahead means revise and show the summary again.

## 6. Ship

After "ship it":
1. Commit with the agreed title, and push the branch.
2. Open the PR against the default branch with the agreed title and description, using the GitHub tools (or `gh` where that is what the session has).
3. Watch the PR if this session can (subscribe to its activity), so CI failures and review comments are handled; otherwise tell the user to say "watch this PR".

## 7. Jira comment: "post it"

1. Spawn `let-it-cook:jira-clerk` with `draft <KEY>` and the facts: root cause, fix, PR link and title, tests, review findings, follow-up after deploy, anything not fixed here.
2. Show the draft. End with: **Reply "post it" to post this on <KEY>, or tell me what to change.**
3. After "post it", spawn `let-it-cook:jira-clerk` with `post <KEY>` and the exact approved text. Report the link.

## 8. Done

One short wrap-up: PR link, Jira comment link, what the PR watch will handle, and anything left for the user (e.g. a backfill after deploy).

Never put an em dash (the long dash) in the output, commits, PRs or comments. Use a comma, colon, full stop or brackets instead.
