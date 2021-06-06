;;; $DOOMDIR/+org-roam-bibtex.el -*- lexical-binding: t; -*-
(use-package! org-roam-bibtex
  :after org-roam
  :load-path (+lbs/bibtex-lib)
  :hook (org-roam-mode . org-roam-bibtex-mode)
  :config (require 'org-ref))

(setq orb-preformat-keywords
      '("citekey" "title" "url" "file" "author-or-editor" "keywords" "year" "journal" "abstract"))
(setq orb-templates
      '(("r" "refnote" plain (function org-roam-capture--get-point)
         ""
         :file-name "PaperNote/${citekey}"
         :head "#+TITLE: ${title}\n#+ROAM_KEY: ${ref}\n+ROAM_ALIAS:\n#+ROAM_TAGS: %?\n
\n* 文献概述
:PROPERTIES:
:Journal: ${journal}
:Year: ${year}
:AUTHOR: ${author-or-editor}
:URL: ${url}
:DOI: ${doi}
:END:

${abstract}

** 研究内容

** 结论和观点

** 研究方法和数据来源

* 文献评价

* 内容摘录\n"
         :unnarrowed t)))
