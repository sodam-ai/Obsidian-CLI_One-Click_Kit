# Obsidian-CLI One-Click Kit

> A one-click Windows kit to install and use **NotesMD CLI** instantly.

[한국어 README](./README.md)

---

## Overview

**NotesMD CLI** is an open-source tool by [Yakitrak/notesmd-cli](https://github.com/Yakitrak/notesmd-cli) that lets you manage your Obsidian vault directly from the terminal.

This kit simplifies the entire workflow — **install → run → uninstall** — into three `.bat` files so anyone can use it without technical knowledge.

---

## Features

Running `RUN.bat` opens an interactive menu with 15 operations:

| # | Feature | Description |
|---|---------|-------------|
| 1 | Set Default Vault | Set your Obsidian vault as the default |
| 2 | Show Vault Info | Display current vault path |
| 3 | Open Note | Open a note in Obsidian or your editor |
| 4 | Daily Note | Open today's Daily Note |
| 5 | Fuzzy Search | Find notes by partial name |
| 6 | Search Content | Search within note content |
| 7 | List Vault | List all notes in the vault |
| 8 | Print Note | Print note content in the terminal |
| 9 | Create / Update Note | Create new notes or append/overwrite content |
| 10 | Move / Rename Note | Automatically updates all linked references |
| 11 | Delete Note | Permanently delete after confirmation |
| 12 | Frontmatter Manager | View, add, or delete YAML metadata |
| 13 | Check Version | Display installed notesmd-cli version |
| 14 | Update | Auto-update to the latest version |
| 15 | Full Help | View all command references |

---

## Requirements

- **OS**: Windows 10 / 11 (64-bit)
- **PowerShell**: Version 5+ (included with Windows)
- **Internet**: Required during installation to download from GitHub
- **Obsidian**: Recommended for opening notes ([obsidian.md](https://obsidian.md))

---

## Installation

### Option 1: One-Click Kit (Recommended)

1. Download `Obsidian-CLI_NotesMD-CLI_One-Click_Kit.7z` from the Releases page.
2. Extract the archive.
3. Double-click **`INSTALL.bat`**.
4. When installation completes, **close the current terminal and open a new one** (required for PATH to take effect).

> Windows Defender or antivirus software may show a warning. This kit only downloads a public open-source tool from GitHub and contains no malware.

### Option 2: Manual Installation

```
https://github.com/Yakitrak/notesmd-cli/releases
→ Download the Windows amd64 build
→ Copy notesmd-cli.exe to %USERPROFILE%\bin
→ Add %USERPROFILE%\bin to your Windows PATH
```

---

## Usage

After installation, open a new terminal and:

1. Double-click **`RUN.bat`**.
2. Enter the menu number and press Enter.

**First time: Always set your vault first with option [1]**
→ Enter your Obsidian vault folder name (e.g. `MyNotes`).

---

## Uninstallation

1. Double-click **`UNINSTALL.bat`**.
2. Type `uninstall` and press Enter to confirm.

> **Safe**: Your Obsidian vaults and `.md` files are **never** deleted. Only the CLI tool is removed.

---

## Folder Structure

```
Obsidian-CLI_One-Click_Kit/
├── INSTALL.bat                                 # Installer script (v14)
├── RUN.bat                                     # Operations menu script (v13)
├── UNINSTALL.bat                               # Uninstaller script (v13)
├── Obsidian-CLI_NotesMD-CLI_One-Click_Kit.7z  # Distribution archive (attached to Releases)
├── README.md                                   # Korean documentation
├── README.en.md                                # This file (English)
└── LICENSE                                     # License
```

---

## Guide for Non-Developers

You don't need any coding knowledge to use this tool.

**Just remember these 3 files:**

| File | When to use |
|------|------------|
| `INSTALL.bat` | Once only — to install the program |
| `RUN.bat` | Every time you want to use the program |
| `UNINSTALL.bat` | When you no longer need the program |

**What is a `.bat` file?**
A batch file is a Windows automation script. Double-clicking it runs it like a program.

**Do I need administrator privileges?**
No. It installs to `%USERPROFILE%\bin` (inside your user folder) without admin rights.

---

## Important Notes

- After running `INSTALL.bat`, you must open a new terminal before `RUN.bat` works correctly.
- The vault name must exactly match the folder name in Obsidian.
- Deleting notes ([11]) is permanent and cannot be undone.
- The update feature ([14]) requires an internet connection.

---

## License

This project is licensed under the [MIT License](./LICENSE).

Copyright © 2026 SoDam AI Studio

> **Note**: The `notesmd-cli` tool downloaded by this kit is subject to its own license at [Yakitrak/notesmd-cli](https://github.com/Yakitrak/notesmd-cli).
