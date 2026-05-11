# Bulk File Renamer (PowerShell)

A collection of **safe, interactive PowerShell scripts** for bulk renaming files.
Built with a focus on **preview-first workflow, collision protection, and controlled execution**.

> ⚡ The project is now centered around the **Bulk File Renamer**, a unified tool that combines all major features into one script.

---

## 🚀 Main Tool (Recommended)

### 🧰 Bulk File Renamer (`Bulk File Renamer.ps1`)

The primary script for this project. Combines all core renaming operations into one interactive CLI-like tool.

### Features

* **Multiple Modes**

  * Prefix (add text at start)
  * Suffix (add text before extension)
  * Find & Replace (modify text anywhere)
* **Preview Before Execution**
* **Collision Protection** (prevents overwriting files)
* **Skip Logic** (avoids duplicate prefixes/suffixes)
* **Optimized Performance** (O(n) speed for large directories)
* **Interactive Controls**

  * `Enter / Y` → Proceed
  * `N` → Restart
  * `Esc` → Exit
* **Session Loop** (run multiple operations without restarting script)

---

## 🧩 Other Scripts (Specialized Use)

These scripts are kept for focused, single-purpose workflows:

### 🔤 Prefix Renamer

Adds a prefix to filenames.

* Skips already-prefixed files
* Safe preview + confirmation flow

### 🔚 Suffix Renamer

Adds a suffix before file extensions.

* Preserves file extensions
* Avoids duplicate suffixes

### 🔍 Find & Replace (`Find And Replace.ps1`)

Original standalone script for text replacement.

* Replace or remove text within filenames
* Useful for quick cleanup operations
* Now optional (functionality included in main tool)

---

## 🛠️ How to Use

### 🌟 Recommended: Run via Web (No Download Required)
The easiest way to run the Bulk File Renamer is directly from your terminal using `Invoke-RestMethod` (`irm`).
1. Open the folder where your files are located
2. Right-click → **Open in Windows Terminal** (or PowerShell)
3. Run the following command:
```powershell
irm https://raw.githubusercontent.com/BishnuMahali/Bulk-File-Renamer/main/Bulk%20File%20Renamer.ps1 | iex
```

### Option 1: Run Directly (Downloaded File)

1. Place the `.ps1` script in your target folder
2. Right-click → **Run with PowerShell**

### Option 2: Run via Windows Terminal (Paste Method)

1. Open the folder where your files are located
2. Right-click → **Open in Windows Terminal** (or PowerShell)
3. Copy the script code
4. Paste it into the terminal
5. Press **Enter** and follow the on-screen instructions

### Option 3: Run from Terminal (Script File)

```powershell id="n0b7k1"
cd "path\to\your\files"
.\Bulk File Renamer.ps1
```

---

## 🔒 Safety Features

All scripts follow the same safety principles:

* ✅ **Preview Mode** — see changes before applying
* ✅ **Confirmation Step** — no accidental execution
* ✅ **Collision Detection** — skips existing filenames
* ✅ **Error Handling** — clear success/failure summary
* ✅ **No Silent Defaults** — all inputs are explicitly required
* ✅ **Special Character Support** — safely handles `[]` in filenames

---

## 📌 Example Use Cases

* Clean up messy filenames in bulk
* Add version tags (`_v2`, `_final`)
* Add identifiers (project names, dates, categories)
* Remove unwanted text from downloaded files

---

## 📦 Requirements

* Windows OS
* PowerShell (5.1 or newer recommended)

---

## 🔮 Roadmap

Planned improvements:

* CLI parameter support (non-interactive mode)
* Undo/rollback system
* Regex-based renaming
* Extension filtering (`*.mp4`, `*.jpg`, etc.)
* Recursive folder support
* Dry-run flag
* Ability to choose a custom target folder (instead of current directory)

---

## 🤝 Contributing / Ideas

This project is evolving toward a **full-featured renaming utility**.
Suggestions, improvements, and feature ideas are welcome.

---

## ⚠️ Disclaimer

Always review the preview before confirming.
While safeguards are in place, bulk renaming operations are inherently sensitive.

---

## 📜 License

This project is licensed under the MIT License — see the LICENSE file for details.

---

## 🤝 Support & Connect

These projects are simple utility scripts built to solve everyday problems. If you find them helpful in your workflow and would like to support me, any small contribution is deeply appreciated! ❤️

<p align="center">
  <a href="https://buymeacoffee.com/Bishnu"><img src="https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black" alt="Buy Me A Coffee"></a>
  <a href="https://ko-fi.com/Bishnu"><img src="https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white" alt="Ko-fi"></a>
  <a href="https://patreon.com/Bishnu"><img src="https://img.shields.io/badge/Patreon-F96854?style=for-the-badge&logo=patreon&logoColor=white" alt="Patreon"></a>
  <a href="https://paypal.me/beingaash"><img src="https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white" alt="PayPal"></a>
</p>

<p align="center">
  <a href="https://github.com/BishnuMahali"><img src="https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white" alt="GitHub"></a>
  <a href="https://bmahali.com"><img src="https://img.shields.io/badge/Website-333333?style=for-the-badge&logo=firefox&logoColor=white" alt="Website"></a>
  <a href="https://youtube.com/@BishnuMahaliPro"><img src="https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white" alt="YouTube"></a>
  <a href="https://instagram.com/itsBishnuMahali"><img src="https://img.shields.io/badge/Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white" alt="Instagram"></a>
  <a href="https://facebook.com/itsBishnuMahali"><img src="https://img.shields.io/badge/Facebook-1877F2?style=for-the-badge&logo=facebook&logoColor=white" alt="Facebook"></a>
  <a href="https://x.com/itsBishnuMahli"><img src="https://img.shields.io/badge/X-000000?style=for-the-badge&logo=x&logoColor=white" alt="X (Twitter)"></a>
  <a href="https://linkedin.com/in/bishnumahali"><img src="https://img.shields.io/badge/LinkedIn-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn"></a>
</p>
