;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Liubianshi"
      user-mail-address "liu.bian.shi@gmail.com")

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
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
(setq doom-font (font-spec :family "FiraCode Nerd Font Mono" :size 28)
      doom-variable-pitch-font (font-spec :family "FiraCode Nerd Font Mono" :size 28)
      doom-unicode-font (font-spec :family "Sarasa Fixed SC" :size 28)
      doom-serif-font (font-spec :family "Sarasa Fixed SC" :size 28)
      doom-big-font (font-spec :family "Sarasa Fixed SC" :size 28))
(add-to-list 'doom-unicode-extra-fonts "Sarasa Fixed SC" t)

;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dracula)
(setq initial-major-mode 'org-mode)
(setq display-line-numbers-type 'relative)
(setq-default cursor-type 'bar)
(setq doom-fallback-buffer-name "► Doom"
      +doom-dashboard-name "► Doom")

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type `relative)


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
;;
;;
(setq default-input-method "rime")
(setq-default line-spacing 14)
(setq confirm-kill-emacs nil)

;; rime
(setq rime-show-candidate 'posframe)
(setq rime-posframe-style 'vertical)
(setq rime-posframe-properties
      (list :font "sarasa fixed sc-14"
            :background-color "#333333"
            :foreground-color "#dcdccc"
            :internal-border-width 6))
(setq rime-user-data-dir "~/.local/share/fcitx5/rime")
(setq rime-inline-ascii-holder nil)
(setq rime-disable-predicates
      '(rime-predicate-evil-mode-p
        rime-predicate-prog-in-code-p
        rime-predicate-current-uppercase-letter-p
        rime-predicate-punctuation-line-begin-p
        rime-predicate-after-alphabet-char-p
        rime-predicate-space-after-cc-p
        rime-predicate-punctuation-after-space-cc-p
        rime-predicate-tex-math-or-command-p))
(map! :desc "Toggle Input Method" "<f12>" #'toggle-input-method)
(map! :map rime-active-mode-map "<tab>" #'rime-inline-ascii)


;; org-mode
(use-package! org-roam
  :commands (org-roam-insert org-roam-find-file org-roam)
  :init
  (setq org-roam-directory "~/Repositories/roam")
  (setq org-roam-graph-viewer "/usr/bin/xdg-open")
  (map! :leader
  :prefix "r"
  :desc "Org-Roam-Insert" "i" #'org-roam-insert
  :desc "Org-Roam-Find"   "/" #'org-roam-find-file
  :desc "Org-Roam-Buffer" "r" #'org-roam)
  :config
  (org-roam-mode +1))
(add-hook 'after-init-hook 'org-roam-mode)

(setq doom-localleader-key ";")
(setq doom-localleader-alt-key "M-;")

;; markdown
(setq grip-preview-use-webkit t)
(add-to-list 'auto-mode-alist '("\\.Rmd\\'" . poly-markdown+r-mode))

;; elang
(setq elfeed-feeds
      '("https://this-week-in-rust.org/rss.xml"
        "http://feeds.bbci.co.uk/news/rss.xml"))
