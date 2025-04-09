$host.UI.RawUI.WindowTitle = "ToolBored starting..."
# Get DirectX Version
$Global:comstatDirectX = (Get-WmiObject -Class Win32_VideoController | Select-Object -First 1).DriverVersion
function Restart {
    $Global:UiType = Get-Content -Path "bin\ui.config"
    .\bin\alias.ps1
}
Restart