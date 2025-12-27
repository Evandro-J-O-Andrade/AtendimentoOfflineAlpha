<?php
// scripts/db_repair.php
// Executa o script SQL de reparo (db_repair.sql) via PDO usando getPDO()

require_once __DIR__ . '/../src/api/config.php';
$pdo = getPDO();

$sql = file_get_contents(__DIR__ . '/db_repair.sql');
// Divide por ponto-e-vírgula seguido de newline para evitar cortar delimiters $$ used elsewhere
$stmts = array_filter(array_map('trim', preg_split('/;\s*\n/', $sql)));

foreach ($stmts as $stmt) {
    if (trim($stmt) === '') continue;
    try {
        $pdo->exec($stmt);
        echo "OK: " . (strlen($stmt) > 80 ? substr($stmt, 0, 80) . '...' : $stmt) . PHP_EOL;
    } catch (PDOException $e) {
        echo "ERR: " . $e->getMessage() . PHP_EOL;
    }
}

echo "db_repair.php: finalizado\n";
