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
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
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

(setq lsp-enable-file-watchers nil)
(setq lsp-elixir-suggest-specs nil)
(setq lsp-elixir-enable-test-lenses nil)
(setq lsp-elixir-ls-version "v0.17.4")
(setq lsp-elixir-ls-download-url "https://github.com/elixir-lsp/elixir-ls/releases/download/v0.17.4/elixir-ls-v0.17.4.zip")

;; Somehow LSP formatting opens a pop-up on file errors and never closes it :/ let's stick to mix format
;;(setq-hook! 'elixir-mode-hook +format-with-lsp nil)

;; Get nice diffs for dooms example config files
;; for comparison on what changed after an update
;;
;; SPC h d i -> diff the init.el
;; SPC h d c -> diff the config.el
(defun doom/ediff-init-and-example ()
  "ediff the current `init.el' with the example in doom-emacs-dir"
  (interactive)
  (ediff-files (concat doom-user-dir "init.el")
               (concat doom-emacs-dir "templates/init.example.el")))
(define-key! help-map "di"   #'doom/ediff-init-and-example)
(defun doom/ediff-config-and-example ()
  "ediff the current `config.el' with the example in doom-emacs-dir"
  (interactive)
  (ediff-files (concat doom-user-dir "config.el")
               (concat doom-emacs-dir "templates/config.example.el")))
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

