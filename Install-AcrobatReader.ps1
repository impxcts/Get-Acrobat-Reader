<#
.SYNOPSIS
    Downloads and silently installs Adobe Acrobat Reader (64-bit) on Windows.

.DESCRIPTION
    Intended for use on a freshly imaged / first-boot PC. Fetches the current
    download link directly from Adobe's own distribution API, so it always
    grabs the latest version rather than a hardcoded/stale URL.
    Requires an active internet connection and admin rights (machine-wide install).

.NOTES
    Run from an elevated PowerShell prompt:
        powershell.exe -ExecutionPolicy Bypass -File .\Install-AcrobatReader.ps1
#>

# Require admin rights for a machine-wide install
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run as Administrator. Right-click PowerShell and choose 'Run as administrator'."
    exit 1
}

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    Write-Host "Looking up the latest Adobe Acrobat Reader version..."

    $apiKey  = "dc-get-adobereader-cdn"
    $lang    = "en"
    $os      = "Windows%2010"

    $productsUrl = "https://rdc.adobe.io/reader/products?lang=$lang&site=enterprise&os=$os&api_key=$apiKey"
    $products    = Invoke-RestMethod -Uri $productsUrl -UseBasicParsing
    $displayName = $products.products.reader.displayName

    $downloadApiUrl = "https://rdc.adobe.io/reader/downloadUrl?name=$displayName&os=$os&site=enterprise&lang=$lang&api_key=$apiKey"
    $downloadInfo   = Invoke-RestMethod -Uri $downloadApiUrl -UseBasicParsing

    $installerUrl  = $downloadInfo.downloadURL
    $installerName = $downloadInfo.saveName
    $installerPath = Join-Path $env:TEMP $installerName

    if (-not $installerUrl) {
        throw "Could not resolve a download URL from Adobe's distribution API."
    }

    Write-Host "Downloading Adobe Acrobat Reader installer ($installerName)..."
    Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath -UseBasicParsing

    Write-Host "Installing Adobe Acrobat Reader silently..."
    $process = Start-Process -FilePath $installerPath -ArgumentList "/sAll", "/rs", "/msi EULA_ACCEPT=YES /qn" -Wait -PassThru

    if ($process.ExitCode -eq 0) {
        Write-Host "Adobe Acrobat Reader installed successfully."
    } else {
        Write-Warning "Installer exited with code $($process.ExitCode)."
    }

    # Clean up the installer
    Remove-Item $installerPath -Force -ErrorAction SilentlyContinue

    # Launch Acrobat Reader once installed
    $readerPaths = @(
        "$env:ProgramFiles\Adobe\Acrobat DC\Acrobat\Acrobat.exe",
        "${env:ProgramFiles(x86)}\Adobe\Acrobat DC\Acrobat\Acrobat.exe",
        "$env:ProgramFiles\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe",
        "${env:ProgramFiles(x86)}\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe"
    )
    $readerExe = $readerPaths | Where-Object { Test-Path $_ } | Select-Object -First 1

    if ($readerExe) {
        Write-Host "Launching Adobe Acrobat Reader..."
        Start-Process -FilePath $readerExe
    } else {
        Write-Warning "Could not locate the Acrobat Reader executable to launch it automatically."
    }
}
catch {
    Write-Error "Something went wrong: $($_.Exception.Message)"
    exit 1
}
