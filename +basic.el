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
(setq doom-theme 'doom-dracula)


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
(setq doom-font (font-spec :family "Fira Code iCursive S12" :size 27)
      doom-variable-pitch-font (font-spec :family "TsangerJinKai01-9128 W04" :size 28)
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
                    (font-spec :family "TsangerJinKai01-9128 W04" :size 28))))))

(defun +my|init-font(frame)
  (with-selected-frame frame
    (if (display-graphic-p)
        (+my/better-font))))

(if (and (fboundp 'daemonp) (daemonp))
    (add-hook 'after-make-frame-functions #'+my|init-font)
  (+my/better-font))
