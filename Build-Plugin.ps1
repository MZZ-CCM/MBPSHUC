# Build-Plugin.ps1
# Packages the moyo-crm-agent folder into a .plugin file.
# Double-click this file (or right-click → Run with PowerShell) to build.

$pluginDir  = Join-Path $PSScriptRoot "moyo-crm-agent"
$outputFile = Join-Path $PSScriptRoot "moyo-crm-agent.plugin"

if (-not (Test-Path $pluginDir)) {
    Write-Host "ERROR: Could not find moyo-crm-agent folder next to this script." -ForegroundColor Red
    pause
    exit 1
}

# Remove old build if it exists
if (Test-Path $outputFile) { Remove-Item $outputFile -Force }

# Create the zip / .plugin file
Compress-Archive -Path "$pluginDir\*" -DestinationPath $outputFile -Force

if (Test-Path $outputFile) {
    Write-Host ""
    Write-Host "SUCCESS: moyo-crm-agent.plugin created at:" -ForegroundColor Green
    Write-Host "  $outputFile" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Install it in Cowork: Settings → Plugins → Install from file" -ForegroundColor Yellow
} else {
    Write-Host "ERROR: Something went wrong — plugin file was not created." -ForegroundColor Red
}

pause
