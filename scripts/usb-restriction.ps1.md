Fizikai OpSec – Engedély nélküli USB tárolóeszközök blokkolása
--------------------------


Ez a script blokkolja az USB tárolóeszközöket (pendrive, külső HDD stb.), de hagyja működni a billentyűzetet, egeret stb.
Két üzemmód: Disable (blokkol) vagy Enable (visszaállít).



Használat példa:

    PowerShell.\usb-restriction.ps1 -Action Disable
    .\usb-restriction.ps1 -Action Enable
    .\usb-restriction.ps1 -Action Disable -WhatIf


