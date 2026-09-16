# MBPS Notion Sync — Auto-Start Installer
# Adds the file bridge to Windows startup so it runs every login

$startupFolder = [System.Environment]::GetFolderPath("Startup")
$bridgeScript  = Join-Path $PSScriptRoot "mbps-file-bridge.js"
$startupBat    = Join-Path $startupFolder "MBPS-Sync-Bridge.bat"

# Check Node.js
try {
    $nodeVersion = & node --version 2>$null
    Write-Host "  ✓  Node.js found: $nodeVersion"
} catch {
    Write-Host "  ✗  Node.js not found. Please install from https://nodejs.org (LTS version)."
    Read-Host "Press Enter to exit"
    exit 1
}

# Write startup bat to Startup folder
$batContent = @"
@echo off
timeout /t 8 /nobreak >nul
where node >nul 2>&1
if %errorlevel% neq 0 exit /b 0
cd /d "$PSScriptRoot"
start "MBPS Sync" /min cmd /c "node mbps-file-bridge.js >> crm-bridge-log.txt 2>&1"
"@

Set-Content -Path $startupBat -Value $batContent -Encoding ASCII
Write-Host "  ✓  Auto-start installed: $startupBat"

# Also start it right now (no need to reboot)
Write-Host "  ▶  Starting file bridge now..."
Start-Process -FilePath "node" -ArgumentList $bridgeScript -WorkingDirectory $PSScriptRoot -WindowStyle Minimized
Start-Sleep -Seconds 2

# Verify it's running
try {
    $resp = Invoke-WebRequest -Uri "http://127.0.0.1:4848/health" -UseBasicParsing -TimeoutSec 3
    Write-Host "  ✓  Bridge is live on localhost:4848"
} catch {
    Write-Host "  ⚠  Bridge starting up — it will be ready in a few seconds"
}

Write-Host ""
Write-Host "  All done! The sync bridge will now:"
Write-Host "    · Start automatically every time you log into Windows"
Write-Host "    · Save your CRM data to crm-sync-data.json on every change"
Write-Host "    · Cowork will push those changes to Notion every 5 minutes"
Write-Host ""
Read-Host "Press Enter to close"
