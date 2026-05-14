# Clojure Ecosystem Setup

A guide to installing the Clojure toolchain for use with this Emacs configuration.

## Prerequisites

- **Java** (JDK 11 or later)

  ```bash
  # macOS
  brew install openjdk

  # Verify
  java -version
  ```

## Clojure CLI

The official Clojure command-line tool for running REPLs, scripts, and managing dependencies.

```bash
# macOS
brew install clojure/tools/clojure

# Linux
curl -L -O https://github.com/clojure/brew-install/releases/latest/download/linux-install.sh
chmod +x linux-install.sh
sudo ./linux-install.sh

# Verify
clojure --version
```

### Usage

```bash
# Start a REPL
clj

# Run with dependencies (deps.edn)
clj -Sdeps '{:deps {org.clojure/data.json {:mvn/version "2.5.1"}}}'

# Run a script
clj -M -m my.namespace
```

### deps.edn

Projects use a `deps.edn` file for dependency management:

```clojure
{:deps {org.clojure/clojure {:mvn/version "1.12.0"}
        org.clojure/data.json {:mvn/version "2.5.1"}}

 :aliases
 {:test {:extra-paths ["test"]
         :extra-deps {io.github.cognitect-labs/test-runner
                      {:git/tag "v0.5.1" :git/sha "dfb30dd"}}}}}
```

## Leiningen

A build tool and project manager for Clojure.

```bash
# macOS
brew install leiningen

# Linux / manual
mkdir -p ~/bin
curl -o ~/bin/lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
chmod +x ~/bin/lein
lein  # self-installs on first run

# Verify
lein version
```

### Usage

```bash
# Create a new project
lein new app my-project

# Start a REPL
cd my-project && lein repl

# Run the project
lein run

# Run tests
lein test

# Build an uberjar
lein uberjar
```

### project.clj

Leiningen projects use `project.clj`:

```clojure
(defproject my-project "0.1.0"
  :description "My Clojure project"
  :dependencies [[org.clojure/clojure "1.12.0"]]
  :main my-project.core
  :repl-options {:init-ns my-project.core})
```

## Connecting from Emacs

### CIDER Jack-In

The simplest way to start a REPL connected to Emacs:

| Command | Description |
|---------|-------------|
| `M-x cider-jack-in` | Start a Clojure REPL (auto-detects Leiningen or deps.edn) |
| `M-x cider-jack-in-cljs` | Start a ClojureScript REPL |
| `M-x cider-connect` | Connect to an already running nREPL server |

### CIDER Key Bindings

Once connected to a REPL:

| Key | Command |
|-----|---------|
| `C-c C-e` | Evaluate expression before point |
| `C-c C-k` | Evaluate current buffer |
| `C-c C-r` | Evaluate region |
| `C-c M-n n` | Switch REPL namespace to current file |
| `C-c C-d d` | Show documentation for symbol |
| `C-c C-d j` | Show Javadoc for symbol |
| `C-c M-.` | Jump to definition |
| `C-c C-t t` | Run test at point |
| `C-c C-t n` | Run tests in namespace |
| `C-c C-t p` | Run all project tests |
| `C-c C-z` | Switch between source and REPL buffers |
| `C-c C-q` | Quit CIDER |

### clj-refactor Key Bindings

Refactoring commands are prefixed with `C-c C-m`:

| Key | Command |
|-----|---------|
| `C-c C-m r r` | Rename symbol |
| `C-c C-m e f` | Extract function |
| `C-c C-m a m` | Add missing require |
| `C-c C-m a p` | Add project dependency |
| `C-c C-m t f` | Thread first (`->`) |
| `C-c C-m t l` | Thread last (`->>`) |
| `C-c C-m i l` | Introduce let binding |
| `C-c C-m s n` | Sort namespace requires |

### Running an External nREPL

If you prefer to start the REPL outside Emacs:

```bash
# With Leiningen
lein repl :headless :port 7888

# With Clojure CLI (requires nREPL dependency)
clj -Sdeps '{:deps {nrepl/nrepl {:mvn/version "1.3.0"} cider/cider-nrepl {:mvn/version "0.50.2"}}}' \
    -M -m nrepl.cmdline --middleware '["cider.nrepl/cider-middleware"]' --port 7888
```

Then connect from Emacs with `M-x cider-connect`, host `localhost`, port `7888`.
