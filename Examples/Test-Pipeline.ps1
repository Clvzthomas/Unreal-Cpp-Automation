$configPath = Join-Path $PSScriptRoot "..\Config\ProjectConfig.psd1"
$exampleConfig = Join-Path $PSScriptRoot "..\Config\ProjectConfig.example.psd1"

if (-not (Test-Path -LiteralPath $configPath)) {
    Write-Host "CONFIG NOT SET UP YET."
    Write-Host "Copy:"
    Write-Host "  $exampleConfig"
    Write-Host "To:"
    Write-Host "  $configPath"
    Write-Host "Then edit the project and engine paths."
    exit 0
}

$config = Import-PowerShellDataFile -LiteralPath $configPath
$config.GetEnumerator() | Sort-Object Name | Format-Table -AutoSize
Write-Host "Configuration loaded. This test did not modify any project files."
