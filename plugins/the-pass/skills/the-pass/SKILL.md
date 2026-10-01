---
name: the-pass
description: Independent review of an open pull request, then fix, verify and report. A fresh reviewer agent (no knowledge of how the change was written) reviews the PR, every valid finding gets fixed, tested and pushed to the PR's branch, a re-review confirms it, the change is run in the sandbox (app run or browser walkthrough), and a verdict comment is posted on the PR. If the PR belongs to a Jira ticket, a ticket comment is drafted and posted only after the user's "post it". Use only when the user invokes /the-pass by name, e.g. "/the-pass 42" or "/the-pass" for the current branch's PR.
disable-model-invocation: true
---

# /the-pass [PR number or link]

Every plate gets checked before it goes out. Running this command is the user's go-ahead to commit and push review fixes **to this PR's branch** and to post one verdict comment on the PR. A Jira comment is only drafted; it is posted after the user replies "post it". Nothing else.

## Hard rules

- Only push to the PR's own head branch. Never to the default branch, never force-push, never merge, never approve.
- If the PR is closed or merged, or its branch can't be pushed to from here, review and report only: post the verdict but don't push fixes.
- Never skip, delete or weaken a test. Never run writes against a database or touch production data.
- Follow the user's CLAUDE.md for commit message style and anything more specific.

## 1. Find the PR

Use the number or link given; otherwise the open PR for the current branch. Read its title, base and head branch, and state. Check out the head branch and pull it, so the working tree matches the PR exactly. Stop if there are uncommitted local changes that are not part of the PR, and tell the user.

## 2. Independent review

Spawn `the-pass:inspector` with only: the repo, the PR number, and the base and head branch names. Do **not** pass it your own reasoning, the ticket summary you already know, or why the change was made. Its independence is the point.

## 3. Fix

For each finding:
- **Valid:** fix it, majors first, then minors, then nits. Keep fixes inside the PR's scope.
- **Not valid** (you can show it is wrong from the code, or fixing it is out of scope for this PR): don't change anything; note the reason. Never dismiss a major without evidence.

Then run the repo's tests (and build or lint if cheap). If tests fail because of a fix, fix that too.

## 4. Push

Commit the fixes as one commit (e.g. `fix(data160): address review findings`, following CLAUDE.md title style) and push to the PR's head branch.

## 5. Re-check (once)

If anything major or minor was fixed, spawn `the-pass:inspector` again on the updated PR (same minimal input). Fix anything new and valid, run tests, push. At most 2 review rounds in total; whatever is left goes into the verdict as open.

## 6. Verify it actually works

After the review rounds, prove the change works in this sandbox, not only in tests:
- Use the `run` skill. It looks for a project verify or run skill first, then launches the app by project type.
- **App with a web UI:** walk through the screens the PR touches in a real browser (Playwright; Chromium is preinstalled in cloud sessions) and take a screenshot as evidence.
- **Pipeline, CLI or service:** run the affected command or job in a dry-run or read-only mode, against fixtures, samples or read-only staging data, and check the output covers the bug's case (e.g. the fixed record now matches).
- Never write to a real database or use production data.
- If verification finds a problem, fix it, run the tests, push, and include it in the verdict.
- If the app can't run here (missing secrets, no database access), say exactly what blocked it and the command the user should run instead.

## 7. Post the verdict on the PR

One comment, in this shape:

> **Independent review: <Approved | Approved after fixes | Needs attention>**
>
> <One or two plain-English sentences: what was checked and the outcome.>
>
> | # | Severity | Finding | Status |
> |---|---|---|---|
> | 1 | major | `file:line` short description | Fixed in `<short sha>` |
> | 2 | nit | `file:line` short description | Not changed: <reason> |
>
> **Tests:** <command> passed (or what failed)
> **Verified:** <what was run or walked through, and what it showed, or why it couldn't run here>
> **Review rounds:** <1 or 2>, reviewer had no context beyond the PR

Use **Approved** when there were no findings, **Approved after fixes** when everything valid is fixed and tests pass, and **Needs attention** when anything major is still open, tests or verification fail, or fixes could not be pushed. If verification could not run here, say so in the verdict; it can still be Approved if the reason is stated.

## 8. Tell the user

PR link, the verdict, the fix commit, what verification showed (attach the screenshot if there is one), and anything still open that needs a human. Then do step 9.

## 9. Jira comment (if the PR belongs to a ticket)

Skip this step when `/the-pass` was run from inside `/let-it-cook`; that skill drafts its own Jira comment.

1. Look for a ticket key in the PR title, branch name or description: an explicit key like `DATA-155`, or the lowercase form in a title or branch like `fix(data155)` or `fix/data155` (which means DATA-155). No key found: skip this step.
2. Draft the comment with `let-it-cook:jira-clerk` (`draft <KEY>`, kind: fix), giving it the facts: root cause and fix (from the PR description and diff), PR link and title, tests, the review verdict and findings, what verification showed, and follow-up after deploy. If that agent isn't installed, draft it yourself in the same shape: a 3 to 4 sentence plain-English summary for a manager, then short technical-details bullets.
3. Show the draft and end with: **Reply "post it" to post this on <KEY>, or tell me what to change.** Wait.
4. After "post it", post it (`let-it-cook:jira-clerk` with `post <KEY>` and the exact approved text, or the Atlassian tools). Report the link. Don't change the ticket's status here.

Never put an em dash (the long dash) in the output, commits or the PR comment. Use a comma, colon, full stop or brackets instead.
