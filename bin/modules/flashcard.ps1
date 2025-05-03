param(
    [string]$psnm = "flashcard"
)

Add-Type -AssemblyName PresentationFramework

# load JSON
$flashcardPath = ".\presets\$psnm.json"
if (-not (Test-Path $flashcardPath)) {
    [System.Windows.MessageBox]::Show("Flashcard file not found: $flashcardPath", "Error","OK","Error")
    return
}
$flashcard = Get-Content $flashcardPath -Raw | ConvertFrom-Json

# state
$global:fcIndex   = 0
$global:fcCorrect = 0
$global:fcTotal   = 0
function Reshuffle {
    $global:questions = $flashcard.Questions | Get-Random -Count $flashcard.Questions.Count
    $global:fcIndex = 0
}
Reshuffle

# globals for UI elements
$grid            = $null
$entryGrid       = $null
$questionBlock   = $null
$answerBox       = $null
$feedbackBlock   = $null
$nextButton      = $null
$startButton     = $null

# build window
$window = [Windows.Window]::new()
$window.Title               = "Flashcards: $($flashcard.Name)"
$window.Width               = 400
$window.Height              = 250
$window.WindowStartupLocation = 'CenterScreen'
$window.ResizeMode          = 'NoResize'
$window.Focusable           = $true

#
# === Entry Screen ===
#
$entryGrid = [Windows.Controls.Grid]::new()
$entryGrid.Margin = '10'
1..3 | ForEach-Object { $entryGrid.RowDefinitions.Add([Windows.Controls.RowDefinition]::new()) }

# Title
$tbTitle = [Windows.Controls.TextBlock]::new()
$tbTitle.Text       = $flashcard.Name
$tbTitle.FontSize   = 20
$tbTitle.FontWeight = 'Bold'
[Windows.Controls.Grid]::SetRow($tbTitle,0)
$entryGrid.Children.Add($tbTitle)

# Author
$tbAuthor = [Windows.Controls.TextBlock]::new()
$tbAuthor.Text     = "By: $($flashcard.Authors)"
$tbAuthor.FontSize = 14
[Windows.Controls.Grid]::SetRow($tbAuthor,1)
$entryGrid.Children.Add($tbAuthor)

# Start Button
$startButton = [Windows.Controls.Button]::new()
$startButton.Content = "Start Game"
$startButton.Height  = 30
[Windows.Controls.Grid]::SetRow($startButton,2)
$entryGrid.Children.Add($startButton)

#
# === Game Screen (built but not yet shown) ===
#
$grid = [Windows.Controls.Grid]::new()
$grid.Margin = '10'
1..4 | ForEach-Object { $grid.RowDefinitions.Add([Windows.Controls.RowDefinition]::new()) }

# Question label
$questionBlock = [Windows.Controls.TextBlock]::new()
$questionBlock.FontSize     = 18
$questionBlock.TextWrapping = 'Wrap'
$questionBlock.Margin       = '0,0,0,10'
[Windows.Controls.Grid]::SetRow($questionBlock,0)
$grid.Children.Add($questionBlock)

# Answer box
$answerBox = [Windows.Controls.TextBox]::new()
$answerBox.FontSize = 16
$answerBox.Height   = 30
[Windows.Controls.Grid]::SetRow($answerBox,1)
$grid.Children.Add($answerBox)

# Feedback
$feedbackBlock = [Windows.Controls.TextBlock]::new()
$feedbackBlock.FontSize   = 14
$feedbackBlock.Foreground = 'Gray'
[Windows.Controls.Grid]::SetRow($feedbackBlock,2)
$grid.Children.Add($feedbackBlock)

# Submit button
$nextButton = [Windows.Controls.Button]::new()
$nextButton.Content = "Submit (Enter)"
$nextButton.Height  = 30
[Windows.Controls.Grid]::SetRow($nextButton,3)
$grid.Children.Add($nextButton)

#
# === Functions ===
#
function Show-Question {
    $q = $global:questions[$global:fcIndex]
    $questionBlock.Text = "Q$($global:fcIndex+1): $($q.Question)"
    $answerBox.Text     = ""
    $answerBox.Focus()  
}

function Check-Answer {
    $q      = $global:questions[$global:fcIndex]
    $ans    = $answerBox.Text.Trim()
    $global:fcTotal++

    $last   = ($global:fcIndex -eq $global:questions.Count - 1)
    if ($ans -eq $q.Answer.Trim()) {
        $global:fcCorrect++
        if ($last) {
            $feedbackBlock.Text       = "[!] Correct! Quiz completed!"
            $feedbackBlock.Foreground = 'Blue'
        } else {
            $feedbackBlock.Text       = "[!] Correct!"
            $feedbackBlock.Foreground = 'Green'
        }
    } else {
        if ($last) {
            $feedbackBlock.Text       = "[X] Wrong! Quiz completed. Ans: $($q.Answer)"
            $feedbackBlock.Foreground = 'Purple'
        } else {
            $feedbackBlock.Text       = "[X] Wrong! Answer: $($q.Answer)"
            $feedbackBlock.Foreground = 'Red'
        }
    }

    $global:fcIndex++
    if ($global:fcIndex -ge $global:questions.Count) {
        Reshuffle
    }
    Show-Question
}

#
# === Events ===
#
# start: swap to game grid
$startButton.Add_Click({
    $window.Content = $grid
    Show-Question
})

# click submit
$nextButton.Add_Click({ Check-Answer })

# global hotkeys
$window.Add_PreviewKeyDown({
    param($s,$e)
    if ($e.Key -eq 'Enter') {
        Check-Answer
        $e.Handled = $true
    } elseif ($e.Key -eq 'Escape') {
        $pct = [math]::Round(($global:fcCorrect/$global:fcTotal)*100,2)
        [System.Windows.MessageBox]::Show(
          "Answered: $global:fcTotal`nCorrect: $global:fcCorrect`nScore: $pct%",
          "Final Score","OK","Info"
        )
        $window.Close()
    }
})

#
# === Launch ===
#
$window.Content = $entryGrid
# ensure key events fire
$window.ShowActivated = $true
$window.Focus()
$window.ShowDialog()
.\bin\cb2\flashcard.ps1