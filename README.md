# Bulk File Renamer (PowerShell)

A collection of **safe, interactive PowerShell scripts** for bulk renaming files.
Built with a focus on **preview-first workflow, collision protection, and controlled execution**.

> ⚡ The project is now centered around the **Unified Renamer**, which combines all major features into a single tool.

---

## 🚀 Main Tool (Recommended)

### 🧰 Unified Renamer (`Unified Renamer.ps1`)

The primary script going forward. Combines all core renaming operations into one interactive CLI-like tool.

### Features

* **Multiple Modes**

  * Prefix (add text at start)
  * Suffix (add text before extension)
  * Find & Replace (modify text anywhere)
* **Preview Before Execution**
* **Collision Protection** (prevents overwriting files)
* **Skip Logic** (avoids duplicate prefixes/suffixes)
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

### 🔍 Find & Replace Renamer

Original script for text replacement.

* Replace or remove text within filenames
* Useful for quick cleanup operations

---

## 🛠️ How to Use

### Option 1: Run Directly

1. Place the `.ps1` script in your target folder
2. Right-click → **Run with PowerShell**

### Option 2: Run from Terminal

```powershell
cd "path\to\your\files"
.\Unified Renamer.ps1
```

---

## 🔒 Safety Features

All scripts follow the same safety principles:

* ✅ **Preview Mode** — see changes before applying
* ✅ **Confirmation Step** — no accidental execution
* ✅ **Collision Detection** — skips existing filenames
* ✅ **Error Handling** — clear success/failure summary
* ✅ **No Silent Defaults** — all inputs are explicitly required

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