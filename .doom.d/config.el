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

;; Nice indentation in some web contexts
(after! editorconfig
  (add-to-list 'editorconfig-indentation-alist '(web-mode-markup-indent-offset web-mode-css-indent-offset web-mode-code-indent-offset)))

;; Disables auto formatting for ruby
(setq +format-on-save-enabled-modes
      '(not ruby-mode
        js2-mode
        rjsx-mode
        js-mode))

;; Make Projectile create missing test files
(after! projectile
  (setq projectile-create-missing-test-files t))

;; ;; Remove spec suggests
;; (setq lsp-elixir-suggest-specs nil)

;; ;; Otherwise we get problems with FDSIZE (not needed since --with-unlimited-select of railwaycat build)
;; (setq lsp-enable-file-watchers nil)

;; ;; (setq lsp-elixir-local-server-command "/Users/andi/bin/elixir-ls/language_server.sh")

;; (with-eval-after-load 'lsp-mode
;;   (add-to-list 'lsp-language-id-configuration
;;     '(elixir-mode . "elixir"))

;;   (lsp-register-client
;;     (make-lsp-client
;;       :new-connection (lsp-stdio-connection '("expert" "--stdio"))
;;                                         ; :major-modes '(elixir-mode)
;;       :priority -1
;;       :activation-fn (lsp-activate-on "elixir")
;;       :server-id 'expert))
;;   )

;; (add-hook 'elixir-mode-hook #'lsp)

;; (with-eval-after-load 'flycheck
;;   (setq-default flycheck-disabled-checkers '(ruby-reek)))

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

;; THE MALTE
;; (remove-hook 'doom-first-input-hook #'evil-snipe-mode)
;; (map! :n "s" #'evil-avy-goto-char)
;; (map! :i "j j" #'evil-force-normal-state)

;; Use nicer iconset in neotre
;; (setq doom-themes-neotree-file-icons t)

;; Evil multiedit case sensitivity
;; https://github.com/hlissner/evil-multiedit/issues/48
(defun make-evil-multiedit-case-sensitive (fn &rest args)
  (let ((case-fold-search (not iedit-case-sensitive)))
    (apply fn args)))

(advice-add #'evil-multiedit-match-and-next :around #'make-evil-multiedit-case-sensitive)

;; (use-package! ellama
;;   :init
;;   (require 'llm-ollama)
;;   (setopt ellama-coding-provider
;;           (make-llm-ollama
;;            :chat-model "devstral:24b"
;;            :embedding-model "nomic-embed-text"
;;            :default-chat-non-standard-params '(("num_ctx" . 32768))))
;;   (setopt ellama-auto-scroll t)
;;   ;; Naming new sessions with llm
;;   (setopt ellama-naming-provider
;;           (make-llm-ollama
;;            :chat-model "llama3.2:3b"
;;            :embedding-model "nomic-embed-text"
;;            :default-chat-non-standard-params '(("stop" . ("\n")))))
;;   (setopt ellama-naming-scheme 'ellama-generate-name-by-llm)
;;   :config
;;   (setq ellama-sessions-directory "~/.config/ellama/.local/cache/ellama-sessions")
;;   ;; show ellama context in header line in all buffers
;;   (ellama-context-header-line-global-mode +1)
;;   ;; show ellama session id in header line in all buffers
;;   (ellama-session-header-line-global-mode +1)
;;   (map! :leader
;;         (:prefix-map ("e" . "Ellama")
;;          :desc "Open" "o" 'ellama
;;          :desc "Write" "w" 'ellama-write
;;          :desc "Proofread" "P" 'ellama-proofread
;;          (:prefix ("c" . "Code")
;;           :desc "Code complete" "c" 'ellama-code-complete
;;           :desc "Add code" "a" 'ellama-code-add
;;           :desc "Edit code" "e" 'ellama-code-edit
;;           :desc "Improve code" "i" 'ellama-code-improve
;;           :desc "Review code" "r" 'ellama-code-review
;;           :desc "Commit message" "m" 'ellama-generate-commit-message
;;           )
;;          (:prefix ("s" . "Summarize")
;;           :desc "Summarize" "s" 'ellama-summarize
;;           :desc "Webpage summary" "w" 'ellama-summarize-webpage
;;           :desc "Killring summary" "c" 'ellama-summarize-killring
;;           :desc "Load session" "l" 'ellama-load-session
;;           :desc "Rename session" "r" 'ellama-session-rename
;;           :desc "Delete session" "d" 'ellama-session-delete
;;           :desc "Activate session" "a" 'ellama-session-switch
;;           )
;;          (:prefix ("i" . "Improve")
;;           :desc "Improve wording" "w" 'ellama-improve-wording
;;           :desc "Grammar and spelling improvement" "g" 'ellama-improve-grammar
;;           :desc "Conciseness improvement" "c" 'ellama-improve-conciseness
;;           )
;;          (:prefix ("m" . "Make")
;;           :desc "Create list" "l" 'ellama-make-list
;;           :desc "Create table" "t" 'ellama-make-table
;;           :desc "Create format" "f" 'ellama-make-format
;;           )
;;          (:prefix ("a" . "Ask")
;;           :desc "Ask about topic" "a" 'ellama-ask-about
;;           :desc "Interactive chat" "i" 'ellama-chat
;;           :desc "Ask current line" "l" 'ellama-ask-line
;;           :desc "Ask selected text" "s" 'ellama-ask-selection
;;           )
;;          (:prefix ("t" . "Translate")
;;           :desc "Translate text" "t" 'ellama-translate
;;           :desc "Translate buffer" "b" 'ellama-translate-buffer
;;           :desc "Enable translation" "e" 'ellama-chat-translation-enable
;;           :desc "Disable translation" "d" 'ellama-chat-translation-disable
;;           :desc "Text completion" "c" 'ellama-complete
;;           )
;;          (:prefix ("d" . "Define")
;;           :desc "Define word" "w" 'ellama-define-word
;;           )
;;          (:prefix ("x" . "Context")
;;           :desc "Add buffer to context" "b" 'ellama-context-add-buffer
;;           :desc "Add file to context" "f" 'ellama-context-add-file
;;           :desc "Add directory to context" "d" 'ellama-context-add-directory
;;           :desc "Add selection to context" "s" 'ellama-context-add-selection
;;           :desc "Add info node to context" "i" 'ellama-context-add-info-node
;;           :desc "Reset context" "r" 'ellama-context-reset
;;           )
;;          (:prefix ("p" . "Provider")
;;           :desc "Select provider" "s" 'ellama-provider-select)
;;          )
;;         )
;;   )


;; (after! lsp-mode
;;   (add-to-list 'lsp-language-id-configuration '(ruby-mode . "ruby"))

;;   ;; Tell LSP to use ruby-lsp instead of solargraph  ;; Tell LSP to use ruby-lsp directly (no bundle exec)
;;   ;; (lsp-register-client
;;   ;;  (make-lsp-client
;;   ;;   :new-connection (lsp-stdio-connection '("ruby-lsp"))
;;   ;;   :major-modes '(ruby-mode enh-ruby-mode)
;;   ;;   :priority 1
;;   ;;   :server-id 'ruby-lsp)))

;;   (lsp-register-client
;;    (make-lsp-client
;;     :new-connection (lsp-stdio-connection '("ruby-lsp"))
;;     :major-modes '(ruby-mode enh-ruby-mode)
;;     :priority 1
;;     :server-id 'ruby-lsp
;;     :initialization-options (lambda ()
;;                               '(:formatter "stree")))))

;; ;; Directly
;; (require 'mise)

;; ;; enable globally
;; (add-hook 'after-init-hook #'global-mise-mode)

;; (define-derived-mode astro-mode web-mode "astro")
;; (setq auto-mode-alist
;;       (append '((".*\\.astro\\'" . astro-mode))
;;               auto-mode-alist))

;; (setenv "CC" "clang")
;; (setenv "CXX" "clang++")

;; (add-to-list 'exec-path "/Users/andi/go/bin")
;; (setenv "PATH" (concat "/Users/andi/go/bin:" (getenv "PATH")))

;; (add-to-list 'auto-mode-alist '("\\.templ\\'" . templ-ts-mode))
;; (after! lsp-mode
;;   (add-to-list 'lsp-language-id-configuration
;;                '(templ-ts-mode . "templ"))

;;   (lsp-register-client
;;    (make-lsp-client
;;     :new-connection
;;     (lsp-stdio-connection
;;      '("go" "tool" "templ" "lsp"))
;;     :activation-fn (lsp-activate-on "templ")
;;     :server-id 'templ-ls
;;     :priority 1)))

;; (after! treesit
;;   (setq treesit-language-source-alist
;;         '((go "https://github.com/tree-sitter/tree-sitter-go")
;;           (templ "https://github.com/vrischmann/tree-sitter-templ"))))

(use-package! claude-code
  :config
  (setq claude-code-terminal-backend 'vterm)
  (map! :leader
        :prefix ("l" . "llm")
        :desc "Start Claude Code"      "c" #'claude-code
        :desc "Claude menu"            "t" #'claude-code-transient
        :desc "Send prompt"            "s" #'claude-code-send-command
        :desc "Send with file/line"    "x" #'claude-code-send-command-with-context
        :desc "Send region/buffer"     "r" #'claude-code-send-region
        :desc "Send current file"      "o" #'claude-code-send-buffer-file
        :desc "Fix error at point"     "e" #'claude-code-fix-error-at-point
        :desc "Switch to Claude"       "b" #'claude-code-switch-to-buffer
        :desc "Toggle read-only"       "z" #'claude-code-toggle-read-only-mode
        :desc "Kill session"           "k" #'claude-code-kill))
