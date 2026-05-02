# MIT License
# Copyright (c) 2026 Bishnu Mahali
# See LICENSE file in the repository root for full license text.

# Clean any leftover variables
Remove-Variable find, replace -ErrorAction SilentlyContinue

# --- INPUT (forced) ---
do {
    $find = Read-Host "Enter text to FIND (required)"
    if ([string]::IsNullOrWhiteSpace($find)) {
        Write-Host "❌ Find text cannot be empty." -ForegroundColor Red
        $valid = $false
    } else {
        $valid = $true
    }
} while (-not $valid)

$replace = Read-Host "Enter text to REPLACE with (can be empty to remove)"

Write-Host "`n📁 Directory: $(Get-Location)" -ForegroundColor Cyan
Write-Host "🔍 Find    : '$find'" -ForegroundColor Yellow
Write-Host "✏️ Replace : '$replace'" -ForegroundColor Yellow

$files = Get-ChildItem -File

if ($files.Count -eq 0) {
    Write-Host "⚠️ No files found." -ForegroundColor Yellow
    return
}

# --- PREVIEW ---
$preview = @()
Write-Host "`n🔍 Preview:" -ForegroundColor Cyan

foreach ($file in $files) {
    if ($file.Name.Contains($find)) {
        $newName = $file.Name.Replace($find, $replace)

        Write-Host "➡️ $($file.Name) → $newName" -ForegroundColor Gray

        $preview += [PSCustomObject]@{
            Original = $file
            NewName  = $newName
        }
    } else {
        Write-Host "⏭️ Skip: $($file.Name)" -ForegroundColor DarkYellow
    }
}

if ($preview.Count -eq 0) {
    Write-Host "`n✅ No matches found." -ForegroundColor Green
    return
}

# --- CONFIRMATION ---
$confirm = Read-Host "`nProceed with these changes? (Y/N)"
if ($confirm -notin @('Y','y')) {
    Write-Host "❌ Operation cancelled." -ForegroundColor Red
    return
}

# --- EXECUTION ---
Write-Host "`n🚀 Applying changes..." -ForegroundColor Cyan

$renamed = 0
$failed = 0
$skipped = 0

foreach ($item in $preview) {
    $targetPath = Join-Path $item.Original.DirectoryName $item.NewName

    if ($item.Original.Name -eq $item.NewName) {
        $skipped++
        continue
    }

    if (Test-Path -LiteralPath $targetPath) {
        Write-Host "⚠️ Skipped (exists): $($item.NewName)" -ForegroundColor Yellow
        $skipped++
        continue
    }

    try {
        Rename-Item -LiteralPath $item.Original.FullName -NewName $item.NewName -ErrorAction Stop
        Write-Host "✅ Renamed: $($item.Original.Name)" -ForegroundColor Green
        $renamed++
    }
    catch {
        Write-Host "❌ Failed: $($item.Original.Name) | $($_.Exception.Message)" -ForegroundColor Red
        $failed++
    }
}

# --- SUMMARY ---
Write-Host "`n📊 Summary:" -ForegroundColor Cyan
Write-Host "Renamed : $renamed" -ForegroundColor Green
Write-Host "Skipped : $skipped" -ForegroundColor Yellow
Write-Host "Failed  : $failed" -ForegroundColor Red