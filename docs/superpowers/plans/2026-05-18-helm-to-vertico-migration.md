# Helm to Vertico Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the dead Helm completion framework with Vertico + Consult + Orderless + Marginalia + Embark in `~/.emacs.d/init.el`.

**Architecture:** Remove all Helm-related `use-package` blocks and references, then add modular completion packages that use Emacs's native `completing-read` API. Each new package has a focused `use-package` block in a new "Completion Framework" section.

**Tech Stack:** Emacs Lisp, use-package, MELPA packages (vertico, orderless, marginalia, consult, embark)

---

### Task 1: Remove all Helm config

**Files:**
- Modify: `~/.emacs.d/init.el:137-206` (Helm section + helm-descbinds + helm-projectile + comment)
- Modify: `~/.emacs.d/init.el:425-438` (helm-eshell + shell history)

- [ ] **Step 1: Delete the Helm section (lines 137-206)**

Remove everything from the `;; * Helm` header through the `helm-swoop` comment. Replace with a section header placeholder:

```elisp
;; =========================================================================
;; * Completion Framework (Vertico + Consult + Orderless + Marginalia + Embark)
;; =========================================================================
```

- [ ] **Step 2: Delete the helm-eshell section (lines 425-438)**

Remove the entire `;; * Eshell Helm Integration` section, including:
- The `helm-eshell` use-package block
- The `;; Shell history with Helm` comment and `with-eval-after-load` form

These will be replaced in Task 4.

- [ ] **Step 3: Verify Emacs launches without errors**

Run: `emacs --batch -l ~/.emacs.d/init.el 2>&1 | head -20`

Expected: No helm-related errors. There may be warnings about missing commands for keybindings that referenced helm — that's fine, they're gone now. Projectile will warn about `helm` completion system — we fix that in Task 5.

- [ ] **Step 4: Commit**

```bash
cd ~/.emacs.d
git add init.el
git commit -m "remove: delete all Helm configuration

Helm has been removed from MELPA and is unmaintained.
Clearing the way for Vertico + Consult stack."
```

---

### Task 2: Add Vertico + Orderless + Savehist

**Files:**
- Modify: `~/.emacs.d/init.el` — add to the new Completion Framework section (after the section header from Task 1)

- [ ] **Step 1: Add vertico, orderless, and savehist config**

Insert the following in the Completion Framework section:

```elisp
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
```

Key details:
- `orderless` sets `completion-styles` globally so all `completing-read` callers get fuzzy matching
- `partial-completion` is kept for file paths so `~/D/C` expands to `~/Documents/Codes`
- `savehist` is built-in (`:ensure nil`), persists minibuffer history so Vertico sorts by recency

- [ ] **Step 2: Verify Emacs launches and Vertico activates**

Run: `emacs --batch -l ~/.emacs.d/init.el --eval "(message \"vertico-mode: %s\" vertico-mode)" 2>&1 | tail -5`

Expected: `vertico-mode: t`

- [ ] **Step 3: Commit**

```bash
cd ~/.emacs.d
git add init.el
git commit -m "feat: add vertico + orderless + savehist for completion UI"
```

---

### Task 3: Add Marginalia + Consult with keybindings

**Files:**
- Modify: `~/.emacs.d/init.el` — append to Completion Framework section after vertico/orderless

- [ ] **Step 1: Add marginalia config**

```elisp
(use-package marginalia
  :config
  (marginalia-mode 1))
```

- [ ] **Step 2: Add consult config with keybindings**

```elisp
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
```

- [ ] **Step 3: Verify consult-buffer works**

Run: `emacs --batch -l ~/.emacs.d/init.el --eval "(message \"consult-buffer: %s\" (fboundp 'consult-buffer))" 2>&1 | tail -5`

Expected: `consult-buffer: t`

- [ ] **Step 4: Commit**

```bash
cd ~/.emacs.d
git add init.el
git commit -m "feat: add marginalia + consult with search/navigation bindings"
```

---

### Task 4: Add Embark + Eshell/Shell history

**Files:**
- Modify: `~/.emacs.d/init.el` — append to Completion Framework section
- Modify: `~/.emacs.d/init.el` — add new eshell/shell section where the old helm-eshell section was

- [ ] **Step 1: Add embark and embark-consult config**

Append to the Completion Framework section:

```elisp
(use-package embark
  :bind (("C-."   . embark-act)
         ("C-;"   . embark-dwim)
         ("C-h B" . embark-bindings)))

(use-package embark-consult
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))
```

- [ ] **Step 2: Add consult-history for eshell and shell**

In the location where the old `Eshell Helm Integration` section was, add:

```elisp
;; =========================================================================
;; * Eshell & Shell History (Consult)
;; =========================================================================

(with-eval-after-load 'eshell
  (add-hook 'eshell-mode-hook
            (lambda ()
              (define-key eshell-mode-map (kbd "C-c C-l")
                #'consult-history))))

(with-eval-after-load 'shell
  (define-key shell-mode-map (kbd "C-c C-l") #'consult-history))
```

- [ ] **Step 3: Verify embark loads**

Run: `emacs --batch -l ~/.emacs.d/init.el --eval "(message \"embark-act: %s\" (fboundp 'embark-act))" 2>&1 | tail -5`

Expected: `embark-act: t`

- [ ] **Step 4: Commit**

```bash
cd ~/.emacs.d
git add init.el
git commit -m "feat: add embark actions + consult-history for eshell/shell"
```

---

### Task 5: Update Projectile and guide-key integration

**Files:**
- Modify: `~/.emacs.d/init.el:217` (projectile completion system)
- Modify: `~/.emacs.d/init.el:390-403` (guide-key config — line numbers will have shifted from earlier edits; search for `guide-key`)

- [ ] **Step 1: Change projectile completion system**

Find this line in the projectile config:

```elisp
  (setq projectile-completion-system 'helm))
```

Replace with:

```elisp
  (setq projectile-completion-system 'default))
```

- [ ] **Step 2: Update guide-key sequences and highlights**

Find the `guide-key` use-package block. Change the `guide-key/guide-key-sequence` to replace `"C-c h"` with `"M-s"` and `"M-g"`:

```elisp
  (setq guide-key/guide-key-sequence
        '("C-x" "C-c" "M-s" "M-g" "C-c p"
          (org-mode "C-c C-x")
          (ess-r-mode "C-c")
          (LaTeX-mode "C-c")))
```

Change the highlight regexp to replace `"helm"` with `"consult"`:

```elisp
  (setq guide-key/highlight-command-regexp
        '("consult" ("projectile" . font-lock-type-face)))
```

- [ ] **Step 3: Verify clean startup**

Run: `emacs --batch -l ~/.emacs.d/init.el 2>&1 | grep -i "error\|warning"`

Expected: No errors. No warnings related to helm or completion.

- [ ] **Step 4: Commit**

```bash
cd ~/.emacs.d
git add init.el
git commit -m "fix: update projectile and guide-key for vertico/consult"
```

---

### Task 6: Clean up stale Helm packages and verify

**Files:**
- No file edits — cleanup and manual verification

- [ ] **Step 1: Delete old Helm packages from elpa directory**

```bash
rm -rf ~/.emacs.d/elpa/helm-* ~/.emacs.d/elpa/async-*
```

(async was only a dependency of Helm. If another package needs it, use-package will reinstall it.)

- [ ] **Step 2: Full startup verification**

Launch Emacs normally (not --batch) and verify:

1. No errors in `*Messages*` buffer (`C-h e` to view)
2. `M-x` shows vertical completion with orderless matching
3. `C-x b` shows buffer list with annotations (marginalia)
4. `M-s l` opens consult-line for in-buffer search
5. `C-.` on a candidate in any completion triggers embark-act
6. `C-c p f` (projectile-find-file) uses Vertico completion
7. Open an R file — no errors

- [ ] **Step 3: Commit any package-related changes**

```bash
cd ~/.emacs.d
git add -A
git commit -m "chore: remove stale helm packages from elpa"
```
