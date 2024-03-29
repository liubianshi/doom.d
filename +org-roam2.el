;;; $DOOMDIR/+org-roam2.el -*- lexical-binding: t; -*-

;; org-roam 配置 {{{
(use-package! org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory (expand-file-name "roam" org-directory))
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
     '(("d" "default" plain "%?"
        :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
        :unnarrowed t)
       ("k" "Question Resolved" plain "%?"
        :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: :Question:%^{QuestionType}")
        :unnarrowed t)
       ("s" "Software Note" plain "%?"
        :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: %^{Software}")
        :unnarrowed t)
       ("r" "bibliography reference" plain
         (file "~/.doom.d/templates/org-roam-ref.org")
         :target
         (file+head "references/${citekey}.org" "#+title: ${title}\n#+filetags: Ref\n\n")
         :unnarrowed t)
       ("n" "Research Note" plain "%?"
        :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: ResearchNote")
        :unnarrowed t)
       ))
  (org-roam-capture-ref-templates
   '(("c" "Clipboard" plain "* %^{heading} %t\n%[/tmp/org/roam-capture.org]\n\n%?"
     :target (file+head "Digest/%<%Y%m%d>-${slug}.org" "#+title: ${title}")
     :unnarrowed t)
     ("a" "Annotation" plain "* %^{heading} %t\n${body}\n\n"
     :target (file+head "Digest/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}")
     :immediate-finish t
     :unnarrowed t)))
  :config
  (map! :leader
        :prefix "r"
        :desc "Org-Roam-Node-Find"     "f" #'org-roam-node-find
        :desc "Org-Roam-graph"         "g" #'org-roam-graph
        :desc "Org-Roam-Node-Insert"   "i" #'org-roam-node-insert
        :desc "Org-Roam-Capture"       "c" #'org-roam-capture
        :desc "Org-Roam-Buffer-Toggle" "l" #'org-roam-buffer-toggle
        :desc "Org-Roam-Daily-Capture-Today" "j" #'org-roam-dailies-capture-today)
  (setq org-roam-tag-sources '(vanilla last-directory)
        org-roam-graph-viewer "/usr/bin/xdg-open"
        org-roam-verbose nil
        org-roam-completion-system 'default)
  (add-hook 'org-roam-buffer-prepare-hook #'hide-mode-line-mode)
  (add-hook 'org-mode-hook #'valign-mode)
  (require 'org-roam-protocol)
  (require 'org-roam-dailies)
  (org-roam-db-autosync-mode)
  )

;; org-roam-jounal 配置
(setq org-roam-dailies-capture-templates
      '(("d" "default" entry "* %<%I:%M %p>: %?"
         :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))))

;; }}}
;; org-roam-ui 相关配置  {{{
(use-package! websocket
    :after org-roam)

;; org-roam-ui 的官网：https://github.com/org-roam/org-roam-ui
(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))
;; }}}
;; org-roam-bibtex 配置 {{{
;; (use-package! org-roam-bibtex
;;   :after org-roam
;;   :custom
;;   (orb-insert-interface 'ivy-bibtex)
;;   :config
;;   (setq orb-preformat-keywords '("citekey" "title" "url" "author-or-editor" "keywords" "file")
;;         orb-process-file-keyword t
;;         orb-insert-link-description 'citation
;;         orb-file-field-extensions '("pdf"))
;;   (require 'org-ref)) ; optional: if Org Ref is not loaded anywhere else, load it here
;; }}}
