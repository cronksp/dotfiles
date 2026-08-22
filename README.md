# Dotfiles 🚀

A modern, fast, and minimalistic dotfiles repository utilizing Zsh and the Starship cross-shell prompt. Designed for seamless productivity across macOS, WSL2, and DevContainers.

---

## 🌟 Features

- **Fast, Native Zsh:** Zero bloated frameworks (no Oh My Zsh). Instant terminal startup.
- **Starship Prompt:** Fast, highly customizable prompt with built-in Git integration and symbols.
- **Modern Coding Fonts:** Automatically downloads and installs Nerd Fonts (`JetBrainsMono`, `FiraCode`, `ComicShannsMono`) and GitHub's `Monaspace`.
- **Machine & Secret Isolation (`.local` Pattern):** Zero secret leakage. Put private work tokens (Artifactory, proxies) or personal API keys in `~/.zshrc.local` (strictly ignored by Git).
- **Modern CLI Tools:** Integrated aliases and fallbacks for `zoxide` (smart `cd`), `eza` (modern `ls`), `bat` (syntax `cat`), and `fzf` (fuzzy search).
- **AI Workspace Bridge:** Seamlessly connects your shell and editor to your dedicated `/ai` repository (`$AI_HOME`).
- **Terminal Configs:** Matching Gruvbox Dark configs for **Ghostty** (macOS) and **Windows Terminal** (Windows).
- **DevContainer & CI Ready:** Automated Docker tests and non-interactive `install.sh` ensure your shell never breaks in remote containers.

---

## 📦 Installation

Run the included `install.sh` script:

```bash
cd dotfiles
./install.sh
```

**What the script does:**
1. Verifies OS and installs system dependencies (`brew` on macOS or `apt` on Linux).
2. Downloads and installs the modern coding fonts into your user font directory.
3. Installs and links the **Starship** prompt configuration.
4. Links **Ghostty** configuration (on macOS / Linux).
5. Links your **AI workspace rules** (`.cursorrules`, `.windsurfrules`) if `$AI_HOME` is present.
6. Backs up existing `~/.zshrc`, `~/.zshenv`, and `~/.zprofile` with a `.backup` suffix.
7. Creates symlinks to the repository configurations in your home directory.
8. Ensures your default shell is set to `zsh`.

---

## 🔐 Machine & Secret Isolation (`~/.zshrc.local`)

To configure machine-specific tokens, work proxies, or personal API keys without committing them to Git:

1. Copy the example template:
   ```bash
   cp zsh/.zshrc.local.example ~/.zshrc.local
   ```
2. Edit `~/.zshrc.local` with your private variables (e.g. `ARTIFACTORY_TOKEN`, `OPENAI_API_KEY`, or `HTTP_PROXY`).
3. `~/.zshrc.local` is automatically sourced at the end of `.zshrc` and is completely ignored by Git.

---

## 🤖 AI Workspace Integration

This repository includes a bridge to an external AI repository (`$AI_HOME`):
- Default location: `~/Documents/dev/repos/ai` (configurable via `export AI_HOME=...`).
- Aliases provided: `ai-repo`, `skills`, `prompts`.
- Automatically appends `$AI_HOME/bin` to your `$PATH` if it exists.

---

## 🧪 Testing

This repository includes a Docker-based test harness that verifies the installation inside a clean Ubuntu environment:

```bash
cd test
./run_tests.sh
```

Tests run automatically via **GitHub Actions** on every push and pull request.
