;;; $DOOMDIR/+org.el -*- lexical-binding: t; -*-

(add-hook 'org-mode-hook #'turn-on-org-cdlatex)
(add-hook 'org-mode-hook #'toggle-input-method)

;; org-mode
(defun +org-capture-ideas-file ()
  (expand-file-name "Ideas/ideas.org" org-directory))
(defun +org-capture-question-file ()
  (expand-file-name "Know-How/question-solving.org" org-directory))
(defun +org-capture-tucao-file()
  (expand-file-name "Tucao.org" org-directory))
(defun +org-capture-anki-file ()
  (expand-file-name
   (format-time-string "DailyNote-%Y%m%d.org" (current-time))
   (expand-file-name "Anki" org-directory)))


(setq org-preview-latex-default-process 'dvisvgm)

(after! org
  (setq org-image-actual-width 500)
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
               '("A" "Daily Note needed remember (cloze)" entry
                 (file +org-capture-anki-file)
                 "* %<%H:%M>   %^g\n:PROPERTIES:\n:ANKI_NOTE_TYPE: Cloze\n:ANKI_DECK: DailyNote\n:END:\n** Front\n%?\n** Back\n%x\n" :prepend t
                 :empty-lines 1))
  (add-to-list 'org-capture-templates
               '("w" "New Word" entry
                 (file +org-capture-anki-file)
                 "* %<%H:%M>   %^g\n:PROPERTIES:\n:ANKI_NOTE_TYPE: Basic\n:ANKI_DECK: NewWords\n:END:\n** Front\n%x\n** Back\n"
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
                :empty-lines 0))
  (add-to-list 'org-capture-templates
             '("f" "Tucao" entry
               (file +org-capture-tucao-file)
               "*  %^{heading} %t %^g\n %?\n" :prepend t :empty-lines 1))
  )

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

(font-lock-add-keywords 'org-mode
                        '(("^ *\\([-]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
(font-lock-add-keywords 'org-mode
                        '(("^ *\\([+]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "◦"))))))

;; ox-pandoc settings
(setq org-pandoc-format-extensions '(markdown+emoji+east_asian_line_breaks+autolink_bare_uris+raw_tex+raw_html)
      ;; org-pandoc-options-for-latex-pdf '((defaults . "2tex.yaml"))
      )
;;      org-pandoc-options-for-beamer-pdf '((defaults . "2beamer"))
;;      org-pandoc-options-for-docx '((defaults . "2docx"))
;;      org-pandoc-options-for-html5 '((defaults . "2html"))
;;      org-pandoc-options-for-html4 '((defaults . "2html"))
;;      org-pandoc-options-for-odt '((defaults . "2odt"))
;;      org-pandoc-options-for-pptx '((defaults . "2pptx"))
;; (setq org-pandoc-format-extensions nil)

;; org-download 设定
(add-hook 'dired-mode-hook 'org-download-enable)
(use-package! org-download
  :after 'org
  :config
  (setq-default org-download-image-dir "./.asset"))

(setq org-hide-emphasis-markers t)

;; org-latex-impatient 设定
(use-package! org-latex-impatient
  :defer t
  :hook (org-mode . org-latex-impatient-mode)
  :init
  (setq org-latex-impatient-tex2svg-bin
        "/usr/bin/tex2svg"))


;; Org-appear for everything else.
(use-package! org-appear
  :after org
  :hook (org-mode . org-appear-mode)
  :config (setq
           org-appear-autolinks t
           org-appear-autoentities t
           org-appear-autosubmarkers t ))


(use-package! org-modern
  :hook (org-mode . org-modern-mode)
  :config
  (setq org-modern-star '("◉" "○" "✸" "✿" "✤" "✜" "◆" "▶")
        org-modern-table-vertical 1
        org-modern-table-horizontal 0.2
        org-modern-list '((43 . "➤")
                          (45 . "–")
                          (42 . "•"))
        org-modern-todo-faces
        '(("TODO" :inverse-video t :inherit org-todo)
          ("PROJ" :inverse-video t :inherit +org-todo-project)
          ("STRT" :inverse-video t :inherit +org-todo-active)
          ("[-]"  :inverse-video t :inherit +org-todo-active)
          ("HOLD" :inverse-video t :inherit +org-todo-onhold)
          ("WAIT" :inverse-video t :inherit +org-todo-onhold)
          ("[?]"  :inverse-video t :inherit +org-todo-onhold)
          ("KILL" :inverse-video t :inherit +org-todo-cancel)
          ("NO"   :inverse-video t :inherit +org-todo-cancel))
        org-modern-footnote
        (cons nil (cadr org-script-display))
        org-modern-block-fringe nil
        org-modern-block-name
        '((t . t)
          ("src" "»" "«")
          ("example" "»–" "–«")
          ("quote" "❝" "❞")
          ("export" "⏩" "⏪"))
        org-modern-progress nil
        org-modern-priority nil
        org-modern-horizontal-rule (make-string 36 ?─)
        org-modern-keyword
        '((t . t)
          ("title" . "𝙏")
          ("subtitle" . "𝙩")
          ("author" . "𝘼")
          ("email" . #("" 0 1 (display (raise -0.14))))
          ("date" . "𝘿")
          ("property" . "☸")
          ("options" . "⌥")
          ("startup" . "⏻")
          ("macro" . "𝓜")
          ("bind" . #("" 0 1 (display (raise -0.1))))
          ("bibliography" . "")
          ("print_bibliography" . #("" 0 1 (display (raise -0.1))))
          ("cite_export" . "⮭")
          ("print_glossary" . #("ᴬᶻ" 0 1 (display (raise -0.1))))
          ("glossary_sources" . #("" 0 1 (display (raise -0.14))))
          ("include" . "⇤")
          ("setupfile" . "⇚")
          ("html_head" . "🅷")
          ("html" . "🅗")
          ("latex_class" . "🄻")
          ("latex_class_options" . #("🄻" 1 2 (display (raise -0.14))))
          ("latex_header" . "🅻")
          ("latex_header_extra" . "🅻⁺")
          ("latex" . "🅛")
          ("beamer_theme" . "🄱")
          ("beamer_color_theme" . #("🄱" 1 2 (display (raise -0.12))))
          ("beamer_font_theme" . "🄱𝐀")
          ("beamer_header" . "🅱")
          ("beamer" . "🅑")
          ("attr_latex" . "🄛")
          ("attr_html" . "🄗")
          ("attr_org" . "⒪")
          ("call" . #("" 0 1 (display (raise -0.15))))
          ("name" . "⁍")
          ("header" . "›")
          ("caption" . "☰")
          ("results" . "🠶")))
  (custom-set-faces! '(org-modern-statistics :inherit org-checkbox-statistics-todo)))

;; Since org-modern’s tag face supplants Org’s tag face, we need to adjust the spell-check face ignore list
(after! spell-fu
  (cl-pushnew 'org-modern-tag (alist-get 'org-mode +spell-excluded-faces-alist)))

;; viewing and managing the heading structure
(use-package! org-ol-tree
  :commands org-ol-tree
  :config
  (setq org-ol-tree-ui-icon-set
        (if (and (display-graphic-p)
                 (fboundp 'all-the-icons-material))
            'all-the-icons
          'unicode))
  (org-ol-tree-ui--update-icon-set))

(map! :map org-mode-map
      :after org
      :localleader
      :desc "Outline" "O" #'org-ol-tree)

;; improve this situation without sacrificing visual amenities
(use-package! org-appear
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autoemphasis t
        org-appear-autosubmarkers t
        org-appear-autolinks nil)
  ;; for proper first-time setup, `org-appear--set-elements'
  ;; needs to be run after other hooks have acted.
  (run-at-time nil nil #'org-appear--set-elements))

;; transclude Org document content.
(use-package! org-transclusion
  :commands org-transclusion-mode
  :init
  (map! :after org :map org-mode-map
        "<f12>" #'org-transclusion-mode))

;; Ligatures adjust
(after! org
  (setq org-ellipsis " ▾ ")
  (appendq! +ligatures-extra-symbols
            `(:checkbox      "☐"
              :pending       "◼"
              :checkedbox    "☑"
              :list_property "∷"
              :em_dash       "—"
              :ellipses      "…"
              :arrow_right   "→"
              :arrow_left    "←"
              :title         nil
              :subtitle      "𝙩"
              :author        "𝘼"
              :date          "𝘿"
              :property      ""
              :options       "⌥"
              :startup       "⏻"
              :macro         "𝓜"
              :html_head     "🅷"
              :html          "🅗"
              :latex_class   "🄻"
              :latex_header  "🅻"
              :beamer_header "🅑"
              :latex         "🅛"
              :attr_latex    "🄛"
              :attr_html     "🄗"
              :attr_org      "⒪"
              :begin_quote   "❝"
              :end_quote     "❞"
              :caption       "☰"
              :header        "›"
              :results       "🠶"
              :begin_export  "⏩"
              :end_export    "⏪"
              :properties    ""
              :end           "∎"
              :priority_a   ,(propertize "⚑" 'face 'all-the-icons-red)
              :priority_b   ,(propertize "⬆" 'face 'all-the-icons-orange)
              :priority_c   ,(propertize "■" 'face 'all-the-icons-yellow)
              :priority_d   ,(propertize "⬇" 'face 'all-the-icons-green)
              :priority_e   ,(propertize "❓" 'face 'all-the-icons-blue)
              :roam_tags nil
              :filetags nil))
  (set-ligatures! 'org-mode
    :merge t
    :checkbox      "[ ]"
    :pending       "[-]"
    :checkedbox    "[X]"
    :list_property "::"
    :em_dash       "---"
    :ellipsis      "..."
    :arrow_right   "->"
    :arrow_left    "<-"
    :title         "#+title:"
    :subtitle      "#+subtitle:"
    :author        "#+author:"
    :date          "#+date:"
    :property      "#+property:"
    :options       "#+options:"
    :startup       "#+startup:"
    :macro         "#+macro:"
    :html_head     "#+html_head:"
    :html          "#+html:"
    :latex_class   "#+latex_class:"
    :latex_header  "#+latex_header:"
    :beamer_header "#+beamer_header:"
    :latex         "#+latex:"
    :attr_latex    "#+attr_latex:"
    :attr_html     "#+attr_html:"
    :attr_org      "#+attr_org:"
    :begin_quote   "#+begin_quote"
    :end_quote     "#+end_quote"
    :caption       "#+caption:"
    :header        "#+header:"
    :begin_export  "#+begin_export"
    :end_export    "#+end_export"
    :results       "#+RESULTS:"
    :property      ":PROPERTIES:"
    :end           ":END:"
    :priority_a    "[#A]"
    :priority_b    "[#B]"
    :priority_c    "[#C]"
    :priority_d    "[#D]"
    :priority_e    "[#E]"
    :roam_tags     "#+roam_tags:"
    :filetags      "#+filetags:")
  (plist-put +ligatures-extra-symbols :name "⁍")
  )

(with-eval-after-load 'org
  (plist-put org-format-latex-options :background 'default))

;; Custom faces
;; Disable enlarged org-mode header appearance
(defun my/org-mode-hook ()
  "Stop the org-level headers from increasing in height relative to the other text."
  (custom-set-faces
   '(org-document-title ((t (:inherit outline-1 :height 1.0))))
   '(org-document-info  ((t (:inherit outline-2 :height 1.0))))
   '(org-level-1 ((t (:inherit outline-1 :height 1.0))))
   '(org-level-2 ((t (:inherit outline-2 :height 1.0))))
   '(org-level-3 ((t (:inherit outline-3 :height 1.0))))
   '(org-level-4 ((t (:inherit outline-4 :height 1.0))))
   '(org-level-5 ((t (:inherit outline-5 :height 1.0))))))

(add-hook 'org-mode-hook #'my/org-mode-hook)
