;;; $DOOMDIR/+fasd.el -*- lexical-binding: t; -*-
(use-package! fasd
  :commands (fasd-find-file)
  :init
  (map! :leader
        :prefix "f"
        :desc "fasd-find-file" "z" #'fasd-find-file)
  :config
  (global-fasd-mode 1))
