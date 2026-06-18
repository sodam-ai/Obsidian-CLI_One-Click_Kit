# Obsidian-CLI One-Click Kit — `Obsidian-CLI_One-Click_Kit`

A beginner-friendly kit that helps **anyone — even first-time computer users —** install,
run, use, and remove [`notesmd-cli`](https://github.com/Yakitrak/notesmd-cli): a terminal
tool to work with your Obsidian notes **without opening Obsidian**.

> 📦 GitHub repository: **`sodam-ai/Obsidian-CLI_One-Click_Kit`**

> 🇺🇸 **English = this file** · 🇰🇷 한국어 → [README.md](./README.md)
> 📘 New or stuck? → **[왕초보_시작_가이드.en.md](./왕초보_시작_가이드.en.md)** (Korean: [왕초보_시작_가이드.md](./왕초보_시작_가이드.md))
> 📄 PDF of this file → [README.en.pdf](./README.en.pdf) (identical content)

---

## 0. At a glance (when you're in a hurry)

1. Double-click `시작하기.bat` ("Start Here") → **`1` Install** → then **`2` Use**.
2. Stuck? Run `자가진단.bat` (Self-check). To remove: `UNINSTALL.bat` (your notes are kept).

The rest of this document explains every step in full detail.

---

## 1. What is all this? (concepts first)

| Term | Plain meaning |
|---|---|
| **Obsidian** | A free app to organize notes. https://obsidian.md |
| **Vault** | One **folder** that holds your notes (`.md` files). e.g. a folder named `MyNotes` |
| **.md (Markdown)** | A lightweight text format. One note = one `.md` file |
| **NotesMD CLI** | A tool to create/find/open notes by typing commands, **without opening Obsidian** |
| **CLI** | A program you use with **text commands** instead of mouse clicks |
| **This kit** | Wrappers so a beginner can install and use the tool with a **one-click Korean menu** |

> Key point: **you need one "vault" (a folder) to use this tool.**

---

## 2. Prerequisites · Required programs

| Item | Required? | Notes |
|---|---|---|
| **Windows 10 / 11** | Yes | This kit is Windows-only. |
| **Windows PowerShell** | Yes (built-in) | Ships with Windows. No separate install. |
| **Internet** | Yes (for install/update) | The tool is downloaded from GitHub. |
| **certutil · tar** | Yes (built-in) | Built into Windows. Used automatically. |
| **Obsidian + 1 vault** | Effectively required | To use a vault by name, it should be registered in Obsidian. |

> ℹ️ Obsidian does **not** need to be running — you only need the vault (folder) to exist.

---

## 3. How to download

### 3-1. Get this kit
- If you got a ZIP, **unzip the whole folder.** The `lib` folder and the `.bat` files must stay **together in one folder**. Do not move files out (especially `lib`).

### 3-2. Get the tool (automatic)
- Clicking Install downloads `notesmd-cli.exe` **automatically** from the latest GitHub release.
- Source: https://github.com/Yakitrak/notesmd-cli/releases

### 3-3. Manual download (fallback if automatic fails)
1. Open the releases page → download `notesmd-cli_X.X.X_windows_amd64.tar.gz`.
2. Extract: `tar -xzf filename.tar.gz`
3. Copy `notesmd-cli.exe` into `%USERPROFILE%\bin`.
4. Add `%USERPROFILE%\bin` to your Windows user PATH.

---

## 4. Quick start (3 steps)

1. Double-click **`시작하기.bat`** → a Korean start screen appears.
2. **`1` Install** → the tool is installed (usually 30s–2min).
3. **`2` Use** → **`1` Set default vault** first, then create/search/open notes.

> Not sure where to start? Just run `시작하기.bat`. The screen shows a "recommended next step".

---

## 5. How to choose (selecting in menus)

- Use **↑ ↓ arrows** to move and **Enter** to run. (Number keys also jump.)
- Press **Enter alone** to pick the **★ recommended** item. (Unsure? Just press Enter.)
- **Red items = dangerous (delete/overwrite).** They also require typing `YES`/`Y`.
- If arrow keys aren't available, it falls back to number-typing automatically.

---

## 6. How to install (in detail)

1. `시작하기.bat` → **`1` Install** (or run `INSTALL.bat`).
2. Steps `[1/4]`–`[4/4]` run: check PowerShell → check built-in tools/folder → check existing install → download & install.
3. **`INSTALLATION COMPLETE`** means success.
4. Install location: **`%USERPROFILE%\bin\notesmd-cli.exe`**.
5. PATH is registered so the tool is found. This kit's `시작하기`/`사용하기` work **without opening a new terminal**.

> Time: usually 30s–2min depending on your connection.

---

## 7. How to run (the Start hub)

`시작하기.bat` opens a Korean hub showing **current status** (installed / vault set / Obsidian detected).

| Menu | What it does |
|---|---|
| **1) Install** | Installs the tool on this PC |
| **2) Use** | Create/search/open notes (Korean menu) |
| **3) Self-check** | Diagnose what works + save a report |
| **4) Remove** | Removes the tool only (keeps notes) |
| **5) Plain explanation** | Explains the concepts again |
| **0) Exit** | Close |

---

## 8. How to use (the 15 menu items)

`시작하기 → 2) Use` opens the Korean menu below. **Always do `1` Set default vault first.**

| # | Menu | What / When | Underlying command |
|---|---|---|---|
| 1 | Set default vault | Once, first. Type the vault folder name | `set-default <vault>` |
| 2 | Vault info | See current vault name/path | `print-default` / `--path-only` |
| 3 | Open note | Open in Obsidian/editor | `open <note>` `[--editor] [--section H] [--vault V]` |
| 4 | Daily note | Today's note | `daily` `[--vault V]` |
| 5 | Quick search | By file name | `search` `[--vault V] [--editor]` |
| 6 | Content search | By text | `search-content <term>` `[--vault V] [--editor]` |
| 7 | List | Vault/subfolder listing | `list [path]` `[--vault V]` |
| 8 | Print note | Print note contents | `print <note>` `[--vault V]` |
| 9 | Create/update | empty/content/overwrite/append | `create <note>` `[--content C] [--overwrite\|--append] [--open] [--editor]` |
| 10 | Move/rename | Move/rename (links auto-updated) | `move <old> <new>` `[--vault V] [--open] [--editor]` |
| 11 | Delete note | **Permanent (caution)** | `delete <note>` `[--vault V]` |
| 12 | Frontmatter | View/edit/delete YAML fields | `frontmatter <note> --print \| --edit --key K --value V \| --delete --key K` |
| 13 | Version | Installed tool version | `--version` |
| 14 | Update | Reinstall latest version | (reruns install engine) |
| 15 | Full help | Tool's own help (English) | `--help` |
| 0 | Back | Back to start | — |

---

## 9. How it works (what happens inside — simply)

When you click Install, the kit automatically:

1. Asks GitHub for the latest version.
2. Uses built-in `certutil` to safely unpack the install script (avoids long-line issues).
3. Verifies the file is a real executable (MZ header check).
4. Extracts archives with a **triple fallback**: `tar.exe` → pure PowerShell extraction → verify.
5. Places it in `%USERPROFILE%\bin` and registers PATH.

> A beginner just clicks "Install" once — all of the above is automatic.

---

## 10. Workflow (typical usage)

```
[Once]
  시작하기.bat → 1) Install
  시작하기.bat → 2) Use → 1) Set default vault (type the vault folder name)

[Daily]
  시작하기.bat → 2) Use →
      9) Create note
      4) Daily note
      5) Quick search / 6) Content search
      7) List

[Occasionally]
  14) Update
  자가진단.bat (self-check)

[To remove]
  4) Remove / UNINSTALL.bat  (notes are safe)
```

---

## 11. Command reference (notesmd-cli v0.3.3)

> With the menu you don't need to memorize these. This table is for terminal users.

| Command | Description |
|---|---|
| `set-default <vault>` | Set the default vault |
| `print-default [--path-only]` | Print default vault name/path |
| `create <note> [--content C] [--overwrite\|--append] [--open] [--editor]` | Create/update note |
| `open <note> [--vault V] [--section H] [--editor]` | Open note |
| `daily [--vault V]` | Today's note |
| `list [path] [--vault V]` | List |
| `print <note> [--vault V]` | Print contents |
| `search [--vault V] [--editor]` | Filename search |
| `search-content <term> [--vault V] [--editor]` | Content search |
| `move <old> <new> [--vault V] [--open] [--editor]` | Move/rename (auto-updates links) |
| `delete <note> [--vault V]` | Delete (permanent) |
| `frontmatter <note> --print \| --edit --key K --value V \| --delete --key K` | Manage YAML frontmatter |
| `completion <shell>` | Shell autocompletion (advanced) |
| `--version` / `--help` | Version / help |

---

## 12. Troubleshooting

**First: run `자가진단.bat`** (Self-check). It checks PowerShell, install, vault, PATH, and
internet, and saves a report to your Desktop as `NotesMD-CLI_진단결과.txt`.

| Symptom | Cause | Fix |
|---|---|---|
| `Cannot find lib\welcome.ps1` | `lib` folder missing/moved | Re-unzip the **whole folder**; keep `.bat` and `lib` together |
| `notesmd-cli NOT FOUND` | Not installed | Run `1) Install` first |
| `Vault not found in Obsidian config file` | Default vault not set (or no Obsidian) | `2) Use → 1) Set default vault`; type the **exact folder name**; needs an Obsidian vault |
| `Install failed` / `certutil decode failed` | Internet/firewall/transient | Check internet, retry; else use manual download (3-3) |
| `MZ header missing` | Corrupt download | Retry; check antivirus/firewall exceptions |
| Garbled characters | Ran a `.bat` directly / console encoding | Always launch via **`시작하기.bat`** |

> English error messages come from the tool (notesmd-cli) itself; the table explains them.

---

## 13. File locations · Document locations

### Kit files (in this folder)
| File/Folder | Role |
|---|---|
| `시작하기.bat` | **Korean start screen (begin here)** |
| `자가진단.bat` | Self-check + save report |
| `INSTALL.bat` | Install engine |
| `RUN.bat` | Original English menu (optional) |
| `UNINSTALL.bat` | Safe removal |
| `lib\` | Korean UI (PowerShell) — **never delete/move** |
| `README.md` / `README.en.md` | Docs (KO/EN) |
| `왕초보_시작_가이드.md` / `.en.md` | Step-by-step guide (KO/EN) |
| `*.pdf` | PDF versions (identical content) |
| `LICENSE` / `NOTICE` | License & notices |

### Install/result locations (on your PC)
| Item | Location |
|---|---|
| Tool executable | `%USERPROFILE%\bin\notesmd-cli.exe` |
| Self-check report | Desktop `NotesMD-CLI_진단결과.txt` |
| Obsidian vault list | `%APPDATA%\obsidian\obsidian.json` (read-only) |

---

## 14. How to remove

1. `시작하기 → 4) Remove` (or `UNINSTALL.bat`).
2. Type **`uninstall`** to proceed.
3. Removed: tool executable (`bin\notesmd-cli.exe`), Scoop install (if any), PATH entry.
4. **Notes (`.md`) and vaults are never deleted.** Reinstall anytime via `INSTALL.bat`.

---

## 15. Safety

- Dangerous actions (delete/overwrite/remove) show in **red** and require typing `YES`/`uninstall`.
- **Notes and vaults are preserved**, even on removal. The kit only touches tool files.
- No login/password/token is stored (the tool has no login).
- No personal data is sent out. The internet is used **only to download the tool from GitHub**.

---

## 16. License · Copyright · Commercial use (strict)

This kit involves **three separate things**, each with a different license.

### (1) This kit itself — files we made (`시작하기.bat`, `자가진단.bat`, `lib\*`, docs)
- License: **Apache License 2.0**, © 2026 **SoDam AI Studio**. ([LICENSE](./LICENSE), [NOTICE](./NOTICE))
- **Commercial use: allowed.** When redistributing, **keep the copyright/license/NOTICE**, and **mark modified files** as changed.
- **AS IS, no warranty.** The authors are not liable for data loss/malfunction/damages (Apache-2.0 §7·§8). Use at your own risk.

### (2) The installed tool `notesmd-cli` — **not bundled**; downloaded at install time
- License: **MIT License**, **© 2023 Kartikay Jainwal** (Yakitrak). Source: https://github.com/Yakitrak/notesmd-cli
- **Commercial use: allowed**, keep the copyright/license notice. **No warranty.**
- This kit is an **unofficial installer helper** and is **not affiliated** with the tool's author.

### (3) Obsidian — a **separate program**, not included here
- Obsidian is **proprietary (closed-source)** software but, per its official license, is **free for all uses including personal, commercial, and non-profit**. (Source: https://obsidian.md/license)
- A business **Commercial License is optional support, not a requirement.**
- This kit is **not affiliated** with Obsidian; follow Obsidian's own terms.

### Trademarks · Disclaimer
- "Obsidian", "GitHub", and related names are trademarks of their owners. This kit is **unofficial** and not affiliated with any company.
- This license summary is **informational, not legal advice.** The original license texts govern.

---

## 17. Credits · Sources

- Tool: **notesmd-cli** — © 2023 Kartikay Jainwal (Yakitrak), MIT — https://github.com/Yakitrak/notesmd-cli
- Notes app: **Obsidian** — https://obsidian.md
- This kit: © 2026 SoDam AI Studio — Apache-2.0
