# Dotfiles 🚀

A modern, fast, and minimalistic dotfiles repository utilizing Zsh and the Starship cross-shell prompt. 

## Features
- **Clean Zsh:** No bloated frameworks like Oh My Zsh. It's built for speed and simplicity.
- **Starship Prompt:** Fast, highly customizable prompt with built-in Git integration and symbols.
- **Modern Fonts:** Automatically installs industry-standard Nerd Fonts (`JetBrainsMono`, `FiraCode`, `ComicShannsMono`) and GitHub's `Monaspace`.
- **Intelligent Git Configuration:** Does not hardcode global Git emails in the installation script, preventing personal emails from leaking onto work machines or devcontainers.
- **Devcontainer Ready:** The installation script runs non-interactively and gracefully installs all dependencies, making it perfect for IDE Devcontainers and remote shells.

## Installation

You can install these dotfiles by running the included `install.sh` script. 

```bash
cd dotfiles
./install.sh
```

**What the script does:**
1. Verifies OS and installs system dependencies (using `brew` on MacOS or `apt` on Linux).
2. Downloads and installs the modern coding fonts into your user font directory.
3. Installs the Starship prompt if it's not already installed.
4. Backs up your existing `~/.zshrc`, `~/.zshenv`, and `~/.zprofile` by appending `.backup` to them.
5. Creates symlinks from the repository configurations to your home directory.
6. Ensures your default shell is set to `zsh`.

## Testing

This repository includes a lightweight Docker-based testing framework to ensure the `install.sh` script works cleanly in a fresh Ubuntu environment (mimicking a standard Devcontainer). 

To run the tests locally:
```bash
cd test
./run_tests.sh
```

This will build a temporary Docker container and execute the installation script inside it to catch any breaking changes. Tests are also configured to run automatically via GitHub Actions on push and PR.

## Recommended Tools

For the best experience, consider installing these modern agentic workflow tools:
- [zoxide](https://github.com/ajeetdsouza/zoxide) - A smarter `cd` command.
- [eza](https://github.com/eza-community/eza) - A modern replacement for `ls`.
- [bat](https://github.com/sharkdp/bat) - A cat clone with syntax highlighting.
- [fzf](https://github.com/junegunn/fzf) - A command-line fuzzy finder.
- [direnv](https://direnv.net/) - Unclutter your `.zshrc` by loading environment variables per directory.
