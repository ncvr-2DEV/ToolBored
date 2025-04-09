param (
    [Parameter(Mandatory = $true)]
    [PSCustomObject]$Settings
)

Add-Type -AssemblyName PresentationFramework

# Debugging: Print the entire object
$Settings | Format-List
Write-Host "
Settings applied:"
$($global:settings) | Out-String | Write-Host

# Decide on game parameters based on mode
if ($Settings.SpeedrunMode -eq $true) {
    # Speedrun mode: Predefined values
    $global:targetCount = 30
    $global:targetSize  = 100
    $global:mode        = "Instant"
} else {
    # Normal mode: Use user-provided settings
    $global:targetCount = $Settings.TotalRounds
    $global:targetSize  = $Settings.WindowSize
    $global:mode        = $Settings.TimingMode
}

# Load necessary assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Stopwatch for timing
$global:stopwatch = [System.Diagnostics.Stopwatch]::New()
$global:roundsCompleted = 0
$global:fastestTime = [Double]::MaxValue
$global:totalTime = 0



# Function to spawn a target window
function Spawn-Target {
    # Create target window
    $form = New-Object Windows.Forms.Form
    $form.Text = "Target"
    $form.Width = $global:targetSize
    $form.Height = $global:targetSize
    $form.StartPosition = [Windows.Forms.FormStartPosition]::Manual

    # Random position on the screen
    $screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
    $screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height
    $randX = Get-Random -Minimum 0 -Maximum ($screenWidth - $global:targetSize)
    $randY = Get-Random -Minimum 0 -Maximum ($screenHeight - $global:targetSize)
    $form.Location = New-Object Drawing.Point($randX, $randY)
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None

    # Attach MouseEnter event – this will fire when the cursor hovers over the target.
    $form.add_MouseEnter({
        if ($Settings.ActivationMode -eq "MouseHover") { Update-stats }
    })

    # Attach MouseClick event – this will fire when the target is clicked.
    $form.add_MouseClick({
        if ($Settings.ActivationMode -eq "MouseClick") { Update-stats }
    })

    # Start timing if not in Speedrun mode.
    if (-not $Settings.SpeedrunMode) {
        $global:stopwatch.Start()
    }

    # Show the form modally. This call blocks until the form is closed.
    $form.ShowDialog() | Out-Null

    # After the form is closed, check if we need another round.
    if ($global:roundsCompleted -lt $global:targetCount) {
        if ($mode -eq "Random") {
            Start-Sleep -Milliseconds (Get-Random -Minimum 0 -Maximum 3000)
        }
         Spawn-Target   # Launch the next target
    } else {
        $global:stopwatch.Stop()  # Stop the stopwatch if in Speedrun mode.
         Show-Results  # All rounds completed; display results.
    }
}



# Function to update statistics after a target is hit
function Update-stats {
    # Update statistics
    if (-not $Settings.SpeedrunMode) {
        $global:stopwatch.Stop()
        $timeTaken = $global:stopwatch.ElapsedMilliseconds / 1000.0
        $global:stopwatch.Reset()
    }

    $global:totalTime += $timeTaken
    $global:fastestTime = [Math]::Min($global:fastestTime, $timeTaken)
    $global:roundsCompleted++
    $form.Close()
}



# Function to display results once rounds are complete
function Show-Results {
    if (-not $Settings.SpeedrunMode) {
        $avgTime = $global:totalTime / $global:targetCount
        $resultsMessage = "Game Over!`n`nTotal Rounds: $global:targetCount`nFastest Time: $([Math]::Round($global:fastestTime, 3)) seconds`nAverage Time: $([Math]::Round($avgTime, 3)) seconds"
    } else {
        # Stop the stopwatch and show the total elapsed time in milliseconds.
        $global:stopwatch.Stop()
        $resultsMessage = "Game Over!`n`nTime: $($global:stopwatch.ElapsedMilliseconds) ms"
    }
    [System.Windows.Forms.MessageBox]::Show($resultsMessage, "Aim Trainer Results")

    # Ask if the user wants to play again
    $playAgain = [System.Windows.Forms.MessageBox]::Show("Do you want to play again?", "Play Again", [System.Windows.Forms.MessageBoxButtons]::YesNo)
    if ($playAgain -eq [System.Windows.Forms.DialogResult]::Yes) {
        $global:roundsCompleted = 0
        $global:totalTime = 0
        $global:fastestTime = [Double]::MaxValue
        $global:stopwatch.Reset()
        Spawn-Target  # Restart the game
    } else {
        # Close the application if the user chooses not to play again.
        [System.Windows.Forms.Application]::Exit()
    }

}



# Start the aim trainer engine by launching the first target.
if ($($Settings.SpeedrunMode)) {
    $global:stopwatch.Start()
}

Spawn-Target

Restart