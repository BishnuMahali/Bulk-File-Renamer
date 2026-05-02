# MIT License
# Copyright (c) 2026 Bishnu Mahali
# See LICENSE file in the repository root for full license text.

while ($true) {

    # Force clean state
    Remove-Variable -Name suffix -ErrorAction SilentlyContinue

    # --- INPUT ---
    do {
        $suffix = Read-Host "Enter suffix (required)"
        
        if ([string]::IsNullOrWhiteSpace($suffix)) {
            Write-Host "❌ Suffix cannot be empty. Try again." -ForegroundColor Red
            $valid = $false
        } else {
            $valid = $true
        }
    } while (-not $valid)

    Write-Host "`n📁 Working Directory: $(Get-Location)" -ForegroundColor Cyan
    Write-Host "📌 Suffix to apply: '$suffix'" -ForegroundColor Yellow

    $files = Get-ChildItem -File

    if ($files.Count -eq 0) {
        Write-Host "⚠️ No files found." -ForegroundColor Yellow
        return
    }

    # --- PREVIEW ---
    Write-Host "`n🔍 Preview:" -ForegroundColor Cyan
    $previewList = @(foreach ($file in $files) {
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
        $extension = $file.Extension

        if ($baseName.EndsWith($suffix)) {
            Write-Host "⏭️ Skip: $($file.Name)" -ForegroundColor DarkYellow
        }
        else {
            $newName = $baseName + $suffix + $extension
            Write-Host "➡️ $($file.Name) → $newName" -ForegroundColor Gray

            [PSCustomObject]@{
                Original = $file
                NewName  = $newName
            }
        }
    })

    if ($previewList.Count -eq 0) {
        Write-Host "`n✅ Nothing to rename." -ForegroundColor Green
        return
    }

    # --- CONFIRMATION (FIXED) ---
    Write-Host "`nPress [Enter] or Y to proceed, N to retry, Esc to exit" -ForegroundColor Cyan

    $key = [System.Console]::ReadKey($true)

    if ($key.Key -eq "Enter" -or $key.Key -eq "Y") {
        Write-Host "`n🚀 Renaming started..." -ForegroundColor Cyan
    }
    elseif ($key.Key -eq "N") {
        Write-Host "`n🔁 Restarting input..." -ForegroundColor Yellow
        continue   # 🔁 Goes back to suffix input
    }
    elseif ($key.Key -eq "Escape") {
        Write-Host "`n❌ Exiting..." -ForegroundColor Red
        break
    }
    else {
        Write-Host "`n❌ Invalid key. Restarting..." -ForegroundColor Red
        continue
    }

    # --- EXECUTION ---
    $renamed = 0
    $failed = 0

    foreach ($item in $previewList) {
        $targetPath = Join-Path $item.Original.DirectoryName $item.NewName

        if (Test-Path -LiteralPath $targetPath) {
            Write-Host "⚠️ Skipped (exists): $($item.NewName)" -ForegroundColor Yellow
            continue
        }

        try {
            Rename-Item -LiteralPath $item.Original.FullName -NewName $item.NewName -ErrorAction Stop
            Write-Host "✅ Renamed: $($item.Original.Name)" -ForegroundColor Green
            $renamed++
        }
        catch {
            Write-Host "❌ Failed: $($item.Original.Name)" -ForegroundColor Red
            $failed++
        }
    }

    # --- SUMMARY ---
    Write-Host "`n📊 Summary:" -ForegroundColor Cyan
    Write-Host "Renamed : $renamed" -ForegroundColor Green
    Write-Host "Failed  : $failed" -ForegroundColor Red

    break
}