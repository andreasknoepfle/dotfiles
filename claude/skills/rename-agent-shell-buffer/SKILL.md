---
name: rename-agent-shell-buffer
description: Rename the Emacs agent-shell buffer this session runs in to "Agent@<project>(<ticket-id>): <subject>". Use right after a new git branch whose name contains a Jira ticket id (e.g. TC-1928-read-only-mode) is created or checked out (git checkout -b, git switch -c, git worktree add, gh pr checkout), or when the user asks to rename the agent shell buffer.
---

# Rename agent-shell buffer

Gives the Emacs agent-shell buffer you are running in a readable name once work on a Jira ticket starts, e.g.

    Agent@taxcore-backend(TC-1928): Expand read-only mode

## When to run

Run it after you create or switch to a branch whose name contains a Jira ticket id (`[A-Z][A-Z0-9]+-[0-9]+`, e.g. `TC-1928-expand-read-only-mode`). Do it as a quiet side step and do not ask first. Skip it if the branch has no ticket id.

## Steps

1. Work out the subject.
   - If an Atlassian/Jira tool is available and authenticated, use the ticket's summary.
   - Otherwise use the branch name: drop the ticket id, turn `-`/`_` into spaces, capitalise the first word.
   - Shorten to about 5 words. The buffer name should stay scannable.
2. Run the helper from the repository the branch lives in:

   ```sh
   ~/.claude/skills/rename-agent-shell-buffer/rename.sh "<subject>"
   ```

   The script reads the branch and project name from git and derives the ticket id. Pass `--branch <name>` to override the branch, for example right after `git worktree add` when your cwd is still on another branch.
3. Report the new buffer name in one line. If the script fails, say so and do not retry in a loop.

## How it works

`rename.sh` walks up its own process ancestry and asks the running Emacs server (via `emacsclient`) for the agent-shell buffer whose ACP client process is one of those ancestors. That identifies the buffer this session runs in even when several agent shells share the same project. It then calls `rename-buffer` with `UNIQUE` set, so a clash gets a `<2>` suffix.

It fails with a message when there is no Emacs server, or when the session is not running under agent-shell (e.g. a plain terminal).
