;;; $DOOMDIR/+org.el -*- lexical-binding: t; -*-

;; org-mode
(defun +org-capture-ideas-file ()
  (expand-file-name "Ideas/ideas.org" org-directory))
(defun +org-capture-question-file ()
  (expand-file-name "Know-How/question-solving.org" org-directory))
(defun +org-capture-anki-file ()
  (expand-file-name
   (format-time-string "DailyNote-%Y%m%d.org" (current-time))
   (expand-file-name "Anki" org-directory)))


(after! org
  (setq org-image-actual-width 600)
  (defun insert-zero-width-space()
    (interactive)
    (insert "​"))

  (map! :map org-mode-map
        :leader
        :prefix "<space>"
        :desc "Insert Zero Space Width" "0" #'insert-zero-width-space)

  (add-to-list 'org-capture-templates
               '("a" "Daily Note needed remember" entry
                 (file +org-capture-anki-file)
                 "* %<%H:%M>   %^g\n:PROPERTIES:\n:ANKI_NOTE_TYPE: Basic\n:ANKI_DECK: DailyNote\n:END:\n** Front\n%x\n** Back\n"
                 :prepend t
                 :empty-lines 1))
  (add-to-list 'org-capture-templates
               '("A" "Daily Note needed remember (cloze)"
                 entry
                 (file +org-capture-anki-file)
                 "* %<%H:%M>   %^g\n:PROPERTIES:\n:ANKI_NOTE_TYPE: Cloze\n:ANKI_DECK: DailyNote\n:END:\n** Front\n%?\n** Back\n%x\n"
                 :prepend t
                 :empty-lines 1))
  (add-to-list 'org-capture-templates
             '("i" "ideas collected" entry
               (file +org-capture-ideas-file)
               "*  %^{heading} %t %^g\n %?\n" :prepend t :empty-lines 1))
  (add-to-list 'org-capture-templates
             '("k" "Questiong Solved" entry
               (file +org-capture-question-file)
               "*  %^{heading} %t %^g\n %?\n" :prepend t :empty-lines 1))
  (add-to-list 'org-capture-templates
                '("c" "Collect terms" table-line (file "~/Documents/Writing/term.org")
                "| %^{term} | %^{desc} | %^{Shorthand} |"
                :prepend 0
                :empty-lines 0)))

;; Org Bullets
(use-package! org
  :config
  (setq
   org-bullets-bullet-list '("⁖")
   org-todo-keyword-faces
   '(("TODO"       :foreground "#7c7c75" :weight normal :underline t)
     ("WAITING"    :foreground "#9f7efe" :weight normal :underline t)
     ("INPROGRESS" :foreground "#0098dd" :weight normal :underline t)
     ("DONE"       :foreground "#50a14f" :weight normal :underline t)
     ("CANCELLED"  :foreground "#ff6480" :weight normal :underline t))
   org-priority-faces '((65 :foreground "#e45649")
                        (66 :foreground "#da8548")
                        (67 :foreground "#0098dd"))
   org-tag-alist '((:startgroup . nil)
                   ("@Work"    . ?w)
                   ("@Private" . ?p)
                   (:endgroup . nil)
                   ("@Remember" . ?b)
                   ("@Bookmarks" . ?b)
                   ("@Case" . ?c)
                   ("@Data" . ?d)
                   ("@Event" . ?e)
                   ("@Funny" . ?f)
                   ("@Institution" . ?i)
                   ("@Motto" . ?m)
                   ("@Research" . ?r)
                   ("@Speech" . ?s))
   ))

;; org-babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '((lisp . t)
   (emacs-lisp . t)
   (ditaa . t)
   (dot . t)
   (lua . t)
   (R . t)
   (sh . t)
   (python. t)
   (perl . t)))

;; Org Noter
(use-package! org-noter
  :after (:any org pdf-view)
  :config
  (setq
   ;; The WM can handle splits
   org-noter-notes-window-location 'other-frame
   ;; Please stop opening frames
   org-noter-always-create-frame nil ;; I want to see the whole file
   org-noter-hide-other nil
   ;; Everything is relative to the main notes file
   org-noter-notes-search-path (list org-directory)))

;; 让中文可以在不加空格的情况下使用行内格式
;; https://emacs-china.org/t/orgmode/9740/12
(setcar (nthcdr 0 org-emphasis-regexp-components) " \t('\"{[:nonascii:]")
(setcar (nthcdr 1 org-emphasis-regexp-components) "- \t.,:!?;'\")}\\[[:nonascii:]")
(org-set-emph-re 'org-emphasis-regexp-components org-emphasis-regexp-components)
(org-element-update-syntax)
;; 规定上下标必须加 {}，否则中文使用下划线时它会以为是两个连着的下标
(setq org-use-sub-superscripts "{}")

;; ox-pandoc settings
;; (setq org-pandoc-format-extensions '(markdown+emoji+east_asian_line_breaks+autolink_bare_uris))
;;      org-pandoc-options-for-latex-pdf '((defaults . "2tex"))
;;      org-pandoc-options-for-beamer-pdf '((defaults . "2beamer"))
;;      org-pandoc-options-for-docx '((defaults . "2docx"))
;;      org-pandoc-options-for-html5 '((defaults . "2html"))
;;      org-pandoc-options-for-html4 '((defaults . "2html"))
;;      org-pandoc-options-for-odt '((defaults . "2odt"))
;;      org-pandoc-options-for-pptx '((defaults . "2pptx"))
(setq org-pandoc-format-extensions nil)

;; org-download 设定
(add-hook 'dired-mode-hook 'org-download-enable)
(use-package! org-download
  :after 'org
  :config
  (setq-default org-download-image-dir "./.asset"))

(setq org-hide-emphasis-markers t)
