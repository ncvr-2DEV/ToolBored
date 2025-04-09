param (
    [Parameter(Mandatory = $true)]
    [PSCustomObject]$Settings
)

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Debugging: Print the entire object and settings
$Settings | Format-List
Write-Host "`nSettings applied:"
$($Settings) | Out-String | Write-Host

# Initialize global game parameters based on mode
$global:targetCount = if ($Settings.SpeedrunMode) { 30 } else { $Settings.TotalRounds }
$global:targetSize  = if ($Settings.SpeedrunMode) { 100 } else { $Settings.WindowSize }
$global:mode        = if ($Settings.SpeedrunMode) { "Instant" } else { $Settings.TimingMode }
$global:activationMode = if ($Settings.SpeedrunMode) { "MouseClick" } else { $Settings.ActivationMode }

# Global stopwatch and statistics
$global:stopwatch = [System.Diagnostics.Stopwatch]::New()
$global:roundsCompleted = 0
$global:fastestTime = [Double]::MaxValue
$global:totalTime = 0

# Function to spawn a target window
function Spawn-Target {
    $global:form = New-Object Windows.Forms.Form
    $global:form.Text = "Target"
    $global:form.Width = $global:targetSize
    $global:form.Height = $global:targetSize
    $global:form.StartPosition = [Windows.Forms.FormStartPosition]::Manual
    $screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
    $screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height
    $randX = Get-Random -Minimum 0 -Maximum ($screenWidth - $global:targetSize)
    $randY = Get-Random -Minimum 0 -Maximum ($screenHeight - $global:targetSize)
    $global:form.Location = New-Object Drawing.Point($randX, $randY)
    $global:form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None

    # Attach events based on the activation mode
    $global:form.add_MouseEnter({ if ($global:activationMode -eq "MouseHover") { Update-Stats } })
    $global:form.add_MouseClick({ if ($global:activationMode -eq "MouseClick") { Update-Stats } })

    # Start timing if not in Speedrun mode
    if (-not $Settings.SpeedrunMode) { $global:stopwatch.Start() }

    # Show the form modally and wait for the user to close it
    $global:form.ShowDialog() | Out-Null

    # Handle rounds completion and spawn the next target if necessary
    if ($global:roundsCompleted -lt $global:targetCount) {
        if ($global:mode -eq "Random") {
            Start-Sleep -Milliseconds (Get-Random -Minimum 0 -Maximum 3000)
        }
        Spawn-Target
    } else {
        $global:stopwatch.Stop()  # Stop stopwatch if in Speedrun mode
        Show-Results
    }
}

# Function to update statistics after a target is hit
function Update-Stats {
    if (-not $Settings.SpeedrunMode) {
        $global:stopwatch.Stop()
        $timeTaken = $global:stopwatch.ElapsedMilliseconds / 1000.0
        $global:stopwatch.Reset()
    }

    $global:totalTime += $timeTaken
    $global:fastestTime = [Math]::Min($global:fastestTime, $timeTaken)
    $global:roundsCompleted++
    $global:form.Close()
}

# Function to display results once all rounds are complete
# Function to display results once all rounds are complete
function Show-Results {
    $global:avgTime = if (-not $Settings.SpeedrunMode) { $global:totalTime / $global:targetCount } else { 0 }

    # Define log file path and create directory if necessary
    $global:logFilePath = "bin\aimtrainertimes.log"
    $global:logDir = Split-Path $global:logFilePath
    if (-not (Test-Path $global:logDir)) { New-Item -ItemType Directory -Path $global:logDir -Force | Out-Null }

    # Read existing log file or initialize default values
    if (Test-Path $global:logFilePath) {
        $global:lines = Get-Content -Path $global:logFilePath
    } else {
        $global:lines = @("N/A", "N/A", "N/A")
    }

    # Ensure $global:lines has at least 3 elements
    if ($global:lines.Count -lt 3) {
        $global:lines += @("N/A") * (3 - $global:lines.Count)
    }

    # Initialize the fastest times with the special default value for "N/A"
    $global:currentFastestTime = if ($global:lines[0] -eq "N/A") { [double]::MaxValue } else { [double]$global:lines[0] }
    $global:currentFastestAvg = if ($global:lines[1] -eq "N/A") { [double]::MaxValue } else { [double]$global:lines[1] }
    $global:currentFastestSR = if ($global:lines[2] -eq "N/A") { [double]::MaxValue } else { [double]$global:lines[2] }

    # Update best times if applicable
    if ($Settings.SpeedrunMode) {
        $global:stopwatch.Stop()
        $global:fastestTime = $global:stopwatch.ElapsedMilliseconds / 1000.0
        if ($global:fastestTime -lt $global:currentFastestSR) { $global:lines[2] = $global:fastestTime }
    } else {
        if ($global:fastestTime -lt $global:currentFastestTime) { $global:lines[0] = $global:fastestTime }
        if ($global:avgTime -lt $global:currentFastestAvg) { $global:lines[1] = $global:avgTime }
    }

    # Write updated stats to the log file
    Set-Content -Path $global:logFilePath -Value $global:lines

    # Show results message
    $resultsMessage = if ($Settings.SpeedrunMode) {
        "Game Over!`n`nTime: $($global:stopwatch.ElapsedMilliseconds) ms"
    } else {
        "Game Over!`n`nTotal Rounds: $global:targetCount`nFastest Time: $([Math]::Round($global:fastestTime, 3)) seconds`nAverage Time: $([Math]::Round($global:avgTime, 3)) seconds"
    }

    [System.Windows.Forms.MessageBox]::Show($resultsMessage, "Aim Trainer Results")

    # Ask if the user wants to play again
    $playAgain = [System.Windows.Forms.MessageBox]::Show("Do you want to play again?", "Play Again", [System.Windows.Forms.MessageBoxButtons]::YesNo)
    if ($playAgain -eq [System.Windows.Forms.DialogResult]::Yes) {
        Reset-Game
        Spawn-Target
    } else {
        [System.Windows.Forms.Application]::Exit()
        .\bin\cb2\aimtrainer.ps1
    }
}



# Function to reset the game for replay
function Reset-Game {
    $global:roundsCompleted = 0
    $global:totalTime = 0
    $global:fastestTime = [Double]::MaxValue
    $global:stopwatch.Reset()
    $global:stopwatch.Start()
}

# Start the aim trainer game
if ($Settings.SpeedrunMode) { $global:stopwatch.Start() }
Spawn-Target
