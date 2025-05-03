# This is the setup for the installer. It sets the parameters for the installation process.

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

# Set Vars
$global:license = Get-Content -Path ".\license.txt" -Raw

if ($license -eq $null) {
    Write-Host "Error: License file not found."
    [System.Windows.Forms.MessageBox]::Show("License file not found.`n(Did you start this from bin or from install.cmd?)", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    exit 1
}

# Main Window
$global:Window = New-Object System.Windows.Window
$global:Window.Title = "Loading..."
$global:Window.Width = 600
$global:Window.Height = 400
$global:Window.WindowStartupLocation = "CenterScreen"

$global:grid = New-Object Windows.Controls.Grid
$global:grid.Margin = '10'

for ($i = 0; $i -lt 6; $i++) {
    $global:row = New-Object Windows.Controls.RowDefinition

    if ($i -eq 1) {
        # Let ULA occupy remaining space
        $global:row.Height = "*"
    } else {
        # Fixed height for others
        $global:row.Height = "Auto"
    }

    $global:grid.RowDefinitions.Add($global:row)
}


### Select Language
$global:langDropDown = New-Object Windows.Controls.ComboBox
@(
    "English"
) | ForEach-Object {
    $global:langDropDown.Items.Add($_) | Out-Null
}
$global:grid.Children.Add($global:langDropDown)
[Windows.Controls.Grid]::SetRow($global:langDropDown, 0)
$global:langDropDown.Margin = '0,10,0,0'
$global:langDropDown.Height = 30
$global:langDropDown.Visibility = "Hidden"
$global:langDropDown.VerticalAlignment = "Top"



### ULA

# ULA TextBox
$global:ulaTextBox = New-Object Windows.Controls.TextBox
$global:ulaTextBox.Text = "User License Agreement (ULA)`n`n`n$($global:license)"
$global:ulaTextBox.IsReadOnly = $true
$global:ulaTextBox.TextWrapping = "Wrap"
$global:ulaTextBox.FontSize = 12
$global:ulaTextBox.FontWeight = "Bold"
$global:ulaTextBox.Height = 200
$global:ulaTextBoxSV = New-Object Windows.Controls.ScrollViewer
$global:ulaTextBoxSV.Visibility = "Hidden"
$global:ulaTextBoxSV.Content = $global:ulaTextBox
$global:grid.Children.Add($global:ulaTextBoxSV)
$global:ulaTextBoxSV.Margin = '0,10,0,0'
[Windows.Controls.Grid]::SetRow($global:ulaTextBoxSV, 0)

## ULA RadioButtons
$global:ulaButtonSP = New-Object Windows.Controls.StackPanel
$global:ulaButtonSP.Visibility = "Hidden"
$global:ulaButtonSP.Margin = '0,10,0,0'
[Windows.Controls.Grid]::SetRow($global:ulaButtonSP, 2)

# ULA RadioButton 1
$global:ulaAccept = New-Object Windows.Controls.RadioButton
$global:ulaAccept.Content = "I accept the ULA"
$global:ulaAccept.IsChecked = $false
$global:ulaAccept.Margin = "0,0,10,0"

# ULA RadioButton 2
$global:ulaDecline = New-Object Windows.Controls.RadioButton
$global:ulaDecline.Content = "I do not accept the ULA"
$global:ulaDecline.IsChecked = $true
$global:ulaDecline.Margin = "0,0,10,0"

# Compile ULA RadioButtons
$global:ulaButtonSP.Children.Add($global:ulaAccept)
$global:ulaButtonSP.Children.Add($global:ulaDecline)
$global:grid.Children.Add($global:ulaButtonSP)
$global:ulaButtonSP.SetValue([Windows.Controls.Grid]::RowProperty, 1)



### Folder Selection
$global:folderSP = New-Object Windows.Controls.StackPanel
$global:folderSP.Visibility = "Hidden"
$global:folderSP.Orientation = "Horizontal"
$global:folderSP.Margin = '0,10,0,10'
[Windows.Controls.Grid]::SetRow($global:folderSP, 1)

# Folder Selection Label
$global:folderLabel = New-Object Windows.Controls.TextBlock
$global:folderLabel.Text = "Select installation folder:"
$global:folderLabel.Visibility = "Hidden"
$global:folderLabel.FontWeight = "Bold"
$global:folderLabel.Margin = "0,0,0,10"
$global:folderLabel.Height = 30
$global:folderLabel.VerticalAlignment = "Bottom"
$global:grid.Children.Add($global:folderLabel)  
[Windows.Controls.Grid]::SetRow($global:folderLabel, 0)

# Folder Path TextBox
$global:folderPath = New-Object Windows.Controls.TextBox
$global:folderPath.Text = "$($env:LOCALAPPDATA)\Programs"
$global:folderPath.Height = 30
$global:folderPath.Width = 400
$global:folderPath.Margin = "0,0,10,0"
$global:folderPath.VerticalAlignment = "Top"

# Folder Path Dialog
$global:folderDialog = New-Object Windows.Controls.Button
$global:folderDialog.Content = "Browse..."
$global:folderDialog.Margin = "0,0,0,10"
$global:folderDialog.Width = 100
$global:folderDialog.Height = 30
$global:folderDialog.VerticalAlignment = "Top"

# Compile Folder Selection
$global:folderSP.Children.Add($global:folderPath)
$global:folderSP.Children.Add($global:folderDialog)
$global:grid.Children.Add($global:folderSP)



### Version Selection

# Version Selection Label
$global:versionLabel = New-Object Windows.Controls.TextBlock
$global:versionLabel.Text = "Select version:"
$global:versionLabel.FontWeight = "Bold"
$global:versionLabel.Margin = "0,0,0,10"
$global:versionLabel.Height = 30
$global:versionLabel.VerticalAlignment = "Bottom"
$global:versionLabel.SetValue([Windows.Controls.Grid]::RowProperty, 0)
$global:versionLabel.Visibility = "Hidden"
$global:grid.Children.Add($global:versionLabel)

# Version Selection ComboBox
$global:versionSelectDropDown = New-Object Windows.Controls.ComboBox
@(
    "Stable Install - Use the most reliable version.", "Beta Version - Use the most recent updates.", "SmoothGUI-Beta - Use the SmoothGUI version. (Experimental)"
) | ForEach-Object {
    $global:versionSelectDropDown.Items.Add($_) | Out-Null
}
$global:versionSelectDropDown.Visibility = "Hidden"
$global:versionSelectDropDown.Margin = '0,10,0,0'
$global:versionSelectDropDown.Height = 30
$global:versionSelectDropDown.VerticalAlignment = "Top"
$global:versionSelectDropDown.SelectedIndex = 0
$global:grid.Children.Add($global:versionSelectDropDown)
$global:versionSelectDropDown.SetValue([Windows.Controls.Grid]::RowProperty, 1)



### StackPanel for extra options
$global:extraOptionsSP = New-Object Windows.Controls.StackPanel
$global:extraOptionsSP.Orientation = "Vertical"
$global:extraOptionsSP.Visibility = "Hidden"
$global:extraOptionsSP.Margin = '0,10,0,0'
$global:extraOptionsSP.SetValue([Windows.Controls.Grid]::RowProperty, 1)
$global:extraOptionsSP.HorizontalAlignment = "Left"
$global:grid.Children.Add($global:extraOptionsSP)

# Checkbox 1 - Desktop Shortcut
$global:desktopShortcut = New-Object Windows.Controls.CheckBox
$global:desktopShortcut.Content = "Create a desktop shortcut"
$global:desktopShortcut.Margin = "0,0,0,10"
$global:desktopShortcut.IsChecked = $true
$global:extraOptionsSP.Children.Add($global:desktopShortcut)

# Checkbox 2 - Start Menu Shortcut
$global:startMenuShortcut = New-Object Windows.Controls.CheckBox
$global:startMenuShortcut.Content = "Create a Start Menu shortcut"
$global:startMenuShortcut.Margin = "0,0,0,10"
$global:startMenuShortcut.IsChecked = $true
$global:extraOptionsSP.Children.Add($global:startMenuShortcut)

# Checkbox 3 - Start after install
$global:startAfterInstall = New-Object Windows.Controls.CheckBox
$global:startAfterInstall.Content = "Start ToolBored after installation"
$global:startAfterInstall.Margin = "0,0,0,10"
$global:startAfterInstall.IsChecked = $true
$global:extraOptionsSP.Children.Add($global:startAfterInstall)



### Install Button

# Install Button Label
$global:installLabel = New-Object Windows.Controls.TextBlock
$global:installLabel.Text = "Confirm installation:`n`n`nInstallation Path: $($global:folderPath.Text)`nVersion: $($global:versionSelectDropDown.SelectedItem)`n`nClick Install to proceed."
$global:installLabel.FontWeight = "Bold"
$global:installLabel.Margin = "0,10,0,10"
$global:installLabel.Visibility = "Hidden"
$global:installLabel.SetValue([Windows.Controls.Grid]::RowProperty, 0)
$global:installLabel.HorizontalAlignment = "Left"

$global:grid.Children.Add($global:installLabel)



### Buttons

# StackPanel for buttons
$global:buttonSP = New-Object Windows.Controls.StackPanel
$global:buttonSP.Orientation = "Horizontal"
$global:buttonSP.Margin = '0,10,0,0'
$global:buttonSP.SetValue([Windows.Controls.Grid]::RowProperty, 3)

# Next Button
$global:nextButton = New-Object Windows.Controls.Button
$global:nextButton.Content = "Next -->"
$global:nextButton.Margin = '0,10,0,0'
$global:nextButton.Width = 100
$global:nextButton.Height = 30
$global:nextButton.IsEnabled = $false

# Back Button
$global:backButton = New-Object Windows.Controls.Button
$global:backButton.Content = "Exit"
$global:backButton.Margin = '0,10,0,0'
$global:backButton.Width = 100
$global:backButton.Height = 30

# Compile Buttons
$global:buttonSP.Children.Add($global:backButton)
$global:buttonSP.Children.Add($global:nextButton)
$global:grid.Children.Add($global:buttonSP)



### Exit Label
$global:exitLabel = New-Object Windows.Controls.TextBlock
$global:exitLabel.Text = "Install was canceled..."
$global:exitLabel.FontWeight = "Bold"
$global:exitLabel.Margin = "0,10,0,0"
$global:exitLabel.Visibility = "Hidden"
$global:exitLabel.FontSize = 20
$global:exitLabel.HorizontalAlignment = "Center"
$global:exitLabel.VerticalAlignment = "Center"
$global:grid.Children.Add($global:exitLabel)
[Windows.Controls.Grid]::SetRow($global:exitLabel, 0)



## Button Events

# Next Button Click Event
$global:nextButton.Add_Click({
    if ($global:langDropDown.Visibility -eq "Visible") {
        $global:langDropDown.Visibility = "Hidden"
        $global:ulaTextBoxSV.Visibility = "Visible"
        $global:ulaButtonSP.Visibility = "Visible"
        $global:backButton.Content = "<-- Back"
        $global:nextButton.IsEnabled = $false
        $global:ulaAccept.IsChecked = $false
        $global:ulaDecline.IsChecked = $true
    } elseif ($global:ulaTextBoxSV.Visibility -eq "Visible") {
        $global:ulaTextBoxSV.Visibility = "Hidden"
        $global:ulaButtonSP.Visibility = "Hidden"
        $global:folderSP.Visibility = "Visible"
        $global:folderLabel.Visibility = "Visible"
    } elseif ($global:folderSP.Visibility -eq "Visible") {
        $folderconfirm = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to install ToolBored to $($global:folderPath.Text)\ToolBored?", "Confirm Installation", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question)
        if ($folderconfirm -eq [System.Windows.Forms.DialogResult]::Yes -and (Test-Path "$($global:folderPath.Text)")) {
            $global:folderSP.Visibility = "Hidden"
            $global:folderLabel.Visibility = "Hidden"
            $global:versionLabel.Visibility = "Visible"
            $global:versionSelectDropDown.Visibility = "Visible"
        } else {
            [System.Windows.Forms.MessageBox]::Show("Please select a valid installation folder.", "Invalid Folder", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        }
    } elseif ($global:versionSelectDropDown.Visibility -eq "Visible") {
        $global:versionSelectDropDown.Visibility = "Hidden"
        $global:versionLabel.Visibility = "Hidden"
        $global:installLabel.Visibility = "Visible"
        $global:extraOptionsSP.Visibility = "Visible"
        $global:nextButton.Content = "Install"
    } elseif ($global:installLabel.Visibility -eq "Visible") {
        # Correct Variables
        if ($global:versionSelectDropDown.SelectedIndex -eq 0) {
            $global:Version = "Stable"
        } elseif ($global:versionSelectDropDown.SelectedIndex -eq 1) {
            $global:Version = "Beta"
        } elseif ($global:versionSelectDropDown.SelectedIndex -eq 2) {
            $global:Version = "SmoothGUI-Beta"
        }
        $global:Path = "$($global:folderPath.Text)\ToolBored"
        # Call the installation script here
        Start-Process -FilePath "powershell.exe" -ArgumentList @(
            "-ExecutionPolicy", "Bypass",
            "-NoProfile",
            "-File", ".\bin\initiate.ps1",
            "-Path", "`"$($global:Path)`"",
            "-Version", "`"$($global:Version)`"",
            "-License", "$($global:ulaAccept.IsChecked)"
            "-DS", "$($global:desktopShortcut.IsChecked)",
            "-SM", "$($global:startMenuShortcut.IsChecked)",
            "-Start", "$($global:startAfterInstall.IsChecked)"
        )
        $exit = $true
        $global:Window.Close()
    }
})

# Back Button Click Event
$global:backButton.Add_Click({
    if ($global:langDropDown.Visibility -eq "Visible") {
        Stop-Process -Id $PID
    } elseif ($global:ulaTextBoxSV.Visibility -eq "Visible") {
        $global:ulaTextBoxSV.Visibility = "Hidden"
        $global:ulaButtonSP.Visibility = "Hidden"
        $global:langDropDown.Visibility = "Visible"
        $global:backButton.Content = "Exit"
        $global:nextButton.IsEnabled = $true
    } elseif ($global:folderSP.Visibility -eq "Visible") {
        $global:folderSP.Visibility = "Hidden"
        $global:folderLabel.Visibility = "Hidden"
        $global:ulaTextBoxSV.Visibility = "Visible"
        $global:ulaButtonSP.Visibility = "Visible"
    } elseif ($global:versionSelectDropDown.Visibility -eq "Visible") {
        $global:versionSelectDropDown.Visibility = "Hidden"
        $global:versionLabel.Visibility = "Hidden"
        $global:folderSP.Visibility = "Visible"
        $global:folderLabel.Visibility = "Visible"
    } elseif ($global:installLabel.Visibility -eq "Visible") {
        $global:installLabel.Visibility = "Hidden"
        $global:extraOptionsSP.Visibility = "Hidden"
        $global:versionSelectDropDown.Visibility = "Visible"
        $global:versionLabel.Visibility = "Visible"
        $global:nextButton.Content = "Next -->"
    }
})

# Language Selection Event
$global:langDropDown.Add_SelectionChanged({
    if ($global:langDropDown.SelectedItem -eq "English") {
        $global:nextButton.IsEnabled = $true
    } else {
        $global:nextButton.IsEnabled = $false
    }
})

# ULA RadioButton Click Events
$global:ulaAccept.Add_Checked({
    if ($global:ulaAccept.IsChecked) {
        $global:nextButton.IsEnabled = $true
    }
})
$global:ulaDecline.Add_Checked({
    $global:nextButton.IsEnabled = $false
})

# Folder Path Dialog Click Event
$global:folderDialog.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Select installation folder:"
    $folderBrowser.ShowNewFolderButton = $true
    $folderBrowser.SelectedPath = $global:folderPath.Text

    if ($folderBrowser.ShowDialog() -eq "OK") {
        $global:folderPath.Text = $folderBrowser.SelectedPath
    }
})

# Window Opening Event
$global:Window.Add_Loaded({
    Start-Sleep -Seconds 2
    $global:Window.Title = "ToolBored Installer"
    $global:langDropDown.Visibility = "Visible"
})

# Window closing event
$global:Window.Add_Closing({
    if ($exit) {
        Start-Sleep -Seconds 1
        return
    }
    # Ask the user for confirmation before closing
    $result = [System.Windows.MessageBox]::Show("Are you sure you want to exit?", "Exit Confirmation", [System.Windows.MessageBoxButton]::YesNo, [System.Windows.MessageBoxImage]::Warning)

    if ($result -eq [System.Windows.MessageBoxResult]::Yes) {
        # Make exitLabel visible
        $global:nextButton.Visibility = "Hidden"
        $global:backButton.Visibility = "Hidden"
        $global:folderSP.Visibility = "Hidden"
        $global:folderLabel.Visibility = "Hidden"
        $global:versionLabel.Visibility = "Hidden"
        $global:versionSelectDropDown.Visibility = "Hidden"
        $global:ulaTextBoxSV.Visibility = "Hidden"
        $global:ulaButtonSP.Visibility = "Hidden"
        $global:installLabel.Visibility = "Hidden"
        $global:langDropDown.Visibility = "Hidden"
        $global:extraOptionsSP.Visibility = "Hidden"
        $global:exitLabel.Visibility = "Visible"
        $global:Window.WindowStyle = "None"

        $_.Cancel = $true

        # Use DispatcherTimer to delay further, then close the window gracefully
        $global:exitTimer = New-Object System.Windows.Threading.DispatcherTimer
        $global:exitTimer.Interval = [System.TimeSpan]::FromSeconds(2)
        $global:exitTimer.add_Tick({
            $global:exitTimer.Stop()
            # Now close the process gracefully
            Stop-Process -Id $PID
    })
    $global:exitTimer.Start()

    } else {
        $_.Cancel = $true
    }
})




### Compile Window
$global:Window.Content = $global:grid
$global:Window.showDialog()