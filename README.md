# Bulk File Find & Replace Renamer

A straightforward PowerShell utility script that searches for specific text strings within filenames and replaces them. It runs interactively and includes built-in safeguards to prevent accidental file overwrites. 

## Features
* **Interactive Prompts:** Asks for the target text and replacement text dynamically.
* **Preview Mode:** Shows you exactly what will change before executing anything.
* **Collision Protection:** Automatically skips files if the target filename already exists.
* **Error Handling:** Provides a clear summary of successful renames, skips, and failures.

## How to Use
1. Copy the `BulkFilerenamer.ps1` script into the folder containing the files you want to rename.
2. Right-click the script and select **Run with PowerShell**.
3. Enter the exact text you want to find.
4. Enter the replacement text (leave blank to just delete the found text).
5. Review the preview list and type 'Y' to confirm the changes.

## Requirements
* Windows OS with PowerShell installed.