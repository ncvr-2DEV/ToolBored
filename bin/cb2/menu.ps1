if ($Global:UiType -eq "GUI") {
    # Load the GUI module
    .\bin\gui\menu.ps1
} elseif ($ui -eq "CLI") {
    # Load the CLI module
    .\bin\cli\menu.ps1
} else {
    Write-Host "Invalid UI option. Please set 'GUI' or 'CLI' in bin\ui.config." -ForegroundColor Red
}