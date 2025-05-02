function Func-show {
    Write-Host "Configuration file not found. Configuring UI..." -ForegroundColor Yellow
    Start-Sleep -Seconds 2
    Write-Host "

GUI - User friendly interface, easier to use, simple.
CLI - Command Line Interface, more advanced, looks more intimidating." -ForegroundColor Green
    $ans = Read-Host "Do you want to use the GUI or CLI? (g/c)"
    if ($ans -eq "g") {
        echo "GUI" | Out-File -FilePath "bin\ui.config" -Force
    } elseif ($ans -eq "c") {
        echo "CLI" | Out-File -FilePath "bin\ui.config" -Force
    } else {
        Write-Host "Invalid input. Please enter 'g' for GUI or 'c' for CLI." -ForegroundColor Red
        Func-show
    }
    Clear-Host
    Write-Host "Configuration saved." -ForegroundColor Green
    Start-Sleep -Seconds 2
    $host.Ui.RawUI.WindowTitle = "ToolBored - [$Global:UiType]"
    Clear-Host
    Start-Process -FilePath "powershell.exe" -ArgumentList '-ExecutionPolicy Bypass -File "TB.ps1"'
}

# Check if the configuration file exists
if (Test-Path "bin\ui.config") {
    $host.UI.RawUI.WindowTitle = "ToolBored - [$Global:UiType]"
    .\bin\cb2\menu.ps1
} else {
    Func-show
}