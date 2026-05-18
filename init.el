;;; init.el --- Main Emacs configuration -*- lexical-binding: t; -*-

;; =========================================================================
;; * Package Management
;; =========================================================================

(require 'package)
(setq package-archives
      '(("melpa"        . "https://melpa.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")
        ("gnu"          . "https://elpa.gnu.org/packages/")
        ("nongnu"       . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)

;; =========================================================================
;; * Theme & Appearance
;; =========================================================================

(use-package tao-theme :defer t)
(use-package badwolf-theme :defer t)

;; Custom face overrides for tao-yang (vibrant syntax on monochrome base)
(defun my/apply-tao-yang-faces ()
  "Apply vibrant syntax highlighting for tao-yang."
  (custom-set-faces
   '(font-lock-keyword-face       ((t (:foreground "#7928a0" :weight bold))))
   '(font-lock-function-name-face ((t (:foreground "#1a6fb5" :weight bold))))
   '(font-lock-variable-name-face ((t (:foreground "#b55a1a"))))
   '(font-lock-string-face        ((t (:foreground "#2a8c4a"))))
   '(font-lock-comment-face       ((t (:foreground "#8a8a8a" :slant italic))))
   '(font-lock-type-face          ((t (:foreground "#a0522d"))))
   '(font-lock-constant-face      ((t (:foreground "#b5264e"))))
   '(font-lock-builtin-face       ((t (:foreground "#6a5acd"))))
   '(font-lock-warning-face       ((t (:foreground "#cc3333" :weight bold))))
   '(font-lock-doc-face           ((t (:foreground "#5f8c5f" :slant italic))))
   '(cider-result-overlay-face    ((t (:foreground "#1a6fb5" :background "#e8f0fe"))))
   '(clojure-keyword-face         ((t (:foreground "#8b2252"))))
   '(rainbow-delimiters-depth-1-face ((t (:foreground "#7928a0"))))
   '(rainbow-delimiters-depth-2-face ((t (:foreground "#1a6fb5"))))
   '(rainbow-delimiters-depth-3-face ((t (:foreground "#2a8c4a"))))
   '(rainbow-delimiters-depth-4-face ((t (:foreground "#b55a1a"))))
   '(rainbow-delimiters-depth-5-face ((t (:foreground "#a0522d"))))
   '(rainbow-delimiters-depth-6-face ((t (:foreground "#6a5acd"))))
   '(rainbow-delimiters-depth-7-face ((t (:foreground "#b5264e"))))
   '(rainbow-delimiters-depth-8-face ((t (:foreground "#8b2252"))))
   '(rainbow-delimiters-depth-9-face ((t (:foreground "#1a6fb5"))))))

(defvar my/current-theme 'badwolf
  "Currently active theme. Set to 'tao-yang or 'badwolf.")

(defun my/load-theme-badwolf ()
  "Load badwolf dark theme."
  (interactive)
  (mapc #'disable-theme custom-enabled-themes)
  (load-theme 'badwolf t)
  (setq my/current-theme 'badwolf))

(defun my/load-theme-tao-yang ()
  "Load tao-yang light theme with vibrant syntax colors."
  (interactive)
  (mapc #'disable-theme custom-enabled-themes)
  (load-theme 'tao-yang t)
  (my/apply-tao-yang-faces)
  (setq my/current-theme 'tao-yang))

(defun my/toggle-theme ()
  "Toggle between badwolf and tao-yang themes."
  (interactive)
  (if (eq my/current-theme 'badwolf)
      (my/load-theme-tao-yang)
    (my/load-theme-badwolf))
  (message "Theme: %s" my/current-theme))

(global-set-key (kbd "C-c t") #'my/toggle-theme)

;; Default to badwolf
(my/load-theme-badwolf)

(set-face-attribute 'default nil
                    :family "Source Code Pro"
                    :height 140
                    :weight 'normal
                    :width 'normal)

(setq-default line-spacing 2)
(global-hl-line-mode 1)
(column-number-mode 1)
(show-paren-mode 1)
(global-display-line-numbers-mode 1)

;; Frame settings
(add-to-list 'default-frame-alist '(width . 120))
(add-to-list 'default-frame-alist '(height . 50))
(add-to-list 'default-frame-alist '(internal-border-width . 15))

;; =========================================================================
;; * General Settings
;; =========================================================================

(setq inhibit-startup-screen t
      initial-scratch-message nil
      ring-bell-function 'ignore
      make-backup-files nil
      auto-save-default nil
      create-lockfiles nil
      custom-file (expand-file-name "custom.el" user-emacs-directory))

(when (file-exists-p custom-file)
  (load custom-file))

(setq-default indent-tabs-mode nil
              tab-width 4)

(fset 'yes-or-no-p 'y-or-n-p)
(global-auto-revert-mode 1)
(delete-selection-mode 1)
(save-place-mode 1)
(recentf-mode 1)
(setq recentf-max-saved-items 200)

;; Unique buffer names
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; UTF-8 everywhere
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)

;; =========================================================================
;; * Completion Framework (Vertico + Consult + Orderless + Marginalia + Embark)
;; =========================================================================

(use-package vertico
  :config
  (vertico-mode 1))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion)))))

;; Persist completion history for Vertico sorting
(use-package savehist
  :ensure nil
  :config
  (savehist-mode 1))

(use-package marginalia
  :config
  (marginalia-mode 1))

(use-package consult
  :bind (("M-y"     . consult-yank-pop)
         ("C-x b"   . consult-buffer)
         ("M-s l"   . consult-line)
         ("M-s g"   . consult-grep)
         ("M-s r"   . consult-ripgrep)
         ("M-s f"   . consult-find)
         ("M-s L"   . consult-locate)
         ("M-g i"   . consult-imenu)
         ("M-g m"   . consult-mark)
         ("M-g M"   . consult-global-mark)
         ("M-g o"   . consult-outline)
         ("C-x r b" . consult-bookmark)))

;; =========================================================================
;; * Project Management
;; =========================================================================

(use-package projectile
  :diminish projectile-mode
  :bind-keymap ("C-c p" . projectile-command-map)
  :config
  (projectile-mode 1)
  (setq projectile-completion-system 'helm))

;; =========================================================================
;; * Completion (Company Mode + YASnippet)
;; =========================================================================

(use-package yasnippet
  :diminish yas-minor-mode
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :after yasnippet)

(use-package company
  :diminish company-mode
  :bind (("C-<tab>" . company-complete)
         :map company-active-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous))
  :config
  (setq company-idle-delay 0.2
        company-minimum-prefix-length 2
        company-require-match nil
        company-tooltip-align-annotations t)
  (global-company-mode 1))

(use-package company-math
  :after company
  :config
  (add-to-list 'company-backends 'company-math-symbols-unicode))

;; =========================================================================
;; * Syntax Checking
;; =========================================================================

(use-package flycheck
  :diminish flycheck-mode
  :config
  (global-flycheck-mode 1))

;; =========================================================================
;; * R / ESS (Emacs Speaks Statistics)
;; =========================================================================

(use-package ess
  :mode (("\\.R\\'"   . ess-r-mode)
         ("\\.Rmd\\'" . ess-r-mode))
  :config
  (setq ess-use-flymake nil)   ;; use flycheck instead
  (setq ess-style 'RStudio)
  (setq ess-ask-for-ess-directory nil)

  ;; Shift+Enter to send line/region
  (defun ess-send-line-or-region ()
    "Send the current line or region to the R process."
    (interactive)
    (if (use-region-p)
        (ess-eval-region (region-beginning) (region-end) nil)
      (ess-eval-line nil)))

  :bind (:map ess-r-mode-map
         ("S-<return>" . ess-send-line-or-region)
         ("M-_"        . ess-insert-assign)
         ("C-c C-i"    . polymode-insert-new-chunk)))

(use-package ess-r-mode
  :ensure nil
  :after ess
  :hook (ess-r-mode . (lambda ()
                        (setq-local ess-use-flymake nil))))

;; Polymode for Rmd files
(use-package poly-R
  :after ess
  :mode ("\\.Rmd\\'" . poly-markdown+r-mode))

(use-package poly-markdown
  :after polymode)

;; =========================================================================
;; * Python (Elpy)
;; =========================================================================

(use-package elpy
  :init
  (elpy-enable)
  :config
  (setq python-shell-interpreter "jupyter"
        python-shell-interpreter-args "console --simple-prompt"
        python-shell-prompt-detect-failure-warning nil)
  (add-to-list 'python-shell-completion-native-disabled-interpreters "jupyter")
  (when (fboundp 'flycheck-mode)
    (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
    (add-hook 'elpy-mode-hook 'flycheck-mode)))

;; =========================================================================
;; * Org Mode
;; =========================================================================

(use-package org
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c c" . org-capture))
  :config
  (setq org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-confirm-babel-evaluate nil
        org-edit-src-content-indentation 0)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python     . t)
     (R          . t)
     (shell      . t)
     (latex      . t))))

;; =========================================================================
;; * LaTeX (AUCTeX + RefTeX)
;; =========================================================================

(use-package tex
  :ensure auctex
  :config
  (setq TeX-auto-save t
        TeX-parse-self t
        TeX-PDF-mode t)
  (setq-default TeX-master nil)
  (setq TeX-view-program-selection '((output-pdf "open")))

  ;; latexmk as default command
  (add-to-list 'TeX-command-list
               '("latexmk" "latexmk -pdf -synctex=1 %s"
                 TeX-run-TeX nil t
                 :help "Run latexmk on file")))

(use-package reftex
  :after tex
  :hook (LaTeX-mode . reftex-mode)
  :config
  (setq reftex-plug-into-AUCTeX t
        reftex-enable-partial-scans t
        reftex-save-parse-info t
        reftex-use-multiple-selection-buffers t)
  (setq reftex-cite-format
        '((?\C-m . "\\cite[]{%l}")
          (?t    . "\\textcite{%l}")
          (?a    . "\\autocite[]{%l}")
          (?p    . "\\parencite{%l}")
          (?f    . "\\footcite[][]{%l}"))))

(use-package ebib
  :after tex
  :bind (:map LaTeX-mode-map ("C-c b" . ebib-insert-citation)))

;; =========================================================================
;; * Git
;; =========================================================================

(use-package magit
  :bind ("C-x g" . magit-status))

(use-package diff-hl
  :config
  (global-diff-hl-mode 1))

;; =========================================================================
;; * Navigation & Editing Helpers
;; =========================================================================

(use-package compat
  :demand t)

(use-package guide-key
  :diminish guide-key-mode
  :config
  (setq guide-key/guide-key-sequence
        '("C-x" "C-c" "C-c h" "C-c p"
          (org-mode "C-c C-x")
          (ess-r-mode "C-c")
          (LaTeX-mode "C-c")))
  (setq guide-key/recursive-key-sequence-flag t)
  (setq guide-key/idle-delay 0.5)
  (setq guide-key/popup-window-position 'bottom)
  (setq guide-key/highlight-command-regexp
        '("helm" ("projectile" . font-lock-type-face)))
  (guide-key-mode 1))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package multiple-cursors
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))

(use-package browse-kill-ring
  :bind ("C-c k" . browse-kill-ring))

(use-package undo-tree
  :diminish undo-tree-mode
  :config
  (global-undo-tree-mode 1)
  (setq undo-tree-history-directory-alist
        `(("." . ,(expand-file-name "undo-tree-hist" user-emacs-directory)))))

(use-package diminish)


;; =========================================================================
;; * Markdown
;; =========================================================================

(use-package markdown-mode
  :mode (("\\.md\\'"       . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)))

;; =========================================================================
;; * CSV Mode
;; =========================================================================

(use-package csv-mode
  :mode "\\.csv\\'")

;; =========================================================================
;; * Clojure
;; =========================================================================

(use-package clojure-mode
  :mode (("\\.clj\\'"  . clojure-mode)
         ("\\.cljs\\'" . clojurescript-mode)
         ("\\.cljc\\'" . clojurec-mode)
         ("\\.edn\\'"  . clojure-mode)))

(use-package cider
  :hook ((clojure-mode . cider-mode)
         (cider-mode . eldoc-mode)
         (cider-repl-mode . eldoc-mode))
  :init
  ;; Set before CIDER loads so dynamic font-lock is ready at connection time
  (setq cider-font-lock-dynamically '(macro core function var))
  :config
  (setq cider-repl-display-help-banner nil
        cider-repl-pop-to-buffer-on-connect 'display-only
        cider-auto-select-error-buffer nil
        cider-repl-use-pretty-printing t
        cider-eldoc-display-for-symbol-at-point t)

  ;; Refresh font-lock after connecting to REPL
  (add-hook 'cider-connected-hook
            (lambda ()
              (dolist (buf (buffer-list))
                (with-current-buffer buf
                  (when (derived-mode-p 'clojure-mode)
                    (cider-refresh-dynamic-font-lock))))))

  ;; Company completion via CIDER
  (add-hook 'cider-mode-hook
            (lambda ()
              (setq-local company-backends
                          '((company-capf company-dabbrev-code)))))
  (add-hook 'cider-repl-mode-hook
            (lambda ()
              (setq-local company-backends
                          '((company-capf company-dabbrev-code))))))

(use-package rainbow-delimiters
  :hook ((clojure-mode . rainbow-delimiters-mode)
         (cider-repl-mode . rainbow-delimiters-mode)
         (emacs-lisp-mode . rainbow-delimiters-mode)))

(use-package clj-refactor
  :after clojure-mode
  :diminish clj-refactor-mode
  :hook (clojure-mode . (lambda ()
                          (clj-refactor-mode 1)
                          (cljr-add-keybindings-with-prefix "C-c C-m"))))

(use-package smartparens
  :diminish smartparens-mode
  :hook ((clojure-mode . smartparens-strict-mode)
         (cider-repl-mode . smartparens-strict-mode)
         (emacs-lisp-mode . smartparens-strict-mode))
  :config
  (require 'smartparens-config))

;; =========================================================================
;; * Lean 4
;; =========================================================================

(use-package dash)

(use-package lsp-mode
  :commands lsp
  :config
  (setq lsp-headerline-breadcrumb-enable t
        lsp-inlay-hint-enable nil)

  ;; Suppress "Unknown request method: workspace/inlayHint/refresh"
  (defun my/lsp-ignore-inlay-hint-refresh (orig-fn workspace request)
    "Silently handle workspace/inlayHint/refresh requests."
    (let ((method (lsp:json-rpc-request-method request)))
      (if (equal method "workspace/inlayHint/refresh")
          (let* ((recv-time (current-time))
                 (id (lsp:json-rpc-request-id request)))
            (lsp--send-request-response workspace recv-time request nil))
        (funcall orig-fn workspace request))))
  (advice-add 'lsp--on-request :around #'my/lsp-ignore-inlay-hint-refresh))

;; Add elan binaries to exec-path so GUI Emacs can find lean/lake
(let ((elan-bin (expand-file-name "~/.elan/bin")))
  (add-to-list 'exec-path elan-bin)
  (setenv "PATH" (concat elan-bin ":" (getenv "PATH"))))

(add-to-list 'load-path (expand-file-name "lean4-mode" user-emacs-directory))
(require 'lean4-mode)

;; =========================================================================
;; * Restore GC Threshold
;; =========================================================================

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold 800000)
            (message "Emacs loaded in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))
