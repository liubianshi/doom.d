;;; $DOOMDIR/+org.el -*- lexical-binding: t; -*-

;; org-mode
(defun +org-capture-ideas-file ()
  (expand-file-name "ideas.org" org-directory))
(defun +org-capture-question-file ()
  (expand-file-name "question-solving.org" org-directory))
(after! org
  (add-to-list 'org-capture-templates
             '("i" "ideas collected" entry
               (file +org-capture-ideas-file)
               "*  %^{heading} %t %^g\n %?\n" :prepend t :empty-lines 1))
  (add-to-list 'org-capture-templates
                '("k" "Quesion Solved" entry
                (file +org-capture-question-file)
                "* TODO %^{Question} %t %^g\n\n** Description\n %?\n\n** Solved Method\n\n** Problem Solving Process\n"
                :prepend t :empty-lines 1)))

;; Org Bullets
(use-package! org
  :config
  (setq
  ; org-bullets-bullet-list '("⁖")
   org-todo-keyword-faces
   '(("TODO" :foreground "#7c7c75" :weight normal :underline t)
     ("WAITING" :foreground "#9f7efe" :weight normal :underline t)
     ("INPROGRESS" :foreground "#0098dd" :weight normal :underline t)
     ("DONE" :foreground "#50a14f" :weight normal :underline t)
     ("CANCELLED" :foreground "#ff6480" :weight normal :underline t))
   org-priority-faces '((65 :foreground "#e45649")
                        (66 :foreground "#da8548")
                        (67 :foreground "#0098dd"))
   ))
;; org-babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '((stata . t)
   (r . t)))

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
