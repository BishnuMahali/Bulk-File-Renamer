while ($true) {

    Clear-Host
    Write-Host "🧰 Bulk File Renamer" -ForegroundColor Cyan
    Write-Host "Choose mode:"
    Write-Host "1 → Add Prefix"
    Write-Host "2 → Add Suffix"
    Write-Host "3 → Find & Replace"
    Write-Host "Esc → Exit"

    $modeKey = [System.Console]::ReadKey($true)

    if ($modeKey.Key -eq "D1") { $mode = "prefix" }
    elseif ($modeKey.Key -eq "D2") { $mode = "suffix" }
    elseif ($modeKey.Key -eq "D3") { $mode = "replace" }
    elseif ($modeKey.Key -eq "Escape") { break }
    else { continue }

    # --- INPUT ---
    if ($mode -eq "prefix") {
        do {
            $value = Read-Host "Enter prefix"
        } while ([string]::IsNullOrWhiteSpace($value))
    }
    elseif ($mode -eq "suffix") {
        do {
            $value = Read-Host "Enter suffix"
        } while ([string]::IsNullOrWhiteSpace($value))
    }
    elseif ($mode -eq "replace") {
        do {
            $find = Read-Host "Find (required)"
        } while ([string]::IsNullOrWhiteSpace($find))

        $replace = Read-Host "Replace (empty = remove)"
    }

    Write-Host "`n📁 Directory: $(Get-Location)" -ForegroundColor Cyan
    $files = Get-ChildItem -File

    if ($files.Count -eq 0) {
        Write-Host "⚠️ No files found." -ForegroundColor Yellow
        return
    }

    # --- PREVIEW ---
    Write-Host "`n🔍 Preview:" -ForegroundColor Cyan
    $previewList = @()

    foreach ($file in $files) {

        $newName = $null

        if ($mode -eq "prefix") {
            if ($file.Name.StartsWith($value)) {
                Write-Host "⏭️ Skip: $($file.Name)" -ForegroundColor DarkYellow
                continue
            }
            $newName = $value + $file.Name
        }

        elseif ($mode -eq "suffix") {
            $base = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
            $ext  = $file.Extension

            if ($base.EndsWith($value)) {
                Write-Host "⏭️ Skip: $($file.Name)" -ForegroundColor DarkYellow
                continue
            }
            $newName = $base + $value + $ext
        }

        elseif ($mode -eq "replace") {
            if (-not $file.Name.Contains($find)) {
                Write-Host "⏭️ Skip: $($file.Name)" -ForegroundColor DarkYellow
                continue
            }
            $newName = $file.Name.Replace($find, $replace)
        }

        Write-Host "➡️ $($file.Name) → $newName" -ForegroundColor Gray

        $previewList += [PSCustomObject]@{
            Original = $file
            NewName  = $newName
        }
    }

    if ($previewList.Count -eq 0) {
        Write-Host "`n✅ Nothing to rename." -ForegroundColor Green
        continue
    }

    # --- CONFIRMATION ---
    Write-Host "`nPress [Enter]/Y = GO | N = Retry | Esc = Exit" -ForegroundColor Cyan
    $key = [System.Console]::ReadKey($true)

    if ($key.Key -eq "Enter" -or $key.Key -eq "Y") {
        Write-Host "`n🚀 Renaming..." -ForegroundColor Cyan
    }
    elseif ($key.Key -eq "N") {
        continue
    }
    elseif ($key.Key -eq "Escape") {
        break
    }
    else {
        continue
    }

    # --- EXECUTION ---
    $renamed = 0
    $failed = 0
    $skipped = 0

    foreach ($item in $previewList) {
        $targetPath = Join-Path $item.Original.DirectoryName $item.NewName

        if ($item.Original.Name -eq $item.NewName) {
            $skipped++
            continue
        }

        if (Test-Path $targetPath) {
            Write-Host "⚠️ Exists: $($item.NewName)" -ForegroundColor Yellow
            $skipped++
            continue
        }

        try {
            Rename-Item -LiteralPath $item.Original.FullName -NewName $item.NewName -ErrorAction Stop
            Write-Host "✅ $($item.Original.Name)" -ForegroundColor Green
            $renamed++
        }
        catch {
            Write-Host "❌ $($item.Original.Name)" -ForegroundColor Red
            $failed++
        }
    }

    Write-Host "`n📊 Summary:" -ForegroundColor Cyan
    Write-Host "Renamed : $renamed" -ForegroundColor Green
    Write-Host "Skipped : $skipped" -ForegroundColor Yellow
    Write-Host "Failed  : $failed" -ForegroundColor Red

    Write-Host "`nPress any key to continue..." -ForegroundColor DarkGray
    [System.Console]::ReadKey($true) | Out-Null
}