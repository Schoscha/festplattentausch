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
