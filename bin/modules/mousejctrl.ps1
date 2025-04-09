param(
    [int]$delay = 100,
    [int]$intensity = 10,
    [string]$pattern = "circle"
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Jiggle-Circle {
    $angle = 0
    while ($true) {
        $x = [math]::Cos($angle) * $intensity
        $y = [math]::Sin($angle) * $intensity
        $pos = [System.Windows.Forms.Cursor]::Position
        $newPos = New-Object System.Drawing.Point(($pos.X + $x), ($pos.Y + $y))
        [System.Windows.Forms.Cursor]::Position = $newPos
        Start-Sleep -Milliseconds $delay
        [System.Windows.Forms.Cursor]::Position = $pos
        $angle += 0.3
    }
}

function Jiggle-Square {
    $points = @(
        { param($p) New-Object System.Drawing.Point($p.X + $intensity, $p.Y) },
        { param($p) New-Object System.Drawing.Point($p.X, $p.Y + $intensity) },
        { param($p) New-Object System.Drawing.Point($p.X - $intensity, $p.Y) },
        { param($p) New-Object System.Drawing.Point($p.X, $p.Y - $intensity) }
    )
    $i = 0
    while ($true) {
        $pos = [System.Windows.Forms.Cursor]::Position
        $newPos = $points[$i % 4].Invoke($pos)
        [System.Windows.Forms.Cursor]::Position = $newPos
        Start-Sleep -Milliseconds $delay
        [System.Windows.Forms.Cursor]::Position = $pos
        $i++
    }
}

switch ($pattern.ToLower()) {
    "square" { Jiggle-Square }
    default  { Jiggle-Circle }
}
