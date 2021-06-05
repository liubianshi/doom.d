;;; $DOOMDIR/+projectile.el -*- lexical-binding: t; -*-
(after! projectile
  (projectile-register-project-type 'rmd '("index.Rmd")
                                    :project-file "index.Rmd"))
