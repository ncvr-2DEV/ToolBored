Add-Type -AssemblyName PresentationCore, PresentationFramework, WindowsBase

# Create the window
$window = New-Object System.Windows.Window
$window.Title = "ToolBored $($global:appversionid) - [GUI - $($Global:comstatDirectX)]"
$window.Width = 1000
$window.Height = 700
$window.WindowStartupLocation = "CenterScreen"

# StackPanel for layout
$panel = New-Object System.Windows.Controls.StackPanel
$panel.Margin = [System.Windows.Thickness]::new(10)
$window.Content = $panel

# Label: prompt
$label = New-Object System.Windows.Controls.Label
$label.Content = "Select a module:"
$panel.Children.Add($label)

# Module SP
$moduleSP = New-Object System.Windows.Controls.StackPanel
$moduleSP.Margin = [System.Windows.Thickness]::new(10)
$moduleSP.Orientation = "Horizontal"
$panel.Children.Add($moduleSP)

# ComboBox: module list
$comboBox = New-Object System.Windows.Controls.ComboBox
@(
    "mousejiggle",
    "randomsound",
    "fakehack",
    "foldermaze",
    "textglitcher",
    "schooltimer",
    "quoteofday",
     "flashcard",
     "aimtrainer"
) | ForEach-Object {
    $comboBox.Items.Add($_) | Out-Null
}
$comboBox.Width = 250
$comboBox.Height = 50
$moduleSP.Children.Add($comboBox)

# Button: submit
$button = New-Object System.Windows.Controls.Button
$button.Content = "Start extension"
$button.Width = 250
$button.Height = 50
$button.Margin = [System.Windows.Thickness]::new(10, 0, 0, 0)
$moduleSP.Children.Add($button)

# Update button
$updatebutton = New-Object System.Windows.Controls.Button
$updatebutton.Content = "Update ToolBored"
$updatebutton.Width = 150
$updatebutton.Height = 30
$updatebutton.VerticalAlignment = "Bottom"
$updatebutton.HorizontalAlignment = "Left"
$updatebutton.Margin = [System.Windows.Thickness]::new(0, 460, 0, 0)
$panel.Children.Add($updatebutton)

# Exit button
$exitbutton = New-Object System.Windows.Controls.Button
$exitbutton.Content = "Exit"
$exitbutton.Width = 150
$exitbutton.Height = 30
$exitbutton.VerticalAlignment = "Bottom"
$exitbutton.HorizontalAlignment = "Left"
$exitbutton.Margin = [System.Windows.Thickness]::new(0, 10, 0, 0)
$panel.Children.Add($exitbutton)
$exitbutton.Add_Click({
    $window.Close()
    Stop-Process -Id $PID
})

# Variable to capture selected module
$script:SelectedModule = $null

# Click handler
$button.Add_Click({
    if ($comboBox.SelectedItem) {
        $script:SelectedModule = $comboBox.SelectedItem.ToString()
    }
    $window.Close()
})

$updatebutton.Add_Click({
    $window.Close()
    .\update.ps1
})

# Show the window (blocking)
$null = $window.ShowDialog()

# Output result
if ($SelectedModule) {
    Write-Host "Selected Module: $SelectedModule" -ForegroundColor Green
    Start-Sleep -Milliseconds 500
    .\bin\selector.ps1 -Module $SelectedModule
} else {
    Write-Host "No module selected." -ForegroundColor Yellow
    Restart
}
