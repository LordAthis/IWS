Hálózati védelem – Quad9 DNS + DNS over HTTPS beállítása
-----------------------


Ez a script minden fizikai hálózati adapteren beállítja a Quad9 DNS-t (9.9.9.9 és 149.112.112.112) DNS over HTTPS (DoH) módban.
Quad9 automatikusan blokkolja a rosszindulatú és phishing domaineket.


Használat példa:

    PowerShell.\set-quad9-doh.ps1
    .\set-quad9-doh.ps1 -WhatIf   # teszt


