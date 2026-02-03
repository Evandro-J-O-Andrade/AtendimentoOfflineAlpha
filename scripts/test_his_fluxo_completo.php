<?php
// scripts/seed_test_users.php
// Seed completo de perfis e usuários de teste para desenvolvimento

require_once __DIR__ . '/../src/api/config.php';
$pdo = getPDO();

try {
    $pdo->beginTransaction();

    echo "=== Limpando usuários de teste e vínculos antigos ===\n";

    // 1️⃣ Deletar vínculo usuario_perfil para usuários de teste
    $stmt = $pdo->prepare("
        DELETE up
        FROM usuario_perfil up
        JOIN usuario u ON u.id_usuario = up.id_usuario
        WHERE u.login LIKE 'test_%'
           OR u.login LIKE 'medico_%'
           OR u.login LIKE 'recep_%'
           OR u.login LIKE 'admin%'
           OR u.login LIKE 'suporte%'
    ");
    $stmt->execute();
    echo "Vínculos antigos removidos: " . $stmt->rowCount() . "\n";

    // 2️⃣ Deletar usuários de teste
    $stmt = $pdo->prepare("
        DELETE FROM usuario
        WHERE login LIKE 'test_%'
           OR login LIKE 'medico_%'
           OR login LIKE 'recep_%'
           OR login LIKE 'admin%'
           OR login LIKE 'suporte%'
    ");
    $stmt->execute();
    echo "Usuários antigos removidos: " . $stmt->rowCount() . "\n";

    echo "=== Criando perfis ===\n";

    $profiles = [
        'ADMIN_MASTER', 'ADMIN', 'SUPORTE_MASTER', 'SUPORTE',
        'ADM_RECEPCAO', 'TOTEM_CALLER', 'MEDICO', 'ENFERMAGEM',
        'TEC_ENFERMAGEM', 'NUTRICIONISTA', 'FISIOTERAPEUTA',
        'TRIAGEM', 'RECEPCAO', 'AUDITORIA', 'FARMACIA', 
        'MANUTENCAO', 'LIMPEZA', 'FATURAMENTO', 'GESTAO'
    ];

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

    echo "=== Criando usuários de teste ===\n";

    // Estrutura: login, nome, perfis[], senha seed
    $users = [
        ['admin_test', 'Administrador Teste', ['ADMIN_MASTER','SUPORTE_MASTER'], 'Senha123!'],
        ['suporte_test', 'Suporte Teste', ['SUPORTE'], 'Senha123!'],
        ['adm_recepcao_test', 'ADM Recepção Teste', ['ADM_RECEPCAO'], 'Senha123!'],
        ['totem_test', 'Totem Teste', ['TOTEM_CALLER'], 'Senha123!'],
        ['recep_test', 'Recepção Teste', ['RECEPCAO'], 'Senha123!'],
        ['medico_clinico_test', 'Médico Clínico Teste', ['MEDICO'], 'Senha123!'],
        ['medico_pediatria_test', 'Médico Pediatria Teste', ['MEDICO'], 'Senha123!'],
        ['enfermagem_test', 'Enfermeiro Teste', ['ENFERMAGEM'], 'Senha123!'],
        ['triagem_test', 'Triagem Teste', ['TRIAGEM'], 'Senha123!']
    ];

    $stmt_find_pessoa = $pdo->prepare('SELECT id_pessoa FROM pessoa WHERE nome_completo = ? LIMIT 1');
    $stmt_insert_pessoa = $pdo->prepare('INSERT INTO pessoa (nome_completo) VALUES (?)');
    $stmt_insert_user = $pdo->prepare('INSERT INTO usuario (login, senha_hash, seed_password, id_pessoa, ativo, primeiro_login, senha_expira_em) VALUES (?, ?, ?, ?, 1, 1, DATE_ADD(CURDATE(), INTERVAL 6 MONTH))');
    $stmt_insert_user_perfil = $pdo->prepare('INSERT INTO usuario_perfil (id_usuario, id_perfil) VALUES (?, ?)');
    $stmt_get_perfil = $pdo->prepare('SELECT id_perfil FROM perfil WHERE nome = ? LIMIT 1');

    foreach ($users as $u) {
        [$login, $nome, $u_perfis, $senha] = $u;

        // pessoa
        $stmt_find_pessoa->execute([$nome]);
        $row = $stmt_find_pessoa->fetch(PDO::FETCH_ASSOC);
        if ($row) {
            $id_pessoa = $row['id_pessoa'];
        } else {
            $stmt_insert_pessoa->execute([$nome]);
            $id_pessoa = $pdo->lastInsertId();
        }

        // usuário
        $senha_hash = password_hash($senha, PASSWORD_DEFAULT);
        $stmt_insert_user->execute([$login, $senha_hash, $senha, $id_pessoa]);
        $id_usuario = $pdo->lastInsertId();
        echo "Usuário criado: $login (id=$id_usuario)\n";

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
    echo "=== Seed completo executado com sucesso! ===\n";
} catch (Exception $e) {
    $pdo->rollBack();
    echo "Erro ao semear dados: " . $e->getMessage() . "\n";
    exit(1);
}
