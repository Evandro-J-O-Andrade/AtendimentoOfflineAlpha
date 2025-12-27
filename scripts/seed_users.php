<?php
// scripts/seed_users.php
// Usage: php scripts/seed_users.php
// This script creates profiles and seed users for local development.

require_once __DIR__ . '/../src/api/config.php';
$pdo = getPDO();

$profiles = [
    'ADMIN_MASTER',
    'SUPORTE_MASTER',
    'SUPORTE',
    'ADM_RECEPCAO',
    'TOTEM_CALLER',
    'MEDICO',
    'ENFERMAGEM',
    'RECEPCAO',
    'AUDITORIA'
];

$users = [
    // login, nome, perfis[], senha
    ['admin', 'Administrador Master', ['ADMIN_MASTER','SUPORTE_MASTER'], 'Senha123!'],
    ['suporte_master', 'Suporte Master', ['SUPORTE_MASTER'], 'Senha123!'],
    ['suporte', 'Suporte Comum', ['SUPORTE'], 'Senha123!'],
    ['adm_recepcao', 'ADM Recepção', ['ADM_RECEPCAO'], 'Senha123!'],
    ['totem01', 'Totem Caller', ['TOTEM_CALLER'], 'Senha123!'],
    // fluxo de teste
    ['recepcao1', 'Recepcionista Teste', ['RECEPCAO'], 'Senha123!'],
    ['medico_clinico', 'Médico Clínico Teste', ['MEDICO'], 'Senha123!'],
    ['medico_pediatria', 'Médico Pediatria Teste', ['MEDICO'], 'Senha123!'],
    ['enfermagem1', 'Enfermeiro Teste', ['ENFERMAGEM'], 'Senha123!']
];

try {
    $pdo->beginTransaction();

    // Cria perfis
    $stmt_check = $pdo->prepare('SELECT id_perfil FROM perfil WHERE nome = ? LIMIT 1');
    $stmt_insert = $pdo->prepare('INSERT INTO perfil (nome) VALUES (?)');

    foreach ($profiles as $p) {
        $stmt_check->execute([$p]);
        if (!$stmt_check->fetch()) {
            $stmt_insert->execute([$p]);
            echo "Perfil criado: $p\n";
        } else {
            echo "Perfil já existe: $p\n";
        }
    }

    // Função helper para criar/recuperar pessoa (por nome)
    $stmt_find_pessoa = $pdo->prepare('SELECT id_pessoa FROM pessoa WHERE nome_completo = ? LIMIT 1');
    $stmt_insert_pessoa = $pdo->prepare('INSERT INTO pessoa (nome_completo) VALUES (?)');

    $stmt_find_user = $pdo->prepare('SELECT id_usuario FROM usuario WHERE login = ? LIMIT 1');
    $stmt_insert_user = $pdo->prepare('INSERT INTO usuario (login, senha_hash, id_pessoa, ativo) VALUES (?, ?, ?, 1)');
    $stmt_insert_user_perfil = $pdo->prepare('INSERT INTO usuario_perfil (id_usuario, id_perfil) VALUES (?, ?)');
    $stmt_get_perfil = $pdo->prepare('SELECT id_perfil FROM perfil WHERE nome = ? LIMIT 1');

    foreach ($users as $u) {
        [$login, $nome, $u_perfis, $senha] = $u;

        // pessoa
        $stmt_find_pessoa->execute([$nome]);
        $row = $stmt_find_pessoa->fetch(PDO::FETCH_ASSOC);
        if ($row) {
            $id_pessoa = $row['id_pessoa'];
            echo "Pessoa já existe: $nome (id=$id_pessoa)\n";
        } else {
            $stmt_insert_pessoa->execute([$nome]);
            $id_pessoa = $pdo->lastInsertId();
            echo "Pessoa criada: $nome (id=$id_pessoa)\n";
        }

        // usuario
        $stmt_find_user->execute([$login]);
        if ($stmt_find_user->fetch()) {
            echo "Usuário já existe: $login\n";
            continue;
        }

        $senha_hash = password_hash($senha, PASSWORD_DEFAULT);
        $stmt_insert_user->execute([$login, $senha_hash, $id_pessoa]);
        $id_usuario = $pdo->lastInsertId();
        echo "Usuário criado: $login (id=$id_usuario) senha: $senha\n";

        // vincular perfis
        foreach ($u_perfis as $pn) {
            $stmt_get_perfil->execute([$pn]);
            $pf = $stmt_get_perfil->fetch(PDO::FETCH_ASSOC);
            if ($pf) {
                $stmt_insert_user_perfil->execute([$id_usuario, $pf['id_perfil']]);
                echo "  Perfil atribuído: $pn\n";
            }
        }
    }

    $pdo->commit();
    echo "SEED: Concluído com sucesso.\n";
    echo "Usuários criados com senha 'Senha123!'. Atualize as senhas em produção.\n";
} catch (Exception $e) {
    $pdo->rollBack();
    echo "Erro ao semear dados: " . $e->getMessage() . "\n";
    exit(1);
}
