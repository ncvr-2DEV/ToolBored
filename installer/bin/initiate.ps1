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
$host.UI.RawUI.WindowTitle = "ToolBored Installer"
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
    "bin/gui/aimtrainer.ps1",
    "bin/gui/fakehack.ps1",
    "bin/gui/flashcard.ps1",
    "bin/gui/mousejiggle.ps1",
    "bin/gui/menu.ps1",
    "bin/modules/aimtrainerengine.ps1",
    "bin/modules/aimtrainersettings.ps1",
    "bin/modules/flashcard.ps1",
    "bin/modules/mousejctrl.ps1",
    "bin/modules/newflashcard.ps1",
    "bin/modules/fh/fhstart.ps1"
)
if ($Version -eq "stable") {
    $uri = "https://raw.githubusercontent.com/eiedouno/ToolBored/stable/"
} elseif ($Version -eq "beta") {
    $uri = "https://raw.githubusercontent.com/eiedouno/ToolBored/beta/"
    Write-Host "`n[WARNING] You are using the beta version. Things may break. This version is updated randomly and frequently, you could already be using a previous version. Please report any issues." -ForegroundColor Yellow
} elseif ($Version -eq "SmoothUI") {
    $uri = "https://raw.githubusercontent.com/eiedouno/ToolBored/beta/"
    Write-Host "`n[WARNING] SmoothUI version is unavailable. Defaulting to beta." -ForegroundColor Yellow
    Write-Host "`n[WARNING] You are using the beta version. Things may break. This version is updated randomly and frequently, you could already be using a previous version. Please report any issues." -ForegroundColor Yellow
} else {
    Write-Host "`n[ERROR] Invalid version specified. Please check your configuration." -ForegroundColor DarkRed
    Pause
    exit 1
}
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
    Start-Process -FilePath ([System.IO.Path]::Combine($Path, 'ToolBored-Launcher.cmd')) -WorkingDirectory $Path
}



# Create build info file
$buildInfoPath = Join-Path $Path "\bin\buildinfo.json"
$buildInfo = @{
    Version = $Version
    Path = $Path
} | ConvertTo-Json | Set-Content -Path $buildInfoPath -Force
Write-Host "[INFO] Build info saved to $buildInfoPath" -ForegroundColor Blue


# End of installation
Write-Host "`n[INFO] Installation completed." -ForegroundColor Blue
Pause
exit 1