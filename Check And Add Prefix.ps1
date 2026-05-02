# MIT License
# Copyright (c) 2026 Bishnu Mahali
# See LICENSE file in the repository root for full license text.

# Force clean state (prevents inherited variables like "Yellow")
Remove-Variable -Name prefix -ErrorAction SilentlyContinue

# Force interactive prompt loop
do {
    $prefix = Read-Host "Enter prefix (required)"
    
    if ([string]::IsNullOrWhiteSpace($prefix)) {
        Write-Host "❌ Prefix cannot be empty. Try again." -ForegroundColor Red
        $valid = $false
    } else {
        $valid = $true
    }
} while (-not $valid)

Write-Host "`n📁 Working Directory: $(Get-Location)" -ForegroundColor Cyan
Write-Host "📌 Prefix Entered   : '$prefix'" -ForegroundColor Yellow

# Gather files first (avoids mid-process surprises)
$files = Get-ChildItem -File

if ($files.Count -eq 0) {
    Write-Host "⚠️ No files found in this directory." -ForegroundColor Yellow
    return
}

# Preview phase
Write-Host "`n🔍 Preview of changes:" -ForegroundColor Cyan

$previewList = @()
foreach ($file in $files) {
    if ($file.Name.StartsWith($prefix)) {
        Write-Host "⏭️ Skip (already prefixed): $($file.Name)" -ForegroundColor DarkYellow
    } else {
        $newName = $prefix + $file.Name
        Write-Host "➡️ $($file.Name) → $newName" -ForegroundColor Gray

        $previewList += [PSCustomObject]@{
            Original = $file
            NewName  = $newName
        }
    }
}

if ($previewList.Count -eq 0) {
    Write-Host "`n✅ Nothing to rename." -ForegroundColor Green
    return
}

# Confirmation step (prevents accidental execution)
$confirm = Read-Host "`nProceed with renaming? (Y/N)"
if ($confirm -notin @('Y','y')) {
    Write-Host "❌ Operation cancelled by user." -ForegroundColor Red
    return
}

# Execution phase
Write-Host "`n🚀 Renaming started..." -ForegroundColor Cyan

$renamed = 0
$failed = 0

foreach ($item in $previewList) {
    $originalPath = $item.Original.FullName
    $newName = $item.NewName
    $targetPath = Join-Path $item.Original.DirectoryName $newName

    # Collision protection
    if (Test-Path -LiteralPath $targetPath) {
        Write-Host "⚠️ Skipped (name exists): $newName" -ForegroundColor Yellow
        continue
    }

    try {
        Rename-Item -LiteralPath $originalPath -NewName $newName -ErrorAction Stop
        Write-Host "✅ Renamed: $($item.Original.Name)" -ForegroundColor Green
        $renamed++
    }
    catch {
        Write-Host "❌ Failed: $($item.Original.Name) | $($_.Exception.Message)" -ForegroundColor Red
        $failed++
    }
}

# Summary
Write-Host "`n📊 Summary:" -ForegroundColor Cyan
Write-Host "Renamed : $renamed" -ForegroundColor Green
Write-Host "Failed  : $failed" -ForegroundColor Red