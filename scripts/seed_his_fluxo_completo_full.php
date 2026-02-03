<?php
// scripts/seed_his_fluxo_completo_full.php
// Uso: php scripts/seed_his_fluxo_completo_full.php
// Este script cria perfis e usuários de teste do fluxo completo HIS, com senha já hashada SHA-256

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

// Usuários de teste: login, perfis[], senha inicial
$users = [
    ['adminMaster', ['ADMIN_MASTER','SUPORTE_MASTER'], 'adminMasterNova123!'],
    ['admin', ['ADMIN_MASTER'], 'admin'],
    ['suporteMaster', ['SUPORTE_MASTER'], 'Senha123!'],
    ['suporte', ['SUPORTE'], 'Senha123!'],
    ['admRecepcao', ['ADM_RECEPCAO'], 'Senha123!'],
    ['totem01', ['TOTEM_CALLER'], 'Senha123!'],
    ['recepcao1', ['RECEPCAO'], 'Senha123!'],
    ['medicoClinico', ['MEDICO'], 'Senha123!'],
    ['medicoPediatria', ['MEDICO'], 'Senha123!'],
    ['enfermagem1', ['ENFERMAGEM'], 'Senha123!'],
    ['paciente1', [], 'Senha123!']
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

    // Funções auxiliares para pessoa e usuário
    $stmt_find_pessoa = $pdo->prepare('SELECT id_pessoa FROM pessoa WHERE nome_completo = ? LIMIT 1');
    $stmt_insert_pessoa = $pdo->prepare('INSERT INTO pessoa (nome_completo) VALUES (?)');

    $stmt_find_user = $pdo->prepare('SELECT id_usuario FROM usuario WHERE login = ? LIMIT 1');
    $stmt_insert_user = $pdo->prepare('INSERT INTO usuario (login, senha, senha_hash, id_pessoa, ativo, primeiro_login, senha_expira_em) VALUES (?, ?, ?, ?, 1, 1, DATE_ADD(CURDATE(), INTERVAL 6 MONTH))');
    $stmt_insert_user_perfil = $pdo->prepare('INSERT INTO usuario_perfil (id_usuario, id_perfil) VALUES (?, ?)');
    $stmt_get_perfil = $pdo->prepare('SELECT id_perfil FROM perfil WHERE nome = ? LIMIT 1');

    foreach ($users as $u) {
        [$login, $u_perfis, $senha] = $u;
        $nome = ucfirst($login); // Nome da pessoa baseado no login

        // Cria pessoa se não existir
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

        // Cria usuário se não existir
        $stmt_find_user->execute([$login]);
        if ($stmt_find_user->fetch()) {
            echo "Usuário já existe: $login\n";
            continue;
        }

        $senha_hash = hash('sha256', $senha);
        $stmt_insert_user->execute([$login, $senha, $senha_hash, $id_pessoa]);
        $id_usuario = $pdo->lastInsertId();
        echo "Usuário criado: $login (id=$id_usuario) senha: $senha\n";

        // Atribui perfis
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
    echo "\nSEED COMPLETO: Usuários e perfis criados com sucesso.\n";
    echo "Senhas SHA-256 já configuradas, prontas para login no frontend.\n";
} catch (Exception $e) {
    $pdo->rollBack();
    echo "Erro ao semear dados: " . $e->getMessage() . "\n";
    exit(1);
}
