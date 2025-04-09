param(
    [string]$Module
)

# Check if the module is provided as an argument
if (-not $Module) {
    Write-Host "No module specified. Please provide a module name." -ForegroundColor Red
    Restart
}

if ($Module -eq "mousejiggle") {
    # Load the mousejiggle module
    .\bin\cb2\mousejiggle.ps1
} elseif ($Module -eq "randomsound") {
    # Load the randomsound module
    .\bin\cb2\randomsound.ps1
} elseif ($Module -eq "fakehack") {
    # Load the fakehack module
    .\bin\cb2\fakehack.ps1
} elseif ($Module -eq "notepadbomb") {
    # Load the notepadbomb module
    .\bin\cb2\notepadbomb.ps1
} elseif ($Module -eq "foldermaze") {
    # Load the foldermaze module
    .\bin\cb2\foldermaze.ps1
} elseif ($Module -eq "textglitcher") {
    # Load the textglitcher module
    .\bin\cb2\textglitcher.ps1
} elseif ($Module -eq "schooltimer") {
    # Load the schooltimer module
    .\bin\cb2\schooltimer.ps1
} elseif ($Module -eq "quoteofday") {
    # Load the quoteofday module
    .\bin\cb2\quoteofday.ps1
} elseif ($Module -eq "noclip") {
    # Load the noclip module
    .\bin\cb2\noclip.ps1
} elseif ($Module -eq "noteself") {
    # Load the noteself module
    .\bin\cb2\noteself.ps1
} elseif ($Module -eq "aimtrainer") {
    # Load the aimtrainer module
    .\bin\cb2\aimtrainer.ps1
} elseif ($Module -eq "exit") {
    # Exit the script
    Write-Host "Exiting ToolBored..." -ForegroundColor Green
    Start-Sleep -Seconds 2
    Stop-Process -Id $PID
} else {
    Write-Host "Invalid module specified." -ForegroundColor Red
    Restart
}