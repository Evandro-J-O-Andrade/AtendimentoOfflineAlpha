<?php
require "config.php";

$q = $_GET['q'] ?? '';

$stmt = $pdo->prepare("
    SELECT id_pessoa, nome_completo, cpf, cns 
    FROM pessoa -- CORREÇÃO: Tabela 'pessoa'
    WHERE nome_completo LIKE ?
          OR cpf LIKE ?
          OR cns = ?
");

$q_like = "%$q%";
$stmt->execute([$q_like, $q, $q]);

echo json_encode($stmt->fetchAll());