<?php
$senha_limpa = '123456';
$novo_hash = password_hash($senha_limpa, PASSWORD_DEFAULT);

echo "Senha limpa: " . $senha_limpa . "\n";
echo "NOVO HASH GERADO NO SEU AMBIENTE PHP: " . $novo_hash . "\n";
?>