;;; $DOOMDIR/+deft.el -*- lexical-binding: t; -*-
(after! deft
  (setq deft-directory "~/Documents/deft"
        deft-extensions '("org")
        deft-use-filename-as-title t
        deft-use-filter-string-for-filename nil
        deft-file-naming-rules '((noslash . "-")
                                 (nospace . "-")
                                 (case-fn . downcase))
        deft-recursive t))
