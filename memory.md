# memory.md – Festplattentausch

> Stand: 2026-10-03. Wer hier weitermacht, liest zuerst diesen Abschnitt.

## Ziel
Die interne M.2-SSD des Laptops „Sascha-Lenovo“ wird gegen eine neue M.2-2280-NVMe-SSD mit doppelter Kapazität (512 GB) getauscht.
Der Laptop hat nur einen M.2-Steckplatz, einen USB-M.2-Adapter gibt es nicht.
**Methode:** Komplettsicherung mit Veeam Agent Free auf die externe Festplatte D: → SSD tauschen → Sicherung vom Veeam-USB-Stick zurückspielen. Die vollständige Anleitung steht in `ANLEITUNG.md`.

## Aktueller Stand: hier weitermachen
**Nächster Schritt: Schritt 3, die Komplettsicherung. Sie ist noch NICHT gelaufen.**
- Veeam ist installiert, der Recovery-USB-Stick ist erstellt.
- Der Backup-Job ist noch nicht angelegt. In der Free-Edition geht das nur über die Oberfläche, nicht per Kommandozeile:
  ☰ → Add New Job → Name `SSD-Tausch` → Entire computer → Local storage → `D:\VeeamBackup` → Schedule-Häkchen weg → Apply → „Run the job when I click Finish“ → Finish.
- Danach: Status prüfen (Success, Warning oder Failed), dann testen, ob der Laptop vom Stick startet (ThinkPad-Bootmenü: **F12**). Erst danach Schritt 5 (Tausch).

## Desktop Commander (Fernzugriff)
- Auf dem Laptop läuft das Remote Device, gestartet mit `npx @wonderwhy-er/desktop-commander@latest remote`.
  - Desktop-Commander-Konto: **zweites (Gmail-)Konto des Nutzers** (Adresse siehe Chat)
  - Device-ID: `c4f8c842-ff44-4d80-bea3-737e8f7b465e`, Name „Sascha-Lenovo“
- **Problem:** Der Desktop-Commander-Connector in Claude (claude.ai) hängt an einem ANDEREN Desktop-Commander-Konto. Dort ist nur das Gerät „Detlef“ (cce34539-…) registriert, und es ist seit über 115 Stunden offline. Deshalb meldet `list_devices` und `ping` „No device online“, der Laptop ist für Claude nicht erreichbar.
- **Lösung:** Unter https://claude.ai/customize/connectors bei Desktop Commander auf Disconnect und dann auf Connect klicken und mit **dem zweiten (Gmail-)Konto des Nutzers** anmelden. Danach eventuell eine neue Session starten. Die PowerShell mit dem Remote Device muss offen bleiben.
- Das Claude-Konto hat damit nichts zu tun.
- Das Gerät „Detlef“ ist veraltet und soll nicht verwendet werden.

## Ergebnis Schritt 1 (Bericht.txt, 2026-10-03 03:30)
| Punkt | Wert |
|---|---|
| Modell | LENOVO 20QGS0QU00, Windows 11 Pro 10.0.26200, UEFI, GPT |
| Alte SSD | Toshiba KXG50ZNV256G NVMe, 238,5 GB, Healthy, Verschleiß 0 %, 35 °C |
| Partitionen Disk 0 | 1 EFI 0,2 GB · 2 MSR 0,02 GB · 3 C: 237,38 GB · **4 Recovery 0,88 GB (liegt HINTER C:)** |
| Belegt | 227,2 GB (C: ist fast voll) |
| Externe Festplatte | **D:** Intenso USB 3.0, 465,8 GB, 465,7 GB frei → reicht |
| USB-Stick | **E:**, Disk 2 „Generic Flash Disk“, 14,6 GB → ist jetzt der Veeam-Recovery-Stick |
| Controller | Standard-NVMe, **kein RST/VMD** → keine Zusatztreiber nötig |
| BitLocker | aus (C:, D:, E:) → kein Wiederherstellungsschlüssel nötig |

**Folgen:**
- Wegen der Recovery-Partition hinter C: lässt sich C: nach dem Restore nicht einfach vergrößern. Zuerst in Schritt 6 „Customize disk mapping → Resize“ versuchen. Klappt das nicht, in Schritt 7 die WinRE-Partition verschieben (reagentc /disable → Partition löschen → C: erweitern → Recovery neu anlegen → reagentc /enable).
- Bei allen Laufwerksauswahlen gilt: **D: = Sicherung, E: = Stick.** Niemals verwechseln.

## Entscheidungen
- Option B: Image auf externe Festplatte, tauschen, zurückspielen.
- Werkzeug Veeam Agent Free statt Clonezilla, weil es BitLocker, VMD und das Vergrößern beim Restore beherrscht.
- `Veeam.Agent.Configurator.exe -import` gibt es nur in der Workstation- und Server-Edition. In der Free-Edition muss der Job deshalb über die Oberfläche angelegt werden (Quellen in `dokumentationen/quellen.md`).
- Der Nutzer will, dass Claude möglichst alles selbst ausführt. Das geht nur über Desktop Commander mit dem richtigen Konto (siehe oben).

## Tasks
- [x] Optionen aufzeigen, ANLEITUNG.md, README.md
- [x] scripts/vorbereitung.ps1 (nur lesend), scripts/nachbereitung.ps1 (C: vergrößern)
- [x] Skripte mit PowerShell 7 auf Syntax geprüft (0 Fehler). Fix: Der SSD-Zustand wird jetzt per DeviceId ausgelesen.
- [x] Schritt 1: Prüfung (Bericht ausgewertet)
- [x] Schritt 2: Veeam installiert
- [x] Schritt 4: Recovery-Stick erstellt (E:)
- [ ] Desktop-Commander-Connector auf das zweite (Gmail-)Konto des Nutzers umstellen (Nutzer)
- [ ] **Schritt 3: Komplettsicherung nach D:\VeeamBackup**, Status Success
- [ ] Boot-Test vom Stick (F12)
- [ ] Schritt 5: SSD tauschen (alte SSD unverändert aufbewahren)
- [ ] Schritt 6: Restore, dabei C: vergrößern
- [ ] Schritt 7: nachbereitung.ps1, eventuell WinRE verschieben, Aktivierung prüfen

## Session-Verlauf
Siehe `dokumentationen/session-2026-10-03.md`.
