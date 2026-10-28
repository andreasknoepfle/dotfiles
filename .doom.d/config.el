;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Andreas Knöpfle"
      user-mail-address "andreas.knoepfle@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:

(setq doom-font (font-spec :family "Fira Code" :size 17 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 17))

;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-molokai)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Make right option usable for osx features
;; This allows to write german umlauts
(setq-default mac-right-option-modifier nil)

;; set localleader (mode key) to ,
(setq doom-localleader-key ",")

;; start maximized
(add-hook 'window-setup-hook #'toggle-frame-maximized)

;; Define some directores
(setq projectile-project-search-path '(("~/repos" . 2)))

(setq deft-directory "~/notes")

;; Go tools (dlv, gopls, ...) live in ~/go/bin. Emacs started from the GUI
;; doesn't read .zshrc and Doom's env file only has them if `doom sync' ran in
;; a shell that did, so add the directory ourselves.
(let ((gobin (expand-file-name "go/bin" "~")))
  (add-to-list 'exec-path gobin)
  (setenv "PATH" (concat gobin path-separator (getenv "PATH"))))

;; Disables auto formatting for ruby
(setq +format-on-save-enabled-modes
      '(not ruby-mode
        js2-mode
        rjsx-mode
        js-mode))

;; Get nice diffs for dooms example config files
;; for comparison on what changed after an update
;;
;; SPC h d i -> diff the init.el
;; SPC h d c -> diff the config.el
(defun doom/ediff-init-and-example ()
  "ediff the current `init.el' with the example in doom-emacs-dir"
  (interactive)
  (ediff-files (concat doom-user-dir "init.el")
               (concat doom-emacs-dir "static/init.example.el")))
(define-key! help-map "di"   #'doom/ediff-init-and-example)
(defun doom/ediff-config-and-example ()
  "ediff the current `config.el' with the example in doom-emacs-dir"
  (interactive)
  (ediff-files (concat doom-user-dir "config.el")
               (concat doom-emacs-dir "static/config.example.el")))
(define-key! help-map "dc"   #'doom/ediff-config-and-example)

;; Copy relative paths
;;
;; SPC f Y
(defun +default/yank-buffer-relative-filename ()
  (interactive)
  (if-let (filename (or buffer-file-name (bound-and-true-p list-buffers-directory)))
      (message (kill-new (file-relative-name filename (projectile-project-root))))
    (error "Couldn't find relative filename in current buffer")))

(map! :leader :desc "Yank buffer relative filename" "f Y" #'+default/yank-buffer-relative-filename)

;; Evil multiedit case sensitivity
;; https://github.com/hlissner/evil-multiedit/issues/48
(defun make-evil-multiedit-case-sensitive (fn &rest args)
  (let ((case-fold-search (not iedit-case-sensitive)))
    (apply fn args)))

(use-package! mise
  :config (global-mise-mode))

(advice-add #'evil-multiedit-match-and-next :around #'make-evil-multiedit-case-sensitive)
(use-package! agent-shell
  :config
  ;; Default `minimal' resumes without replaying messages; show first and last turns.
  (setq agent-shell-session-restore-verbosity 'first-last)
  (map! :leader
        (:prefix ("l" . "agent shell")
         :desc "Start Claude (new buffer)" "c" #'agent-shell-anthropic-start-claude-code
         :desc "New shell"                 "n" #'agent-shell-new-shell
         :desc "New worktree shell"        "w" #'agent-shell-new-worktree-shell
         :desc "Toggle shell"              "t" #'agent-shell-toggle
         :desc "Send dwim"                 "s" #'agent-shell-send-dwim
         :desc "Send region to..."         "R" #'agent-shell-send-region-to
         :desc "Send file"                 "a" #'agent-shell-send-file
         :desc "Send file to..."           "A" #'agent-shell-send-file-to
         :desc "Send screenshot"           "S" #'agent-shell-send-screenshot
         :desc "Send clipboard image"      "i" #'agent-shell-send-clipboard-image
         :desc "Compose prompt"            "p" #'agent-shell-prompt-compose
         :desc "Set model"                 "o" #'agent-shell-set-session-model
         :desc "Cycle mode"                "y" #'agent-shell-cycle-session-mode
         :desc "Interrupt"                 "x" #'agent-shell-interrupt
         :desc "Kill session buffer"       "k" #'kill-current-buffer
         :desc "Restart session"           "r" #'agent-shell-restart)))

(use-package! agent-shell-sidebar
  :after agent-shell
  :config
  (setq agent-shell-sidebar-default-config
        (agent-shell-anthropic-make-claude-code-config))
  (setq agent-shell-anthropic-claude-environment
        (agent-shell-make-environment-variables
         :inherit-env t
         "MCP_TIMEOUT" "5000"))
  (setq agent-shell-sidebar-minimum-width 70)
  (defvar my/agent-shell-sidebar-wide-width "40%"
    "Sidebar width when the frame has no other split.")
  (defun my/agent-shell-sidebar-wide-when-alone (fn)
    "Call FN with a wider sidebar width if no window besides the sidebar exists."
    (let ((agent-shell-sidebar-width
           (if (<= (length (seq-remove (lambda (w) (window-parameter w 'window-side))
                                       (window-list nil 'no-mini)))
                   1)
               my/agent-shell-sidebar-wide-width
             agent-shell-sidebar-width)))
      (funcall fn)))
  (advice-add #'agent-shell-sidebar--calculate-width
              :around #'my/agent-shell-sidebar-wide-when-alone)
  (map! :leader
        :desc "Sidebar toggle"          "l l" #'agent-shell-sidebar-toggle
        :desc "Sidebar focus"           "l f" #'agent-shell-sidebar-toggle-focus
        (:prefix ("l L" . "sidebar actions")
         :desc "Reset"           "r" #'agent-shell-sidebar-reset
         :desc "Change provider" "p" #'agent-shell-sidebar-change-provider)))

(use-package! agent-shell-manager
  :after agent-shell
  :config
  (setq agent-shell-manager-side 'bottom)
  (map! :leader
        :desc "Manager" "l m" #'agent-shell-manager-toggle
        :desc "Delete killed sessions" "l d" #'agent-shell-manager-delete-killed))

;; Keep transcripts out of the project folders: <root>/<project>/<timestamp>.md
(defvar my/agent-shell-transcript-root
  (expand-file-name "agent-shell/transcripts/" "~/.local/share/")
  "Shared directory holding agent-shell transcripts, one subdirectory per project.")

(defun my/agent-shell-transcript-file-path ()
  "Return a new transcript path under `my/agent-shell-transcript-root'."
  (let* ((project (file-name-nondirectory (directory-file-name (agent-shell-cwd))))
         (dir (expand-file-name project my/agent-shell-transcript-root)))
    (make-directory dir t)
    (expand-file-name (format-time-string "%F-%H-%M-%S.md") dir)))

(setq agent-shell-transcript-file-path-function #'my/agent-shell-transcript-file-path)

(defun my/agent-recall-extra-transcript-dirs ()
  "One `agent-recall-extra-transcript-dirs' entry per project under the transcript root."
  (mapcar (lambda (dir)
            (list :dir dir :project (file-name-nondirectory (directory-file-name dir))))
          (when (file-directory-p my/agent-shell-transcript-root)
            (seq-filter #'file-directory-p
                        (directory-files my/agent-shell-transcript-root t "\\`[^.]")))))

(use-package! agent-recall
  :after agent-shell
  :hook (agent-shell-mode . agent-recall-track-sessions)
  :config
  (setq agent-recall-search-paths '("~/repos")
        agent-recall-max-depth 4
        agent-recall-search-function 'consult-ripgrep
        agent-recall-browse-sort 'modified-desc)
  ;; Transcripts live in `my/agent-shell-transcript-root', not in the project
  ;; folders, so recall only finds them via the extra dirs. Refresh the list on
  ;; every reindex to pick up new projects.
  (defun my/agent-recall-refresh-extra-dirs (&rest _)
    (setq agent-recall-extra-transcript-dirs (my/agent-recall-extra-transcript-dirs)))
  (advice-add 'agent-recall-reindex :before #'my/agent-recall-refresh-extra-dirs)
  (my/agent-recall-refresh-extra-dirs)
  (map! :leader
        :desc "Browse transcripts"         "l b" #'agent-recall-browse
        :desc "Browse project transcripts" "l B" #'agent-recall-browse-project
        :desc "Search transcripts"         "l g" #'agent-recall-consult-search
        :desc "Resume past session"        "l h" #'agent-recall-resume))

(setq agent-shell-show-cost-indicator t)

(use-package! agent-shell-gc
  :after agent-shell
  :config
  ;; Kill sessions idle for 8 hours.  Busy, visible, pinned shells and shells with
  ;; unsubmitted prompt text are never collected; transcripts stay resumable.
  (setq agent-shell-gc-idle-session-ttl (* 8 60 60)
        agent-shell-gc-store-file (expand-file-name "agent-shell-gc/state.eld" doom-cache-dir))
  (agent-shell-gc-mode 1)
  (map! :leader
        :desc "Pin / unpin session (gc)" "l K" #'agent-shell-gc-toggle-keep
        :desc "GC session list"          "l G" #'agent-shell-gc-list))

(use-package! agent-shell-macext
  :after agent-shell
  :hook (agent-shell-mode . agent-shell-macext-setup))

(add-hook 'agent-shell-mode-hook #'doom-mark-buffer-as-real-h)

;; Forge: take the GitHub token from the gh CLI instead of ~/.authinfo.
(defun my/ghub-token-from-gh-cli (host _username package &rest _)
  "Return the gh CLI token for forge's github.com requests, else nil.
Returning nil lets ghub fall back to its normal auth-source lookup."
  (when (and (eq package 'forge)
             (member host '("api.github.com" "github.com")))
    (when-let* ((gh (executable-find "gh"))
                (token (string-trim
                        (with-output-to-string
                          (with-current-buffer standard-output
                            ;; Discard stderr so errors never pose as a token.
                            (call-process gh nil '(t nil) nil
                                          "auth" "token" "--hostname" "github.com"))))))
      (unless (string-empty-p token) token))))

(defun my/ghub-username-from-gh-cli (fn host &optional forge)
  "Call FN, falling back to the gh CLI's github.com login when git has no `github.user'."
  (condition-case err
      (funcall fn host forge)
    (error
     (or (and (eq (or forge 'github) 'github)
              (when-let* ((gh (executable-find "gh"))
                          (user (string-trim
                                 (with-output-to-string
                                   (with-current-buffer standard-output
                                     (call-process gh nil '(t nil) nil
                                                   "config" "get" "user" "-h" "github.com"))))))
                (unless (string-empty-p user) user)))
         (signal (car err) (cdr err))))))

(after! ghub
  (advice-add 'ghub--token :before-until #'my/ghub-token-from-gh-cli)
  (advice-add 'ghub--username :around #'my/ghub-username-from-gh-cli))

;; code-review: reuse forge's credentials (and thus the gh CLI token above).
(after! code-review
  (setq code-review-auth-login-marker 'forge)
  ;; code-review still calls `ghub-graphql', which ghub 5 moved to ghub-legacy.
  (require 'ghub-legacy))


;; anvil: MCP server running inside Emacs.  It is registered with Claude Code at
;; user scope (see bin/anvil-mcp and bin/install-mac), so agent-shell and terminal
;; sessions both get it.  The stdio bridge calls `my/anvil-start' through emacsclient
;; when a session starts.  No stop function: all sessions share this Emacs, so one
;; ending must not disable anvil.
(defun my/anvil-start ()
  "Enable anvil and start its MCP server unless they are already running."
  (unless (bound-and-true-p anvil--enabled)
    (anvil-enable))
  (unless (anvil-server-running-p)
    (anvil-server-start))
  "anvil ready")
