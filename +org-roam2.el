(use-package! org-roam
    :init
    :config
    (setq org-roam-directory (expand-file-name "roam" org-directory)
          org-roam-tag-sources '(vanilla last-directory)
          org-roam-graph-viewer "/usr/bin/xdg-open"
          org-roam-verbose nil
          org-roam-completion-system 'default)
)
