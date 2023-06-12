;;; $DOOMDIR/+rime.el -*- lexical-binding: t; -*-
;;;
(setq rime-user-data-dir "~/.local/share/emacs/rime"
      rime-show-candidate 'posframe
      rime-posframe-style 'horizontal
      rime-show-preedit 't
      rime-cursor "|"
      rime-inline-ascii-holder ?a
      rime-inline-ascii-trigger 'shift-r
      )

(defun rime-predicate-space-after-lbs-p ()
  "If cursor is after a whitespace which follow a non-ascii character."
  (and (> (point) (save-excursion (back-to-indentation) (point)))
       (let ((string (buffer-substring (point) (max (line-beginning-position) (- (point) 80)))))
         (string-match-p "[=~`@<$.!]$" string))))
(defun rime-predicate-tex-math-or-command-lbs-p ()
  (and (derived-mode-p 'tex-mode 'markdown-mode)
       (or (and (featurep 'tex-site)
                (texmathp))
           (and rime--current-input-key
                (or (= #x24 rime--current-input-key)
                    (= #x5c rime--current-input-key))
                (or (= (point) (line-beginning-position))
                    (= #x20 (char-before))
                    (rime-predicate-after-ascii-char-p)))
           (and (> (point) (save-excursion (back-to-indentation) (point)))
                (let ((string (buffer-substring (point) (max (line-beginning-position) (- (point) 80)))))
                  (or (string-match-p "[\x5c][\x21-\x24\x26-\x59\x61\x7e]*$" string)
                      (string-match-p "[\x5c][a-zA-Z\x23\x40]+[\x7b][^\x7d\x25\x60]*$" string)))))))

(defun rime-predicate-source-code-lbs-p ()
  "If cursor is in a line source code line"
  (let ((string (buffer-substring (line-beginning-position) (point))))
    (string-match-p "^[:space:]*#\\+begin" string)))


(bind-key "C-`" 'rime-send-keybinding)


(face-spec-set 'rime-default-face
               '((((class color) (background dark))
                  (:foreground "#FFFFFF"))
                 (((class color) (background light))
                  (:foreground "#4a5966" )))
               'face-defface-spec)

(defface rime-indicator-face
  '((((class color) (background dark))
     (:foreground "#BADFFF" :bold t))
    (((class color) (background light))
     (:foreground "#BADFFF" :bold t)))
  "Face for mode-line indicator when input-method is available."
  :group 'rime)

; (setq rime-posframe-properties
;       (list :font (font-spec :family font-monospace :size (* fontsize 1.5))
;             :internal-border-width 0))

(setq rime-disable-predicates
      '(rime-predicate-evil-mode-p
        rime-predicate-prog-in-code-p
        rime-predicate-current-uppercase-letter-p
        rime-predicate-punctuation-line-begin-p
        rime-predicate-after-alphabet-char-p
        rime-predicate-space-after-cc-p
        rime-predicate-punctuation-after-space-cc-p
        rime-predicate-tex-math-or-command-p
        rime-predicate-space-after-lbs-p
        rime-predicate-source-code-lbs-p))
(map! :desc "Toggle Input Method" :i "C-;" #'toggle-input-method)
(map! :map rime-active-mode-map "<tab>" #'rime-inline-ascii)


(if (eq system-type 'darwin)
    (use-package! rime
    :custom
    (rime-librime-root "/opt/local/librime/dist")
    (rime-emacs-module-header-root "/Applications/MacPorts/Emacs.app/Contents/Resources/include/")
    (default-input-method "rime"))
  )
