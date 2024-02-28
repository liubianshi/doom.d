;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(defconst IS-MAC (eq system-type 'darwin))

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Liubianshi"
      user-mail-address "liu.bian.shi@gmail.com"
      ;org-directory (or (getenv "ORG_LIB") "~/Documents/Writing/Note-Org/")
      ; citar-bibliography '("~/Documents/paper_ref.bib")
      org-directory "~/Documents/Writing/"
      +lbs/bibtex-lib "~/Documents/paper_ref.bib"
      +lbs/pdf-paper-lib (expand-file-name "Zotero/AttachStorage/" (getenv "NUTSTORE"))
)
(setq doom-localleader-key ";"
      doom-localleader-alt-key "M-;")
(setq select-enable-clipboard t
      select-enable-primary t)

(setq auto-mode-alist
      (append
       '(("\\.\\(?:a?do\\|smcl\\)\\'" . ado-mode)
         ("\\.vim\\(rc\\)?\\'" . vimrc-mode))
       auto-mode-alist))

;; 网络代理
;; (setq url-gateway-method 'socks)
;; (setq socks-server '("Default server" "127.0.0.1" 10800 5))

;; 加载其自定义文件
(load! "+basic")
(load! "+window")
(load! "+functions")
(load! "+rime")
;; (load! "+evil-pinyin")
(load! "+org")
(load! "+fasd")
;;(load! "+org-ref")
(load! "+deft")
(load! "+anki")
(load! "+ess")
(load! "+stata")
(load! "+projectile")
(load! "+markdown")
(load! "+fold.el")
;; (load! "+ivy-bibtex")
(load! "+org-roam2")
;;(load! "+org-roam-bibtex")
(load! "+company")
(load! "+bindings")
(load! "+translate")
;; (load! "+youdao")
(load! "+citar")

(use-package! pangu-spacing
  :init
  (add-hook 'org-mode-hook
            #'(lambda ()
               (set (make-local-variable
                     'pangu-spacing-real-insert-separtor) t)))
  :config
  (global-pangu-spacing-mode 1)
)

;; 使用普通方法设置行高时没有效果，需要使用这种方法
(setq-default global-hl-line-modes nil)
(hl-line-mode -1)
(defun set-bigger-spacing ()
  (setq-local default-text-properties '(line-spacing 0.2 line-height 1.2)))
(add-hook 'text-mode-hook 'set-bigger-spacing)
(add-hook 'prog-mode-hook 'set-bigger-spacing)

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
