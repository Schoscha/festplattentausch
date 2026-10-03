<#
.SYNOPSIS
  Vorbereitung SSD-Tausch (Windows 11, Laptop, ein M.2-Steckplatz).

.DESCRIPTION
  Liest nur aus und schreibt zwei Textdateien auf das externe Laufwerk:
    - Bericht.txt            : Datentraeger, Partitionen, SSD-Zustand, Platzbedarf
    - BitLocker-Schluessel.txt: Wiederherstellungsschluessel (falls verschluesselt)
  Es wird NICHTS am System veraendert.

.PARAMETER Ziel
  Laufwerk/Ordner auf dem externen Datentraeger, z. B. E:\

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File .\vorbereitung.ps1 -Ziel E:\
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$Ziel
)

$ErrorActionPreference = 'Stop'

$istAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $istAdmin) {
    Write-Host 'Bitte PowerShell als Administrator starten (Rechtsklick > Als Administrator ausfuehren).' -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $Ziel)) {
    Write-Host "Ziel '$Ziel' nicht gefunden. Externes Laufwerk angeschlossen?" -ForegroundColor Red
    exit 1
}

$ordner = Join-Path $Ziel 'SSD-Tausch'
New-Item -ItemType Directory -Path $ordner -Force | Out-Null
$bericht = Join-Path $ordner 'Bericht.txt'
$warnungen = New-Object System.Collections.Generic.List[string]

function Abschnitt([string]$titel) { "`r`n===== $titel =====" }

$text = @()
$text += "SSD-Tausch Vorbereitung - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
$text += "Rechner: $env:COMPUTERNAME"

# --- System ---
$text += Abschnitt 'System'
$cs = Get-CimInstance Win32_ComputerSystem
$os = Get-CimInstance Win32_OperatingSystem
$text += "Modell : $($cs.Manufacturer) $($cs.Model)"
$text += "Windows: $($os.Caption) $($os.Version)"
try { $text += "Firmware: $(if ($env:firmware_type) { $env:firmware_type } else { (Get-ComputerInfo -Property BiosFirmwareType).BiosFirmwareType })" } catch {}

# --- Datentraeger ---
$text += Abschnitt 'Physische Datentraeger'
$text += (Get-PhysicalDisk | Sort-Object DeviceId |
    Format-Table DeviceId, FriendlyName, BusType, MediaType,
        @{n = 'GroesseGB'; e = { [math]::Round($_.Size / 1GB, 1) } }, HealthStatus -AutoSize |
    Out-String).TrimEnd()

$systemDisk = Get-Partition -DriveLetter C | Get-Disk
$text += Abschnitt "Partitionen der Systemplatte (Disk $($systemDisk.Number))"
$text += "Partitionsstil: $($systemDisk.PartitionStyle)"
$text += (Get-Partition -DiskNumber $systemDisk.Number |
    Format-Table PartitionNumber, DriveLetter, Type,
        @{n = 'GroesseGB'; e = { [math]::Round($_.Size / 1GB, 2) } } -AutoSize |
    Out-String).TrimEnd()

# --- Platzbedarf ---
$text += Abschnitt 'Platzbedarf'
$belegtGB = 0
foreach ($v in Get-Volume | Where-Object { $_.DriveType -eq 'Fixed' -and $_.Size -gt 0 }) {
    $part = Get-Partition -Volume $v -ErrorAction SilentlyContinue
    if ($part -and $part.DiskNumber -eq $systemDisk.Number) {
        $belegtGB += ($v.Size - $v.SizeRemaining) / 1GB
    }
}
$belegtGB = [math]::Round($belegtGB, 1)
$zielLw = (Get-Item $Ziel).PSDrive.Name
$freiZielGB = [math]::Round((Get-PSDrive $zielLw).Free / 1GB, 1)
$text += "Belegt auf Systemplatte : $belegtGB GB"
$text += "Frei auf Ziel ($zielLw`:)        : $freiZielGB GB"
if ($freiZielGB -lt $belegtGB) {
    $warnungen.Add("Externes Laufwerk hat evtl. zu wenig Platz ($freiZielGB GB frei, $belegtGB GB belegt). Veeam komprimiert zwar, aber besser vorher Platz schaffen.")
}

# --- SSD-Zustand ---
$text += Abschnitt 'SSD-Zustand'
try {
    $rc = $systemDisk | Get-PhysicalDisk | Get-StorageReliabilityCounter
    $text += "Verschleiss (%)      : $($rc.Wear)"
    $text += "Temperatur (C)       : $($rc.Temperature)"
    $text += "Lesefehler (unkorr.) : $($rc.ReadErrorsUncorrected)"
    if ($rc.ReadErrorsUncorrected -gt 0) { $warnungen.Add('SSD meldet unkorrigierbare Lesefehler - Backup zeitnah machen, Sicherung danach pruefen.') }
} catch {
    $text += 'Nicht auslesbar (Treiber liefert keine Werte) - unkritisch.'
}

# --- Speichercontroller (wichtig fuer Wiederherstellungsmedium) ---
$text += Abschnitt 'Speichercontroller'
$ctrl = Get-CimInstance Win32_SCSIController | Select-Object -ExpandProperty Name
$text += ($ctrl -join "`r`n")
if ($ctrl -match 'RST|VMD|Rapid Storage|Volume Management') {
    $warnungen.Add('Intel RST/VMD erkannt: Beim Erstellen des Veeam-Wiederherstellungsmediums unbedingt "Hardwaretreiber dieses Computers einbinden" aktiviert lassen.')
}

# --- BitLocker ---
$text += Abschnitt 'BitLocker / Geraeteverschluesselung'
$schluesselDatei = Join-Path $ordner 'BitLocker-Schluessel.txt'
try {
    $blv = Get-BitLockerVolume -ErrorAction Stop
    $text += ($blv | Format-Table MountPoint, VolumeStatus, ProtectionStatus, EncryptionPercentage -AutoSize | Out-String).TrimEnd()
    $schluessel = @()
    foreach ($b in $blv) {
        foreach ($kp in $b.KeyProtector | Where-Object { $_.KeyProtectorType -eq 'RecoveryPassword' }) {
            $schluessel += "Laufwerk $($b.MountPoint)  ID: $($kp.KeyProtectorId)  Schluessel: $($kp.RecoveryPassword)"
        }
    }
    if ($schluessel.Count -gt 0) {
        $schluessel | Set-Content -Path $schluesselDatei -Encoding UTF8
        $text += "Wiederherstellungsschluessel gespeichert: $schluesselDatei"
        $warnungen.Add("BitLocker-Schluessel liegt in $schluesselDatei - zusaetzlich abfotografieren/ausdrucken, Datei nach erfolgreichem Tausch loeschen.")
    } else {
        $text += 'Kein Wiederherstellungsschluessel vorhanden (Laufwerk vermutlich unverschluesselt).'
    }
} catch {
    $text += 'BitLocker-Modul nicht verfuegbar, Ausgabe von manage-bde:'
    $text += (manage-bde -status C: | Out-String).TrimEnd()
    $text += 'Schluessel ggf. unter https://account.microsoft.com/devices/recoverykey abrufen.'
}

# --- Ergebnis ---
$text += Abschnitt 'Hinweise'
if ($warnungen.Count -eq 0) { $text += 'Keine Auffaelligkeiten. Weiter mit Schritt 2 der Anleitung.' }
else { $text += $warnungen | ForEach-Object { "- $_" } }

$text | Set-Content -Path $bericht -Encoding UTF8
$text | Write-Host
Write-Host "`r`nBericht gespeichert: $bericht" -ForegroundColor Green
