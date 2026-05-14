# Emacs Configuration

A minimal Emacs configuration for data science (R, Python, LaTeX) and Lean 4 theorem proving, built on Helm and the tao-yang monochrome theme.

## Prerequisites

- Emacs 27+
- [Source Code Pro](https://github.com/adobe-fonts/source-code-pro) font
- [elan](https://github.com/leanprover/elan) (for Lean 4 support)

## Installation

```bash
git clone --recursive https://github.com/anirban-a/emacs-config.git ~/.emacs.d
```

On first launch, Emacs will automatically download and install all packages from MELPA/ELPA. This may take a minute or two.

## What's Included

### Theme & Appearance

- [tao-yang](https://github.com/11111000000/tao-theme-emacs) monochrome light theme
- Source Code Pro, 14pt
- Line numbers, line highlighting, matched parentheses

### Navigation (Helm)

Helm replaces standard Emacs completion with fuzzy-matching interactive selection.

| Key | Command |
|-----|---------|
| `M-x` | `helm-M-x` (fuzzy command search) |
| `C-x C-f` | `helm-find-files` |
| `C-x b` | `helm-mini` (buffers + recent files) |
| `M-y` | `helm-show-kill-ring` |
| `C-c h o` | `helm-occur` (search in buffer) |
| `C-c h i` | `helm-semantic-or-imenu` (jump to definition) |
| `C-c h a` | `helm-apropos` |
| `C-c h b` | `helm-resume` (resume last session) |
| `C-c p h` | `helm-projectile` (project-wide file search) |

### Data Science

**R / ESS**
- ESS with RStudio-style indentation
- `S-RET` sends line or region to R process
- `M-_` inserts assignment operator (`<-`)
- Polymode for R Markdown (`.Rmd`) files

**Python / Elpy**
- Elpy with Jupyter console integration
- Flycheck for syntax checking (replaces flymake)

**Org Mode**
- Babel support for R, Python, shell, LaTeX, and Emacs Lisp
- Native source block fontification

**LaTeX / AUCTeX**
- AUCTeX with auto-parsing and PDF mode
- RefTeX for citations and cross-references (biblatex formats)
- ebib for BibTeX database management
- latexmk compilation with synctex

### Clojure

- [CIDER](https://github.com/clojure-emacs/cider) for interactive REPL development (`M-x cider-jack-in` to connect)
- [clj-refactor](https://github.com/clojure-emacs/clj-refactor.el) for refactoring (`C-c C-m` prefix)
- [smartparens](https://github.com/Fuco1/smartparens) strict mode for balanced parentheses
- Supports `.clj`, `.cljs`, `.cljc`, and `.edn` files
- Requires [Leiningen](https://leiningen.org/) or the [Clojure CLI](https://clojure.org/guides/install_clojure)

### Lean 4

- [lean4-mode](https://github.com/leanprover-community/lean4-mode) (included as git submodule)
- LSP integration via lsp-mode
- Automatic `~/.elan/bin` path setup for GUI Emacs

| Key | Command |
|-----|---------|
| `C-c C-k` | Show keystroke for symbol |
| `C-c C-d` | Reload imports |
| `C-c C-x` | Execute standalone |
| `C-c C-p C-l` | Build with Lake |
| `C-c C-i` | Toggle proof state viewer |

### Completion & Editing

- **Company** for auto-completion (with math symbol support)
- **YASnippet** for snippet expansion
- **Flycheck** for on-the-fly syntax checking
- **Magit** (`C-x g`) for git
- **[guide-key](https://github.com/kai2nenobu/guide-key)** for keybinding discovery (press a prefix like `C-x` or `C-c h` and wait 0.5s to see available bindings in a popup; recursive mode enabled, Helm/Projectile commands highlighted)
- **multiple-cursors** (`C->`/`C-<`)
- **expand-region** (`C-=`)
- **undo-tree** for visual undo history

## File Structure

```
~/.emacs.d/
  early-init.el   -- startup optimizations, disable UI chrome early
  init.el         -- main configuration
  lean4-mode/     -- git submodule
```

Packages are installed to `elpa/` on first launch (gitignored).
