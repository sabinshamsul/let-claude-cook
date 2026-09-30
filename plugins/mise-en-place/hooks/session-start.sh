#!/bin/bash
# Build the graphify code graph in the background and tell Claude to use it first.
# Does nothing if graphify is missing or the folder is not a git repo.
export PATH="$HOME/.local/bin:$PATH"
command -v graphify >/dev/null 2>&1 || exit 0
cd "${CLAUDE_PROJECT_DIR:-$PWD}" 2>/dev/null || exit 0
git rev-parse --git-dir >/dev/null 2>&1 || exit 0

# Keep graphify-out/ out of git on this machine only (never touches .gitignore).
exclude="$(git rev-parse --git-path info/exclude)"
mkdir -p "$(dirname "$exclude")"
grep -qsx 'graphify-out/' "$exclude" || echo 'graphify-out/' >> "$exclude"

# Code only, no LLM. Runs detached so the session starts straight away.
nohup graphify update . </dev/null >/dev/null 2>&1 &

cat <<'MSG'
Code graph: graphify-out/graph.json (being refreshed in the background, usually ready within a minute).
Before reading files to answer a question about this code, use `graphify query "<question>"`, `graphify explain "<symbol>"` or `graphify path "<A>" "<B>"`, then open only the files it points to. If the graph is missing or looks stale, fall back to normal search.
MSG
