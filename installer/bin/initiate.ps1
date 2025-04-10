param(
    [string]$Path = "ERROR: Path not set",
    [string]$Version = "ERROR: Version not set",
    [string]$License = "false"
)

if ($Path -eq "ERROR: Path not set" -or $Version -eq "ERROR: Version not set") {
    Write-Host "[ERROR] Path or Version not set. Please check your configuration."
    Pause
    exit 1
}

if ($License -eq "false") {
    Write-Host "[ERROR] Please accept the license agreement before proceeding."
    Pause
    exit
}

# Text
Start-Sleep -Seconds 2
Write-Host "[INFO] Initiating installation process..."
Start-Sleep -Seconds 2
Write-Host "[INFO] Path: $Path"
Write-Host "[INFO] Version: $Version"
Start-Sleep -Seconds 2

# File list
$files = @(
    "ToolBored.ps1",
    "ToolBored.cmd",
    "bin/alias.ps1",
    "bin/selector.ps1",
    "bin/cb2/menu.ps1"
)

$uri = "https://raw.githubusercontent.com/eiedouno/ToolBored/stable/"

foreach ($file in $files) {
    # Use Join-Path to ensure proper Windows path formatting
    $localPath = Join-Path $Path $file
    $folder = Split-Path $localPath

    # Make sure the folder exists
    if (!(Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
    }

    # Download the file
    Invoke-WebRequest -Uri ($uri + $file) -OutFile $localPath
}
