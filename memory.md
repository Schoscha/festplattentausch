# memory.md – Festplattentausch

## Ziel
Interne M.2-SSD eines Windows-11-Laptops auf neue SSD (doppelte Kapazität) übertragen.
Laptop hat nur einen M.2-Steckplatz, kein USB-M.2-Adapter vorhanden.

## Entscheidungen
- 2026-10-03: Option B (Image auf externe Festplatte → tauschen → zurückspielen).
- Werkzeug: Veeam Agent for Windows Free (statt Clonezilla wegen BitLocker/VMD/Resize).
- 2026-10-03: Desktop Commander wird NICHT mehr verwendet (Nutzer: „Schrott“). Kein Fernzugriff auf
  den Laptop → Nutzer führt Skripte selbst aus. Connector-Entfernung durch Nutzer:
  https://claude.ai/customize/connectors, Gerät „Detlef“: https://mcp.desktopcommander.app/

## Tasks
- [x] Optionen aufzeigen
- [x] Anleitung (ANLEITUNG.md)
- [x] scripts/vorbereitung.ps1 (nur lesend, BitLocker-Schlüssel sichern)
- [x] scripts/nachbereitung.ps1 (C: vergrößern)
- [x] README.md mit Optionsvergleich
- [x] Nutzer: Schritt 1 (Bericht 2026-10-03 03:30)
- [ ] Nutzer: Schritt 2–4 (Veeam, Backup nach D:, Recovery-Stick = Disk 2 / 14,6 GB)
- [ ] Nutzer: Schritt 5–7 (Tausch, Restore, Kontrolle)
- [ ] Ggf. WinRE-Partition verschieben, falls hinter C:

## Offene Punkte
- USB-Stick ≥ 8 GB vorhanden (bestätigt 2026-10-03).
- 2026-10-03: Schritt 1 angefragt. Laptop nicht erreichbar → Nutzer führt Skript selbst aus.
- 2026-10-03: Skripte per PowerShell-7-Parser geprüft (0 Fehler). Fix vorbereitung.ps1: SSD-Zustand per DeviceId statt Pipeline Disk→Get-PhysicalDisk.
- Bericht Schritt 1 (2026-10-03): Lenovo 20QGS0QU00, Win 11 Pro 26200, UEFI/GPT.
  SSD: Toshiba KXG50ZNV256G NVMe 238,5 GB, Healthy, Verschleiß 0 %.
  Partitionen: 1 EFI 0,2 | 2 MSR 0,02 | 3 C: 237,38 | 4 Recovery 0,88 (HINTER C: → Schritt 7 relevant).
  Belegt 227,2 GB (C: fast voll). Extern D: Intenso 465,8 GB, frei 465,7 GB → reicht.
  USB-Stick = E: / Disk 2 „Generic Flash Disk“ 14,6 GB.
  Controller: Standard-NVMe, KEIN RST/VMD. BitLocker: aus, kein Schlüssel nötig.
