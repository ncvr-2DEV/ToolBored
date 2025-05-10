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
    .\bin\gui\mousejiggle.ps1
} elseif ($Module -eq "randomsound") {
    # Load the randomsound module
    .\bin\gui\randomsound.ps1
} elseif ($Module -eq "fakehack") {
    # Load the fakehack module
    .\bin\gui\fakehack.ps1
} elseif ($Module -eq "foldermaze") {
    # Load the foldermaze module
    .\bin\gui\foldermaze.ps1
} elseif ($Module -eq "textglitcher") {
    # Load the textglitcher module
    .\bin\gui\textglitcher.ps1
} elseif ($Module -eq "schooltimer") {
    # Load the schooltimer module
    .\bin\gui\schooltimer.ps1
} elseif ($Module -eq "quoteofday") {
    # Load the quoteofday module
    .\bin\gui\quoteofday.ps1
} elseif ($Module -eq "flashcard") {
    # Load the flashcard module
    .\bin\gui\flashcard.ps1
} elseif ($Module -eq "aimtrainer") {
    # Load the aimtrainer module
    .\bin\gui\aimtrainer.ps1
} else {
    Write-Host "Invalid module specified." -ForegroundColor Red
    Restart
}