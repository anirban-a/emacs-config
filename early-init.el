;;; early-init.el --- Early initialization -*- lexical-binding: t; -*-

;; Increase GC threshold for faster startup
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))

;; Disable package.el at startup (we use use-package)
(setq package-enable-at-startup nil)

;; Disable UI elements early for faster startup
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(setq frame-inhibit-implied-resize t)
