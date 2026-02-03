<?php
// scripts/seed_his_fluxo_completo.php
// Usage: php scripts/seed_his_fluxo_completo.php

require_once __DIR__ . '/../src/api/config.php';
$pdo = getPDO();

try {
    $pdo->beginTransaction();

    echo "=== Limpando usuários e perfis de teste ===\n";

    // Limpa usuários de teste (seed)
    $stmt = $pdo->prepare("DELETE FROM usuario WHERE login LIKE 'test_%' OR login LIKE 'medico_%' OR login LIKE 'recep_%' OR login LIKE 'admin%' OR login LIKE 'suporte%'");
    $stmt->execute();
    echo "Usuários antigos removidos.\n";

    // Limpa vínculos de perfis
    $stmt = $pdo->prepare("DELETE FROM usuario_perfil WHERE id_usuario NOT IN (SELECT id_usuario FROM usuario)");
    $stmt->execute();

    // Perfis desejados
    $profiles = [
        'ADMIN_MASTER',
        'ADMIN',
        'SUPORTE_MASTER',
        'SUPORTE',
        'ADM_RECEPCAO',
        'TOTEM_CALLER',
        'MEDICO_CLINICO',
        'MEDICO_PEDIATRICO',
        'TRIAGEM',
        'RECEPCAO',
        'ENFERMAGEM',
        'FARMACIA',
        'MANUTENCAO',
        'LIMPEZA',
        'FATURAMENTO',
        'GESTAO'
    ];

    // Insere perfis se não existirem
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

    // Funções auxiliares para pessoas e usuários
    $stmt_find_pessoa = $pdo->prepare('SELECT id_pessoa FROM pessoa WHERE nome_completo = ? LIMIT 1');
    $stmt_insert_pessoa = $pdo->prepare('INSERT INTO pessoa (nome_completo) VALUES (?)');
    $stmt_insert_user = $pdo->prepare('INSERT INTO usuario (login, senha_hash, seed_password, id_pessoa, ativo, primeiro_login, senha_expira_em) VALUES (?, ?, ?, ?, 1, 1, DATE_ADD(CURDATE(), INTERVAL 6 MONTH))');
    $stmt_insert_user_perfil = $pdo->prepare('INSERT INTO usuario_perfil (id_usuario, id_perfil) VALUES (?, ?)');
    $stmt_get_perfil = $pdo->prepare('SELECT id_perfil FROM perfil WHERE nome = ? LIMIT 1');

    // Usuários de teste
    $users = [
        ['adminMaster', 'Administrador Master', ['ADMIN_MASTER']],
        ['admin', 'Administrador', ['ADMIN']],
        ['suporteMaster', 'Suporte Master', ['SUPORTE_MASTER']],
        ['suporte', 'Suporte', ['SUPORTE']],
        ['admRecepcao', 'ADM Recepção', ['ADM_RECEPCAO']],
        ['totem01', 'Totem Caller', ['TOTEM_CALLER']],
        ['medicoClinico', 'Médico Clínico', ['MEDICO_CLINICO']],
        ['medicoPediatria', 'Médico Pediatria', ['MEDICO_PEDIATRICO']],
        ['triagem01', 'Triagem Teste', ['TRIAGEM']],
        ['recepcao01', 'Recepção Teste', ['RECEPCAO']],
        ['enfermagem01', 'Enfermeiro Teste', ['ENFERMAGEM']],
        ['farmacia01', 'Farmacêutico Teste', ['FARMACIA']],
        ['manutencao01', 'Manutenção Teste', ['MANUTENCAO']],
        ['limpeza01', 'Limpeza Teste', ['LIMPEZA']],
        ['faturamento01', 'Faturamento Teste', ['FATURAMENTO']],
        ['gestao01', 'Gestão Teste', ['GESTAO']]
    ];

    foreach ($users as $u) {
        [$login, $nome, $u_perfis] = $u;

        // Pessoa
        $stmt_find_pessoa->execute([$nome]);
        $row = $stmt_find_pessoa->fetch(PDO::FETCH_ASSOC);
        if ($row) {
            $id_pessoa = $row['id_pessoa'];
        } else {
            $stmt_insert_pessoa->execute([$nome]);
            $id_pessoa = $pdo->lastInsertId();
        }

        // Usuário
        $senha = 'Senha123!';
        $senha_hash = password_hash($senha, PASSWORD_DEFAULT);
        $stmt_insert_user->execute([$login, $senha_hash, $senha, $id_pessoa]);
        $id_usuario = $pdo->lastInsertId();

        // Atribuir perfis
        foreach ($u_perfis as $pn) {
            $stmt_get_perfil->execute([$pn]);
            $pf = $stmt_get_perfil->fetch(PDO::FETCH_ASSOC);
            if ($pf) {
                $stmt_insert_user_perfil->execute([$id_usuario, $pf['id_perfil']]);
            }
        }

        echo "Usuário seed criado: $login com senha '$senha'\n";
    }

    $pdo->commit();
    echo "=== Seed completo concluído com sucesso ===\n";

} catch (Exception $e) {
    $pdo->rollBack();
    echo "Erro ao semear dados: " . $e->getMessage() . "\n";
    exit(1);
}
