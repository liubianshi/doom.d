;;; $DOOMDIR/+translate.el -*- lexical-binding: t; -*-
(use-package! go-translate
  :custom
  (gts-translate-list '(("en" "zh") ("fr" "zh"))))
(setq gts-default-translator
      (gts-translator
       :picker (gts-prompt-picker :texter (gts-current-or-selection-texter) :single nil)
       :engines (list (gts-google-rpc-engine :parser (gts-google-rpc-summary-parser))
                      (gts-bing-engine))
       :render (gts-buffer-render)))
