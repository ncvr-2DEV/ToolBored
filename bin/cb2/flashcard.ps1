Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName Microsoft.VisualBasic



### Vars

# Presets
$presetPath = ".\presets"

# Make sure folder exists
if (-not (Test-Path $presetPath)) {
    New-Item -ItemType Directory -Path $presetPath | Out-Null
}



### Window Creation
$global:Window = New-Object System.Windows.Window
$global:Window.Title = "ToolBored $($global:appversionid) Flashcard Module"
$global:Window.Width = 1000
$global:Window.Height = 700
$global:Window.ResizeMode = "NoResize"
$global:Window.WindowStartupLocation = "CenterScreen"

$global:grid = New-Object Windows.Controls.Grid
$global:grid.Margin = '10'

for ($i = 0; $i -lt 6; $i++) {
    $global:row = New-Object Windows.Controls.RowDefinition
    $global:row.Height = "Auto"
    $global:grid.RowDefinitions.Add($global:row)
}



### Componets

# Preset Selector
$global:presetDropDown = New-Object System.Windows.Controls.ComboBox
$global:presetDropDown.Margin = '0,10,0,0'
$global:presetDropDown.Height = 30
$global:presetDropDown.VerticalAlignment = "Top"
Get-ChildItem -Path $presetPath -Filter *.json | ForEach-Object {
    $global:presetDropDown.Items.Add($_.BaseName)
}
$global:grid.Children.Add($global:presetDropDown)
[Windows.Controls.Grid]::SetRow($global:presetDropDown, 1)


## Buttons SP
$global:buttonSP = New-Object Windows.Controls.StackPanel
$global:buttonSP.Margin = "0,10,0,0"
$global:grid.Children.Add($global:buttonSP)
[Windows.Controls.Grid]::SetRow($global:buttonSP, 2)
$global:buttonSP1 = New-Object Windows.Controls.StackPanel
$global:buttonSP1.Orientation = "Horizontal"
$global:buttonSP1.Margin = "0,10,0,0"
$global:buttonSP.Children.Add($global:buttonSP1)
$global:buttonSP2 = New-Object Windows.Controls.StackPanel
$global:buttonSP2.Orientation = "Horizontal"
$global:buttonSP2.Margin = "0,10,0,0"
$global:buttonSP.Children.Add($global:buttonSP2)

# Edit Button
$global:EditButton = New-Object Windows.Controls.Button
$global:EditButton.Content = "Open in Editor..."
$global:EditButton.Margin = "10,0,0,0"
$global:EditButton.Height = 30
$global:EditButton.Width = 100
$global:EditButton.HorizontalAlignment = "Left"
$global:buttonSP1.Children.Add($global:EditButton)

# Open Button
$global:OpenButton = New-Object Windows.Controls.Button
$global:OpenButton.Content = "Run..."
$global:OpenButton.Margin = "10,0,0,0"
$global:OpenButton.Height = 30
$global:OpenButton.Width = 100
$global:OpenButton.HorizontalAlignment = "Left"
$global:buttonSP1.Children.Add($global:OpenButton)

# Rename Button
$global:RenameButton = New-Object Windows.Controls.Button
$global:RenameButton.Content = "Rename..."
$global:RenameButton.Margin = "10,0,0,0"
$global:RenameButton.Height = 30
$global:RenameButton.Width = 100
$global:RenameButton.HorizontalAlignment = "Left"
$global:buttonSP2.Children.Add($global:RenameButton)

# Open Folder Button
$global:OpenFolderButton = New-Object Windows.Controls.Button
$global:OpenFolderButton.Content = "Open Folder..."
$global:OpenFolderButton.Margin = "10,0,0,0"
$global:OpenFolderButton.Height = 30
$global:OpenFolderButton.Width = 100
$global:OpenFolderButton.HorizontalAlignment = "Left"
$global:buttonSP2.Children.Add($global:OpenFolderButton)

# Delete Button
$global:DeleteButton = New-Object Windows.Controls.Button
$global:DeleteButton.Content = "Delete..."
$global:DeleteButton.Margin = "10,10,0,0"
$global:DeleteButton.Height = 30
$global:DeleteButton.Width = 210
$global:DeleteButton.HorizontalAlignment = "Left"
$global:buttonSP.Children.Add($global:DeleteButton)

# Create Button
$global:CreateButton = New-Object Windows.Controls.Button
$global:CreateButton.Content = "Create New..."
$global:CreateButton.Margin = "10,10,0,0"
$global:CreateButton.Height = 30
$global:CreateButton.Width = 210
$global:CreateButton.HorizontalAlignment = "Left"
$global:buttonSP.Children.Add($global:CreateButton)


# CodeBox
$global:CodeBox = New-Object System.Windows.Controls.TextBox
$global:CodeBox.Margin = '0,10,0,0'
$global:CodeBox.Height = 590
$global:CodeBox.VerticalAlignment = "Top"
$global:CodeBox.HorizontalAlignment = "Right"
$global:CodeBox.Width = 710
$global:CodeBox.AcceptsReturn = $true
$global:CodeBox.Text = ""
$global:grid.Children.Add($global:CodeBox)
[Windows.Controls.Grid]::SetRow($global:CodeBox, 2)


# Back Button
$global:BackButton = New-Object Windows.Controls.Button
$global:BackButton.Content = "Back"
$global:BackButton.Height = 30
$global:BackButton.Width = 100
$global:BackButton.HorizontalAlignment = "Left"
$global:BackButton.VerticalAlignment = "Bottom"
$global:BackButton.Margin = '10,10,0,0'
$global:grid.Children.Add($global:BackButton)
[Windows.Controls.Grid]::SetRow($global:BackButton, 2)

# Save Button
$global:SaveButton = New-Object Windows.Controls.Button
$global:SaveButton.Content = "Save"
$global:SaveButton.Height = 30
$global:SaveButton.Width = 100
$global:SaveButton.HorizontalAlignment = "Left"
$global:SaveButton.VerticalAlignment = "Bottom"
$global:SaveButton.Margin = '120,10,0,0'
$global:grid.Children.Add($global:SaveButton)
[Windows.Controls.Grid]::SetRow($global:SaveButton, 2)



### Button Click Events

# Edit Button Click
$global:EditButton.Add_Click({
    $presetName = $global:presetDropDown.SelectedItem
    if ($presetName) {
        $global:CodeBox.Text = Get-Content -Path "$presetPath\$presetName.json" -Raw
    } else {
        [System.Windows.MessageBox]::Show("Please select a preset to edit.")
    }
})

# Rename Button Click
$global:RenameButton.Add_Click({
    $presetName = $global:presetDropDown.SelectedItem
    if ($presetName) {
        $newName = [Microsoft.VisualBasic.Interaction]::InputBox(
            "Enter new name for the preset:", 
            "Rename Preset", 
            $presetName
        )
        if ($newName -and $newName -ne $presetName) {
            Rename-Item -Path "$presetPath\$presetName.json" -NewName "$newName.json"
            $global:presetDropDown.Items.Clear()
            Get-ChildItem -Path $presetPath -Filter *.json | ForEach-Object {
                $global:presetDropDown.Items.Add($_.BaseName)
            }
        }
    } else {
        [System.Windows.MessageBox]::Show("Please select a preset to rename.")
    }
})

# Open Folder Button Click
$global:OpenFolderButton.Add_Click({
    Start-Process -FilePath "explorer.exe" -ArgumentList "$presetPath"
})

# Delete Button Click
$global:DeleteButton.Add_Click({
    $presetName = $global:presetDropDown.SelectedItem
    if ($presetName) {
        $confirmation = [System.Windows.MessageBox]::Show(
            "Are you sure you want to delete the preset '$presetName'?",
            "Delete Confirmation",
            [System.Windows.MessageBoxButton]::YesNo,
            [System.Windows.MessageBoxImage]::Warning
        )
        if ($confirmation -eq [System.Windows.MessageBoxResult]::Yes) {
            Remove-Item -Path "$presetPath\$presetName.json"
            $global:presetDropDown.Items.Remove($presetName)
            $global:CodeBox.Text = ""
        }
    } else {
        [System.Windows.MessageBox]::Show("Please select a preset to delete.")
    }
})

# Create Button Click
$global:CreateButton.Add_Click({
    .\bin\modules\newflashcard.ps1
    $global:presetDropDown.Items.Clear()
    Get-ChildItem -Path $presetPath -Filter *.json | ForEach-Object {
        $global:presetDropDown.Items.Add($_.BaseName)
    }
})

# Back Button Click
$global:BackButton.Add_Click({
    $global:Window.Close()
})

# Save Button Click
$global:SaveButton.Add_Click({
    $presetName = $global:presetDropDown.SelectedItem
    if ($presetName) {
        Set-Content -Path "$presetPath\$presetName.json" -Value $global:CodeBox.Text
        [System.Windows.MessageBox]::Show("Preset '$presetName' saved successfully.")
    } else {
        [System.Windows.MessageBox]::Show("Please select a preset to save.")
    }
})

# Open Button Click
$global:OpenButton.Add_Click({
    $presetName = $global:presetDropDown.SelectedItem
    if ($presetName) {
        $global:Window.Close()
        .\bin\modules\flashcard.ps1 "$presetName"
    } else {
        [System.Windows.MessageBox]::Show("Please select a preset to run.")
    }
})



### Compile Window
$global:Window.Content = $global:grid
$global:Window.showDialog()
Restart