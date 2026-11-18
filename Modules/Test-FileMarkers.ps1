function Test-FileMarkers {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string[]]$Patterns
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "FILE NOT FOUND: $Path"
    }

    foreach ($pattern in $Patterns) {
        $count = (Select-String -LiteralPath $Path -Pattern $pattern -AllMatches |
            ForEach-Object { $_.Matches.Count } |
            Measure-Object -Sum).Sum
        if ($null -eq $count) { $count = 0 }
        [pscustomobject]@{
            Pattern = $pattern
            Count   = [int]$count
            Found   = ([int]$count -gt 0)
        }
    }
}
