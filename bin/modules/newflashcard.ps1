Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName PresentationFramework

$global:nfwindow = New-Object System.Windows.Window
$global:nfwindow.Title = "ToolBored $($global:appversionid) - Flashcard Module"
$global:nfwindow.Width = 500
$global:nfwindow.Height = 500
$global:nfwindow.WindowStartupLocation = "CenterScreen" 
$global:nfwindow.ResizeMode = "NoResize"

$global:nfgrid = New-Object Windows.Controls.Grid
$global:nfgrid.Margin = '10'

for ($i = 0; $i -lt 6; $i++) {
    $global:nfrow = New-Object Windows.Controls.RowDefinition
    $global:nfrow.Height = "Auto"
    $global:nfgrid.RowDefinitions.Add($global:nfrow)
}

# Name Label
$global:nfname = New-Object System.Windows.Controls.TextBlock
$global:nfname.Text = "Name: "
$global:nfname.Margin = '0,10,0,0'
$global:nfname.VerticalAlignment = "Top"
$global:nfgrid.Children.Add($global:nfname)
[Windows.Controls.Grid]::SetRow($global:nfname, 0)

# Name TextBox
$global:nfnameBox = New-Object System.Windows.Controls.TextBox
$global:nfnameBox.Margin = '0,10,0,0'
$global:nfnameBox.VerticalAlignment = "Top"
$global:nfnameBox.Width = 200
$global:nfgrid.Children.Add($global:nfnameBox)
[Windows.Controls.Grid]::SetRow($global:nfnameBox, 1)

# Authors Label
$global:nfauthors = New-Object System.Windows.Controls.TextBlock
$global:nfauthors.Text = "Authors: "
$global:nfauthors.Margin = '0,10,0,0'
$global:nfauthors.VerticalAlignment = "Top"
$global:nfgrid.Children.Add($global:nfauthors)
[Windows.Controls.Grid]::SetRow($global:nfauthors, 2)

# Authors TextBox
$global:nfauthorsBox = New-Object System.Windows.Controls.TextBox
$global:nfauthorsBox.Margin = '0,10,0,0'
$global:nfauthorsBox.VerticalAlignment = "Top"
$global:nfauthorsBox.Width = 200
$global:nfgrid.Children.Add($global:nfauthorsBox)
[Windows.Controls.Grid]::SetRow($global:nfauthorsBox, 3)

# Question Label
$global:nfquestion = New-Object System.Windows.Controls.TextBlock
$global:nfquestion.Text = "Questions and answers: (one per line, alternating question and answer)"
$global:nfquestion.Margin = '0,10,0,0'
$global:nfquestion.VerticalAlignment = "Top"
$global:nfgrid.Children.Add($global:nfquestion)
[Windows.Controls.Grid]::SetRow($global:nfquestion, 4)

# Question TextBox
$global:nfquestionBox = New-Object System.Windows.Controls.TextBox
$global:nfquestionBox.Margin = '0,10,0,0'
$global:nfquestionBox.VerticalAlignment = "Top"
$global:nfquestionBox.Width = 200
$global:nfquestionBox.Height = 200
$global:nfquestionBox.AcceptsReturn = $true
$global:nfquestionBox.TextWrapping = "Wrap"
$global:nfquestionBox.Text = "Question 1`nAnswer 1`nQuestion 2`nAnswer 2"
$global:nfgrid.Children.Add($global:nfquestionBox)
[Windows.Controls.Grid]::SetRow($global:nfquestionBox, 5)

# Save Button
$global:nfsaveButton = New-Object Windows.Controls.Button
$global:nfsaveButton.Content = "Save"
$global:nfsaveButton.Height = 30
$global:nfsaveButton.Width = 100
$global:nfsaveButton.HorizontalAlignment = "Left"
$global:nfsaveButton.VerticalAlignment = "Bottom"
$global:nfsaveButton.Margin = '10,10,0,0'
$global:nfgrid.Children.Add($global:nfsaveButton)
[Windows.Controls.Grid]::SetRow($global:nfsaveButton, 6)



### Button Click Events

# Save Button Click
$global:nfsaveButton.Add_Click({
    if (-not $global:nfnameBox.Text) {
        [System.Windows.MessageBox]::Show("Please enter a name for the flashcard.", "Error", "OK", "Error")
        return
    }
    if (-not $global:nfauthorsBox.Text) {
        [System.Windows.MessageBox]::Show("Please enter authors for the flashcard.", "Error", "OK", "Error")
        return
    }
    $name = $global:nfnameBox.Text
    $authors = $global:nfauthorsBox.Text
    $lines = $global:nfquestionBox.Text -split "`n" | Where-Object { $_.Trim() -ne "" }

    # Create a new flashcard object
    $flashcard = [PSCustomObject]@{
        Name     = $name
        Authors  = $authors
        Questions = @()
    }

    for ($i = 0; $i -lt $lines.Count; $i += 2) {
        if ($i + 1 -lt $lines.Count) {
            $question = $lines[$i].Trim()
            $answer = $lines[$i + 1].Trim()
            $flashcard.Questions += [PSCustomObject]@{
                Question = $question
                Answer   = $answer
            }
        }
    }

    

    # Save the flashcard object to a file or database (not implemented here)
    # Example: Export to JSON file
    $flashcard | ConvertTo-Json | Set-Content -Path ".\presets\$name.json"

    # Close the window after saving
    $global:nfwindow.Close()
})

$global:nfwindow.Content = $global:nfgrid
$global:nfwindow.ShowDialog()