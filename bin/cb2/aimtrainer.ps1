Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

# Define Stats
$global:fastestAimTime = Get-Content -Path "bin\aimtrainertimes.log" | Select-Object -First 1
$global:totalAimTime = Get-Content -Path "bin\aimtrainertimes.log" | Select-Object -Skip 1 -First 1
$global:speedAimTime = Get-Content -Path "bin\aimtrainertimes.log" | Select-Object -Skip 2 -First 1



# Create Window
$global:menuwindow = New-Object System.Windows.Window
$global:menuwindow.Title = "ToolBored Aim Trainer"
$global:menuwindow.Width = 1000
$global:menuwindow.Height = 700
$global:menuwindow.WindowStartupLocation = "CenterScreen"

# Main Grid
$windowgrid = New-Object Windows.Controls.Grid
$windowgrid.Margin = '10'

for ($i = 0; $i -lt 6; $i++) {
    $row = New-Object Windows.Controls.RowDefinition
    $row.Height = "Auto"
    $windowgrid.RowDefinitions.Add($row)
}

# View Stats Button
$global:viewStatsButton = New-Object Windows.Controls.Button
$global:viewStatsButton.Content = "View Stats"
$global:viewStatsButton.Height = 30
$global:viewStatsButton.Width = 100
$global:viewStatsButton.HorizontalAlignment = "Left"
$global:viewStatsButton.Margin = '0,0,0,10'
[Windows.Controls.Grid]::SetRow($global:viewStatsButton, 0)
$windowgrid.Children.Add($global:viewStatsButton)

# New Game Button
$global:newGameButton = New-Object Windows.Controls.Button
$global:newGameButton.Content = "New Game"
$global:newGameButton.Height = 30
$global:newGameButton.Width = 100
$global:newGameButton.HorizontalAlignment = "Right"
$global:newGameButton.Margin = '0,0,0,10'
[Windows.Controls.Grid]::SetRow($global:newGameButton, 0)
$windowgrid.Children.Add($global:newGameButton)

# Back Button
$global:backButton = New-Object Windows.Controls.Button
$global:backButton.Content = "Back"
$global:backButton.Height = 30
$global:backButton.Width = 100
$global:backButton.HorizontalAlignment = "Left"
$global:backButton.Margin = '0,0,0,10'
[Windows.Controls.Grid]::SetRow($global:backButton, 1)
$windowgrid.Children.Add($global:backButton)

# Reset stats Button
$global:resetStatsButton = New-Object Windows.Controls.Button
$global:resetStatsButton.Content = "Reset Stats"
$global:resetStatsButton.Height = 30
$global:resetStatsButton.Width = 100
$global:resetStatsButton.HorizontalAlignment = "Right"
$global:resetStatsButton.Margin = '0,0,0,10'
$global:resetStatsButton.Visibility = "Hidden"
[Windows.Controls.Grid]::SetRow($global:resetStatsButton, 0)
$windowgrid.Children.Add($global:resetStatsButton)

# stat1 Label
$global:stat1Label = New-Object Windows.Controls.TextBlock
$global:stat1Label.Text = "Fastest Reaction Time: $($global:fastestAimTime)`nFastest Average Time: $($global:totalAimTime)`nFastest Speedrun Time: $($global:speedAimTime)"
$global:stat1Label.HorizontalAlignment = "Left"
$global:stat1Label.Margin = '0,0,0,10'
$global:stat1Label.Visibility = "Hidden"
[Windows.Controls.Grid]::SetRow($global:stat1Label, 0)
$windowgrid.Children.Add($global:stat1Label)

# Button Click Events
$global:viewStatsButton.Add_Click({
    # Load the stats window
    $global:viewStatsButton.Visibility = "Hidden"
    $global:newGameButton.Visibility = "Hidden"

    $global:stat1Label.Visibility = "Visible"
    $global:resetStatsButton.Visibility = "Visible"
    [Windows.Controls.Grid]::SetRow($global:backButton, 2)
})
$global:newGameButton.Add_Click({
    # Load the aim trainer settings window
    $global:menuwindow.Close()
    .\bin\modules\aimtrainersettings.ps1
})
$global:backButton.Add_Click({
    if ($global:viewStatsButton.Visibility -eq "Visible") {
        $global:menuwindow.Close()
        Restart
    } else {
        $global:viewStatsButton.Visibility = "Visible"
        $global:newGameButton.Visibility = "Visible"
        $global:stat1Label.Visibility = "Hidden"
        $global:resetStatsButton.Visibility = "Hidden"
        [Windows.Controls.Grid]::SetRow($global:backButton, 1)
    }
})
$global:resetStatsButton.Add_Click({
    $yesno = [System.Windows.MessageBox]::Show("Are you sure you want to reset the stats?", "Reset Stats", [System.Windows.MessageBoxButton]::YesNo, [System.Windows.MessageBoxImage]::Warning)
    if ($yesno -eq [System.Windows.Forms.DialogResult]::Yes) {
        Remove-Item -Path ".\bin\aimtrainertimes.log" -Force
        New-Item -Path ".\bin\aimtrainertimes.log" -ItemType File -Force | Out-Null
        [System.Windows.MessageBox]::Show("Stats reset successfully!", "Reset Stats", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
        $global:menuwindow.Close()
        .\bin\cb2\aimtrainer.ps1
    }
})

$global:menuwindow.Content = $windowgrid
$global:menuwindow.ShowDialog()

Restart