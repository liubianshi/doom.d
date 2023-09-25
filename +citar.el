(use-package! citar
  :custom
  (citar-bibliography '("~/Documents/paper_ref.bib" "~/Documents/url_ref.bib"))
  (citar-notes-paths '("~/Documents/Writing/roam/references"))
  (citar-file-note-extensions '("org" "md" "Rmd" "rmd" "norg"))
  :hook
  (LaTeX-mode . citar-capf-setup)
  (markdown-mode . citar-capf-setup)
  (org-mode . citar-capf-setup))

(use-package! citar-embark
  :after citar embark
  :no-require
  :config (citar-embark-mode))
