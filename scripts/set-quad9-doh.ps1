<#
.SYNOPSIS
    Quad9 DNS + DNS over HTTPS (DoH) beállítása Windows 11/10 rendszeren.
    Alapszintű hálózati megerősítés az Altsito videó alapján.

.DESCRIPTION
    Beállítja a Quad9 DNS szervereket minden fizikai adapteren DoH módban.
    Ajánlott a Quad9 hivatalos útmutatója alapján.

.PARAMETER WhatIf
    Csak szimulálja a műveleteket (teszteléshez)
#>

param([switch]$WhatIf)

# Admin jog ellenőrzése
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "❌ A scriptet Administrator jogokkal kell futtatni!" -ForegroundColor Red
    pause
    exit 1
}

$LogFile = "$env:USERPROFILE\Desktop\Set-Quad9-DoH-Log_$(Get-Date -Format 'yyyyMMdd-HHmm').txt"
"=============================================================" | Out-File $LogFile
"Quad9 DoH Setup Script – $(Get-Date)" | Out-File $LogFile -Append
"=============================================================" | Out-File $LogFile -Append

Write-Host "🌐 Quad9 DNS + DoH beállítása indul..." -ForegroundColor Cyan

# Quad9 DoH szerverek hozzáadása a ismert DoH listához
$Quad9Primary   = "9.9.9.9"
$Quad9Secondary = "149.112.112.112"
$DoHTemplate    = "https://dns.quad9.net/dns-query"

if (-not $WhatIf) {
    try {
        Add-DnsClientDohServerAddress -ServerAddress $Quad9Primary `
                                      -DohTemplate $DoHTemplate `
                                      -AutoUpgrade $true `
                                      -AllowFallbackToUdp $false -ErrorAction Stop
        Add-DnsClientDohServerAddress -ServerAddress $Quad9Secondary `
                                      -DohTemplate $DoHTemplate `
                                      -AutoUpgrade $true `
                                      -AllowFallbackToUdp $false -ErrorAction Stop
        Write-Host "   ✅ Quad9 DoH szerverek hozzáadva a rendszerhez" -ForegroundColor Green
        "DoH servers added: $Quad9Primary and $Quad9Secondary" | Out-File $LogFile -Append
    } catch {
        Write-Host "   ⚠️  DoH hozzáadás hiba (lehet, hogy már létezik): $($_.Exception.Message)" -ForegroundColor Yellow
    }
} else {
    Write-Host "   [WhatIf] Quad9 DoH szerverek hozzáadása" -ForegroundColor Gray
}

# Minden fizikai adapter beállítása
$Adapters = Get-NetAdapter -Physical | Where-Object { $_.Status -eq 'Up' -or $_.Status -eq 'Disconnected' }

foreach ($Adapter in $Adapters) {
    $Name = $Adapter.Name
    Write-Host "   🔧 Adapter feldolgozása: $Name" -ForegroundColor White
    
    if (-not $WhatIf) {
        try {
            # IPv4 DNS beállítása
            Set-DnsClientServerAddress -InterfaceIndex $Adapter.ifIndex `
                                       -ServerAddresses ($Quad9Primary, $Quad9Secondary) -ErrorAction Stop
            
            # IPv6 is (opcionális, de ajánlott)
            Set-DnsClientServerAddress -InterfaceIndex $Adapter.ifIndex `
                                       -ServerAddresses ("2620:fe::fe", "2620:fe::9") -ErrorAction SilentlyContinue
            
            Write-Host "      ✅ $Name → Quad9 DoH beállítva" -ForegroundColor Green
            "Adapter: $Name (Index: $($Adapter.ifIndex)) → Quad9 DoH" | Out-File $LogFile -Append
        } catch {
            Write-Host "      ❌ $Name hiba: $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "      [WhatIf] $Name → Quad9 DoH beállítása" -ForegroundColor Gray
    }
}

Write-Host "`n🎉 Quad9 + DoH beállítás kész!" -ForegroundColor Cyan
Write-Host "   Log fájl: $LogFile" -ForegroundColor White
Write-Host "`n⚠️  Javaslat: Indítsd újra a gépet vagy futtasd: ipconfig /flushdns" -ForegroundColor Yellow
Write-Host "   Ellenőrizd a Beállítások → Hálózat és internet → DNS oldalon." -ForegroundColor Yellow

pause
