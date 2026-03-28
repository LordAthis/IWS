----------------------------
# IWS - Increase Windows Security (Windows Biztonság növelése)
----------------------------


# Windows Hardening Toolkit

**Teddd 95%-kal nehezebben feltörhetővé a Windows PC-det** – lépésről lépésre, kezdőknek és haladóknak.

Alapul szolgál az **Altsito** videó:  
[„Make your PC 95% HARDER to hack in 11 minutes (the easy way)”](https://youtu.be/2RkIHWygEVM)

Ez a nyílt forráskódú projekt egy egyszerű, biztonságos eszközkészlet Windows rendszerek megerősítéséhez.  
Cél: csökkentsük a támadási felületet (Attack Surface), erősítsük a védelmet BIOS-tól a böngészőig, anélkül, hogy enterprise szintű eszközöket kellene használni.

## Funkciók

- **Core Hardening**: Attack Surface Reduction (ASR) szabályok, Vulnerable Driver Blocklist, Virtualization-Based Security (VBS)
- **Hálózat**: Quad9 DNS + DNS over HTTPS (DoH)
- **Fizikai védelem**: USB tárolóeszközök blokkolása (Rubber Ducky / BadUSB ellen)
- **Böngésző**: Hardening javaslatok + uBlock Origin ajánlás
- **Monitoring**: Autoruns ellenőrzés (indítási elemek / persistence)
- **GUI telepítő**: Egyszerű grafikus felület magyar és angol nyelvvel (Python + customtkinter)
- **One-click installer**: Minden script sorban futtatható

## Gyors telepítés

1. Töltsd le a repository-t (Code → Download ZIP) vagy klónozd:
   ```bash
   git clone https://github.com/[felhasználóneved]/windows-hardening-toolkit.git





1, Nyisd meg a scripts mappát rendszergazdaként (PowerShell).
2, Futtasd a teljes telepítőt:

    PowerShell.\install-hardening.ps1

Vagy használd a GUI-t (installer/hardening-gui.py):
Bash:

    pip install customtkinter
    python hardening-gui.py

Fontos: Mindig Administrator jogokkal futtasd a script-eket!

---------------------------
Mappa struktúra:
---------------------------

- /docs/          – Cikkek, checklist-ek, BIOS útmutató
- /scripts/       – PowerShell script-ek (fő eszközök)
- /installer/     – GUI telepítő (Python)
- /configs/       – .reg fájlok és egyéb konfigurációk
- /images/        – Képernyőképek a dokumentációhoz


---------------------------
Elérhető script-ek:
---------------------------

  Script neve:                Leírás:                                             Ajánlott mód:

harden-windows-core.ps1        ASR szabályok + VBS + Vulnerable Driver            Audit → Block
set-quad9-doh.ps1              Quad9 DNS + DoH beállítása                         -
usb-restriction.ps1            USB tárolóeszközök blokkolása                      Disable
browser-hardening.ps1          Böngésző ajánlások                                 -
check-autoruns.ps1             Indítási elemek ellenőrzése (Sysinternals)         -
install-hardening.ps1          Teljes telepítés (sorrendben)                      -



---------------------------
Használat lépésről lépésre:
---------------------------

Részletes útmutató található a /docs/ mappában vagy a teljes cikkben.
---------------------------
Ajánlott sorrend:

- BIOS szint (manuális – lásd checklist)
- Core Hardening
- Quad9 DoH
- USB restriction
- Böngésző + identitásvédelem
- Monitoring + 3-2-1 backup

---------------------------
Biztonsági megjegyzések:
---------------------------

- Először mindig Audit módban tesztelj!
- VBS bekapcsolása után ellenőrizd a teljesítményt (5–15% csökkenés lehetséges).
- Újraindítás gyakran szükséges a változások érvényesítéséhez.
- Készíts biztonsági mentést a registry-ről importálás előtt!

---------------------------
Hozzájárulás:
---------------------------

- Teszteld különböző Windows 10/11 verziókon
- Jelents bug-okat az Issues oldalon
- Küldj Pull Request-et új script-ekkel vagy javításokkal

---------------------------
Licenc:
---------------------------

MIT License – szabadon használható, módosítható.


---------------------------
Kapcsolat:
---------------------------

- GitHub Issues
- Blogom elérhetőségén

Biztonságosabbá teszed a gépedet, vagy más gépét?
Köszönjük, hogy használtad a projektet! 🚀

