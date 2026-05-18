;;; platform-linux.el --- Linux-specific settings -*- lexical-binding: t; -*-

;; PDF viewer
(with-eval-after-load 'tex
  (setq TeX-view-program-selection '((output-pdf "xdg-open"))))
