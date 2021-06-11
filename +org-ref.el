;;; $DOOMDIR/+org-ref.el -*- lexical-binding: t; -*-
(use-package! org-ref
    :config
    (setq
         org-ref-notes-directory org-directory
         org-ref-default-bibliography (list +lbs/bibtex-lib)
         org-ref-bibliography-notes (expand-file-name "paper-note.org" org-directory)
         org-ref-pdf-directory +lbs/pdf-paper-lib
         org-ref-completion-library 'org-ref-ivy-cite-completion
         org-ref-get-pdf-filename-function 'org-ref-get-pdf-filename-helm-bibtex
         org-ref-note-title-format "* TODO %y - %t\n :PROPERTIES:\n  :Custom_ID: %k\n  :NOTER_DOCUMENT: %F\n :ROAM_KEY: cite:%k\n  :AUTHOR: %9a\n  :JOURNAL: %j\n  :YEAR: %y\n  :VOLUME: %v\n  :PAGES: %p\n  :DOI: %D\n  :URL: %U\n :END:\n\n"
         org-ref-notes-function 'orb-edit-notes))

;; (after! org
;;   (add-to-list 'org-capture-templates
;;                '(("a"               ; key
;;                   "Article"         ; name
;;                   entry             ; type
;;                   (file+headline (expand-file-name "paper.org" org-directory) "Article")  ; target
;;                   "\* %^{Title} %^{org-set-tags}  :article: \n:PROPERTIES:\n:Created: %U\n:Linked: %a\n:END:\n%i\nBrief description:\n%?"  ; template
;;                   :prepend t        ; properties
;;                   :empty-lines 1    ; properties
;;                   :created t        ; properties
;; ))))
