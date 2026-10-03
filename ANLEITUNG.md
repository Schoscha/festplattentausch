# SSD-Tausch: Windows 11 Laptop, ein M.2-Steckplatz, ohne Adapter

**Methode:** Komplettsicherung auf eine externe Festplatte → SSD tauschen → Sicherung zurückspielen.
**Werkzeug:** Veeam Agent for Microsoft Windows (kostenlos)
**Dauer:** etwa 1,5 bis 3 Stunden, je nach Datenmenge

## Warum Veeam statt Clonezilla?
- Die Sicherung läuft direkt unter Windows. Du brauchst kein Linux-Rettungssystem.
- Ist BitLocker oder die Geräteverschlüsselung aktiv, kann Clonezilla die Partition nicht lesen. Es kopiert sie dann Sektor für Sektor, und das Image wird so groß wie die ganze Partition. Veeam sichert dagegen nur die belegten Daten.
- Das Wiederherstellungsmedium enthält die Speichertreiber deines Laptops (Intel RST/VMD). Dadurch wird die neue SSD beim Zurückspielen sicher erkannt.
- Beim Zurückspielen kannst du C: direkt auf die doppelte Größe ziehen.

## Was du brauchst
- [ ] Externe Festplatte mit mindestens so viel freiem Platz, wie auf C: belegt ist
- [ ] **Zusätzlichen USB-Stick mit mindestens 8 GB.** Er wird für das Rettungssystem komplett gelöscht.
- [ ] Netzteil am Laptop, kleinen Kreuzschlitzschraubendreher (oft PH0/PH00), eventuell Plastikhebel
- [ ] Die Schraube oder Halterung der alten SSD aufbewahren, sie wird für die neue gebraucht

---

## Schritt 1 – Vorbereitung prüfen (Skript, etwa 1 Minute)
1. Externe Festplatte anschließen und den Laufwerksbuchstaben merken (z. B. `E:`).
2. `scripts\vorbereitung.ps1` auf den Laptop kopieren.
3. Startmenü → „PowerShell“ → Rechtsklick → **Als Administrator ausführen**:
   ```powershell
   powershell -ExecutionPolicy Bypass -File "$HOME\Downloads\vorbereitung.ps1" -Ziel E:\
   ```
4. Ergebnis ansehen in `E:\SSD-Tausch\Bericht.txt`. Das Skript **ändert nichts** am System. Es
   - zeigt SSD, Partitionen, belegten Platz und freien Platz auf der externen Festplatte,
   - liest den Zustand der SSD aus,
   - erkennt Intel RST/VMD,
   - speichert den **BitLocker-Wiederherstellungsschlüssel** in `BitLocker-Schluessel.txt`.
     Den Schlüssel zusätzlich abfotografieren. Er ist auch unter https://account.microsoft.com/devices/recoverykey abrufbar.

## Schritt 2 – Veeam installieren
1. Download: https://www.veeam.com/products/free/microsoft-windows.html (kostenloses Konto nötig)
2. Archiv entpacken, `VeeamAgentWindows_<version>.exe` ausführen und Standardoptionen übernehmen.
3. Fragt die Installation nach einem Backup-Ziel, **„Skip“** wählen. Den Job legen wir in Schritt 3 an.

## Schritt 3 – Komplettsicherung erstellen
1. Veeam öffnen (Symbol im Infobereich) → Menü ☰ → **Add New Job**.
2. Name: `SSD-Tausch`.
3. Backup Mode: **Entire computer**.
4. Destination: **Local storage** → externe Festplatte wählen (z. B. `E:\VeeamBackup`).
5. Schedule: **Häkchen entfernen**, damit der Job nur einmal läuft.
6. **Apply** → Häkchen bei **Run the job when I click Finish** → Finish.
7. Warten, bis der Status **Success** anzeigt. Bei „Warning“ oder „Failed“ nicht weitermachen und mir die Meldung schicken.

## Schritt 4 – Wiederherstellungsmedium erstellen (USB-Stick)
1. USB-Stick einstecken. Die externe Festplatte kann dranbleiben.
2. Veeam → Menü ☰ → **Create Recovery Media**.
3. Ziel: **Removable storage device** → den **USB-Stick** wählen. Den Buchstaben genau prüfen!
4. Häkchen **Include hardware drivers from this computer** aktiviert lassen. Das ist wichtig für die NVMe-Erkennung.
5. Create und warten.
6. **Test:** Laptop neu starten und vom Stick booten. Das Bootmenü öffnet sich je nach Hersteller mit F12, F9, F11 oder Esc. Erscheint die Veeam-Oberfläche, den Rechner wieder ausschalten.

> Erst wenn Schritt 3 erfolgreich war **und** der Stick bootet, die SSD tauschen.

## Schritt 5 – SSD tauschen
1. Laptop **herunterfahren**, nicht in den Ruhezustand schicken. Sicherer ist es, beim Klick auf „Herunterfahren“ die Umschalttaste gedrückt zu halten (deaktiviert den Schnellstart). Netzteil abziehen.
2. Bodenplatte lösen. Die Anleitung für dein Modell findest du beim Hersteller oder auf iFixit, Suche nach dem Modell aus `Bericht.txt`.
3. Falls der Laptop das erlaubt, den Akkustecker abziehen oder im BIOS den „Battery Disconnect“ bzw. „Ship Mode“ aktivieren.
4. Schraube der alten SSD lösen, SSD schräg herausziehen, die neue im gleichen Winkel einstecken und festschrauben. Einen vorhandenen Wärmeleitpad oder Kühlkörper übernehmen.
5. Akku wieder anstecken, Boden schließen, Netzteil anschließen.
6. **Die alte SSD unverändert aufbewahren.** Sie ist dein Notfall-Backup.

## Schritt 6 – Sicherung zurückspielen
1. USB-Stick **und** externe Festplatte anschließen, vom Stick booten.
2. Veeam Recovery: **Bare Metal Recovery** → **Local storage** → die Sicherung auf der externen Festplatte wählen (wird meist automatisch gefunden).
3. Restore Point: den neuesten wählen.
4. Restore Mode: **Entire computer**.
5. Disk Mapping: als Ziel die **neue SSD** wählen. Über **Customize disk mapping** kannst du die Partition C: auf den vollen Platz vergrößern (**Resize**). Das kannst du auch auslassen und Schritt 7 nutzen.
6. Restore starten. Danach Stick und externe Festplatte abziehen und neu starten.

## Schritt 7 – Kontrolle und Speicherplatz nutzen
1. Windows startet wie gewohnt, mit allen Programmen und Daten.
2. `scripts\nachbereitung.ps1` als Administrator ausführen:
   ```powershell
   powershell -ExecutionPolicy Bypass -File "$HOME\Downloads\nachbereitung.ps1"
   ```
   Das Skript zeigt die Partitionen und vergrößert C: auf Nachfrage.
   Meldet es, dass eine **Wiederherstellungspartition hinter C:** im Weg liegt, schick mir die Ausgabe. Den Fall löse ich dann gezielt (WinRE verschieben).
3. Geräteverschlüsselung bzw. BitLocker unter *Einstellungen → Datenschutz & Sicherheit → Geräteverschlüsselung* prüfen und bei Bedarf wieder aktivieren.
4. Windows-Aktivierung prüfen: *Einstellungen → System → Aktivierung*. Das ist bei einem SSD-Tausch normalerweise kein Problem.
5. Erst nach ein paar Tagen ohne Probleme: Veeam-Sicherung und `BitLocker-Schluessel.txt` auf der externen Festplatte löschen. Die alte SSD darfst du dann weiterverwenden.

---

## Wenn etwas schiefgeht
| Problem | Lösung |
|---|---|
| Laptop bootet nicht vom Stick | Im BIOS „Secure Boot“ kurz prüfen, die Taste fürs Bootmenü ausprobieren und einen anderen USB-Anschluss nehmen |
| Veeam sieht die neue SSD nicht | Beim Recovery-Medium unter „Load driver“ den Treiber laden, oder im BIOS den SATA-Modus von RST/VMD auf AHCI stellen und **nach** dem Restore wieder zurückstellen |
| Nach dem Restore fragt Windows nach dem BitLocker-Schlüssel | Schlüssel aus `BitLocker-Schluessel.txt` bzw. dem Foto eingeben |
| Totalausfall | Alte SSD wieder einbauen. Sie ist unverändert, und der Ausgangszustand ist sofort wiederhergestellt |
