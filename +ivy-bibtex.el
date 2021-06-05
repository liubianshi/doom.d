;;; $DOOMDIR/+ivy-bibtex.el -*- lexical-binding: t; -*-
(setq ivy-re-builders-alist
      '((ivy-bibtex . ivy--regex-ignore-order)
        (t . ivy--regex-plus)))

(setq bibtex-completion-notes-path (expand-file-name "../Knowledge/PaperNote" org-directory)
      bibtex-completion-bibliography +lbs/bibtex-lib
      bibtex-completion-library-path +lbs/pdf-paper-lib
      bibtex-completion-pdf-field "file"
      bibtex-completion-notes-template-multiple-files
      (concat
        "#+TITLE: ${title}\n"
        "#+ROAM_KEY: cite:${=key=}\n"
        "* TODO Notes\n"
        ":PROPERTIES:\n"
        ":Custom_ID: ${=key=}\n"
        ":NOTER_DOCUMENT: %(orb-process-file-field \"${=key=}\")\n"
        ":AUTHOR: ${author-abbrev}\n"
        ":JOURNAL: ${journaltitle}\n"
        ":DATE: ${date}\n"
        ":YEAR: ${year}\n"
        ":DOI: ${doi}\n"
        ":URL: ${url}\n"
        ":END:\n\n"))

;; (defun bibtex-completion-open-pdf-external (keys &optional fallback-action)
;;   (let ((bibtex-completion-pdf-open-function
;;          (lambda (fpath) (start-process "evince" "*helm-bibtex-evince*" "/usr/bin/evince" fpath))))
;;     (bibtex-completion-open-pdf keys fallback-action)))

;; (ivy-bibtex-ivify-action bibtex-completion-open-pdf-external ivy-bibtex-open-pdf-external)

;; (ivy-add-actions
;;  'ivy-bibtex
;;  '(("P" ivy-bibtex-open-pdf-external "Open PDF file in external viewer (if present)")))

;; (setq bibtex-completion-format-citation-functions
;;   '((org-mode      . bibtex-completion-format-citation-org-link-to-PDF)
;;     (latex-mode    . bibtex-completion-format-citation-cite)
;;     (markdown-mode . bibtex-completion-format-citation-pandoc-citeproc)
;;     (default       . bibtex-completion-format-citation-default)))
