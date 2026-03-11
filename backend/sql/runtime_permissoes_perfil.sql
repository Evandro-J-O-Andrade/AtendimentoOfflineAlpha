-- =====================================================
-- Runtime Parrudo - Tabelas de Permissões por Perfil
-- Executar no banco de dados
-- =====================================================

-- 1. Criar tabela de permissões (se não existir)
CREATE TABLE IF NOT EXISTS permissao (
    id_permissao INT AUTO_INCREMENT PRIMARY KEY,
    acao VARCHAR(100) NOT NULL UNIQUE,
    descricao VARCHAR(255),
    modulo VARCHAR(50),
    ativo TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Criar tabela de perfil_permissao (se não existir)
CREATE TABLE IF NOT EXISTS perfil_permissao (
    id_perfil_permissao INT AUTO_INCREMENT PRIMARY KEY,
    id_perfil INT NOT NULL,
    id_permissao INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_perfil) REFERENCES perfil(id_perfil),
    FOREIGN KEY (id_permissao) REFERENCES permissao(id_permissao),
    UNIQUE KEY uk_perfil_permissao (id_perfil, id_permissao)
);

-- 3. Inserir permissões base do sistema
INSERT INTO permissao (acao, descricao, modulo) VALUES
-- Permissões de Fila
('visualizar_filas', 'Visualizar filas de atendimento', 'fila'),
('chamar_senha', 'Chamar próxima senha', 'fila'),
('registrar_atendimento', 'Registrar atendimento', 'fila'),
('encaminhar_paciente', 'Encaminhar paciente', 'fila'),
('finalizar_atendimento', 'Finalizar atendimento', 'fila'),

-- Permissões de Triagem
('triagem_registrar', 'Registrar triagem', 'triagem'),
('triagem_classificar', 'Classificar risco', 'triagem'),
('sinais_vitais_registrar', 'Registrar sinais vitais', 'triagem'),

-- Permissões Médicas
('administrar_ffa', 'Administrar FFA', 'medico'),
('prescrever', 'Prescrever medicamentos', 'medico'),
('evolucao_clinica', 'Registrar evolução clínica', 'medico'),
('solicitar_exame', 'Solicitar exames', 'medico'),
('laudo_exame', 'Emitir laudo', 'medico'),

-- Permissões de Enfermagem
('administrar_medicacao', 'Administrar medicação', 'enfermagem'),
('procedimentos_enfermagem', 'Realizar procedimentos', 'enfermagem'),
('curativo', 'Realizar curativo', 'enfermagem'),
('coletar_amostras', 'Coletar amostras laboratoriais', 'enfermagem'),

-- Permissões de Farmácia
('dispensar_medicacao', 'Dispensar medicamento', 'farmacia'),
('consultar_estoque', 'Consultar estoque', 'farmacia'),
('auditoria_estoque', 'Auditar estoque', 'farmacia'),
('cadastrar_medicamento', 'Cadastrar medicamento', 'farmacia'),

-- Permissões Administrativas
('gerenciar_usuarios', 'Gerenciar usuários', 'admin'),
('gerenciar_perfis', 'Gerenciar perfis', 'admin'),
('gerenciar_salas', 'Gerenciar salas/local', 'admin'),
('gerenciar_unidades', 'Gerenciar unidades', 'admin'),
('consultar_relatorios', 'Consultar relatórios', 'admin'),
('exportar_dados', 'Exportar dados', 'admin'),

-- Permissões de Totem/Painel
('gerar_senha', 'Gerar senha', 'totem'),
('registrar_satisfacao', 'Registrar satisfação', 'totem'),
('monitorar_atendimento', 'Monitorar atendimento', 'painel'),
('exibir_painel', 'Exibir painel', 'painel'),

-- Permissões de Paciente
('cadastrar_paciente', 'Cadastrar paciente', 'paciente'),
('editar_paciente', 'Editar paciente', 'paciente'),
('buscar_paciente', 'Buscar paciente', 'paciente'),
('historico_paciente', 'Ver histórico', 'paciente'),

-- Permissões de Recepção
('registrar_chegada_paciente', 'Registrar chegada do paciente', 'recepcao'),
('cadastrar_novo_paciente', 'Cadastrar novo paciente', 'recepcao'),
('verificar_cadastro', 'Verificar cadastro', 'recepcao'),

-- Permissões de Almoxarifado
('movimentar_estoque', 'Movimentar estoque', 'almoxarifado'),
('auditar_estoque', 'Auditar estoque', 'almoxarifado'),
('entrada_estoque', 'Entrada de estoque', 'almoxarifado'),
('saida_estoque', 'Saída de estoque', 'almoxarifado'),

-- Permissões de TI/Manutenção
('manutencao_sistema', 'Manutenção do sistema', 'ti'),
('monitorar_dispositivos', 'Monitorar dispositivos', 'ti'),
('reset_senha_totem', 'Resetar senha totem', 'ti'),
('configurar_sistema', 'Configurar sistema', 'ti'),
('logs_auditoria', 'Ver logs de auditoria', 'ti'),
('backup_dados', 'Realizar backup', 'ti')
ON DUPLICATE KEY UPDATE descricao = VALUES(descricao);

-- 4. Vincular permissões aos perfis (baseado no nome do perfil)
-- Primeiro, limpar vínculos existentes
TRUNCATE TABLE perfil_permissao;

-- Administrador: todas as permissões
INSERT INTO perfil_permissao (id_perfil, id_permissao)
SELECT p.id_perfil, pm.id_permissao
FROM perfil p
CROSS JOIN permissao pm
WHERE p.nome IN ('ADMIN', 'ADMINISTRADOR', 'SUPORTE', 'TI')
ON DUPLICATE KEY UPDATE id_perfil = id_perfil;

-- Médico: permissões médicas
INSERT INTO perfil_permissao (id_perfil, id_permissao)
SELECT p.id_perfil, pm.id_permissao
FROM perfil p
CROSS JOIN permissao pm
WHERE p.nome LIKE '%MEDICO%' OR p.nome LIKE '%CLINICO%'
AND pm.acao IN (
    'visualizar_filas', 'chamar_senha', 'registrar_atendimento', 
    'triagem_registrar', 'triagem_classificar',
    'administrar_ffa', 'prescrever', 'evolucao_clinica', 'solicitar_exame', 'laudo_exame',
    'cadastrar_paciente', 'editar_paciente', 'buscar_paciente', 'historico_paciente'
);

-- Enfermeiro: permissões de enfermagem
INSERT INTO perfil_permissao (id_perfil, id_permissao)
SELECT p.id_perfil, pm.id_permissao
FROM perfil p
CROSS JOIN permissao pm
WHERE p.nome LIKE '%ENFERMAGEM%' OR p.nome LIKE '%ENFERMEIRO%'
AND pm.acao IN (
    'visualizar_filas', 'chamar_senha', 'registrar_atendimento',
    'triagem_registrar', 'triagem_classificar', 'sinais_vitais_registrar',
    'administrar_medicacao', 'procedimentos_enfermagem', 'curativo', 'coletar_amostras',
    'cadastrar_paciente', 'buscar_paciente'
);

-- Técnico: permissões técnicas
INSERT INTO perfil_permissao (id_perfil, id_permissao)
SELECT p.id_perfil, pm.id_permissao
FROM perfil p
CROSS JOIN permissao pm
WHERE p.nome LIKE '%TECNICO%'
AND pm.acao IN (
    'visualizar_filas', 'registrar_atendimento',
    'coletar_amostras', 'procedimentos_enfermagem',
    'buscar_paciente'
);

-- Triagem
INSERT INTO perfil_permissao (id_perfil, id_permissao)
SELECT p.id_perfil, pm.id_permissao
FROM perfil p
CROSS JOIN permissao pm
WHERE p.nome = 'TRIAGEM'
AND pm.acao IN (
    'visualizar_filas', 'chamar_senha', 'registrar_atendimento',
    'triagem_registrar', 'triagem_classificar', 'sinais_vitais_registrar',
    'encaminhar_paciente', 'cadastrar_paciente', 'buscar_paciente'
);

-- Farmacêutico
INSERT INTO perfil_permissao (id_perfil, id_permissao)
SELECT p.id_perfil, pm.id_permissao
FROM perfil p
CROSS JOIN permissao pm
WHERE p.nome LIKE '%FARMAC%'
AND pm.acao IN (
    'dispensar_medicacao', 'consultar_estoque', 'auditoria_estoque', 
    'cadastrar_medicamento', 'buscar_paciente'
);

-- Administrativo
INSERT INTO perfil_permissao (id_perfil, id_permissao)
SELECT p.id_perfil, pm.id_permissao
FROM perfil p
CROSS JOIN permissao pm
WHERE p.nome LIKE '%ADMINISTRATIVO%'
AND pm.acao IN (
    'gerenciar_usuarios', 'gerenciar_salas', 'consultar_relatorios', 'exportar_dados',
    'cadastrar_paciente', 'editar_paciente', 'buscar_paciente', 'visualizar_filas'
);

-- Recepção
INSERT INTO perfil_permissao (id_perfil, id_permissao)
SELECT p.id_perfil, pm.id_permissao
FROM perfil p
CROSS JOIN permissao pm
WHERE p.nome LIKE '%RECEP%'
AND pm.acao IN (
    'gerar_senha', 'registrar_chegada_paciente', 'cadastrar_novo_paciente', 
    'verificar_cadastro', 'buscar_paciente', 'visualizar_filas'
);

-- Almoxarifado
INSERT INTO perfil_permissao (id_perfil, id_permissao)
SELECT p.id_perfil, pm.id_permissao
FROM perfil p
CROSS JOIN permissao pm
WHERE p.nome LIKE '%ALMOXARIF%' OR p.nome LIKE '%ESTOQUE%'
AND pm.acao IN (
    'movimentar_estoque', 'consultar_estoque', 'auditar_estoque',
    'entrada_estoque', 'saida_estoque'
);

-- TI / Manutenção
INSERT INTO perfil_permissao (id_perfil, id_permissao)
SELECT p.id_perfil, pm.id_permissao
FROM perfil p
CROSS JOIN permissao pm
WHERE p.nome LIKE '%TI%' OR p.nome LIKE '%MANUTEN%'
AND pm.acao IN (
    'manutencao_sistema', 'monitorar_dispositivos', 'reset_senha_totem',
    'configurar_sistema', 'logs_auditoria', 'backup_dados',
    'gerenciar_usuarios', 'gerenciar_perfis'
);

-- Totem
INSERT INTO perfil_permissao (id_perfil, id_permissao)
SELECT p.id_perfil, pm.id_permissao
FROM perfil p
CROSS JOIN permissao pm
WHERE p.nome LIKE '%TOTEM%'
AND pm.acao IN ('gerar_senha', 'registrar_satisfacao');

-- Painel
INSERT INTO perfil_permissao (id_perfil, id_permissao)
SELECT p.id_perfil, pm.id_permissao
FROM perfil p
CROSS JOIN permissao pm
WHERE p.nome LIKE '%PAINEL%'
AND pm.acao IN ('visualizar_filas', 'monitorar_atendimento', 'exibir_painel');

-- 5. Verificar estrutura final
SELECT 'Permissões criadas:' as info, COUNT(*) as total FROM permissao;
SELECT 'Vínculos perfil-permissão:' as info, COUNT(*) as total FROM perfil_permissao;
