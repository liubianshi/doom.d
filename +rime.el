;;; $DOOMDIR/+rime.el -*- lexical-binding: t; -*-
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

(setq rime-show-candidate 'posframe)
(setq rime-posframe-style 'horizontal)
(setq rime-posframe-properties
      (list :font "WenQuanYi Micro Hei Mono"
            :background-color "#333333"
            :foreground-color "#dcdccc"
            :internal-border-width 6))
(setq rime-user-data-dir "~/.local/share/fcitx5/rime")
(setq rime-inline-ascii-holder nil)
(setq rime-disable-predicates
      '(rime-predicate-evil-mode-p
        rime-predicate-prog-in-code-p
        rime-predicate-current-uppercase-letter-p
        rime-predicate-punctuation-line-begin-p
        rime-predicate-after-alphabet-char-p
        rime-predicate-space-after-cc-p
        rime-predicate-punctuation-after-space-cc-p
        rime-predicate-tex-math-or-command-p
        rime-predicate-space-after-lbs-p))
(map! :desc "Toggle Input Method" "<next>" #'toggle-input-method)
(map! :map rime-active-mode-map "<tab>" #'rime-inline-ascii)
