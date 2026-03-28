<#
.SYNOPSIS
    USB tárolóeszközök (storage) blokkolása vagy engedélyezése.
    Rubber Ducky / BadUSB / unauthorized USB támadások ellen.

.DESCRIPTION
    Registry alapján letiltja az USBSTOR szolgáltatást (csak tárolóeszközöket).
    HID eszközök (billentyűzet, egér) továbbra is működnek.

.PARAMETER Action
    Disable = blokkolja az USB tárolót
    Enable  = visszaállítja (alapértelmezett)

.PARAMETER WhatIf
    Csak szimulálja a műveleteket
#>

param(
    [ValidateSet("Disable", "Enable")]
    [string]$Action = "Disable",

    [switch]$WhatIf
)

# Admin jog ellenőrzése
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "❌ A scriptet Administrator jogokkal kell futtatni!" -ForegroundColor Red
    pause
    exit 1
}

$LogFile = "$env:USERPROFILE\Desktop\USB-Restriction-Log_$(Get-Date -Format 'yyyyMMdd-HHmm').txt"
"=============================================================" | Out-File $LogFile
"USB Restriction Script – $(Get-Date) – Action: $Action" | Out-File $LogFile -Append
"=============================================================" | Out-File $LogFile -Append

$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR"

Write-Host "🔌 USB tárolóeszközök kezelése indul... ($Action)" -ForegroundColor Cyan

if (-not (Test-Path $RegPath)) {
    Write-Host "   ⚠️  USBSTOR kulcs nem található. Lehet, hogy a szolgáltatás nincs telepítve." -ForegroundColor Yellow
}

$Value = if ($Action -eq "Disable") { 4 } else { 3 }   # 4 = Disabled, 3 = Manual

if (-not $WhatIf) {
    try {
        Set-ItemProperty -Path $RegPath -Name "Start" -Value $Value -Type DWord -Force -ErrorAction Stop
        Write-Host "   ✅ USBSTOR Start érték beállítva: $Value ($Action)" -ForegroundColor Green
        "USBSTOR Start = $Value ($Action)" | Out-File $LogFile -Append
    } catch {
        Write-Host "   ❌ Hiba a registry módosításakor: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "   [WhatIf] USBSTOR Start → $Value ($Action)" -ForegroundColor Gray
}

Write-Host "`n🎉 USB restriction kész!" -ForegroundColor Cyan
Write-Host "   Log fájl: $LogFile" -ForegroundColor White

if ($Action -eq "Disable") {
    Write-Host "`n⚠️  Figyelem: Az USB pendrive-ok és külső meghajtók mostantól NEM fognak működni." -ForegroundColor Yellow
    Write-Host "   Billentyűzet és egér továbbra is használható." -ForegroundColor Yellow
}

Write-Host "`nÚjraindítás ajánlott a változások teljes érvényesüléséhez." -ForegroundColor Yellow

pause
