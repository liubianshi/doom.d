(defun +lbs/paste-image ()
  "paste image by flameshot"
  (interactive)

  (setq current-file-path     (or load-file-name buffer-file-name)
        current-file-basename (file-name-base current-file-path)
        current-file-ext      (or (file-name-extension current-file-path) "org")
        current-file-dir      (file-name-directory current-file-path)
        target-image-dir      (expand-file-name ".asset/" current-file-dir)
        target-image-default  (format-time-string "screenshot%Y%m%d%H%M%S.png" (current-time))
        target-image-name     (read-string
                               (format "Screenshot base filename (%s): " target-image-default)
                               nil nil target-image-default))

  (unless (file-name-extension target-image-name)
    (setq target-image-name (concat target-image-name ".png")))

  (setq target-image-title (file-name-base target-image-name)
        target-image-name (concat current-file-basename "-" target-image-name)
        target-image-path (expand-file-name target-image-name target-image-dir))

  (call-process-shell-command (format "mkdir -p \"%s\" && flameshot-to-file \"%s\""
                                      target-image-dir
                                      target-image-path))

  (if (file-exists-p target-image-path)
      (cond
       ((string-match-p "^md\\|markdown" current-file-ext)
        (insert (format "![%s](./.asset/%s)" target-image-title target-image-name)))
       ((string-match-p "^[Rr]md\\|[Rr]markdown" current-file-ext)
        (insert (concat "```{r, fig.cap =" target-image-title
                        ", out.width = '70%', fig.pos = 'h', fig.show = 'hold'}\n"
                        "knitr::include_graphics(\"./.asset/" target-image-name "\")\n```")))
       (t
        (insert (format "[[file:./.asset/%s][%s]]" target-image-name target-image-title))))))
