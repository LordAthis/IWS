<#
.SYNOPSIS
    Teljes Windows Hardening telepítő – sorban futtatja az összes scriptet
#>

param(
    [switch]$WhatIf,
    [switch]$SkipVBS   # ha teljesítményprobléma van
)

Write-Host "🚀 Teljes Hardening telepítés indul..." -ForegroundColor Cyan

$Scripts = @(
    "harden-windows-core.ps1",
    "set-quad9-doh.ps1",
    "usb-restriction.ps1",
    "browser-hardening.ps1",
    "check-autoruns.ps1"
)

foreach ($Script in $Scripts) {
    $Path = Join-Path $PSScriptRoot $Script
    if (Test-Path $Path) {
        Write-Host "`n► Futtatás: $Script" -ForegroundColor Magenta
        if ($WhatIf) {
            Write-Host "   [WhatIf] $Script szimulálása" -ForegroundColor Gray
        } else {
            try {
                & $Path -WhatIf:$WhatIf
            } catch {
                Write-Host "   ❌ Hiba: $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "   ⚠️  Hiányzó script: $Script" -ForegroundColor Yellow
    }
}

Write-Host "`n🎉 Teljes hardening folyamat kész!" -ForegroundColor Green
Write-Host "   Javasolt: Újraindítás a változások érvényesítéséhez." -ForegroundColor Yellow
pause
