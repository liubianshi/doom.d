;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Liubianshi"
      user-mail-address "liu.bian.shi@gmail.com"
      ;org-directory (or (getenv "ORG_LIB") "~/Documents/Writing/Note-Org/")
      org-directory "~/Documents/Writing/"
      +lbs/bibtex-lib (or (getenv "BIBTEX_LIB") "~/Documents/paper_ref.bib")
      +lbs/pdf-paper-lib (expand-file-name "Zotero/AttachStorage/" (getenv "NUTSTORE"))
)
(setq doom-localleader-key ";"
      doom-localleader-alt-key "M-;")
(setq select-enable-clipboard t
      select-enable-primary t)

(setq auto-mode-alist
      (append
       '(("\\.\\(?:a?do\\|smcl\\)\\'" . ado-mode))
       auto-mode-alist))

;; 网络代理
(setq url-gateway-method 'socks)
(setq socks-server '("Default server" "127.0.0.1" 1081 5))

;; 加载其自定义文件
(load! "+basic")
(load! "+window")
(load! "+functions")
(load! "+rime")
(load! "+evil-pinyin")
(load! "+org")
(load! "+fasd")
(load! "+org-ref")
(load! "+deft")
(load! "+anki")
(load! "+ess")
(load! "+stata")
(load! "+projectile")
(load! "+markdown")
(load! "+fold.el")
(load! "+ivy-bibtex")
(load! "+org-roam")
(load! "+org-roam-bibtex")
(load! "+bindings")


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
