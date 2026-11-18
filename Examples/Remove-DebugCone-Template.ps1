# TEMPLATE ONLY: inspect the target source and adapt the exact OldText/NewText
# blocks before running. This intentionally does not edit any file by itself.

$configPath = Join-Path $PSScriptRoot "..\Config\ProjectConfig.psd1"
if (-not (Test-Path -LiteralPath $configPath)) {
    throw "Create Config\ProjectConfig.psd1 first."
}
$config = Import-PowerShellDataFile -LiteralPath $configPath
$target = Join-Path $config.ProjectRoot "Source\MyGame\MyAttackComponent.cpp"

Write-Host "Example target: $target"
Write-Host "Search first:"
Select-String -LiteralPath $target -Pattern "DrawDebugCone" -Context 5,12
Write-Host ""
Write-Host "Review the complete containing block, then use Invoke-ExactTextPatch with exact old/new text."
Write-Host "No files were modified."
