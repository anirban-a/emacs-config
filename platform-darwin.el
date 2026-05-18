;;; platform-darwin.el --- macOS-specific settings -*- lexical-binding: t; -*-

;; PDF viewer
(with-eval-after-load 'tex
  (setq TeX-view-program-selection '((output-pdf "open"))))
