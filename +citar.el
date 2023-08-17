(use-package citar
  :custom
  (citar-bibliography '("~/Documents/paper_ref.bib"))
  :hook
  (LaTeX-mode . citar-capf-setup)
  (markdown-mode . citar-capf-setup)
  (org-mode . citar-capf-setup))

(use-package citar-embark
  :after citar embark
  :no-require
  :config (citar-embark-mode))
