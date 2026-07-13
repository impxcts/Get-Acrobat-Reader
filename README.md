<div align="center">

# 📄 Acrobat Reader Auto-Installer

**One double-click. Silent install. Adobe Acrobat Reader ready to go.**

A lightweight Windows utility that downloads, silently installs, and launches Adobe Acrobat Reader (free) — built for first-boot setups, freshly imaged machines, or any PC that needs a PDF reader fast.

![Platform](https://img.shields.io/badge/platform-Windows%2010%2F11-0078D6?logo=windows&logoColor=white)
![Shell](https://img.shields.io/badge/PowerShell-5.1%2B-5391FE?logo=powershell&logoColor=white)
![License](https://img.shields.io/badge/license-Free%20%26%20Open%20Source-green)

</div>

---

## ✨ Overview

No install wizard. No clicking through prompts. No manually hunting for the current download link.

Just double-click one file, approve the admin prompt, and Adobe Acrobat Reader installs itself in the background — opening automatically the moment it's done.

## 📁 Project Structure

```
acrobat-reader-auto-installer/
├── Get-AcrobatReader.bat        # Double-click entry point — handles elevation
├── Install-AcrobatReader.ps1    # Core logic — download, install, launch
└── README.md
```

## ⚙️ How It Works

```
 ┌───────────────────────┐   elevates (UAC)   ┌─────────────────────────────┐
 │  Get-AcrobatReader.bat │ ─────────────────► │  Install-AcrobatReader.ps1  │
 └───────────────────────┘                     └───────────────┬─────────────┘
                                                                 │
                                   ┌─────────────────────────────┼─────────────────────────────┐
                                   ▼                             ▼                             ▼
                          Look up latest version           Silent install                Launch Acrobat Reader
                          & download installer
```

1. **`Get-AcrobatReader.bat`** checks for admin rights and self-elevates via UAC if needed.
2. It hands off to **`Install-AcrobatReader.ps1`**, which:
   - Queries Adobe's own distribution API to resolve the current version and direct download link (no hardcoded/stale URLs)
   - Downloads the official installer
   - Runs it silently, auto-accepting the EULA
   - Deletes the installer once finished
   - Launches Acrobat Reader automatically

## 🚀 Usage

1. Clone or download this repo.
2. Keep `Get-AcrobatReader.bat` and `Install-AcrobatReader.ps1` **in the same folder**.
3. Double-click **`Get-AcrobatReader.bat`**.
4. Approve the UAC prompt.
5. Done — Acrobat Reader installs and opens on its own.

<details>
<summary>Prefer the command line?</summary>

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Install-AcrobatReader.ps1
```

</details>

## ✅ Requirements

- Windows 10 or later
- Administrator privileges (machine-wide install)
- Active internet connection

## 🛠 Notes

- Acrobat Reader is installed system-wide, available to all users on the machine.
- The script always fetches the latest available version at run time — it doesn't rely on a fixed version number that can go stale.
- If the script can't locate the Acrobat Reader executable to auto-launch it, it'll print a warning — but the install itself will still have completed successfully.
- Adobe occasionally changes its distribution API or installer switches; if a run fails outright, check for updates to this script.

## 📄 License

Free and open source — use, modify, and share it however you'd like.

## ☕ Support

If this saved you some time, consider buying me a coffee:

[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-FFDD00?logo=buymeacoffee&logoColor=black)](https://buymeacoffee.com/impxcts)

---

<div align="center">
<sub>Built for the "plug it in and it just works" first-boot workflow.</sub>
</div>
