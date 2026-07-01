$f = Get-Content -LiteralPath "D:\AtendimentoOfflineAlpha\docs\database\procedures_raw\sp_contexto_assert_transicao.json" -Raw -Encoding UTF8 | ConvertFrom-Json
$text = $f.text
$text = $text -replace "`r`n", "`n"

Write-Host "=== TEXT START ==="
Write-Host $text
Write-Host "=== TEXT END ==="

$inParams = $false
$paramLines = @()
foreach ($line in ($text -split "`n")) {
    $trimmed = $line.Trim()
    Write-Host "LINE: [$trimmed]"
    if ($trimmed -match '^PROCEDURE\s+') {
        Write-Host "MATCHED PROCEDURE"
        $inParams = $true
        continue
    }
    if ($inParams) {
        if ($trimmed -eq ')' -or $trimmed -match '^(BEGIN|AS\s+BEGIN|SQL\s+SECURITY)') {
            Write-Host "BREAKING"
            break
        }
        $paramLines += $trimmed
        Write-Host "ADDED PARAM LINE"
    }
}

Write-Host "=== PARAM LINES ==="
foreach ($p in $paramLines) { Write-Host $p }

Write-Host "=== REGEX TEST ==="
foreach ($p in $paramLines) {
    $m = [regex]::Match($p, '^(IN|OUT|INOUT)\s+([\w]+)\s+([\w]+(?:\([^)]*\))?)\s*,?\s*$')
    Write-Host "LINE: [$p] MATCH: $($m.Success) G1: $($m.Groups[1].Value) G2: $($m.Groups[2].Value) G3: $($m.Groups[3].Value)"
}
