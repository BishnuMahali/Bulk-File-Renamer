# MIT License
# Copyright (c) 2026 Bishnu Mahali
# See LICENSE file in the repository root for full license text.

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Bulk File Renamer Pro" Height="650" Width="900" Background="#F0F0F0" WindowStartupLocation="CenterScreen">
    <Grid Margin="20">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <!-- Header -->
        <StackPanel Grid.Row="0" Margin="0,0,0,20">
            <TextBlock Text="BULK FILE RENAMER" FontSize="24" FontWeight="Bold" Foreground="#007ACC"/>
            <TextBlock Text="Fast, safe, and modern file renaming utility" FontSize="12" Foreground="Gray"/>
        </StackPanel>

        <!-- Configuration -->
        <Border Grid.Row="1" Background="White" CornerRadius="8" Padding="15" Margin="0,0,0,20">
            <StackPanel>
                <Grid Margin="0,0,0,10">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="Auto"/>
                    </Grid.ColumnDefinitions>
                    <TextBox x:Name="txtPath" Grid.Column="0" VerticalContentAlignment="Center" Padding="5" Height="30" IsReadOnly="True" Background="#F9F9F9"/>
                    <Button x:Name="btnBrowse" Grid.Column="1" Content="Browse Folder" Width="100" Margin="10,0,0,0" Cursor="Hand"/>
                </Grid>

                <UniformGrid Columns="2">
                    <StackPanel Margin="0,5,10,5">
                        <TextBlock Text="Add Prefix" FontWeight="SemiBold" Margin="0,0,0,5"/>
                        <TextBox x:Name="txtPrefix" Padding="5" Height="28"/>
                    </StackPanel>
                    <StackPanel Margin="10,5,0,5">
                        <TextBlock Text="Add Suffix" FontWeight="SemiBold" Margin="0,0,0,5"/>
                        <TextBox x:Name="txtSuffix" Padding="5" Height="28"/>
                    </StackPanel>
                    <StackPanel Margin="0,5,10,5">
                        <TextBlock Text="Find Text" FontWeight="SemiBold" Margin="0,0,0,5"/>
                        <TextBox x:Name="txtFind" Padding="5" Height="28"/>
                    </StackPanel>
                    <StackPanel Margin="10,5,0,5">
                        <TextBlock Text="Replace With" FontWeight="SemiBold" Margin="0,0,0,5"/>
                        <TextBox x:Name="txtReplace" Padding="5" Height="28"/>
                    </StackPanel>
                </UniformGrid>
            </StackPanel>
        </Border>

        <!-- Preview Table -->
        <GroupBox Grid.Row="2" Header="Live Preview" FontWeight="SemiBold">
            <DataGrid x:Name="dgPreview" AutoGenerateColumns="False" IsReadOnly="True" Background="White" Margin="5"
                      CanUserAddRows="False" CanUserDeleteRows="False" SelectionMode="Extended" GridLinesVisibility="Horizontal">
                <DataGrid.Columns>
                    <DataGridTextColumn Header="Original Filename" Binding="{Binding Original}" Width="*"/>
                    <DataGridTextColumn Header="New Filename" Binding="{Binding New}" Width="*">
                        <DataGridTextColumn.ElementStyle>
                            <Style TargetType="TextBlock">
                                <Setter Property="Foreground" Value="#007ACC"/>
                                <Setter Property="FontWeight" Value="SemiBold"/>
                            </Style>
                        </DataGridTextColumn.ElementStyle>
                    </DataGridTextColumn>
                </DataGrid.Columns>
            </DataGrid>
        </GroupBox>

        <!-- Actions -->
        <Grid Grid.Row="3" Margin="0,20,0,0">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="Auto"/>
            </Grid.ColumnDefinitions>
            <TextBlock x:Name="lblStatus" Grid.Column="0" VerticalAlignment="Center" Text="Ready" Foreground="Gray"/>
            <Button x:Name="btnApply" Grid.Column="1" Content="Apply Changes" Width="150" Height="40" Background="#007ACC" Foreground="White" FontWeight="Bold" Cursor="Hand">
                <Button.Resources>
                    <Style TargetType="Border">
                        <Setter Property="CornerRadius" Value="5"/>
                    </Style>
                </Button.Resources>
            </Button>
        </Grid>
    </Grid>
</Window>
"@

# Load XAML
$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

# Map Controls
$txtPath = $window.FindName("txtPath")
$btnBrowse = $window.FindName("btnBrowse")
$txtPrefix = $window.FindName("txtPrefix")
$txtSuffix = $window.FindName("txtSuffix")
$txtFind = $window.FindName("txtFind")
$txtReplace = $window.FindName("txtReplace")
$dgPreview = $window.FindName("dgPreview")
$btnApply = $window.FindName("btnApply")
$lblStatus = $window.FindName("lblStatus")

$currentPath = Get-Location
$txtPath.Text = $currentPath.Path

# ─────────────────────────────────────────────
# LOGIC
# ─────────────────────────────────────────────

function Update-Preview {
    if (-not (Test-Path -LiteralPath $txtPath.Text)) { return }

    $prefix = $txtPrefix.Text
    $suffix = $txtSuffix.Text
    $find = $txtFind.Text
    $replace = $txtReplace.Text

    $files = Get-ChildItem -LiteralPath $txtPath.Text -File
    $previewData = New-Object System.Collections.ObjectModel.ObservableCollection[PSCustomObject]

    foreach ($file in $files) {
        $newName = $file.Name

        # Apply Find/Replace
        if (![string]::IsNullOrEmpty($find)) {
            $newName = $newName.Replace($find, $replace)
        }

        # Apply Prefix
        if (![string]::IsNullOrEmpty($prefix) -and -not $newName.StartsWith($prefix)) {
            $newName = $prefix + $newName
        }

        # Apply Suffix
        if (![string]::IsNullOrEmpty($suffix)) {
            $base = [System.IO.Path]::GetFileNameWithoutExtension($newName)
            $ext = [System.IO.Path]::GetExtension($newName)
            if (-not $base.EndsWith($suffix)) {
                $newName = $base + $suffix + $ext
            }
        }

        $previewData.Add([PSCustomObject]@{
            Original = $file.Name
            New = $newName
            FullPath = $file.FullName
        })
    }

    $dgPreview.ItemsSource = $previewData
    $lblStatus.Text = "$($previewData.Count) files in queue"
}

# ─────────────────────────────────────────────
# EVENTS
# ─────────────────────────────────────────────

$btnBrowse.Add_Click({
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.SelectedPath = $txtPath.Text
    if ($dialog.ShowDialog() -eq "OK") {
        $txtPath.Text = $dialog.SelectedPath
        Update-Preview
    }
})

$textChangedHandler = { Update-Preview }
$txtPrefix.Add_TextChanged($textChangedHandler)
$txtSuffix.Add_TextChanged($textChangedHandler)
$txtFind.Add_TextChanged($textChangedHandler)
$txtReplace.Add_TextChanged($textChangedHandler)

$btnApply.Add_Click({
    $items = $dgPreview.ItemsSource
    if (-not $items -or $items.Count -eq 0) {
        [System.Windows.MessageBox]::Show("Nothing to rename!", "Info")
        return
    }

    $result = [System.Windows.MessageBox]::Show("Are you sure you want to rename $($items.Count) files?", "Confirm", "YesNo", "Question")
    if ($result -eq "No") { return }

    $success = 0
    $failed = 0

    foreach ($item in $items) {
        if ($item.Original -eq $item.New) { continue }

        $targetPath = Join-Path (Split-Path $item.FullPath) $item.New
        if (Test-Path -LiteralPath $targetPath) {
            $failed++
            continue
        }

        try {
            Rename-Item -LiteralPath $item.FullPath -NewName $item.New -ErrorAction Stop
            $success++
        } catch {
            $failed++
        }
    }

    [System.Windows.MessageBox]::Show("Renaming Complete!`nSuccess: $success`nFailed: $failed", "Done")
    Update-Preview
})

# Initial load
Update-Preview

$window.ShowDialog() | Out-Null
