<#
.SYNOPSIS
    Autoruns ellenőrzés – indítási elemek (persistence) vizsgálata
    Sysinternals Autorunsc használatával
#>

param([switch]$WhatIf)

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "❌ Administrator jog szükséges!" -ForegroundColor Red
    pause; exit 1
}

$LogFile = "$env:USERPROFILE\Desktop\Autoruns-Check-Log_$(Get-Date -Format 'yyyyMMdd-HHmm').txt"
"Autoruns Check – $(Get-Date)" | Out-File $LogFile -Append

$AutorunsDir = "$env:USERPROFILE\Downloads\Autoruns"
$Autorunsc   = "$AutorunsDir\autorunsc64.exe"

Write-Host "🔍 Autoruns ellenőrzés indul..." -ForegroundColor Cyan

# Letöltés ha nincs meg
if (-not (Test-Path $Autorunsc)) {
    Write-Host "   📥 Autoruns letöltése..." -ForegroundColor Yellow
    if (-not $WhatIf) {
        $Url = "https://live.sysinternals.com/autorunsc64.exe"
        New-Item -Path $AutorunsDir -ItemType Directory -Force | Out-Null
        Invoke-WebRequest -Uri $Url -OutFile $Autorunsc
        Write-Host "   ✅ Autorunsc64 letöltve" -ForegroundColor Green
    } else {
        Write-Host "   [WhatIf] Autoruns letöltése" -ForegroundColor Gray
    }
}

if (-not $WhatIf) {
    $OutputHtml = "$env:USERPROFILE\Desktop\Autoruns_Report_$(Get-Date -Format 'yyyyMMdd-HHmm').html"
    $OutputCsv  = "$env:USERPROFILE\Desktop\Autoruns_Report_$(Get-Date -Format 'yyyyMMdd-HHmm').csv"
    
    & $Autorunsc -accepteula -a * -h -vt -c > $OutputCsv
    Write-Host "   ✅ CSV jelentés elkészült: $OutputCsv" -ForegroundColor Green
    
    # Egyszerű HTML wrapper
    "<h1>Autoruns Report</h1><pre>" + (Get-Content $OutputCsv -Raw) + "</pre>" | Out-File $OutputHtml -Encoding UTF8
    Write-Host "   ✅ HTML jelentés: $OutputHtml" -ForegroundColor Green
} else {
    Write-Host "   [WhatIf] Autoruns futtatása és jelentés készítése" -ForegroundColor Gray
}

Write-Host "`n🎉 Autoruns ellenőrzés kész! Nyisd meg a generált fájlokat." -ForegroundColor Cyan
pause
