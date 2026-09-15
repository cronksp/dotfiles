# Dotfiles 🚀

A modern, fast, and minimalist dotfiles repository engineered for **Arch Linux / Omarchy**, **macOS**, **Windows (PowerShell & WSL)**, and **DevContainers**.

Features a dynamic, holiday- and season-aware **Starship** prompt with automatic palette swapping, rich OS symbols, popping directory icons, language mascots, long-command duration tracking, modern CLI tool integrations, coding font management, and secret isolation.

---

## 🌟 Starship Prompt Architecture

The terminal prompt is structured into color-coordinated powerline bubbles with high-visibility text:

```text
 [OS_SYMBOL • SEASONAL_ICONS] [USER]  [DIRECTORY]  [BRANCH] [STATUS]  [LANGUAGES]  [DURATION]  [TIME] 
❯
```

### Live Examples:
```text
 🏹 • 🍂 🍁 🌽  spc  ~/💻 dev/📦 repos/dotfiles  🌿 main 📝 2  🦀 1.78.0   00:25 
❯
```
*(When a command takes >2s to run, a subtle execution bubble automatically appears before the clock)*:
```text
 🏹 • 🍂 🍁 🌽  spc  ~/💻 dev/📦 repos/dotfiles  🌿 main  ⏱️ 4.2s   00:25 
❯
```

---

## 🎨 Seasonal & Holiday Themes

The prompt dynamically selects custom palettes and seasonal icons based on the date and major holidays. The directory bubble uses harmonious, rich dark tones matching each theme:

| Theme | Schedule | Icons | Palette / Theme Highlights |
| :--- | :--- | :---: | :--- |
| **Autumn** | Sep & Nov | 🍂 🍁 🌽 | Warm harvest amber, roasted chestnut brown directory, and earth accents. |
| **Halloween** | October | 🎃 👻 💀 | Spooky pumpkin orange, deep midnight directory, eerie violet, and blood red. |
| **Thanksgiving** | 4th week of Nov | 🦃 🥧 🍂 | Golden cider, rich walnut brown directory, and cranberry accents. |
| **Christmas** | Dec 20 – Dec 28 | 🎄 🎅 🎁 | Festive ribbon red, deep pine green directory, and bright holiday gold. |
| **New Year** | Dec 29 – Jan 1 | 🎆 🥂 ✨ | Midnight celebration violet, space black directory, and champagne sparkle. |
| **Winter** | Dec – Feb | ❄️ ⛄ 🏔️ | Frosty sapphire blue, arctic glacier navy directory, and icy aqua. |
| **St. Patrick's** | Mar 14 – Mar 17 | 🍀 🌈 🪙 | Vivid Emerald Isle green, deep clover night directory, and radiant Irish gold. |
| **Spring** | Mar – May | 🌱 🌸 🐣 | Fresh blossom green, deep garden moss directory, and spring meadow lime. |
| **Summer** | Jun – Aug | ☀️ 🌊 🍉 | Vibrant solar gold/coral, deep ocean marine directory, and lagoon cyan. |
| **4th of July** | Jul 1 – Jul 4 | 🇺🇸 🎆 🗽 | Patriotic bold flag red, royal midnight navy directory, and sparkler gold. |

### 🎛️ Managing Themes

You can check or switch the active theme anytime from any terminal (Bash, Zsh, or PowerShell):

```bash
# View active theme
set-theme current

# Switch to any seasonal or holiday theme
set-theme halloween
set-theme christmas
set-theme st_patricks
set-theme fourth_of_july
set-theme summer

# Return to automatic date-based seasonal schedule
set-theme auto

# View full help and schedule
theme
```

---

## 💻 Operating System Icons

The OS icon is dynamically detected and rendered cleanly with high-contrast, recognizable symbols:

| OS / Distro | Symbol | Description |
| :--- | :---: | :--- |
| **Arch Linux** | 🏹 | Bow and Arrow (*Arch/Archery*) |
| **Linux (Generic)** | 🐧 | Tux the Penguin |
| **macOS** | 🍏 | Green Apple |
| **Windows** | 🪟 | Window |
| **Ubuntu** | 🟠 | Ubuntu Brand Orange Circle |
| **Debian** | 🌀 | Debian Spiral Swirl |
| **Fedora** | 🎩 | Fedora / Top Hat |
| **Red Hat / RHEL** | 🧢 | Red Cap (*Red Hat*) |
| **EndeavourOS** | 🚀 | Space Shuttle Endeavour Rocket |
| **openSUSE** | 🦎 | Geeko the Chameleon |
| **Alpine Linux** | 🏔️ | Snow-capped Alps |
| **Linux Mint** | 🌿 | Mint Herb Sprig |
| **Gentoo** | 🧬 | Source-Compilation DNA |
| **Pop!_OS** | 🍿 | Popcorn (*Pop!*) |
| **Manjaro** | 🌲 | Mountain Forest Evergreen |
| **Raspbian / RPi** | 🍓 | Raspberry Strawberry |
| **CentOS** | 🎯 | Target / Bullseye Logo |
| **Rocky Linux** | 🪨 | Rocky Mountain Stone |
| **NixOS** | ❄️ | Snowflake Logo |
| **Kali Linux** | 🐉 | Security Dragon Logo |
| **Garuda Linux** | 🦅 | Mythical Garuda Eagle |
| **Android** | 🤖 | Bugdroid Robot |
| **Amazon Linux** | 📦 | Delivery Package |
| **FreeBSD** | 😈 | Beastie the BSD Daemon |
| **OpenBSD** | 🐡 | Puffy the Pufferfish |
| **Void Linux** | 🌌 | Milky Way Cosmic Void |

---

## 🛠️ Languages, Tools & Git Symbols

| Tool / Component | Symbol | Description |
| :--- | :---: | :--- |
| **Rust** | 🦀 | Ferris the Rust Crab |
| **Go** | 🐹 | Go Gopher |
| **Python** | 🐍 | Python Snake & Virtualenv shield (`🛡️`) |
| **Node.js** |  | Node.js Nerd Font icon |
| **Ruby** | 💎 | Ruby Gem |
| **PHP** | 🐘 | elePHPant Mascot |
| **Java** | ☕ | Coffee Cup |
| **Lua** | 🌙 | Lua Moon |
| **Elixir** | 💧 | Elixir Drop |
| **Zig** | ⚡ | Lightning Bolt |
| **Swift** | 🐦 | Swift Bird |
| **C / C++** | ⚙️ | Gear |
| **Kotlin** | 🎯 | Target |
| **Haskell** | λ | Lambda |
| **Docker** | 🐳 | Docker Whale |
| **Duration** | ⏱️ | Command duration (only appears if >2s) |
| **Git Branch** | 🌿 | Branch Sprig |
| **Git Status** | 💥 📝 ✨ 📦 🔮 ⇡ ⇣ | Conflicts, modified, staged, stashed, untracked, ahead/behind |

---

## 📁 Directory Icons

Common directory paths render with vivid, recognizable icons:

| Directory | Icon | Rendered Path Example |
| :--- | :---: | :--- |
| **Documents** | 📄 | `~/📄 Documents` |
| **Downloads** | 📥 | `~/📥 Downloads` |
| **Music** | 🎧 | `~/🎧 Music` |
| **Pictures** | 🎨 | `~/🎨 Pictures` |
| **Developer** | 💻 | `~/💻 Developer` |
| **dev** | 💻 | `~/💻 dev` |
| **repos** | 📦 | `~/📦 repos` |
| **Desktop** | 🖥️ | `~/🖥️ Desktop` |
| **Videos** | 🎬 | `~/🎬 Videos` |

---

## 🚀 Setup Guides for Your Environments

### 1. Work Windows Laptop (PowerShell & Windows Terminal)
1. Open PowerShell and clone the repository:
   ```powershell
   git clone https://github.com/cronksp/dotfiles.git "$HOME\dev\repos\dotfiles"
   ```
2. Run the Windows installer:
   ```powershell
   cd "$HOME\dev\repos\dotfiles\powershell"
   .\install.ps1
   ```
3. Set up your private `.local` file for work proxies or custom paths:
   ```powershell
   # For PowerShell 7:
   Copy-Item profile.local.example.ps1 "$HOME\Documents\PowerShell\profile.local.ps1"
   # For Windows PowerShell (5.1):
   Copy-Item profile.local.example.ps1 "$HOME\Documents\WindowsPowerShell\profile.local.ps1"
   ```
4. *(Optional)* Add your custom work paths or proxies to `profile.local.ps1`:
   ```powershell
   $env:DEV_DIR = "C:\Users\username\Source"
   $env:HTTP_PROXY = "http://proxy.corp.com:8080"
   ```

---

### 2. Home MacBook (macOS)
1. Clone and install:
   ```bash
   git clone https://github.com/cronksp/dotfiles.git ~/dev/repos/dotfiles
   cd ~/dev/repos/dotfiles
   ./install.sh
   ```
2. *(Optional)* Create private overrides in `~/.zshrc.local`:
   ```bash
   cp zsh/.zshrc.local.example ~/.zshrc.local
   ```

---

### 3. Omarchy / Arch Linux Laptop
1. Clone and install:
   ```bash
   git clone https://github.com/cronksp/dotfiles.git ~/dev/repos/dotfiles
   cd ~/dev/repos/dotfiles
   ./install.sh
   ```
2. Omarchy environment hooks and pacman/mise updates will be linked automatically.

---

### 4. Personal Windows PC (PowerShell / WSL2)
- **For Native PowerShell**: Run the Windows setup (`.\powershell\install.ps1`).
- **For WSL2 (Ubuntu/Debian)**: Inside your WSL terminal, run `./install.sh`.

---

### 5. DevContainers (VS Code, Windsurf, Cursor)
VS Code has built-in Dotfiles support that can automatically bootstrap every DevContainer you open:
1. Open VS Code Settings (`Ctrl + ,` or `Cmd + ,`) ➔ Search for **Dotfiles**.
2. Configure:
   - **Dotfiles: Repository**: `cronksp/dotfiles`
   - **Dotfiles: Target Path**: `~/dotfiles`
   - **Dotfiles: Install Command**: `install.sh --quick`
3. Any DevContainer you create will automatically clone your dotfiles and run `./install.sh --quick` in **< 1 second** with your exact Starship prompt and aliases ready.

---

### 6. Brand New Machine (One-Liner)

**macOS / Linux**:
```bash
git clone https://github.com/cronksp/dotfiles.git ~/dotfiles && cd ~/dotfiles && ./install.sh
```

**Windows PowerShell**:
```powershell
git clone https://github.com/cronksp/dotfiles.git "$HOME\dotfiles"; cd "$HOME\dotfiles\powershell"; .\install.ps1
```

---

## 🧭 Custom Path Configuration (No File Moving Needed)

You do **not** need to move any existing directories. The aliases (`dev`, `repos`, `dotfiles`, `ai-repo`) check environment variables first.

### How to set paths for any machine:

| Environment | File to Edit | Example Content |
| :--- | :--- | :--- |
| **Bash** *(Linux / WSL)* | `~/.bashrc.local` | `export DEV_DIR="/custom/path/to/dev"`<br>`export REPOS_DIR="/custom/path/to/repos"` |
| **Zsh** *(macOS / Linux)* | `~/.zshrc.local` | `export DEV_DIR="$HOME/Documents/dev"`<br>`export REPOS_DIR="$HOME/Documents/dev/repos"` |
| **PowerShell** *(Windows)* | `Documents\PowerShell\profile.local.ps1` | `$env:DEV_DIR = "D:\Work\Source"`<br>`$env:REPOS_DIR = "D:\Work\Source\Repos"` |

If not explicitly defined in `.local`, the system automatically detects whatever directory exists on that machine (`~/dev`, `~/Documents/dev`, `~/Developer`, `/workspaces`, etc.).

---

## 🗂️ Directory Structure

```text
dotfiles/
├── bin/
│   └── starship-seasonal-theme        # Dynamic Starship palette generator (POSIX shell)
├── powershell/
│   ├── Microsoft.PowerShell_profile.ps1 # PowerShell profile
│   ├── starship-seasonal-theme.ps1    # Dynamic Starship palette generator (PowerShell)
│   ├── profile.local.example.ps1      # Local private overrides template for PowerShell
│   └── install.ps1                    # One-click Windows installer
├── starship/
│   ├── starship.toml                  # Master seasonal Starship template
│   └── .config/starship.toml          # Compatibility mirror
├── bash/
│   ├── .bashrc                        # Bash configuration (Omarchy-compatible)
│   ├── aliases.bash                   # Shared CLI & navigation aliases
│   ├── tool-updates.bash              # System (pacman/yay) & mise upgrade helpers
│   └── .bashrc.local.example          # Private override template for Bash
├── zsh/
│   ├── .zshrc                         # Zsh configuration
│   ├── .zprofile                      # Zsh login profile
│   ├── .zshenv                        # Zsh environment
│   └── .zshrc.local.example           # Private override template for Zsh
├── ghostty/
│   └── config                         # Ghostty terminal config
├── windows-terminal/
│   └── settings.json                  # Windows Terminal profile & theme
├── install.sh                         # Idempotent cross-platform installer
└── README.md
```

---

## 🔤 Modern Coding Fonts

The installer automatically installs 4 coding font families:
- **JetBrainsMono Nerd Font** (v3.2.1)
- **FiraCode Nerd Font** (v3.2.1)
- **ComicShannsMono Nerd Font** (v3.2.1)
- **Monaspace** (GitHub Next v1.101)
