;;; $DOOMDIR/+markdown.el -*- lexical-binding: t; -*-
(setq grip-preview-use-webkit t)
(add-to-list 'auto-mode-alist '("\\.[Rr]md\\'" . poly-markdown+r-mode))
(add-hook 'markdown-mode-hook #'valign-mode)
(add-hook 'markdown-mode-hook #'pandoc-mode)
