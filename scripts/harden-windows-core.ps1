<#
.SYNOPSIS
    Windows Hardening Core Script – ASR szabályok, VBS, Vulnerable Driver Blocklist
    Alapszintű megerősítés az Altsito videó és a Microsoft ajánlásai alapján.
    GitHub projekt: Windows PC Biztonsági Megerősítés

.DESCRIPTION
    Egy kattintásos megoldás kezdőknek és haladóknak.
    Először Audit módban futtasd, majd Block módban.

.PARAMETER Mode
    Audit = csak naplózza (ajánlott először)
    Block = valóban blokkol (éles használat)

.PARAMETER EnableVBS
    $true = bekapcsolja a Virtualization-Based Security-t (ajánlott)

.PARAMETER WhatIf
    Csak szimulálja a műveleteket (teszteléshez)
#>

param(
    [ValidateSet("Audit", "Block")]
    [string]$Mode = "Audit",

    [bool]$EnableVBS = $true,

    [switch]$WhatIf
)

# =============================================
# 1. Ellenőrzések
# =============================================
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "❌ A scriptet Administrator jogokkal kell futtatni!" -ForegroundColor Red
    Write-Host "   Kattints jobb gombbal → Futtatás rendszergazdaként" -ForegroundColor Yellow
    pause
    exit 1
}

$LogFile = "$env:USERPROFILE\Desktop\Harden-Windows-Core-Log_$(Get-Date -Format 'yyyyMMdd-HHmm').txt"
"=============================================================" | Out-File $LogFile
"Windows Hardening Core Script – $(Get-Date)" | Out-File $LogFile -Append
"Mode: $Mode | VBS: $EnableVBS | WhatIf: $WhatIf" | Out-File $LogFile -Append
"=============================================================" | Out-File $LogFile -Append

Write-Host "🚀 Windows Hardening Core script indul..." -ForegroundColor Cyan

# =============================================
# 2. ASR szabályok (Microsoft ajánlott + Altsito videó alapján)
# =============================================
$ASR_Rules = @{
    # Standard protection (minimális hatással)
    "56a863a9-875e-4185-98a7-b882c64b5ce5" = "Block abuse of exploited vulnerable signed drivers"
    "9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2" = "Block credential stealing from lsass.exe"
    
    # Email és script alapú támadások
    "be9ba2d9-53ea-4cdc-84e5-9b1eeee46550" = "Block executable content from email client and webmail"
    "5beb7efe-fd9a-4556-801d-275e5ffc04cc" = "Block execution of potentially obfuscated scripts"
    "d3e037e1-3eb8-44c8-a917-57927947596d" = "Block JS/VBS from launching downloaded executable content"
    
    # Office alapú támadások
    "3b576869-a4ec-4529-8536-b80a7769e899" = "Block Office apps from creating executable content"
    "75668c1f-73b5-4cf0-bb93-3ecf5cb7cc84" = "Block Office apps from injecting code into other processes"
    "92e97fa1-2edf-4476-bdd6-9dd0b4dddc7b" = "Block Win32 API calls from Office macros"
    
    # USB és egyéb
    "b2b3f03d-6a65-4f7b-a9c7-1c7ef74a9ba4" = "Block untrusted and unsigned processes that run from USB"
    "c1db55ab-c21a-4637-bb3f-a12568109d35" = "Use advanced protection against ransomware"
}

$Action = if ($Mode -eq "Block") { "Enabled" } else { "AuditMode" }

Write-Host "📋 ASR szabályok beállítása ($Mode mód)..." -ForegroundColor Green

foreach ($Rule in $ASR_Rules.GetEnumerator()) {
    if ($WhatIf) {
        Write-Host "   [WhatIf] $($Rule.Value) → $Action" -ForegroundColor Gray
    } else {
        try {
            Add-MpPreference -AttackSurfaceReductionRules_Ids $Rule.Key `
                              -AttackSurfaceReductionRules_Actions $Action -ErrorAction Stop
            Write-Host "   ✅ $($Rule.Value)" -ForegroundColor Green
            "ASR: $($Rule.Key) = $Action" | Out-File $LogFile -Append
        } catch {
            Write-Host "   ❌ $($Rule.Value) – hiba: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

# =============================================
# 3. Microsoft Vulnerable Driver Blocklist
# =============================================
Write-Host "🛡️  Vulnerable Driver Blocklist bekapcsolása..." -ForegroundColor Green
if (-not $WhatIf) {
    Set-MpPreference -EnableVulnerableDriverBlocklist $true
    "Vulnerable Driver Blocklist: Enabled" | Out-File $LogFile -Append
    Write-Host "   ✅ Engedélyezve" -ForegroundColor Green
} else {
    Write-Host "   [WhatIf] Vulnerable Driver Blocklist → Enabled" -ForegroundColor Gray
}

# =============================================
# 4. Virtualization-Based Security (VBS) + Core Isolation
# =============================================
if ($EnableVBS) {
    Write-Host "🔒 Virtualization-Based Security (VBS) bekapcsolása..." -ForegroundColor Green
    
    $RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard"
    
    if (-not (Test-Path $RegPath)) {
        New-Item -Path $RegPath -Force | Out-Null
    }
    
    if (-not $WhatIf) {
        Set-ItemProperty -Path $RegPath -Name "EnableVirtualizationBasedSecurity" -Value 1 -Type DWord
        Set-ItemProperty -Path $RegPath -Name "RequirePlatformSecurityFeatures" -Value 1 -Type DWord  # 1 = Secure Boot + DMA Protection
        "VBS: EnableVirtualizationBasedSecurity = 1" | Out-File $LogFile -Append
        "VBS: RequirePlatformSecurityFeatures = 1" | Out-File $LogFile -Append
        Write-Host "   ✅ Registry beállítások elkészültek (újraindítás szükséges a Core Isolation-hoz)" -ForegroundColor Green
    } else {
        Write-Host "   [WhatIf] VBS registry kulcsok → 1" -ForegroundColor Gray
    }
    
    Write-Host "   📌 Megjegyzés: A Windows Security → Core isolation → Memory integrity után kapcsolható be manuálisan is." -ForegroundColor Yellow
}

# =============================================
# 5. Opcionális könnyű debloating (biztonságos)
# =============================================
# Ha szeretnéd, kikapcsolhatod a paraméterrel később
Write-Host "🧹 Felesleges bloatware tisztítás (opcionális)..." -ForegroundColor DarkGray
# Itt később bővíthető – most csak példa

# =============================================
# 6. Összefoglaló és javaslat
# =============================================
Write-Host "`n🎉 A hardening folyamat kész!" -ForegroundColor Cyan
Write-Host "   Log fájl mentve ide: $LogFile" -ForegroundColor White

if (-not $WhatIf) {
    Write-Host "`n⚠️  AJÁNLOTT: Indítsd újra a gépet, hogy a változások érvénybe lépjenek." -ForegroundColor Yellow
    Write-Host "   Utána ellenőrizd a Windows Security → Device security → Core isolation oldalt." -ForegroundColor Yellow
}

Write-Host "`nKöszönjük, hogy biztonságosabbá tetted a Windows-odat! 🚀" -ForegroundColor Magenta
Write-Host "GitHub projekt: hamarosan elérhető – kövesd a repo-t!"

pause
