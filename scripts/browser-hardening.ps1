<#
.SYNOPSIS
    Böngésző megerősítés – Microsoft Edge + Brave támogatással
    Altsito videó + Microsoft/Brave ajánlások alapján
#>

param([switch]$WhatIf)

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "❌ Administrator jog szükséges!" -ForegroundColor Red
    pause; exit 1
}

$LogFile = "$env:USERPROFILE\Desktop\Browser-Hardening-Log_$(Get-Date -Format 'yyyyMMdd-HHmm').txt"
"Browser Hardening Script – $(Get-Date)" | Out-File $LogFile -Append

Write-Host "🌐 Böngésző megerősítés indul (Edge + Brave)..." -ForegroundColor Cyan

# === Microsoft Edge Hardening ===
Write-Host "`n🔒 Microsoft Edge megerősítése..." -ForegroundColor Green

$EdgePolicyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"

if (-not (Test-Path $EdgePolicyPath)) {
    New-Item -Path $EdgePolicyPath -Force | Out-Null
}

if (-not $WhatIf) {
    # Strict Tracking Prevention (3 = Strict)
    Set-ItemProperty -Path $EdgePolicyPath -Name "TrackingPrevention" -Value 3 -Type DWord -Force
    # SmartScreen bekapcsolása
    Set-ItemProperty -Path $EdgePolicyPath -Name "SmartScreenEnabled" -Value 1 -Type DWord -Force
    # WebRTC IP leaking blokkolása
    Set-ItemProperty -Path $EdgePolicyPath -Name "WebRtcLocalhostIpHandling" -Value 1 -Type DWord -Force

    Write-Host "   ✅ Edge: Strict Tracking Prevention, SmartScreen, WebRTC védelem" -ForegroundColor Green
    "Edge: TrackingPrevention=3, SmartScreen=1, WebRtcLocalhostIpHandling=1" | Out-File $LogFile -Append
} else {
    Write-Host "   [WhatIf] Edge registry beállítások" -ForegroundColor Gray
}

# === Brave ajánlás ===
Write-Host "`n🛡️  Brave böngésző ajánlása (jobb alapvédelem)..." -ForegroundColor Magenta
Write-Host "   • Töltsd le hivatalos oldalról: https://brave.com" -ForegroundColor White
Write-Host "   • Ajánlott beállítások: Shields = Aggressive, Fingerprinting = Strict" -ForegroundColor White
Write-Host "   • Extra: Telemetry kikapcsolása, Wallet/VPN letiltása (flags vagy policies)" -ForegroundColor White

# Brave specifikus registry példa (opcionális)
$BravePolicyPath = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"
if (-not $WhatIf) {
    if (-not (Test-Path $BravePolicyPath)) { New-Item -Path $BravePolicyPath -Force | Out-Null }
    # Példa: Rewards és Wallet letiltása a támadási felület csökkentéséhez
    Set-ItemProperty -Path $BravePolicyPath -Name "BraveRewardsDisabled" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $BravePolicyPath -Name "BraveWalletDisabled" -Value 1 -Type DWord -Force
    Write-Host "   ✅ Brave: Rewards és Wallet letiltva (opcionális)" -ForegroundColor Green
}

Write-Host "`n📌 Közös ajánlás mindkét böngészőhöz:" -ForegroundColor Yellow
Write-Host "   • Telepítsd az uBlock Origin-t (Extra szűrőlistákkal)" -ForegroundColor White
Write-Host "   • Használj standard felhasználói fiókot (least privilege)" -ForegroundColor White
Write-Host "   • Bitwarden + hardveres 2FA" -ForegroundColor White

Write-Host "`n🎉 Böngésző hardening kész! Log: $LogFile" -ForegroundColor Cyan
Write-Host "   Edge-et mindig frissítsd, Brave-ot pedig preferáld ahol lehet." -ForegroundColor White

pause
