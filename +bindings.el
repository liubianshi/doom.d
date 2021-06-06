;;; $DOOMDIR/+bindings.el -*- lexical-binding: t; -*-
(map! :n "j"  #'evil-next-visual-line
      :n "k"  #'evil-previous-visual-line
      :n "gj" #'evil-next-line
      :n "gk" #'evil-previous-line)

(map! :map evil-window-map
      "SPC" #'rotate-layout
      ;; Navigation
      "<left>"     #'evil-window-left
      "<down>"     #'evil-window-down
      "<up>"       #'evil-window-up
      "<right>"    #'evil-window-right
      ;; Swapping windows
      "C-<left>"       #'+evil/window-move-left
      "C-<down>"       #'+evil/window-move-down
      "C-<up>"         #'+evil/window-move-up
      "C-<right>"      #'+evil/window-move-right)
