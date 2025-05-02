param(
    [string]$Path = "ERROR: Path not set",
    [string]$Version = "ERROR: Version not set",
    [string]$License = "false",
    [string]$DS="false",
    [string]$SM="false",
    [string]$Start="false"
)

# This is the installer for ToolBored.

if ($Path -eq "ERROR: Path not set" -or $Version -eq "ERROR: Version not set") {
    Write-Host "`n[ERROR] Path or Version not set. Please check your configuration." -ForegroundColor DarkRed
    Pause
    exit 1
}

if ($License -eq "false") {
    Write-Host "`n[ERROR] Please accept the license agreement before proceeding." -ForegroundColor DarkRed
    Pause
    exit
}

# Intro
Write-Host "`nInstalling ToolBored -$Version" -ForegroundColor Cyan
Write-Host "--------------------------------------" -ForegroundColor Blue
Write-Host "[INFO] Installation path: $Path" -ForegroundColor Blue
Write-Host "[INFO] Starting download and setup..." -ForegroundColor Blue
Write-Host ""

Start-Sleep -Seconds 1

# File list
$files = @(
    "TB.ps1",
    "ToolBored-Launcher.cmd",
    "LICENSE.md",
    "README.md",
    "bin/alias.ps1",
    "bin/reset.ps1",
    "bin/selector.ps1",
    "bin/cb2/aimtrainer.ps1",
    "bin/cb2/menu.ps1",
    "bin/cb2/mousejiggle.ps1",
    "bin/gui/menu.ps1",
    "bin/modules/aimtrainerengine.ps1",
    "bin/modules/aimtrainersettings.ps1",
    "bin/modules/mousejctrl.ps1"
)

$uri = "https://raw.githubusercontent.com/eiedouno/ToolBored/stable/"
$total = $files.Count
$count = 0
$maxLength = ($files | Measure-Object -Property Length -Maximum).Maximum

foreach ($file in $files) {
    $count++
    $localPath = Join-Path $Path $file
    $folder = Split-Path $localPath
    $paddedFile = $file.PadRight($maxLength + 2)
    $percent = [math]::Round(($count / $total) * 100)

    try {
        # Ensure directory exists
        if (!(Test-Path $folder)) {
            New-Item -ItemType Directory -Path $folder -Force | Out-Null
        }

        # Show live percent
        Write-Host "`r[Downloading] $paddedFile ($percent%)" -NoNewline -ForegroundColor Yellow

        # Download the file
        Invoke-WebRequest -Uri ($uri + $file) -OutFile $localPath -ErrorAction Stop

        # Overwrite with success
        Write-Host "`r[Installed  ] $paddedFile       " -ForegroundColor Green
    }
    catch {
        Write-Host "`r[Failed     ] $paddedFile       " -ForegroundColor DarkRed
    }
}



Start-Sleep -Seconds 1
if ($DS -eq "true") {
    Write-Host "[INFO] Creating shortcut on Desktop..." -ForegroundColor Blue
    $shortcutPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'), 'ToolBored.lnk')
    $WshShell = New-Object -ComObject WScript.Shell
    $shortcut = $WshShell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = [System.IO.Path]::Combine($Path, 'ToolBored-Launcher.cmd')
    $shortcut.WorkingDirectory = $Path
    $shortcut.Save()
}
if ($SM -eq "true") {
    Write-Host "[INFO] Creating shortcut in Start Menu..." -ForegroundColor Blue
    $startMenuPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('StartMenu'), 'Programs', 'ToolBored.lnk')
    $WshShell = New-Object -ComObject WScript.Shell
    $shortcut = $WshShell.CreateShortcut($startMenuPath)
    $shortcut.TargetPath = [System.IO.Path]::Combine($Path, 'ToolBored-Launcher.cmd')
    $shortcut.WorkingDirectory = $Path
    $shortcut.Save()
}
if ($Start -eq "true") {
    Write-Host "[INFO] Starting ToolBored..." -ForegroundColor Blue
    Start-Process -FilePath ([System.IO.Path]::Combine($Path, 'ToolBored-Launcher.cmd'))
}



# End of installation
Write-Host "`n[INFO] Installation completed." -ForegroundColor Blue
Start-Sleep -Seconds 1
exit 1