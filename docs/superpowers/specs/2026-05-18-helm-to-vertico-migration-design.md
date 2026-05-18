# Helm to Vertico Migration Design

## Context

Helm has been removed from MELPA and is effectively unmaintained. The Emacs config at `~/.emacs.d/init.el` depends on Helm for minibuffer completion, and can no longer install it. This design replaces Helm with the Vertico + Consult + Orderless + Marginalia + Embark stack.

## Package Mapping

### New packages

| Package | Role | Replaces |
|---------|------|----------|
| vertico | Vertical completion UI in minibuffer | Helm's popup display |
| orderless | Space-separated fuzzy/partial matching | All `helm-*-fuzzy-match` settings |
| marginalia | Rich annotations (docstrings, file info) | Helm's built-in candidate annotations |
| consult | Search/navigation commands | helm-mini, helm-occur, helm-imenu, helm-show-kill-ring, helm-all-mark-rings, helm-locate, helm-man-woman, helm-find |
| embark | Contextual actions on any candidate | helm-select-action (C-z) |
| embark-consult | Glue between embark and consult | N/A |

### Removed packages (no replacement)

- `helm` — replaced by vertico + orderless
- `helm-descbinds` — not needed; embark covers action discovery
- `helm-projectile` — not needed; projectile uses `completing-read` natively
- `helm-eshell` — replaced by consult-history
- `helm-top`, `helm-surfraw`, `helm-google-suggest`, `helm-color`, `helm-regexp` — dropped per user request

### New supporting config

- `savehist-mode` — enables Vertico to sort candidates by recency

## Keybindings

| Binding | Command | Purpose |
|---------|---------|---------|
| M-x | built-in (enhanced by Vertico) | Command completion |
| M-y | consult-yank-pop | Kill ring browser |
| C-x b | consult-buffer | Buffers + recent files + bookmarks |
| C-x C-f | built-in find-file (enhanced by Vertico) | File navigation |
| M-s l | consult-line | Search lines in current buffer |
| M-s g | consult-grep | Grep across files |
| M-s r | consult-ripgrep | Ripgrep across files |
| M-s f | consult-find | Find file by name |
| M-s L | consult-locate | Locate files |
| M-g i | consult-imenu | Jump to symbol in buffer |
| M-g m | consult-mark | Mark ring navigation |
| M-g M | consult-global-mark | Global mark ring |
| M-g o | consult-outline | Jump to heading |
| C-x r b | consult-bookmark | Bookmarks |
| C-. | embark-act | Context action on any candidate |
| C-; | embark-dwim | Default action on thing at point |

Eshell and shell modes bind `C-c C-l` to `consult-history`.

## Integration Changes

### Projectile

Change `projectile-completion-system` from `'helm` to `'default`. Projectile then uses `completing-read`, which Vertico enhances automatically.

### guide-key

- Remove `"C-c h"` from `guide-key/guide-key-sequence` (was Helm prefix)
- Add `"M-s"` and `"M-g"` (Consult search/goto prefixes)
- Remove `"helm"` from `guide-key/highlight-command-regexp`
- Add `"consult"` highlight instead

### Eshell / Shell history

- Replace `helm-eshell-history` hook with `consult-history` on `C-c C-l` in eshell-mode
- Replace `helm-comint-input-ring` with `consult-history` on `C-c C-l` in shell-mode

### Company

No changes. Company operates in-buffer; Vertico operates in the minibuffer. They are independent.

## Scope

This migration is limited to replacing Helm in `~/.emacs.d/init.el`. No other files are affected. The structure of init.el is preserved — the Helm section is replaced with a Completion Framework section containing the new packages.
