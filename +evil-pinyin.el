;;; $DOOMDIR/+evil-pinyin.el -*- lexical-binding: t; -*-
(use-package! evil-pinyin
  :init
  (setq-default evil-pinyin-scheme 'simplified-xiaohe-all)
  (setq-default evil-pinyin-with-search-rule 'custom)
  :config
  (global-evil-pinyin-mode))
