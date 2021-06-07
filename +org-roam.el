;;; $DOOMDIR/+org-roam.el -*- lexical-binding: t; -*-

;; org-roam
(use-package! org-roam
  :commands (org-roam-buffer-toggle-display
             org-roam-find-find-file
             org-roam-graph
             org-roam-insert
             org-roam-switch-to-buffer
             org-roam-dailies-date
             org-roam-dailies-today
             org-roam-dailies-tomorrow
             org-roam-dailies-yesterday
             org-roam)
  :preface
  (defvar org-roam-directory nil)
  :init
  :config
  (setq org-roam-directory (expand-file-name "../Knowledge" org-directory)
        org-roam-graph-viewer "/usr/bin/xdg-open"
        org-roam-verbose nil
        org-roam-completion-system 'default)
  (map! :leader
        :prefix "r"
        :desc "Org-Roam" "l" #'org-roam
        :desc "Org-Roam-Insert" "i" #'org-roam-insert
        :desc "org-roam-switch-to-buffer" "b" #'org-roam-switch-to-buffer
        :desc "Org-Roam-Find"   "f" #'org-roam-find-file
        :desc "org-roam-show-graph" "g" #'org-roam-show-graph
        :desc "org-roam-capture" "c" #'org-roam-capture)

  ;; Normally, the org-roam buffer doesn't open until you explicitly call
  ;; `org-roam'. If `+org-roam-open-buffer-on-find-file' is non-nil, the
  ;; org-roam buffer will be opened for you when you use `org-roam-find-file'
  ;; (but not `find-file', to limit the scope of this behavior).
  (add-hook 'find-file-hook
    (defun +org-roam-open-buffer-maybe-h ()
      (and +org-roam-open-buffer-on-find-file
           (memq 'org-roam-buffer--update-maybe post-command-hook)
           (not (window-parameter nil 'window-side)) ; don't proc for popups
           (not (eq 'visible (org-roam-buffer--visibility)))
           (with-current-buffer (window-buffer)
             (org-roam-buffer--get-create)))))

  ;; Hide the mode line in the org-roam buffer, since it serves no purpose. This
  ;; makes it easier to distinguish among other org buffers.
  (add-hook 'org-roam-buffer-prepare-hook #'hide-mode-line-mode)

  (org-roam-mode +1))

;; Since the org module lazy loads org-protocol (waits until an org URL is
;; detected), we can safely chain `org-roam-protocol' to it.
(use-package! org-roam-protocol :after org-protocol)

(add-hook 'after-init-hook 'org-roam-mode)
(add-hook 'org-mode-hook #'valign-mode)

(use-package! org-roam-server
  :after org-roam
  :config
  (setq org-roam-server-host "127.0.0.1"
        org-roam-server-port 9090
        org-roam-server-authenticate nil
        org-roam-server-export-inline-images t
        org-roam-server-serve-files nil
        org-roam-server-served-file-extensions '("pdf" "mp4" "ogv")
        org-roam-server-network-poll t
        org-roam-server-network-arrows nil
        org-roam-server-network-label-truncate t
        org-roam-server-network-label-truncate-length 60
        org-roam-server-network-label-wrap-length 20)
  (defun org-roam-server-open ()
    "Ensure the server is active, then open the roam graph."
    (interative)
    (org-roam-server-mode 1)
    (browser-url-xdg-open (format "http://localhost:%d" org-roam-server-port))))
(after! org-roam (org-roam-server-mode))

(after! org-roam
  (add-to-list 'org-roam-capture-templates
               '("t" "Term" plain (function org-roam-capture--get-point)
                 "+ 领域: %^{术语所属领域}\n+ 释义: %?\n"
                 :file-name "Term/%<%Y%m%d%H%M%S>-${slug}"
                 :head "#+title: ${title}\n#+roam_alias:\n#+roam_tags: \n\n"
                 :unnarrowed t))
  (add-to-list 'org-roam-capture-templates
               '("p" "Paper" plain (function org-roam-capture--get-point)
                 ""
                 :file-name "PaperNote/%<%Y%m%d%H%M%S>-${slug}"
                 :head "#+title: ${title}\n#+roam_alias:\n#+author:\n#+roam_tags: \n\ncitation: \n\n* 文献评价\n\n* 研究内容\n%?\n\n* 结论和观点\n\n* 研究方法和数据来源\n\n* 内容摘录\n"
                 :unnarrowed t))
  (add-to-list 'org-roam-capture-templates
               '("n" "Normal" plain (function org-roam-capture--get-point)
                 "%?"
                 :file-name "%<%Y%m%d%H%M%S>-${slug}"
                 :head "#+title: ${title}\n#+roam_alias:\n\n#+roam_tags: \n\n"
                 :unnarrowed t ))
  (add-to-list 'org-roam-capture-templates
               '("i" "ideas" plain (function org-roam-capture--get-point)
                 "%?"
                 :file-name "Ideas/%<%Y%m%d%H%M%S>-${slug}"
                 :head "#+title: ${title}\n#+roam_alias:\n\n#+roam_tags: \n\n"
                 :unnarrowed t ))
  (add-to-list 'org-roam-capture-ref-templates
               '("a" "Annotation" plain (function org-roam-capture--get-point)
                 "%U ${body}\n"
                 :file-name "Digest/%<%Y%m%d%H%M%S>-${slug}"
                 :head "#+title: ${title}\n#+roam_key: ${ref}\n#+roam_alias:\n\n"
                 :immediate-finish t
                 :unnarrowed t
                 :empty-lines 0)))
