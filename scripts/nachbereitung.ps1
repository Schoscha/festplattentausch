<#
.SYNOPSIS
  Nach dem SSD-Tausch: prueft das Ergebnis und vergroessert C: auf den freien Platz.

.DESCRIPTION
  - Zeigt Datentraeger und Partitionen der neuen SSD.
  - Liegt direkt hinter C: freier Platz, wird C: auf Wunsch maximal vergroessert.
  - Liegt eine Wiederherstellungspartition dahinter, wird nur ein Hinweis ausgegeben
    (nichts wird geloescht).

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File .\nachbereitung.ps1
#>
$ErrorActionPreference = 'Stop'

$istAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $istAdmin) {
    Write-Host 'Bitte PowerShell als Administrator starten.' -ForegroundColor Red
    exit 1
}

$cPart = Get-Partition -DriveLetter C
$disk = $cPart | Get-Disk
$diskGB = [math]::Round($disk.Size / 1GB, 1)
Write-Host "Systemplatte: $($disk.FriendlyName), $diskGB GB, $($disk.PartitionStyle)"

Get-Partition -DiskNumber $disk.Number |
    Format-Table PartitionNumber, DriveLetter, Type,
        @{n = 'StartGB'; e = { [math]::Round($_.Offset / 1GB, 2) } },
        @{n = 'GroesseGB'; e = { [math]::Round($_.Size / 1GB, 2) } } -AutoSize

$max = (Get-PartitionSupportedSize -DriveLetter C).SizeMax
$zuwachsGB = [math]::Round(($max - $cPart.Size) / 1GB, 1)

if ($zuwachsGB -lt 1) {
    $danach = Get-Partition -DiskNumber $disk.Number | Where-Object { $_.Offset -gt $cPart.Offset }
    if ($danach) {
        Write-Host "C: kann nicht vergroessert werden: hinter C: liegt Partition $($danach[0].PartitionNumber) ($($danach[0].Type))." -ForegroundColor Yellow
        Write-Host 'Das ist meist die Wiederherstellungspartition (ca. 1 GB). Siehe Anleitung, Schritt 7.' -ForegroundColor Yellow
    } else {
        Write-Host 'C: nutzt bereits den gesamten Platz. Nichts zu tun.' -ForegroundColor Green
    }
    exit 0
}

$antwort = Read-Host "C: um $zuwachsGB GB vergroessern? (j/n)"
if ($antwort -eq 'j') {
    Resize-Partition -DriveLetter C -Size $max
    $neu = [math]::Round((Get-Partition -DriveLetter C).Size / 1GB, 1)
    Write-Host "Fertig. C: ist jetzt $neu GB gross." -ForegroundColor Green
} else {
    Write-Host 'Abgebrochen, nichts geaendert.'
}
