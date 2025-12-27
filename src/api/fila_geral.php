<?php
require "config.php";
require "middleware.php";

$pdo = getPDO();
$usuario = validarToken($pdo);

// A view vw_fila_atendimento já concentra a regra da fila
$stmt = $pdo->query("SELECT * FROM vw_fila_atendimento");
echo json_encode($stmt->fetchAll());
