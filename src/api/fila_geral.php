<?php
require "config.php";

// A view vw_fila_atendimento já está correta no seu DDL
$stmt = $pdo->query("SELECT * FROM vw_fila_atendimento");
echo json_encode($stmt->fetchAll());