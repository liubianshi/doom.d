;;; $DOOMDIR/+basic.el -*- lexical-binding: t; -*-

;;; 启动管理
(setq window-system-default-frame-alist
      '((x
         ;; face 具体可以更换为系统支持的中文字体
         ;; (font . "Sarasa Fixed SC")
         (menu-bar-lines . nil)
         (tool-bar-lines . nil)
         ;; mouse
         (mouse-wheel-mode . 1)
         (mouse-wheel-follow-mouse . t)
         (mouse-avoidance-mode . 'exile)
         (line-spacing . 0.5)
         )
        ;; if on term
        (nil
         (menu-bar-lines . 0)
         (tool-bar-lines . 0)
         ;; (background-color . "black")
         ;; (foreground-color . "white")
         )))

;; Window Title
(setq frame-title-format
    '(""
      (:eval
       (if (s-contains-p org-roam-directory (or buffer-file-name ""))
           (replace-regexp-in-string ".*/[0-9]*-?" "🢔 " buffer-file-name)
         "%b"))
      (:eval
       (let ((project-name (projectile-project-name)))
         (unless (string= "-" project-name)
           (format (if (buffer-modified-p)  " ◉ %s" "  ●  %s") project-name))))))

(setq
    initial-major-mode 'org-mode
    display-line-numbers-type 'relative
    doom-fallback-buffer-name "► Doom"
    +doom-dashboard-name "► Doom"
    default-input-method "rime"
    line-spacing 0.5
    undo-limit 80000000
    confirm-kill-emacs nil
    evil-want-fine-undo t
    auto-save-default t
    truncate-string-ellipsis "…")

(setq-default
    cursor-type 'bar
    delete-by-moving-to-trash t
    window-combination-resize t
    x-stretch-cursor t
    tab-width 4
    uniquify-buffer-name-style 'forward)

(display-time-mode 1)                  ; Enable time in the mode-line
(delete-selection-mode 1)
(global-subword-mode 1)

;; 主题设置
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-flatwhite)
;; (setq doom-theme 'doom-dracula)
(setq doom-theme 'doom-acario-dark)
;; (setq doom-theme 'berrys)


;;; 系统字体设置
;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "sans" :size 13))
(setq doom-font (font-spec :family "Fira Code" :size 27)
      doom-variable-pitch-font (font-spec :family "Fira Code" :size 27)
      doom-unicode-font (font-spec :family "monospace" :size 28)
      doom-serif-font (font-spec :family "Noto Serif CJK SC" :size 28)
      doom-big-font (font-spec :family "Sans" :size 32))

(defun +my/better-font()
    (interactive)
    ;; english font
    (if (display-graphic-p)
        (progn
            (set-face-attribute 'default nil :font (format "%s:pixelsize=%d" "Fira Code iCursive S12" 27)) ;; 11 13 17 19 23
            ;; chinese font
            (dolist (charset '(kana han symbol cjk-misc bopomofo))
                (set-fontset-font (frame-parameter nil 'font)
                    charset
                    (font-spec :family "TsangerJinKai01-9128 W03" :size 28))))))

(defun +my|init-font(frame)
  (with-selected-frame frame
    (if (display-graphic-p)
        (+my/better-font))))

(if (and (fboundp 'daemonp) (daemonp))
    (add-hook 'after-make-frame-functions #'+my|init-font)
  (+my/better-font))



(setq which-key-idle-delay 0.5)

(after! company
  (setq company-idle-delay 0.5
        company-minimum-prefix-length 2)
  (setq company-show-quick-access t)
  (add-hook 'evil-normal-state-entry-hook #'company-abort))

(setq-default history-length 1000)
(setq-default prescient-history-length 1000)

(set-company-backend!
  '(text-mode
    markdown-mode
    gfm-mode)
  '(:seperate
    company-ispell
    company-files
    company-yasnippet))
(set-company-backend! 'ess-r-mode '(company-R-args company-R-objects company-dabbrev-code :separate))

(setq projectile-ignored-projects '("~/" "/tmp" "~/.emacs.d/.local/straight/repos/"))
(defun projectile-ignored-project-function (filepath)
  "Return t if FILEPATH is within any of `projectile-ignored-projects'"
  (or (mapcar (lambda (p) (s-starts-with-p p filepath)) projectile-ignored-projects)))
(setq yas-triggers-in-field t)

(defvar mixed-pitch-modes '(org-mode LaTeX-mode markdown-mode gfm-mode Info-mode)
  "Modes that `mixed-pitch-mode' should be enabled in, but only after UI initialisation.")
(defun init-mixed-pitch-h ()
  "Hook `mixed-pitch-mode' into each mode in `mixed-pitch-modes'.
Also immediately enables `mixed-pitch-modes' if currently in one of the modes."
  (when (memq major-mode mixed-pitch-modes)
    (mixed-pitch-mode 1))
  (dolist (hook mixed-pitch-modes)
    (add-hook (intern (concat (symbol-name hook) "-hook")) #'mixed-pitch-mode)))
(add-hook 'doom-init-ui-hook #'init-mixed-pitch-h)
(autoload #'mixed-pitch-serif-mode "mixed-pitch"
  "Change the default face of the current buffer to a serifed variable pitch, while keeping some faces fixed pitch." t)

(after! mixed-pitch
  (defface variable-pitch-serif
    '((t (:family "serif")))
    "A variable-pitch face with serifs."
    :group 'basic-faces)
  (setq mixed-pitch-set-height t)
  (setq variable-pitch-serif-font (font-spec :family "Noto Serif CJK SC" :size 27))
  (set-face-attribute 'variable-pitch-serif nil :font variable-pitch-serif-font)
  (defun mixed-pitch-serif-mode (&optional arg)
    "Change the default face of the current buffer to a serifed variable pitch, while keeping some faces fixed pitch."
    (interactive)
    (let ((mixed-pitch-face 'variable-pitch-serif))
      (mixed-pitch-mode (or arg 'toggle)))))

(set-char-table-range composition-function-table ?f '(["\\(?:ff?[fijlt]\\)" 0 font-shape-gstring]))
(set-char-table-range composition-function-table ?T '(["\\(?:Th\\)" 0 font-shape-gstring]))


(setq +zen-text-scale 0.8)

(defvar +zen-serif-p nil
  "Whether to use a serifed font with `mixed-pitch-mode'.")

(after! writeroom-mode
  (defvar-local +zen--original-org-indent-mode-p nil)
  (defvar-local +zen--original-mixed-pitch-mode-p nil)
  ;(defvar-local +zen--original-org-pretty-table-mode-p nil)
  (defun +zen-enable-mixed-pitch-mode-h ()
    "Enable `mixed-pitch-mode' when in `+zen-mixed-pitch-modes'."
    (when (apply #'derived-mode-p +zen-mixed-pitch-modes)
      (if writeroom-mode
          (progn
            (setq +zen--original-mixed-pitch-mode-p mixed-pitch-mode)
            (funcall (if +zen-serif-p #'mixed-pitch-serif-mode #'mixed-pitch-mode) 1))
        (funcall #'mixed-pitch-mode (if +zen--original-mixed-pitch-mode-p 1 -1)))))
  (pushnew! writeroom--local-variables
            'display-line-numbers
            'visual-fill-column-width
            'org-adapt-indentation
            'org-superstar-headline-bullets-list
            'org-superstar-remove-leading-stars)
  (add-hook 'writeroom-mode-enable-hook
            (defun +zen-prose-org-h ()
              "Reformat the current Org buffer appearance for prose."
              (when (eq major-mode 'org-mode)
                (setq display-line-numbers nil
                      visual-fill-column-width 60
                      org-adapt-indentation nil)
                (when (featurep 'org-superstar)
                  (setq-local
                              ;; org-superstar-headline-bullets-list '("🙘" "🙙" "🙚" "🙛")
                              ;; org-superstar-headline-bullets-list '("🙐" "🙑" "🙒" "🙓" "🙔" "🙕" "🙖" "🙗")
                              org-superstar-remove-leading-stars t)
                  (org-superstar-restart))
                (setq
                 +zen--original-org-indent-mode-p org-indent-mode
                 ;;+zen--original-org-pretty-table-mode-p (bound-and-true-p org-pretty-table-mode)
                 )
                (org-indent-mode -1)
                ;;(org-pretty-table-mode 1)
                )))
  (add-hook 'writeroom-mode-disable-hook
            (defun +zen-nonprose-org-h ()
              "Reverse the effect of `+zen-prose-org'."
              (when (eq major-mode 'org-mode)
                (when (featurep 'org-superstar)
                  (org-superstar-restart))
                (when +zen--original-org-indent-mode-p (org-indent-mode 1))
                ;; (unless +zen--original-org-pretty-table-mode-p (org-pretty-table-mode -1))
                ))))
