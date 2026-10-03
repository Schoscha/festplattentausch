# memory.md – Festplattentausch

## Ziel
Interne M.2-SSD eines Windows-11-Laptops auf neue SSD (doppelte Kapazität) übertragen.
Laptop hat nur einen M.2-Steckplatz, kein USB-M.2-Adapter vorhanden.

## Entscheidungen
- 2026-10-03: Option B (Image auf externe Festplatte → tauschen → zurückspielen).
- Werkzeug: Veeam Agent for Windows Free (statt Clonezilla wegen BitLocker/VMD/Resize).
- Desktop-Commander-Gerät „Detlef“: NICHT verwenden – Nutzer arbeitet dort nie mehr.
  Entfernen muss der Nutzer selbst unter https://mcp.desktopcommander.app/ (kein Tool dafür).
- Ziel-Laptop ist nicht per Desktop Commander verbunden → Nutzer führt Skripte selbst aus.

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
- 2026-10-03: Schritt 1 angefragt. Laptop nicht erreichbar (nur „Detlef“, offline) → Nutzer führt Skript selbst aus.
- 2026-10-03: Skripte per PowerShell-7-Parser geprüft (0 Fehler). Fix vorbereitung.ps1: SSD-Zustand per DeviceId statt Pipeline Disk→Get-PhysicalDisk.
- Warte auf Bericht.txt aus Schritt 1.
