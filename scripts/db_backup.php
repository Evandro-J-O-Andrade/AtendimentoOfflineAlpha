<?php
// scripts/db_backup.php
// Tenta localizar mysqldump e executar um dump completo com rotinas e triggers
require_once __DIR__ . '/../src/api/config.php';

// Extrai credenciais do config (duplicando lógica simples)
$host = '127.0.0.1';
$db   = 'pronto_atendimento';
$user = 'root';
$pass = 'root';
$port = 3306;

$paths = [
    'C:\\xampp\\mysql\\bin\\mysqldump.exe',
    'C:\\Program Files\\MySQL\\MySQL Server 8.0\\bin\\mysqldump.exe',
    'C:\\Program Files\\MySQL\\MySQL Server 5.7\\bin\\mysqldump.exe',
    '/usr/bin/mysqldump',
    '/usr/local/bin/mysqldump'
];

$found = null;
foreach ($paths as $p) {
    if (file_exists($p)) { $found = $p; break; }
}

if (!$found) {
    echo "Erro: mysqldump não encontrado em caminhos padrão. Instale ou atualize PATH.\n";
    exit(1);
}

$dir = __DIR__ . DIRECTORY_SEPARATOR . 'backups';
if (!is_dir($dir)) mkdir($dir, 0755, true);
$ts = date('Ymd_His');
$filename = $dir . DIRECTORY_SEPARATOR . "backup_{$db}_{$ts}.sql";

// Monta comando seguro
$cmd = escapeshellarg($found) . " -h " . escapeshellarg($host) . " -P " . escapeshellarg($port) . " -u " . escapeshellarg($user) . " -p" . $pass . " --single-transaction --routines --triggers " . escapeshellarg($db) . " --result-file=" . escapeshellarg($filename);

exec($cmd . " 2>&1", $output, $rc);
if ($rc !== 0) {
    echo "Erro ao executar mysqldump (rc=$rc). Saída:\n" . implode("\n", $output) . "\n";
    exit(1);
}

echo "Backup criado: $filename\n";
