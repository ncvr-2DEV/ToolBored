Add-Type -AssemblyName PresentationCore, PresentationFramework, WindowsBase

# Create the window
$window = New-Object System.Windows.Window
$window.Title = "Tool Bored v0.01-preview - [$($Global:UiType)- $($Global:comstatDirectX)]"
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

# ComboBox: module list
$comboBox = New-Object System.Windows.Controls.ComboBox
@(
    "mousejiggle", "randomsound", "fakehack", "notepadbomb",
    "foldermaze", "textglitcher", "schooltimer", "quoteofday",
    "noclip", "noteself", "aimtrainer", "exit"
) | ForEach-Object {
    $comboBox.Items.Add($_) | Out-Null
}
$panel.Children.Add($comboBox)

# Button: submit
$button = New-Object System.Windows.Controls.Button
$button.Content = "Start extension"
$button.Margin = [System.Windows.Thickness]::new(0, 10, 0, 0)
$panel.Children.Add($button)

# Variable to capture selected module
$script:SelectedModule = $null

# Click handler
$button.Add_Click({
    if ($comboBox.SelectedItem) {
        $script:SelectedModule = $comboBox.SelectedItem.ToString()
    }
    $window.Close()
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
    Stop-Process -Id $PID
}
