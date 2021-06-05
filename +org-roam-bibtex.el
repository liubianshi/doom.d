;;; $DOOMDIR/+org-roam-bibtex.el -*- lexical-binding: t; -*-
(use-package! org-roam-bibtex
  :after (org-roam)
  :load-path (+lbs/bibtex-lib)
  :hook (org-roam-mode . org-roam-bibtex-mode)
  :bind (:map org-mode-map
         (("C-c n a" . orb-note-actions)))
  :config
  (setq orb-templates
        '(("r" "ref" plain (function org-roam-capture--get-point) ""
           :file-name "PaperNote/${citekey}"
           :head "#+TITLE: ${citekey}: ${title}\n#+ROAM_KEY: ${ref}\n"
           :unnarrowed t)))
  (setq org-roam-bibtex-preformat-keywords '("=key=" "title" "url" "file" "author-or-editor" "keywords"))
  (setq orb-preformat-keywords '(("citekey" . "=key=") "title" "url" "file" "author-or-editor" "keywords"))
  )

(setq orb-templates
      '(("n" "ref+noter" plain (function org-roam-capture--get-point)
         ""
         :file-name "${slug}"
         :head "#+TITLE: ${citekey}: ${title}\n#+ROAM_KEY: ${ref}\n#+ROAM_TAGS:

- tags ::
- keywords :: ${keywords}
\* ${title}
:PROPERTIES:
:Custom_ID: ${citekey}
:URL: ${url}
:AUTHOR: ${author-or-editor}
:NOTER_DOCUMENT: %(orb-process-file-field \"${citekey}\")
:NOTER_PAGE:
:END:")))
