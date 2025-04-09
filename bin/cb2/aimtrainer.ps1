Add-Type -AssemblyName PresentationFramework

# Create Window
$window = New-Object System.Windows.Window
$window.Title = "ToolBored Aim Trainer"
$window.Width = 1000
$window.Height = 700
$window.WindowStartupLocation = "CenterScreen"

# Main Grid
$windowgrid = New-Object Windows.Controls.Grid
$windowgrid.Margin = '10'

for ($i = 0; $i -lt 6; $i++) {
    $row = New-Object Windows.Controls.RowDefinition
    $row.Height = "Auto"
    $windowgrid.RowDefinitions.Add($row)
}

# View Stats Button
$viewStatsButton = New-Object Windows.Controls.Button
$viewStatsButton.Content = "View Stats"
$viewStatsButton.Height = 30
$viewStatsButton.Width = 100
$viewStatsButton.HorizontalAlignment = "Left"
$viewStatsButton.Margin = '0,0,0,10'
[Windows.Controls.Grid]::SetRow($viewStatsButton, 0)
$windowgrid.Children.Add($viewStatsButton)
### Adding a click event to the button to show stats
###
###                                                    ###############################################
# Set settings for the aim trainer
.\bin\modules\aimtrainersettings.ps1