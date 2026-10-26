#!/usr/bin/env bash
#
# Rename the agent-shell buffer this process runs under to
# "Agent@<project>(<ticket-id>): <subject>".
#
# Usage: rename.sh [--branch <name>] <subject>
set -euo pipefail

branch=""
if [[ "${1:-}" == "--branch" ]]; then
  branch="${2:?--branch needs a value}"
  shift 2
fi
subject="${1:?usage: rename.sh [--branch <name>] <subject>}"

branch="${branch:-$(git branch --show-current)}"
ticket=$(grep -oE '[A-Za-z][A-Za-z0-9]+-[0-9]+' <<<"$branch" | head -n1 | tr '[:lower:]' '[:upper:]' || true)
[[ -n "$ticket" ]] || { echo "no ticket id in branch '$branch'" >&2; exit 1; }

# Name the project after the main checkout, so worktrees do not rename it.
common_dir=$(cd "$(git rev-parse --git-common-dir)" && pwd -P)
project=$(basename "$(dirname "$common_dir")")

# This process and all its ancestors; one of them is the agent-shell ACP client.
pids=""
pid=$$
while [[ "$pid" -gt 1 ]]; do
  pids+="$pid "
  pid=$(ps -o ppid= -p "$pid" | tr -d ' ')
  [[ -n "$pid" ]] || break
done

# Pass data as an elisp string literal and let `read' parse it, so quotes in the subject are safe.
elisp_string() { printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/^/"/' -e 's/$/"/'; }

emacsclient -e "(let* ((pids (mapcar #'string-to-number (split-string $(elisp_string "$pids"))))
       (buf (seq-find
             (lambda (b)
               (with-current-buffer b
                 (and (derived-mode-p 'agent-shell-mode)
                      (when-let ((proc (ignore-errors
                                         (map-nested-elt agent-shell--state '(:client :process)))))
                        (memq (process-id proc) pids)))))
             (buffer-list))))
  (if buf
      (with-current-buffer buf
        (rename-buffer (format \"Agent@%s(%s): %s\" $(elisp_string "$project") $(elisp_string "$ticket") $(elisp_string "$subject")) t))
    (error \"no agent-shell buffer found for this process\")))"
