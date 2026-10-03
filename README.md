# Festplattentausch – Windows 11 Laptop mit nur einem M.2-Steckplatz

Die interne M.2-SSD soll auf eine neue SSD mit doppelter Kapazität umziehen.
Weil es nur einen Steckplatz gibt, kann die neue SSD erst bespielt werden, wenn sie eingebaut ist.

**→ Schritt-für-Schritt: [ANLEITUNG.md](ANLEITUNG.md)**

## Optionen im Vergleich
| Option | Zusätzlich nötig | Aufwand | Bewertung |
|---|---|---|---|
| A) USB-M.2-Gehäuse + direkt klonen | Gehäuse für ca. 15–25 € | 1 Durchgang, ca. 1 h | Am einfachsten, aber kein Adapter vorhanden |
| **B) Image auf externe Festplatte → tauschen → zurückspielen** | Externe Festplatte + USB-Stick ≥ 8 GB | 2 Durchgänge, ca. 1,5–3 h | **Gewählt** |
| C) Windows neu installieren + Daten übertragen | USB-Stick, Zeit | Hoch | Nur sinnvoll, wenn das System sowieso aufgeräumt werden soll |

**Werkzeug für B:** Veeam Agent for Microsoft Windows (kostenlos). Begründung siehe [ANLEITUNG.md](ANLEITUNG.md#warum-veeam-statt-clonezilla).

## Inhalt
| Datei | Zweck |
|---|---|
| [ANLEITUNG.md](ANLEITUNG.md) | Ablauf in 7 Schritten inkl. Fehlerbehebung |
| [scripts/vorbereitung.ps1](scripts/vorbereitung.ps1) | Liest nur aus: Bericht zu Festplatte, Platzbedarf, SSD-Zustand und RST/VMD, sichert den BitLocker-Schlüssel |
| [scripts/nachbereitung.ps1](scripts/nachbereitung.ps1) | Nach dem Tausch: prüft die Partitionen und vergrößert C: auf den neuen Platz |
| [dokumentationen/quellen.md](dokumentationen/quellen.md) | Quellen und Auszüge aus der Doku |
| [memory.md](memory.md) | Projektstand, Entscheidungen, offene Aufgaben |

## Status
- [x] Optionen geprüft, Option B gewählt
- [x] Anleitung und Skripte erstellt
- [ ] Schritte 1–4: Prüfung, Veeam, Sicherung, Rettungsstick
- [ ] Schritte 5–7: Tausch, Zurückspielen, Kontrolle
