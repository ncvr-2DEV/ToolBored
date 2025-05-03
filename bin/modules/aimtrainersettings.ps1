Add-Type -AssemblyName PresentationFramework

# Create Window
$window = New-Object Windows.Window
$window.Title = "ToolBored Aim Trainer Settings"
$window.Width = 400
$window.Height = 350
$window.ResizeMode = "NoResize"
$window.WindowStartupLocation = "CenterScreen"

# Main Grid
$grid = New-Object Windows.Controls.Grid
$grid.Margin = '10'

# Define Rows
for ($i = 0; $i -lt 6; $i++) {
    $row = New-Object Windows.Controls.RowDefinition
    $row.Height = "Auto"
    $grid.RowDefinitions.Add($row)
}
$lastRow = New-Object Windows.Controls.RowDefinition
$lastRow.Height = "*"
$grid.RowDefinitions.Add($lastRow)

### Speedrun Mode Checkbox
$speedrunPanel = New-Object Windows.Controls.StackPanel
$speedrunPanel.Margin = '0,0,0,10'
[Windows.Controls.Grid]::SetRow($speedrunPanel, 0)

$speedrunCheck = New-Object Windows.Controls.CheckBox
$speedrunCheck.Content = "Speedrun Mode"
$speedrunCheck.Margin = "0,0,0,10"
$speedrunPanel.Children.Add($speedrunCheck)

### Total Rounds
$roundsPanel = New-Object Windows.Controls.StackPanel
$roundsPanel.Margin = '0,0,0,10'
[Windows.Controls.Grid]::SetRow($roundsPanel, 1)

$roundsLabel = New-Object Windows.Controls.TextBlock
$roundsLabel.Text = "Total Rounds:"
$roundsLabel.FontWeight = "Bold"
$roundsPanel.Children.Add($roundsLabel)

$roundsSlider = New-Object Windows.Controls.Slider
$roundsSlider.Minimum = 5
$roundsSlider.Maximum = 100
$roundsSlider.Value = 10
$roundsSlider.TickFrequency = 5
$roundsSlider.IsSnapToTickEnabled = $true
$roundsPanel.Children.Add($roundsSlider)

$roundsValueText = New-Object Windows.Controls.TextBlock
$roundsValueText.Text = "10"
$roundsValueText.HorizontalAlignment = "Right"
$roundsPanel.Children.Add($roundsValueText)

### Window Size
$sizePanel = New-Object Windows.Controls.StackPanel
$sizePanel.Margin = '0,0,0,10'
[Windows.Controls.Grid]::SetRow($sizePanel, 2)

$sizeLabel = New-Object Windows.Controls.TextBlock
$sizeLabel.Text = "Window Size (px):"
$sizeLabel.FontWeight = "Bold"
$sizePanel.Children.Add($sizeLabel)

$sizeSlider = New-Object Windows.Controls.Slider
$sizeSlider.Minimum = 50
$sizeSlider.Maximum = 200
$sizeSlider.Value = 100
$sizeSlider.TickFrequency = 10
$sizeSlider.IsSnapToTickEnabled = $true
$sizePanel.Children.Add($sizeSlider)

$sizeValueText = New-Object Windows.Controls.TextBlock
$sizeValueText.Text = "100"
$sizeValueText.HorizontalAlignment = "Right"
$sizePanel.Children.Add($sizeValueText)

### Timing Mode
$timingPanel = New-Object Windows.Controls.StackPanel
$timingPanel.Margin = '0,0,0,10'
[Windows.Controls.Grid]::SetRow($timingPanel, 3)

$timingLabel = New-Object Windows.Controls.TextBlock
$timingLabel.Text = "Popup Timing Mode:"
$timingLabel.FontWeight = "Bold"
$timingPanel.Children.Add($timingLabel)

$timingButtons = New-Object Windows.Controls.StackPanel
$timingButtons.Orientation = "Horizontal"
$timingButtons.Margin = "5,5,0,0"

$instantRadio = New-Object Windows.Controls.RadioButton
$instantRadio.Content = "Instant"
$instantRadio.IsChecked = $true
$instantRadio.Margin = "0,0,10,0"

$randomRadio = New-Object Windows.Controls.RadioButton
$randomRadio.Content = "Random Delay"

$timingButtons.Children.Add($instantRadio)
$timingButtons.Children.Add($randomRadio)
$timingPanel.Children.Add($timingButtons)

### Activation Mode
$actvPanel = New-Object Windows.Controls.StackPanel
$actvPanel.Margin = '0,0,0,10'
[Windows.Controls.Grid]::SetRow($actvPanel, 4)

$actvLabel = New-Object Windows.Controls.TextBlock
$actvLabel.FontWeight = "Bold"
$actvLabel.Text = "Detection Mode:"
$actvPanel.Children.Add($actvLabel)

$actvButtons = New-Object Windows.Controls.StackPanel
$actvButtons.Orientation = "Horizontal"
$actvButtons.Margin = "5,5,0,0"

$hoverRadioactv = New-Object Windows.Controls.RadioButton
$hoverRadioactv.Content = "Mouse Hover"
$hoverRadioactv.IsChecked = $true
$hoverRadioactv.Margin = "0,0,10,0"

$clickRadioactv = New-Object Windows.Controls.RadioButton
$clickRadioactv.Content = "Mouse Click"

$actvButtons.Children.Add($hoverRadioactv)
$actvButtons.Children.Add($clickRadioactv)
$actvPanel.Children.Add($actvButtons)

### Start Button
$startButton = New-Object Windows.Controls.Button
$startButton.Content = "Start!"
$startButton.Height = 30
$startButton.Width = 100
$startButton.HorizontalAlignment = "Center"
$startButton.Margin = "0,10,0,0"
[Windows.Controls.Grid]::SetRow($startButton, 5)

# Add all to Grid
$grid.Children.Add($speedrunPanel)
$grid.Children.Add($roundsPanel)
$grid.Children.Add($sizePanel)
$grid.Children.Add($timingPanel)
$grid.Children.Add($actvPanel)
$grid.Children.Add($startButton)

# Update value labels live
$roundsSlider.Add_ValueChanged({
    $roundsValueText.Text = [math]::Round($roundsSlider.Value)
})
$sizeSlider.Add_ValueChanged({
    $sizeValueText.Text = [math]::Round($sizeSlider.Value)
})

# Logic for Speedrun Mode: Disable all settings except the speedrun checkbox
$speedrunCheck.Add_Checked({
    $roundsSlider.IsEnabled = $false
    $sizeSlider.IsEnabled = $false
    $instantRadio.IsEnabled = $false
    $randomRadio.IsEnabled = $false
    $actvButtons.IsEnabled = $false
    $roundsValueText.Visibility = "Collapsed"
    $sizeValueText.Visibility = "Collapsed"
})
$speedrunCheck.Add_Unchecked({
    $roundsSlider.IsEnabled = $true
    $sizeSlider.IsEnabled = $true
    $instantRadio.IsEnabled = $true
    $randomRadio.IsEnabled = $true
    $actvButtons.IsEnabled = $true
    $roundsValueText.Visibility = "Visible"
    $sizeValueText.Visibility = "Visible"
})

# Start Button Click Event
$startButton.Add_Click({
    $global:settings = [PSCustomObject]@{
        SpeedrunMode = $speedrunCheck.IsChecked
        TotalRounds = if ($speedrunCheck.IsChecked) { "N/A" } else { [math]::Round($roundsSlider.Value) }
        WindowSize = [math]::Round($sizeSlider.Value)
        TimingMode = if ($speedrunCheck.IsChecked) { "N/A" } else { if ($instantRadio.IsChecked) { "Instant" } else { "Random" }}
        ActivationMode = if ($hoverRadioactv.IsChecked) { "MouseHover" } else { "MouseClick" }
    }

    $window.Close()
    
    # Start the aim trainer engine with the settings
    .\bin\modules\aimtrainerengine.ps1 -Settings $global:settings | Out-Null
})

# Assign content and show window
$window.Content = $grid
$window.ShowDialog() | Out-Null

Restart