## File editing

Prefer Anvil MCP tools over the built-in Read/Edit/Write
whenever they apply. They ship only the delta, batch multiple
edits in one round trip, and avoid full-file reads.

The tools come from the `anvil-emacs-eval` MCP server, so they appear
as `mcp__anvil-emacs-eval__<tool>`. They are deferred: load the schemas
with ToolSearch (e.g. `select:mcp__anvil-emacs-eval__file-batch`) before
the first call.

At the start of any session that will read or edit files, before the
first file operation, load the core set in one call:
`ToolSearch select:mcp__anvil-emacs-eval__file-read,mcp__anvil-emacs-eval__file-outline,mcp__anvil-emacs-eval__file-batch,mcp__anvil-emacs-eval__file-replace-string,mcp__anvil-emacs-eval__file-replace-regexp,mcp__anvil-emacs-eval__file-insert-at-line,mcp__anvil-emacs-eval__file-delete-lines,mcp__anvil-emacs-eval__file-append`.
Do not fall back to the built-in Read/Edit/Write just because the
schemas are not loaded yet. If the Anvil call fails (e.g. Emacs is not
running), say so and then use the built-ins.

- `file-batch` — 3+ edits to the same file (collapse into one call)
- `file-replace-string` / `file-replace-regexp` —
  pinpoint replacement; no need to read the whole file first
- `file-insert-at-line` / `file-delete-lines` /
  `file-append` — localized line-level operations

Use the built-in `Edit` only for small one-off changes. For 3 or
more edits to the same file, always use `file-batch`.
