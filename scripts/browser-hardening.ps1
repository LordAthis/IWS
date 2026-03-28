<#
.SYNOPSIS
    Böngésző hardening script – uBlock Origin + alapvető biztonsági beállítások
    Altsito videó alapján (NoScript-szerű védelmek)

.DESCRIPTION
    Javaslatok és részleges automatikus beállítások Edge/Chrome böngészőkhöz.
    Teljes uBlock konfigurációhoz lásd a GitHub docs mappát.
#>

param([switch]$WhatIf)

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "❌ Administrator jog szükséges!" -ForegroundColor Red
    pause; exit 1
}

$LogFile = "$env:USERPROFILE\Desktop\Browser-Hardening-Log_$(Get-Date -Format 'yyyyMMdd-HHmm').txt"
"Browser Hardening Script – $(Get-Date)" | Out-File $LogFile -Append

Write-Host "🌐 Böngésző megerősítés indul..." -ForegroundColor Cyan

# uBlock Origin ajánlása
Write-Host "`n📌 Ajánlott bővítmények telepítése:" -ForegroundColor Green
Write-Host "   • uBlock Origin (Edge / Chrome / Firefox)" -ForegroundColor White
Write-Host "   • Bitwarden" -ForegroundColor White

if (-not $WhatIf) {
    # Edge tracking védelem erősítése (példa registry)
    $EdgePath = "HKCU:\Software\Policies\Microsoft\Edge"
    if (-not (Test-Path $EdgePath)) { New-Item -Path $EdgePath -Force | Out-Null }
    Set-ItemProperty -Path $EdgePath -Name "TrackingPrevention" -Value 3 -Type DWord   # 3 = Strict
    "Edge: TrackingPrevention = Strict" | Out-File $LogFile -Append
    Write-Host "   ✅ Edge tracking védelem: Strict mód" -ForegroundColor Green
}

Write-Host "`n⚠️  Manuális lépések javasoltak:" -ForegroundColor Yellow
Write-Host "   1. Telepítsd az uBlock Origin-t minden böngészőbe"
Write-Host "   2. Engedélyezd a 'Medium' vagy 'High' módot az uBlock-ban"
Write-Host "   3. Használj standard felhasználói fiókot (least privilege)"

Write-Host "`n🎉 Browser hardening kész! Log: $LogFile" -ForegroundColor Cyan
pause
