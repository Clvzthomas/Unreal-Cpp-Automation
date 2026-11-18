[CmdletBinding()]
param(
    [string]$ConfigPath = (Join-Path $PSScriptRoot "..\Config\ProjectConfig.psd1")
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $ConfigPath -PathType Leaf)) {
    throw "Config not found: $ConfigPath. Copy ProjectConfig.example.psd1 to ProjectConfig.psd1 and edit it."
}

$config = Import-PowerShellDataFile -LiteralPath $ConfigPath
$projectPath = Join-Path $config.ProjectRoot $config.ProjectFile

foreach ($required in @($config.ProjectRoot, $projectPath, $config.BuildBatch)) {
    if (-not (Test-Path -LiteralPath $required)) {
        throw "Required path not found: $required"
    }
}

$args = @(
    $config.Target,
    $config.Platform,
    $config.Configuration,
    "-project=`"$projectPath`""
)
if ($config.ExtraBuildArguments) {
    $args += @($config.ExtraBuildArguments)
}

Write-Host "Building Unreal project..."
Write-Host "Project: $projectPath"
Write-Host "Target:  $($config.Target) $($config.Platform) $($config.Configuration)"
Write-Host ""

& $config.BuildBatch @args
$buildExitCode = $LASTEXITCODE

if ($buildExitCode -eq 0) {
    Write-Host "BUILD SUCCEEDED" -ForegroundColor Green
} else {
    Write-Error "BUILD FAILED (exit code $buildExitCode)"
}
exit $buildExitCode
