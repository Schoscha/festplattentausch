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
- [ ] Nutzer: Schritt 1–4 (Prüfung, Veeam, Backup, Recovery-Stick)
- [ ] Nutzer: Schritt 5–7 (Tausch, Restore, Kontrolle)
- [ ] Ggf. WinRE-Partition verschieben, falls hinter C:

## Offene Punkte
- USB-Stick ≥ 8 GB vorhanden (bestätigt 2026-10-03).
- 2026-10-03: Schritt 1 angefragt. Laptop nicht erreichbar → Nutzer führt Skript selbst aus.
- 2026-10-03: Skripte per PowerShell-7-Parser geprüft (0 Fehler). Fix vorbereitung.ps1: SSD-Zustand per DeviceId statt Pipeline Disk→Get-PhysicalDisk.
- Warte auf Bericht.txt aus Schritt 1.
