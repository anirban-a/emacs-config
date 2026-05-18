# Emacs Configuration

A minimal Emacs configuration for data science (R, Python, LaTeX), Clojure, and Lean 4 theorem proving. Uses Vertico + Consult for completion and the badwolf/tao-yang themes.

## Setup

### macOS

```bash
# Emacs
brew install --cask emacs

# Font
brew install --cask font-source-code-pro

# Language toolchains
brew install r
brew install python
pip install jupyter
brew install leiningen            # Clojure
brew install --cask mactex        # LaTeX
brew install latexmk
brew install ripgrep              # for consult-ripgrep

# Lean 4
curl -sSf https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh | sh
```

### Ubuntu

```bash
# Emacs
sudo apt install emacs

# Font
sudo apt install fonts-source-code-pro

# Language toolchains
sudo apt install r-base
sudo apt install python3 python3-pip python3-venv
pip install jupyter
sudo apt install leiningen        # Clojure
sudo apt install texlive texlive-latex-extra latexmk  # LaTeX
sudo apt install ripgrep          # for consult-ripgrep

# Lean 4
curl -sSf https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh | sh
```

### Install the config

```bash
git clone --recursive https://github.com/anirban-a/emacs-config.git ~/.emacs.d
```

Lean 4 mode is not on MELPA. If not included as a submodule, clone it manually:

```bash
cd ~/.emacs.d
git clone https://github.com/leanprover-community/lean4-mode.git
```

On first launch, Emacs will automatically download and install all packages from MELPA/ELPA. This may take a minute or two.

## File Structure

```
~/.emacs.d/
  init.el              # Main configuration
  early-init.el        # Startup optimizations, disable UI chrome early
  platform-darwin.el   # macOS-specific settings (PDF viewer: open)
  platform-linux.el    # Linux-specific settings (PDF viewer: xdg-open)
  lean4-mode/          # Local checkout (git submodule)
```

Platform-specific files are loaded automatically based on `system-type`. Packages are installed to `elpa/` on first launch (gitignored).

## Theme & Appearance

Two themes, toggled with `C-c t`:

- **[badwolf](https://github.com/bkruczyk/badwolf-emacs)** (default) -- dark theme
- **[tao-yang](https://github.com/11111000000/tao-theme-emacs)** -- light theme with custom vibrant syntax colors

Other: Source Code Pro 14pt, line numbers, line highlighting, matched parentheses, [rainbow-delimiters](https://github.com/Fanael/rainbow-delimiters).

## Key Bindings

### Completion & Navigation (Vertico + Consult + Embark)

| Key | Command | Purpose |
|-----|---------|---------|
| `M-x` | (enhanced by Vertico) | Command completion with orderless matching |
| `C-x b` | `consult-buffer` | Buffers + recent files + bookmarks |
| `C-x C-f` | (enhanced by Vertico) | File navigation |
| `M-y` | `consult-yank-pop` | Kill ring browser |
| `M-s l` | `consult-line` | Search lines in buffer |
| `M-s g` | `consult-grep` | Grep across files |
| `M-s r` | `consult-ripgrep` | Ripgrep across files |
| `M-s f` | `consult-find` | Find file by name |
| `M-s L` | `consult-locate` | Locate files |
| `M-g i` | `consult-imenu` | Jump to symbol |
| `M-g o` | `consult-outline` | Jump to heading |
| `M-g m` | `consult-mark` | Mark ring |
| `M-g M` | `consult-global-mark` | Global mark ring |
| `C-x r b` | `consult-bookmark` | Bookmarks |
| `C-.` | `embark-act` | Context actions on candidate |
| `C-;` | `embark-dwim` | Default action at point |
| `C-h B` | `embark-bindings` | Browse all key bindings |

### R / ESS

| Key | Command | Purpose |
|-----|---------|---------|
| `S-<return>` | `ess-send-line-or-region` | Send line/region to R |
| `M-_` | `ess-insert-assign` | Insert `<-` |
| `C-c C-i` | `polymode-insert-new-chunk` | New R chunk in Rmd |

ESS uses RStudio-style indentation. Flycheck runs on save only (to avoid lag from lintr). Polymode is enabled for `.Rmd` files.

### Python / Elpy

Elpy with Jupyter console integration. Start with `M-x run-python`.

Flycheck replaces flymake for syntax checking.

### Clojure

| Key | Command | Purpose |
|-----|---------|---------|
| `M-x cider-jack-in` | | Connect to REPL |
| `C-c C-m` | clj-refactor prefix | Refactoring commands |

CIDER for REPL, Company + CIDER for completion, eldoc for signatures, dynamic syntax highlighting, rainbow-delimiters, smartparens strict mode. Supports `.clj`, `.cljs`, `.cljc`, `.edn`.

Requires [Leiningen](https://leiningen.org/) or the [Clojure CLI](https://clojure.org/guides/install_clojure).

### Lean 4

| Key | Command |
|-----|---------|
| `C-c C-k` | Show keystroke for symbol |
| `C-c C-d` | Reload imports |
| `C-c C-x` | Execute standalone |
| `C-c C-p C-l` | Build with Lake |
| `C-c C-i` | Toggle proof state viewer |

LSP integration via lsp-mode. `~/.elan/bin` is added to PATH automatically.

### LaTeX / AUCTeX

AUCTeX with auto-parsing, PDF mode, and latexmk. RefTeX for citations (biblatex formats). ebib for BibTeX management (`C-c b`).

PDF viewer is configured per-platform (`open` on macOS, `xdg-open` on Linux).

### Project Management

| Key | Command | Purpose |
|-----|---------|---------|
| `C-c p f` | `projectile-find-file` | Find file in project |
| `C-c p s` | `projectile-switch-project` | Switch project |
| `C-c p g` | `projectile-grep` | Grep in project |

### Git

| Key | Command |
|-----|---------|
| `C-x g` | `magit-status` |

### Editing

| Key | Command | Purpose |
|-----|---------|---------|
| `C-c t` | `my/toggle-theme` | Toggle dark/light theme |
| `C-=` | `er/expand-region` | Expand selection |
| `C->` / `C-<` | `mc/mark-next/previous-like-this` | Multiple cursors |
| `C-c k` | `browse-kill-ring` | Browse kill ring |

Other: undo-tree, guide-key (press a prefix and wait 0.5s to see available bindings), YASnippet, Company auto-completion with math symbol support.
