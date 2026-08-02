$content = [System.IO.File]::ReadAllText("D:\AtendimentoOfflineAlpha\database\dump\Dump20260726.sql")
$sps = @("sp_master_login", "sp_auth_contexto_get", "sp_auth_contexto_set", "sp_sessao_contexto_get", "sp_sessao_contexto_set")

foreach ($sp in $sps) {
    $startMarker = "CREATE DEFINER=`root`@`localhost` PROCEDURE `$sp`"
    $start = $content.IndexOf($startMarker)
    if ($start -ge 0) {
        $afterStart = $content.Substring($start)
        $lines = $afterStart -split "`r`n"
        $spLines = @()
        foreach ($line in $lines) {
            $spLines += $line
            if ($line.Trim() -eq ";;") {
                break
            }
        }
        $spText = $spLines -join "`r`n"
        Write-Host "=== $sp ==="
        Write-Host $spText
    } else {
        Write-Host "=== $sp === NOT FOUND"
    }
    Write-Host ""
}
