$ts = (Get-Date).ToString('yyyyMMdd_HHmmss')
$out = "scripts/backups/backup_pronto_atendimento_$ts.sql"
if (-not (Test-Path 'scripts/backups')) { New-Item -ItemType Directory -Path 'scripts/backups' | Out-Null }
& 'C:\xampp\mysql\bin\mysqldump.exe' -u root -proot --single-transaction --routines --triggers pronto_atendimento | Out-File -FilePath $out -Encoding UTF8
Write-Output $out
