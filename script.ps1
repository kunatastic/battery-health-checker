[reflection.assembly]::loadwithpartialname('System.Windows.Forms')
[reflection.assembly]::loadwithpartialname('System.Drawing')


Function IsOnBattery {
    [BOOL](Get-WmiObject -Class BatteryStatus -Namespace root\wmi).PowerOnLine
}


Function BatteryPercentage {
    [int](Get-WmiObject -Class win32_battery).estimatedChargeRemaining
}

Function PopNotification($message) {
    $notify = new-object system.windows.forms.notifyicon
    $notify.icon = [System.Drawing.SystemIcons]::Information
    $notify.visible = $true
    $notify.showballoontip($duration, "Background Battery Health", $message, [system.windows.forms.tooltipicon]::None)
}


PopNotification "Welcome the the Background Battery Health script"

while ($true) {
    # Get the current window handle
    [INT]$duration = 100
    [INT]$batteryPercentage = BatteryPercentage
    [BOOL]$isCharging = IsOnBattery
    [BOOL]$greaterThan80 = $batteryPercentage -gt 80
    [BOOL]$lessThan20 = $batteryPercentage -lt 20
    $date = Get-Date

    if ( $greaterThan80 -and $isCharging ) {
        Write-Output "[$date] Battery charge is above 80%"
        PopNotification("Battery charge is above 80%. Current Percentage is $batteryPercentage%")
    }
    elseif ( $lessThan20 -and !$isCharging ) {
        Write-Output "[$date] Battery charge is below 20% - $batteryPercentage"
        PopNotification("Battery charge is below 20%. Current Percentage is $batteryPercentage%")
    }   
    else {
        Write-Output "[$date] Battery charge is $batteryPercentage. All good Thanks"
    }

    # Sleep for 30 minutes
    Write-Output "[$date] Sleeping for 15 minutes"
    Start-Sleep -s 900
}