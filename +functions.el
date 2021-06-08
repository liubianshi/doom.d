(defun +lbs/paste-image ()
  "paste image by flameshot"
  (interactive)
  (setq mode (file-name-extension (or load-file-name buffer-file-name)))
  (message mode)
  (setq localBaseDir (expand-file-name
                      ".asset/"
                      (file-name-directory (or load-file-name buffer-file-name))))
  (setq screenshot-file-name (format-time-string "screenshot%Y%m%d%H%M%S.png" (current-time)))
  (call-process-shell-command (concat "mkdir -p " localBaseDir))
  (call-process-shell-command "flameshot gui")
  (call-process-shell-command (concat "xclip -o -sel clip -t image/png > \""
                                      (expand-file-name screenshot-file-name localBaseDir) "\" &"))
  (cond
   ((string-match-p "^md\\|markdown" mode)
    (insert (concat "![](\"./.asset/" screenshot-file-name "\")")))
   ((string-match-p "^[Rr]md\\|[Rr]markdown" mode)
    (insert (concat "```{r, out.width = '70%', fig.pos = 'h', fig.show = 'hold'}\n"
                    "knitr::include_graphics(\"./.asset/" screenshot-file-name "\")\n```"
                    )))
   (t
    (insert (concat "[[./.asset/" screenshot-file-name "]]")))))
