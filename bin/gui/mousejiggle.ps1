Add-Type -AssemblyName PresentationCore, PresentationFramework, WindowsBase
Add-Type -AssemblyName System.Windows.Forms
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;

public class HotKeyManager {
    [DllImport("user32.dll")]
    public static extern bool RegisterHotKey(IntPtr hWnd, int id, int fsModifiers, int vk);

    [DllImport("user32.dll")]
    public static extern bool UnregisterHotKey(IntPtr hWnd, int id);

    // Use PeekMessage with PM_REMOVE=1 so each message is processed once.
    [DllImport("user32.dll")]
    public static extern bool PeekMessage(out MSG lpMsg, IntPtr hWnd, uint wMsgFilterMin, uint wMsgFilterMax, uint wRemoveMsg);

    public const int MOD_CONTROL = 0x2;
    public const int MOD_SHIFT = 0x4;
    public const int WM_HOTKEY = 0x0312;

    [StructLayout(LayoutKind.Sequential)]
    public struct MSG {
        public IntPtr hWnd;
        public uint message;
        public IntPtr wParam;
        public IntPtr lParam;
        public uint time;
        public int pt_x;
        public int pt_y;
    }
}
'@

# --- Hotkey constants ---
$TOGGLE_ID = 1
$EXIT_ID   = 2
# 6 = MOD_CONTROL | MOD_SHIFT
[HotKeyManager]::RegisterHotKey([IntPtr]::Zero, $TOGGLE_ID, 6, 0x4A) | Out-Null  # Ctrl+Shift+J
[HotKeyManager]::RegisterHotKey([IntPtr]::Zero, $EXIT_ID,   6, 0x51) | Out-Null  # Ctrl+Shift+Q

# --- Global Variables ---
$global:exit = $false
$global:settings = @{
    Delay     = 0
    Intensity = 0
    Pattern   = "circle"
}
$global:JigglerPath = ".\bin\modules\mousejctrl.ps1"
$global:JigglerPID = $null

# Cooldown delay in milliseconds to prevent rapid retriggering of hotkey processing
$global:HotkeyCooldown = 300

# --- Create the MouseJiggler Config UI using WPF ---
$window = New-Object System.Windows.Window
$window.Title = "ToolBored $($global:appversionid) Mouse Jiggler"
$window.Width = 300
$window.Height = 200
$window.WindowStartupLocation = "CenterScreen"

$panel = New-Object System.Windows.Controls.StackPanel
$panel.Margin = [System.Windows.Thickness]::new(10)
$window.Content = $panel

# Delay
$delayText = New-Object System.Windows.Controls.TextBlock
$delayText.Text = "Delay (ms):"
$panel.Children.Add($delayText)
$delayBox = New-Object System.Windows.Controls.TextBox
$delayBox.Text = "100"
$panel.Children.Add($delayBox)

# Intensity
$intensityText = New-Object System.Windows.Controls.TextBlock
$intensityText.Text = "Intensity (px):"
$panel.Children.Add($intensityText)
$intensityBox = New-Object System.Windows.Controls.TextBox
$intensityBox.Text = "10"
$panel.Children.Add($intensityBox)

# Pattern
$patternText = New-Object System.Windows.Controls.TextBlock
$patternText.Text = "Pattern:"
# $panel.Children.Add($patternText)
$patternBox = New-Object System.Windows.Controls.ComboBox
"circle","square","zigzag","random" | ForEach-Object { $patternBox.Items.Add($_) | Out-Null }
$patternBox.SelectedItem = "circle"
# $panel.Children.Add($patternBox)

# Apply Button
$applyBtn = New-Object System.Windows.Controls.Button
$applyBtn.Content = "Start Jiggle"
$applyBtn.Margin = [System.Windows.Thickness]::new(0,10,0,0)
$panel.Children.Add($applyBtn)

$applyBtn.Add_Click({
    $global:settings.Delay     = [int]$delayBox.Text
    $global:settings.Intensity = [int]$intensityBox.Text
    $global:settings.Pattern   = $patternBox.SelectedItem

    Write-Host "Settings applied: Delay=$($global:settings.Delay), Intensity=$($global:settings.Intensity), Pattern=$($global:settings.Pattern)"
    Write-Host "`n`nKeybinds: Ctrl+Shift+J to toggle, Ctrl+Shift+Q to exit."
    # Start jiggler based on these settings
    Start-Jiggler
    $window.Close()
})

# --- Function Definitions ---
function Start-Jiggler {
    # If there's an active jiggler process, stop it first.
    if ($global:JigglerPID -and (Get-Process -Id $global:JigglerPID -ErrorAction SilentlyContinue)) {
        Write-Host "[WARNING] Already running. Stopping it first..."
        Stop-Jiggler
        Start-Sleep -Milliseconds 200
    }
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "powershell.exe"
    $psi.Arguments = "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$JigglerPath`" -delay $($global:settings.Delay) -intensity $($global:settings.Intensity) -pattern $($global:settings.Pattern)"
    $psi.CreateNoWindow = $true
    $psi.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
    $psi.UseShellExecute = $false

    $proc = [System.Diagnostics.Process]::Start($psi)
    $global:JigglerPID = $proc.Id
    Write-Host "[INFO] Started with PID $global:JigglerPID; pattern '$($global:settings.Pattern)', delay=$($global:settings.Delay), intensity=$($global:settings.Intensity)"
}

function Stop-Jiggler {
    if ($global:JigglerPID) {
        try {
            Stop-Process -Id $global:JigglerPID -Force -ErrorAction Stop
            Write-Host "[INFO] Stopped process $global:JigglerPID."
        }
        catch {
            Write-Host "[ERROR] Could not stop process $global:JigglerPID."
        }
        $global:JigglerPID = $null
    }
}

function Check-Hotkeys {
    $msg = New-Object HotKeyManager+MSG
    if ([HotKeyManager]::PeekMessage([ref]$msg, [IntPtr]::Zero, [HotKeyManager]::WM_HOTKEY, [HotKeyManager]::WM_HOTKEY, 1)) {
        switch ($msg.wParam.ToInt32()) {
            $TOGGLE_ID {
                if ($global:JigglerPID -and (Get-Process -Id $global:JigglerPID -ErrorAction SilentlyContinue)) {
                    Stop-Jiggler
                    Write-Host "[INFO] Toggled: Stopped jiggler."
                }
                else {
                    Start-Jiggler
                    Write-Host "[INFO] Toggled: Started jiggler."
                }
            }
            $EXIT_ID {
                $global:exit = $true
                Stop-Jiggler
                Write-Host "[INFO] Exit pressed. Exiting jiggler controller..."
            }
        }
        Start-Sleep -Milliseconds $global:HotkeyCooldown
    }
}

# --- Show the configuration UI ---
$window.ShowDialog() | Out-Null

# --- After the UI closes, enter a hotkey-monitoring loop until exit ---
while (-not $global:exit) {
    Check-Hotkeys
    Start-Sleep -Milliseconds 100
}

# --- Clean up hotkeys and ensure jiggler is stopped ---
if ($global:JigglerPID) {
    Stop-Jiggler
}
[HotKeyManager]::UnregisterHotKey([IntPtr]::Zero, $TOGGLE_ID)
[HotKeyManager]::UnregisterHotKey([IntPtr]::Zero, $EXIT_ID)

Write-Host "Exiting script..."

Restart