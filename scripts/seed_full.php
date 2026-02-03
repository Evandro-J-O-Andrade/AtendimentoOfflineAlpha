<?php
// scripts/seed_full.php
// Seed completo HIS / Pronto Atendimento
// Uso: php scripts/seed_full.php

require_once __DIR__ . '/../src/api/config.php';

$pdo = getPDO();

try {
    echo "=== Iniciando seed completo HIS ===\n";

    $pdo->beginTransaction();

    // -----------------------------
    // Limpando usuários de teste e vínculos
    // -----------------------------
    echo "=== Limpando usuários e perfis de teste ===\n";
    $delete_up = "
        DELETE FROM usuario_perfil
        WHERE id_usuario IN (
            SELECT id_usuario FROM usuario
            WHERE login LIKE 'test_%'
               OR login LIKE 'medico_%'
               OR login LIKE 'recep_%'
               OR login LIKE 'admin%'
               OR login LIKE 'suporte%'
        )
    ";
    $pdo->exec($delete_up);

    $delete_users = "
        DELETE FROM usuario
        WHERE login LIKE 'test_%'
           OR login LIKE 'medico_%'
           OR login LIKE 'recep_%'
           OR login LIKE 'admin%'
           OR login LIKE 'suporte%'
    ";
    $pdo->exec($delete_users);

    echo "Usuários de teste removidos.\n";

    // -----------------------------
    // Perfis: cria se não existir
    // -----------------------------
    $perfils = [
        'ADMIN_MASTER', 'ADMIN', 'SUPORTE_MASTER', 'SUPORTE', 'ADM_RECEPCAO',
        'TOTEM_CALLER', 'MEDICO', 'ENFERMAGEM', 'RECEPCAO', 'AUDITORIA',
        'FARMACIA', 'MANUTENCAO', 'LIMPEZA', 'FATURAMENTO', 'GESTAO'
    ];

    $stmt_check = $pdo->prepare("SELECT id_perfil FROM perfil WHERE nome = ? LIMIT 1");
    $stmt_insert = $pdo->prepare("INSERT INTO perfil (nome) VALUES (?)");

    foreach ($perfils as $p) {
        $stmt_check->execute([$p]);
        if (!$stmt_check->fetch()) {
            $stmt_insert->execute([$p]);
            echo "Perfil criado: $p\n";
        } else {
            echo "Perfil já existe: $p\n";
        }
    }

    // -----------------------------
    // Pessoas de teste
    // -----------------------------
    $persons = [
        'Administrador Master',
        'Suporte Master',
        'Suporte Comum',
        'ADM Recepção',
        'Totem Caller',
        'Recepcionista Teste',
        'Médico Clínico Teste',
        'Médico Pediatria Teste',
        'Enfermeiro Teste'
    ];

    $stmt_find_pessoa = $pdo->prepare("SELECT id_pessoa FROM pessoa WHERE nome_completo = ? LIMIT 1");
    $stmt_insert_pessoa = $pdo->prepare("INSERT INTO pessoa (nome_completo) VALUES (?)");

    $person_ids = [];

    foreach ($persons as $p) {
        $stmt_find_pessoa->execute([$p]);
        $row = $stmt_find_pessoa->fetch(PDO::FETCH_ASSOC);
        if ($row) {
            $person_ids[$p] = $row['id_pessoa'];
            echo "Pessoa já existe: $p\n";
        } else {
            $stmt_insert_pessoa->execute([$p]);
            $person_ids[$p] = $pdo->lastInsertId();
            echo "Pessoa criada: $p (id={$person_ids[$p]})\n";
        }
    }

    // -----------------------------
    // Usuários de teste
    // -----------------------------
    $users = [
        ['admin', 'Administrador Master', ['ADMIN_MASTER','SUPORTE_MASTER']],
        ['suporte_master', 'Suporte Master', ['SUPORTE_MASTER']],
        ['suporte', 'Suporte Comum', ['SUPORTE']],
        ['adm_recepcao', 'ADM Recepção', ['ADM_RECEPCAO']],
        ['totem01', 'Totem Caller', ['TOTEM_CALLER']],
        ['recepcao1', 'Recepcionista Teste', ['RECEPCAO']],
        ['medico_clinico', 'Médico Clínico Teste', ['MEDICO']],
        ['medico_pediatria', 'Médico Pediatria Teste', ['MEDICO']],
        ['enfermagem1', 'Enfermeiro Teste', ['ENFERMAGEM']]
    ];

    $stmt_find_user = $pdo->prepare("SELECT id_usuario FROM usuario WHERE login = ? LIMIT 1");
    $stmt_insert_user = $pdo->prepare("INSERT INTO usuario (login, senha_hash, seed_password, id_pessoa, ativo) VALUES (?, ?, ?, ?, 1)");
    $stmt_find_perfil = $pdo->prepare("SELECT id_perfil FROM perfil WHERE nome = ? LIMIT 1");
    $stmt_insert_user_perfil = $pdo->prepare("INSERT INTO usuario_perfil (id_usuario, id_perfil) VALUES (?, ?)");

    foreach ($users as $u) {
        [$login, $person_name, $user_perfis] = $u;

        $stmt_find_user->execute([$login]);
        if ($stmt_find_user->fetch()) {
            echo "Usuário já existe: $login\n";
            continue;
        }

        $seed_password = 'Senha123!';
        $senha_hash = ''; // vazio, será convertido no primeiro login
        $stmt_insert_user->execute([$login, $senha_hash, $seed_password, $person_ids[$person_name]]);
        $id_usuario = $pdo->lastInsertId();
        echo "Usuário criado: $login (id=$id_usuario)\n";

        // Atribuir perfis
        foreach ($user_perfis as $perfil_nome) {
            $stmt_find_perfil->execute([$perfil_nome]);
            $p = $stmt_find_perfil->fetch(PDO::FETCH_ASSOC);
            if ($p) {
                $stmt_insert_user_perfil->execute([$id_usuario, $p['id_perfil']]);
                echo "  Perfil atribuído: $perfil_nome\n";
            }
        }
    }

    $pdo->commit();
    echo "=== Seed completo finalizado com sucesso ===\n";
    echo "Senha de teste para todos os usuários: 'Senha123!'. Na primeira autenticação a API converte para hash seguro.\n";

} catch (Exception $e) {
    $pdo->rollBack();
    echo "Erro ao semear dados: " . $e->getMessage() . "\n";
    exit(1);
}
