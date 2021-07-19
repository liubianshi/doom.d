;;; $DOOMDIR/+ess.el -*- lexical-binding: t; -*-
(use-package! ess
  :config
  (setq comint-move-point-for-output t)
  (defun then_R_operator ()
    "R - %>% operator or 'then' pipe operator"
    (interactive)
    (just-one-space 1)
    (insert "%>%")
    (reindent-then-newline-and-indent))

  (map! :map ess-r-mode-map
        :i "M-=" #'ess-insert-assign
        :i "M-\\" #'then_R_operator)
  )

