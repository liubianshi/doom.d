;;; $DOOMDIR/+fold.el -*- lexical-binding: t; -*-
;;origami https://github.com/gregsexton/origami.el
;; https://www.reddit.com/r/emacs/comments/5ei7wa/awesome_vimlike_folding_for_evilmode_with_markers/dafj2x4?utm_source=share&utm_medium=web2x&context=3
(require 'origami)
(global-origami-mode 1)

(defun nin-origami-toggle-node ()
  (interactive)
  (if (equal major-mode 'org-mode)
      (org-cycle)
    (save-excursion ;; leave point where it is
      (goto-char (point-at-eol))             ;; then go to the end of line
      (origami-toggle-node (current-buffer) (point)))))                 ;; and try to fold


; "Fold"
(add-hook 'prog-mode-hook
          (lambda ()
            (setq-local origami-fold-style 'triple-braces)
            (origami-mode)
            (origami-close-all-nodes (current-buffer))))
(evil-define-key 'normal prog-mode-map (kbd "TAB") 'nin-origami-toggle-node)

(define-key evil-normal-state-map "za" 'origami-forward-toggle-node)
(define-key evil-normal-state-map "zR" 'origami-close-all-nodes)
(define-key evil-normal-state-map "zM" 'origami-open-all-nodes)
(define-key evil-normal-state-map "zr" 'origami-close-node-recursively)
(define-key evil-normal-state-map "zm" 'origami-open-node-recursively)
(define-key evil-normal-state-map "zo" 'origami-show-node)
(define-key evil-normal-state-map "zc" 'origami-close-node)
(define-key evil-normal-state-map "zj" 'origami-forward-fold)
(define-key evil-normal-state-map "zk" 'origami-previous-fold)
(define-key evil-visual-state-map "zf"
  #'(lambda ()
      "create fold and add comment to it"
      (interactive)
      (setq start (region-beginning))
      (setq end (region-end))
      (deactivate-mark)
      (and (< end start) (setq start (prog1 end (setq end start))))
      (goto-char start)
      (beginning-of-line)
      (indent-according-to-mode)
      (insert comment-start)
      (setq start (point))
      (insert " Folding" " {{{\n")
      (goto-char end)
      (end-of-line)
      (and (not (bolp))
           (eq 0 (forward-line))
           (eobp)
           (insert ?\n))
      (indent-according-to-mode)
      (if (equal comment-end "")
          (insert comment-start " }}}")
        (insert comment-end "}}}"))
      (goto-char start)))
