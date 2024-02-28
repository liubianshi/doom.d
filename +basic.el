;;; $DOOMDIR/+basic.el -*- lexical-binding: t; -*-

;;; 禁止一些消息
(setq warning-suppress-types (append warning-suppress-types '((org-element-cache))))

;; 禁用 italic
(set-face-italic 'font-lock-comment-face nil)

(if (eq system-type 'darwin)
    (setq fontsize 18
          fontsize-sc 18
          font-monospace "Maple Mono SC NF"
          font-monospace-sc "LXGW WenKai Mono"
          font-sans "LXGW WenKai Mono"
          font-serif "AR PL UKai CN"
          font-weight 'regular
          line-space 0
          doom-theme 'kanagawa
          )
  (setq fontsize 28
        fontsize-sc 28
        font-monospace "Maple Mono NF"
        font-monospace-sc "LXGW WenKai Mono"
        font-sans "AR PL UKai CN"
        font-serif "LXGW WenKai Mono"
        font-weight 'semi-light
        line-space 0.2
        doom-theme 'catppuccin
        ))



;;; 启动管理
(setq window-system-default-frame-alist
      '((x
         ;; face 具体可以更换为系统支持的中文字体
         ;; (font . "Sarasa Mono Slab SC")
         (menu-bar-lines . nil)
         (tool-bar-lines . nil)
         ;; mouse
         (mouse-wheel-mode . 1)
         (mouse-wheel-follow-mouse . t)
         ; (mouse-avoidance-mode . 'exile)
         )
        ;; if on term
        (nil
         (menu-bar-lines . 0)
         (tool-bar-lines . 0)
         (background-color . "black")
         (foreground-color . "white")
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
           (format (if (buffer-modified-p)  "  [%s]  ◉" "  [%s]  ●") project-name))))))

(setq
    ; initial-major-mode 'org-mode
    display-line-numbers-type 'relative
    doom-fallback-buffer-name "► Doom"
    +doom-dashboard-name "► Doom"
    default-input-method "rime"
    undo-limit 80000000
    confirm-kill-emacs nil
    evil-want-fine-undo t
    auto-save-default t
    truncate-string-ellipsis "…")
(setq-default
    cursor-type 'bar
    delete-by-moving-to-trash t
    window-combination-resize t
    line-spacing line-space
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
;; (setq doom-theme 'berrys)

;; Since this is a comfy config for writing, proportional fonts are what we want,
;; but its nice to have both mono and proportional fonts.
;; (use-package! mixed-pitch
;;   :hook (org-mode . mixed-pitch-mode)
;;   :config
;;   (setq mixed-pitch-face 'variable-pitch))

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
;; (setq doom-font (font-spec :family "FiraCode Nerd Font" :size 27)
;;       doom-variable-pitch-font (font-spec :family "FiraCode Nerd Font" :size 27))

(setq doom-font                (font-spec :family font-monospace :size fontsize    :weight font-weight)
      doom-variable-pitch-font (font-spec :family font-sans      :size fontsize    :weight font-weight)
      doom-unicode-font        (font-spec :family font-sans      :size fontsize-sc :weight font-weight)
      doom-serif-font          (font-spec :family font-serif     :size fontsize-sc)
      doom-big-font            (font-spec :family font-sans      :size (floor (* fontsize 1))))

(defun +my/better-font()
    (interactive)
    ;; english font
    (if (display-graphic-p)
        (progn
            (set-face-attribute 'default nil :font (format "%s:pixelsize=%d" font-monospace fontsize)) ;; 11 13 17 19 23
            ;; chinese font
            (dolist (charset '(kana han symbol cjk-misc bopomofo))
                (set-fontset-font (frame-parameter nil 'font)
                    charset
                    (font-spec :family font-monospace-sc :size fontsize-sc))))))

(defun +my|init-font(frame)
  (with-selected-frame frame
    (if (display-graphic-p)
        (+my/better-font))))

(if (and (fboundp 'daemonp) (daemonp))
    (add-hook 'after-make-frame-functions #'+my|init-font)
  (+my/better-font))

(setq which-key-idle-delay 0.5)

(setq-default history-length 1000)
(setq-default prescient-history-length 1000)


(setq projectile-ignored-projects '("~/" "/tmp" "~/.emacs.d/.local/straight/repos/"))
(defun projectile-ignored-project-function (filepath)
  "Return t if FILEPATH is within any of `projectile-ignored-projects'"
  (or (mapcar (lambda (p) (s-starts-with-p p filepath)) projectile-ignored-projects)))
(setq yas-triggers-in-field t)


(setq +zen-text-scale 0)
(after! writeroom-mode
  (defvar-local +zen--original-org-indent-mode-p nil)
  (defvar-local +zen--original-mixed-pitch-mode-p nil)
  (defun +zen-prose-org-h ()
    "reformat the current org buffer appearance for prose."
    (setq display-line-numbers nil)
    (when (eq major-mode 'org-mode)
      (setq org-adapt-indentation -1
            visual-fill-column-width 70)
      (when (featurep 'org-superstar)
        (setq-local org-superstar-remove-leading-stars t)
        (org-superstar-restart))
      (setq +zen--original-org-indent-mode-p org-indent-mode)
      (org-indent-mode 1)
      ))
  (defun +zen-nonprose-org-h ()
    "reverse the effect of `+zen-prose-org'."
    (when (eq major-mode 'org-mode)
      (when (featurep 'org-superstar)
        (org-superstar-restart))
      (when +zen--original-org-indent-mode-p (org-indent-mode 1))
      ))
  (pushnew! writeroom--local-variables
            'display-line-numbers
            'visual-fill-column-width
            'org-adapt-indentation
            'org-superstar-headline-bullets-list
            'org-superstar-remove-leading-stars)
  (add-hook 'writeroom-mode-enable-hook #'+zen-prose-org-h)
  (add-hook 'writeroom-mode-disable-hook #'+zen-nonprose-org-h))



(defun set-background-for-terminal (&optional frame)
  (or frame (setq frame (selected-frame)))
  "unsets the background color in terminal mode"
  (unless (display-graphic-p frame)
    (set-face-background 'default "unspecified-bg" frame)))
(add-hook 'after-make-frame-functions 'set-background-for-terminal)
(add-hook 'window-setup-hook 'set-background-for-terminal)


(defun et/fixup-whitespace ()
  "Fixup white space between objects around point.
Leave one space or none, according to the context."
  (interactive "*")
  (save-excursion
    (delete-horizontal-space)
    (if (or (looking-at "^\\|\\s)")
            (save-excursion (forward-char -1)
                            ;; we adapted the regexp here:
                            (looking-at "\\cc\\|$\\|\\s(\\|\\s'")))
        nil
      (insert ?\s))))

(defun et/delete-indentation (old-func &rest args)
  (cl-letf (((symbol-function 'fixup-whitespace) #'et/fixup-whitespace))
    (apply old-func args)))

(advice-add #'delete-indentation :around #'et/delete-indentation)


