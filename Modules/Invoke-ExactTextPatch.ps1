function Invoke-ExactTextPatch {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][AllowEmptyString()][string]$OldText,
        [Parameter(Mandatory)][AllowEmptyString()][string]$NewText,
        [Parameter(Mandatory)][string]$BackupRoot
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "TARGET NOT FOUND - nothing saved: $Path"
    }
    if ($OldText.Length -eq 0) {
        throw "OldText cannot be empty."
    }

    $resolved = (Resolve-Path -LiteralPath $Path).Path
    $content = [System.IO.File]::ReadAllText($resolved)

    $oldCount = ([regex]::Matches(
        $content,
        [regex]::Escape($OldText),
        [System.Text.RegularExpressions.RegexOptions]::CultureInvariant
    )).Count

    $newCount = ([regex]::Matches(
        $content,
        [regex]::Escape($NewText),
        [System.Text.RegularExpressions.RegexOptions]::CultureInvariant
    )).Count

    if ($oldCount -eq 0 -and $newCount -gt 0) {
        Write-Output "ALREADY APPLIED - no changes made"
        return
    }
    if ($oldCount -ne 1) {
        throw "PATCH NOT APPLIED - expected exactly 1 old-text match; found $oldCount. Nothing saved."
    }

    $updated = $content.Replace($OldText, $NewText)
    if ($updated -eq $content) {
        Write-Output "NO CHANGE - replacement produced identical content"
        return
    }

    $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $backupDir = Join-Path $BackupRoot $stamp
    $null = New-Item -ItemType Directory -Path $backupDir -Force
    $relativeName = [System.IO.Path]::GetFileName($resolved)
    $backupPath = Join-Path $backupDir $relativeName

    if ($PSCmdlet.ShouldProcess($resolved, "Back up to '$backupPath' and apply exact patch")) {
        Copy-Item -LiteralPath $resolved -Destination $backupPath -Force
        $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($resolved, $updated, $utf8NoBom)
        Write-Output "OK - patch applied"
        Write-Output "BACKUP - $backupPath"
    }
}
