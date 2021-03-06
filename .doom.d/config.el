;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Andreas Knöpfle"
      user-mail-address "andreas.knoepfle@gmail.com")


;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Fira Code" :size 17)
      doom-variable-pitch-font (font-spec :family "Fira Sans"))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-snazzy)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
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
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Make right option usable for osx features
;; This allows to write german umlauts
(setq-default mac-right-option-modifier nil)

;; define command to switch between implementation and test to be on
;; SPC a
(map! :leader :desc "Toggle between implementation and test" "a" #'projectile-toggle-between-implementation-and-test)

;; set localleader (mode key) to ,
(setq doom-localleader-key ",")

;; start maximized
(add-hook 'window-setup-hook #'toggle-frame-maximized)

;; Using .editorconfig now
;; tab width
;; (setq tab-width 2)
;; ; Proper indents in web mode
;; (after! web-mode
;;  (setq web-mode-markup-indent-offset 2
;;        web-mode-css-indent-offset 2
;;        web-mode-code-indent-offset 2))
;;

;; Disables auto formatting for ruby
(setq +format-on-save-enabled-modes
      '(not ruby-mode  ; uses rufo :/
            ))

;; Make Projectile create missing test files and some nice config
;; that works better with non rspec projects
(after! projectile
  (setq projectile-create-missing-test-files t)

  ;; Ruby
  (projectile-register-project-type 'ruby-rspec '("Gemfile" "lib" "spec")
                                    :project-file "Gemfile"
                                    :compile "bundle exec rake"
                                    :src-dir "lib/"
                                    :test "bundle exec rspec"
                                    :test-dir "spec/"
                                    :test-suffix "_spec")

  (projectile-register-project-type 'ruby-test '("Gemfile" "lib" "test")
                                    :project-file "Gemfile"
                                    :compile "bundle exec rake"
                                    :src-dir "lib/"
                                    :test "bundle exec rake test"
                                    :test-suffix "_test")

  (projectile-register-project-type 'rails-test '("Gemfile" "app" "lib" "db" "config" "test")
                                    :project-file "Gemfile"
                                    :compile "bundle exec rails server"
                                    :src-dir "app/"
                                    :test "bundle exec rake test"
                                    :test-suffix "_test")

  (projectile-register-project-type 'rails-rspec '("Gemfile" "app" "lib" "db" "config" "spec")
                                    :project-file "Gemfile"
                                    :compile "bundle exec rails server"
                                    :src-dir "app/"
                                    :test "bundle exec rspec"
                                    :test-dir "spec/"
                                    :test-suffix "_spec"))

;; Better support for umbrella project. Better use .git than mix.exs
;; Probably there is a better way, but this does the trick for now.
(after! projectile
  (setq projectile-project-root-files (delete "mix.exs" projectile-project-root-files)))

(setq lsp-enable-file-watchers nil)

;; Get nice diffs for dooms example config files
;; for comparison on what changed after an update
;;
;; SPC h d i -> diff the init.el
;; SPC h d c -> diff the config.el
(defun doom/ediff-init-and-example ()
  "ediff the current `init.el' with the example in doom-emacs-dir"
  (interactive)
  (ediff-files (concat doom-private-dir "init.el")
               (concat doom-emacs-dir "init.example.el")))
(define-key! help-map "di"   #'doom/ediff-init-and-example)
(defun doom/ediff-config-and-example ()
  "ediff the current `config.el' with the example in doom-emacs-dir"
  (interactive)
  (ediff-files (concat doom-private-dir "config.el")
               (concat doom-emacs-dir "core/templates/config.example.el")))
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
