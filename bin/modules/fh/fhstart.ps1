$host.UI.RawUI.WindowTitle = "Nitrous - ACX Elite"
$defaultColor = $host.UI.RawUI.ForegroundColor
$host.UI.RawUI.ForegroundColor = "Green"



### Set variables



# Get current time and system uptime
$now = Get-Date
$uptime = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
$uptimeSpan = $now - $uptime

# Epochs
$unixEpoch = [datetime]"1970-01-01T00:00:00Z"
$sinceUnix = [int]($now.ToUniversalTime() - $unixEpoch).TotalSeconds



function New-Line {
    param(
        [string]$Info = "",
        [string]$W = "",
        [string]$E = ""
    )

    if (-not [string]::IsNullOrWhiteSpace($Info)) {
        Write-Host "[INFO] $Info" -ForegroundColor Cyan
    }

    if (-not [string]::IsNullOrWhiteSpace($W)) {
        Write-Host "[WARN] $W" -ForegroundColor Yellow
    }

    if (-not [string]::IsNullOrWhiteSpace($E)) {
        Write-Host "[ERROR] $E" -ForegroundColor Red
    }
}

function Get-CPUInfo {
    $cpu = Get-CimInstance Win32_Processor
    foreach ($c in $cpu) {
        New-Line "CPU: $($c.Name)"
        New-Line "ProcessorID: $($c.ProcessorId)"
        New-Line "Cores: $($c.NumberOfCores)"
        New-Line "LogicalProcessors: $($c.NumberOfLogicalProcessors)"
        New-Line "MaxClockSpeed: $($c.MaxClockSpeed)MHz"
        New-Line "Architecture: $($c.Architecture)"
        New-Line "DataWidth: $($c.DataWidth)-bit"
        New-Line "Virtualization: $($c.VirtualizationFirmwareEnabled)"
        New-Line ""
    }

    # Now get per-core stats (logical processors)
    $cores = Get-CimInstance Win32_PerfFormattedData_PerfOS_Processor | Where-Object { $_.Name -ne "_Total" }
    foreach ($core in $cores) {
        $coreName = if ($core.Name -eq "0") { "Core0" } else { "Core$core.Name" }
        New-Line "$coreName Load: $($core.PercentProcessorTime)%"
        New-Line "$coreName UserTime: $($core.PercentUserTime)%"
        New-Line "$coreName PrivilegedTime: $($core.PercentPrivilegedTime)%"
        New-Line "$coreName IdleTime: $([math]::Round(100 - $core.PercentProcessorTime, 1))%"
        New-Line ""
    }
}




### Function

Clear-Host
Write-Host "`n"
Start-Sleep -Seconds 1
Write-Host "`n"
Start-Sleep -Milliseconds 40
Write-Host "Welcome to Nitrous - ACX Elite"
Start-Sleep -Milliseconds 600
Write-Host "Logging in . . ."
Start-Sleep -Milliseconds 600
Write-Host "Connected to $($env:COMPUTERNAME)"
Start-Sleep -Seconds 3
$num = (Get-Random -Minimum 8342934248823481293482192939422 -Maximum 98790812734098217342817462897346198237461)
New-Line "vm_page_bootstrap $num"
Start-Sleep -Milliseconds 200
$kernelVersion = (Get-CimInstance -ClassName Win32_OperatingSystem).Version
New-Line "Kernel Version $kernelVersion"
Start-Sleep -Milliseconds 100
New-Line "Creating a dev location"
Start-Sleep -Milliseconds 80
New-Line -W "dev location was found but wasn't available : 0x84n1" -ForegroundColor Yellow
New-Line "Using following workaround: LOCALDISK"
Start-Sleep -Milliseconds 50
New-Line "Time found: ISO8601T.$($now.ToString('o'))   UTC: $($now.ToUniversalTime().ToString('u'))   Local: $($now.ToString('F'))   UNIX: $sinceUnix   Current uptime: $($uptimeSpan.Days)d $($uptimeSpan.Hours)h $($uptimeSpan.Minutes)m $($uptimeSpan.Seconds)s   Boot Time: $($uptime.ToString('F'))"
Get-CPUInfo
New-Line -W "namespace STD was not located"
New-Line -W "using workaround: pwsh"
Start-Sleep -Milliseconds 60
New-Line -W "Net class unavailable"
New-Line "Waiting for object creation..."
Start-Sleep -Milliseconds 100
New-Line "Loading registry..."
Start-Sleep -Milliseconds 900


function Main-Menu {
    # Main menu
    Clear-Host
    Write-Host "`n`nNitrous - ACX Elite server penetration testing framework`nVersion 5.6.1"
    Write-Host "`n`n[1] - Dump registry"
    Write-Host "[2] - Tree local C:"
    Write-Host "[3] - List all processes"
    $ans = Read-Host "`n`$>"

    if ($ans -eq 1) {
        Clear-Host
        New-Line "Dumping registry..."
        Start-Sleep -Seconds 2
        reg query "HKLM\DRIVERS" /s
        reg query "HKLM\HARDWARE" /s
        reg query "HKLM\SAM" /s
        reg query "HKLM\SOFTWARE" /s
        reg query "HKLM\SYSTEM" /s
        New-Line "Registry dump complete."
        Pause
        Main-Menu
    } elseif ($ans -eq 2) {
        Clear-Host
        Write-Host "`n`nTree local C:"
        Start-Sleep -Seconds 2
        New-Line "C:\Windows\System32"
        New-Line "C:\Windows\System32\config"
        New-Line "C:\Windows\System32\drivers"
        tree C:\ /f /a
        Pause
        Main-Menu
    } elseif ($ans -eq 3) {
        Clear-Host
        Write-Host "`n`nListing all processes..."
        Start-Sleep -Seconds 2
        Get-Process | Format-Table -AutoSize
        Pause
        Main-Menu
    } elseif ($ans -eq "exit") {
        New-Line "Cleaning up..."
        $host.UI.RawUI.foregroundColor = $defaultColor
        $host.UI.RawUI.WindowTitle = "ToolBored - [CLI]"
        Restart
        return
    } else {
        $ans
        Pause
        Main-Menu
    }
}

Main-Menu