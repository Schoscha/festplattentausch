# Quellen & Doku-Auszüge

## Veeam Agent for Microsoft Windows (Free / Community Edition)
- Produktseite/Download: https://www.veeam.com/products/free/microsoft-windows.html
- Benutzerhandbuch „Protect Windows Computer“: https://helpcenter.veeam.com/docs/agentforwindows/userguide/howto_protect_computer.html?ver=40
- Kernaussagen:
  - Kostenlose Sicherung von Windows-Desktops/Laptops auf externe Festplatte, NAS-Freigabe oder Veeam-Repository.
  - Wiederherstellungsmedium auf USB-Stick, SD-Karte, CD/DVD oder als ISO.
  - Bare-Metal-Recovery des gesamten Rechners möglich.
  - Installation: Archiv entpacken, `VeeamAgentWindows_<version>.exe` ausführen.

## Clonezilla (verworfene Alternative)
- https://clonezilla.org/
- Kernaussage: Clonezilla verwendet partclone/ntfsclone; bei Dateisystemen, die es nicht erkennt
  (z. B. BitLocker-verschlüsselte Partitionen), wird die gesamte Partition mit `dd` kopiert →
  Image so groß wie die Partition, nicht wie die belegten Daten.

## BitLocker-Schlüssel online
- https://account.microsoft.com/devices/recoverykey

## Veeam Agent – Kommandozeile (Recherche 2026-10-03)
- Stille Installation: `VeeamAgentWindows_<ver>.exe /silent /accepteula /acceptthirdpartylicenses /acceptlicensingpolicy /acceptrequiredsoftware` (Admin-Shell) – https://wingetly.io/apps/veeam/veeam-agent/silent-install
- `Veeam.Agent.Configurator.exe -import` (Job per XML anlegen) nur in Workstation-/Server-Edition, **nicht Free** – https://helpcenter.veeam.com/docs/agentforwindows/configurator/import.html
- `Veeam.EndPoint.Manager.exe /standalone [<Ordner>]` erzeugt eine Vollsicherung, setzt aber einen angelegten Job voraus – https://helpcenter.veeam.com/docs/agentforwindows/userguide/backup_cmd.html
- Folge: In der Free-Edition muss der Backup-Job einmal in der GUI angelegt werden.
