Ez a script a cikk „Windows operációs rendszer megerősítése” Blog Cikkem első fejezetének, és a rendszer hangolásának a szíve.
Egyetlen futtatással beállítja:

Az összes ajánlott Attack Surface Reduction (ASR) szabályt (Block vagy Audit módban választható)
A Microsoft Vulnerable Driver Blocklist-et
A Virtualization-Based Security (VBS) + Core Isolation (Memory Integrity) bekapcsolását (registry-n keresztül, biztonságos módon)
Alapvető debloatingot (opcionális, nagyon óvatosan)
Részletes logolást fájlba

A script teljesen biztonságos kezdőknek is: először Audit módban tesztelheted, utána Block-ra kapcsolhatod.


----------------------------
Hogyan használod?
----------------------------

Mentés: harden-windows-core.ps1 néven a /scripts/ mappába.

- Első teszt:
      PowerShell.\harden-windows-core.ps1 -Mode Audit

- Éles használat:
      PowerShell.\harden-windows-core.ps1 -Mode Block

- VBS nélkül (ha lassabb lenne a gép):
      PowerShell.\harden-windows-core.ps1 -Mode Block -EnableVBS $false

A script teljesen dokumentált, logol, és biztonságosan használja az Add-MpPreference parancsot (nem írja felül a korábbi szabályokat).
