<?php
// scripts/seed_users.php
// Uso: php scripts/seed_users.php
// Popula perfis e usuários de teste para desenvolvimento local.

require_once __DIR__ . '/../src/api/config.php';
$pdo = getPDO();

// Perfis do sistema
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

// Usuários de teste: login, nome, perfis[], senha inicial
$users = [
    ['adminMaster',      'Administrador Master', ['ADMIN_MASTER','SUPORTE_MASTER'], 'adminMaster'],
    ['admin',            'Administrador Comum',  ['ADMIN_MASTER'], 'admin'],
    ['suporteMaster',    'Suporte Master',      ['SUPORTE_MASTER'], 'suporteMaster'],
    ['suporte',          'Suporte Comum',       ['SUPORTE'], 'suporte'],
    ['admRecepcao',      'ADM Recepção',        ['ADM_RECEPCAO'], 'admRecepcao'],
    ['totem01',          'Totem Caller',        ['TOTEM_CALLER'], 'totem01'],
    ['recepcao1',        'Recepcionista Teste', ['RECEPCAO'], 'recepcao1'],
    ['medicoClinico',    'Médico Clínico Teste',['MEDICO'], 'medicoClinico'],
    ['medicoPediatria',  'Médico Pediatria Teste',['MEDICO'], 'medicoPediatria'],
    ['enfermagem1',      'Enfermeiro Teste',    ['ENFERMAGEM'], 'enfermagem1'],
    ['paciente1',        'Paciente Teste',      [], 'paciente1']
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

    // Helper: criar/recuperar pessoa
    $stmt_find_pessoa = $pdo->prepare('SELECT id_pessoa FROM pessoa WHERE nome_completo = ? LIMIT 1');
    $stmt_insert_pessoa = $pdo->prepare('INSERT INTO pessoa (nome_completo) VALUES (?)');

    // Helper: criar usuário
    $stmt_find_user = $pdo->prepare('SELECT id_usuario FROM usuario WHERE login = ? LIMIT 1');
    $stmt_insert_user = $pdo->prepare('INSERT INTO usuario (login, senha, senha_hash, ativo, primeiro_login, senha_expira_em, seed_password, id_pessoa) VALUES (?, ?, ?, 1, 1, ?, ?, ?)');
    $stmt_get_perfil = $pdo->prepare('SELECT id_perfil FROM perfil WHERE nome = ? LIMIT 1');
    $stmt_insert_user_perfil = $pdo->prepare('INSERT INTO usuario_perfil (id_usuario, id_perfil) VALUES (?, ?)');

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

        // usuário
        $stmt_find_user->execute([$login]);
        if ($stmt_find_user->fetch()) {
            echo "Usuário já existe: $login\n";
            continue;
        }

        // Hash compatível com SHA2(., 256) do MySQL
        $senha_hash = hash('sha256', $senha);

        // Define senha expira em 6 meses
        $senha_expira_em = date('Y-m-d', strtotime('+6 months'));

        $stmt_insert_user->execute([
            $login,
            $senha,         // senha em texto para login direto
            $senha_hash,    // hash compatível com SP
            $senha_expira_em,
            $senha,         // seed_password = login
            $id_pessoa
        ]);

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
    echo "Usuários criados com senha igual ao login e hash compatível com SP.\n";

} catch (Exception $e) {
    $pdo->rollBack();
    echo "Erro ao semear dados: " . $e->getMessage() . "\n";
    exit(1);
}
