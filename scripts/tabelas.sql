-- Tabela base: Pessoa (pacientes e usuários)
CREATE TABLE IF NOT EXISTS pessoa (
    id_pessoa BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome_completo VARCHAR(200) NOT NULL COMMENT 'Nome completo do indivíduo',
    nome_social VARCHAR(200) COMMENT 'Nome social preferido',
    cpf VARCHAR(14) COMMENT 'CPF do indivíduo',
    cns VARCHAR(20) COMMENT 'Cartão Nacional de Saúde',
    data_nascimento DATE COMMENT 'Data de nascimento',
    sexo ENUM('M','F','O') COMMENT 'Sexo biológico ou identificado',
    nome_mae VARCHAR(200) COMMENT 'Nome da mãe',
    telefone VARCHAR(20) COMMENT 'Telefone de contato',
    email VARCHAR(150) COMMENT 'Email de contato',
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação do registro',
    UNIQUE KEY uk_cpf (cpf),
    UNIQUE KEY uk_cns (cns),
    INDEX idx_data_nascimento (data_nascimento)
) ENGINE=InnoDB COMMENT 'Tabela de pessoas (pacientes, usuários, etc.)';

-- Usuários do sistema
CREATE TABLE IF NOT EXISTS usuario (
    id_usuario BIGINT AUTO_INCREMENT PRIMARY KEY,
    login VARCHAR(100) NOT NULL UNIQUE COMMENT 'Login único do usuário',
    senha_hash VARCHAR(255) NOT NULL COMMENT 'Hash da senha (use bcrypt ou similar)',
    ativo BOOLEAN DEFAULT TRUE COMMENT 'Usuário ativo/inativo',
    id_pessoa BIGINT COMMENT 'Referência à pessoa associada',
    last_login DATETIME COMMENT 'Último login para segurança',
    token VARCHAR(255) COMMENT 'Token de sessão para autenticação',
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa) ON DELETE CASCADE,
    INDEX idx_login (login)
) ENGINE=InnoDB COMMENT 'Usuários do sistema com credenciais';

-- Perfis de acesso
CREATE TABLE IF NOT EXISTS perfil (
    id_perfil INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE COMMENT 'Nome do perfil (ex: ADMIN, MEDICO)'
) ENGINE=InnoDB COMMENT 'Perfis de usuário para permissões';

-- Associação usuário-perfil
CREATE TABLE IF NOT EXISTS usuario_perfil (
    id_usuario BIGINT,
    id_perfil INT,
    PRIMARY KEY (id_usuario, id_perfil),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_perfil) REFERENCES perfil(id_perfil) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT 'Associação M:N entre usuários e perfis';

-- Especialidades médicas
CREATE TABLE IF NOT EXISTS especialidade (
    id_especialidade INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE COMMENT 'Nome da especialidade',
    ativa BOOLEAN DEFAULT TRUE COMMENT 'Especialidade ativa'
) ENGINE=InnoDB COMMENT 'Especialidades médicas disponíveis';

-- Médicos
CREATE TABLE IF NOT EXISTS medico (
    id_usuario BIGINT PRIMARY KEY,
    crm VARCHAR(20) NOT NULL COMMENT 'Número do CRM',
    uf_crm CHAR(2) NOT NULL COMMENT 'UF do CRM',
    UNIQUE KEY uk_crm (crm, uf_crm),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT 'Médicos cadastrados';

-- Associação médico-especialidade
CREATE TABLE IF NOT EXISTS medico_especialidade (
    id_usuario BIGINT,
    id_especialidade INT,
    PRIMARY KEY (id_usuario, id_especialidade),
    FOREIGN KEY (id_usuario) REFERENCES medico(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_especialidade) REFERENCES especialidade(id_especialidade) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT 'Especialidades por médico';

-- Locais de atendimento
CREATE TABLE IF NOT EXISTS local_atendimento (
    id_local INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE COMMENT 'Nome do local (ex: Pronto Socorro)'
) ENGINE=InnoDB COMMENT 'Locais físicos de atendimento';

-- Salas dentro dos locais
CREATE TABLE IF NOT EXISTS sala (
    id_sala INT AUTO_INCREMENT PRIMARY KEY,
    nome_exibicao VARCHAR(100) NOT NULL COMMENT 'Nome exibido da sala',
    id_local INT NOT NULL COMMENT 'Local associado',
    id_especialidade INT COMMENT 'Especialidade da sala',
    ativa BOOLEAN DEFAULT TRUE COMMENT 'Sala ativa',
    FOREIGN KEY (id_local) REFERENCES local_atendimento(id_local) ON DELETE CASCADE,
    FOREIGN KEY (id_especialidade) REFERENCES especialidade(id_especialidade) ON DELETE SET NULL,
    INDEX idx_local (id_local)
) ENGINE=InnoDB COMMENT 'Salas de atendimento';

-- Alocação de usuários em salas
CREATE TABLE IF NOT EXISTS usuario_alocacao (
    id_alocacao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_usuario BIGINT NOT NULL COMMENT 'Usuário alocado',
    id_sala INT NOT NULL COMMENT 'Sala alocada',
    id_especialidade INT COMMENT 'Especialidade durante alocação',
    inicio DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Início da alocação',
    fim DATETIME COMMENT 'Fim da alocação',
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_sala) REFERENCES sala(id_sala) ON DELETE CASCADE,
    FOREIGN KEY (id_especialidade) REFERENCES especialidade(id_especialidade) ON DELETE SET NULL,
    INDEX idx_usuario (id_usuario)
) ENGINE=InnoDB COMMENT 'Alocação de usuários em salas/especialidades';

-- Senhas geradas
CREATE TABLE IF NOT EXISTS senhas (
    id_senha BIGINT AUTO_INCREMENT PRIMARY KEY,
    numero INT NOT NULL COMMENT 'Número da senha',
    origem ENUM('TOTEM','RECEPCAO','TOTEM_PRI_PEDI','TOTEM_PRI_ADULTO') COMMENT 'Origem da senha',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de geração',
    chamada BOOLEAN DEFAULT FALSE COMMENT 'Senha chamada'
) ENGINE=InnoDB COMMENT 'Senhas geradas para fila';

-- Feedback do totem
CREATE TABLE IF NOT EXISTS totem_feedback (
    id_feedback BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_senha BIGINT NULL COMMENT 'Senha associada',
    origem VARCHAR(50) NULL COMMENT 'Origem do feedback',
    nota INT NULL COMMENT 'Nota de satisfação',
    comentario TEXT NULL COMMENT 'Comentário do usuário',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data do feedback',
    FOREIGN KEY (id_senha) REFERENCES senhas(id_senha) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT 'Feedback de totens';

-- Atendimentos
CREATE TABLE IF NOT EXISTS atendimento (
    id_atendimento BIGINT AUTO_INCREMENT PRIMARY KEY,
    protocolo VARCHAR(30) NOT NULL UNIQUE COMMENT 'Protocolo único (GPAT)',
    id_pessoa BIGINT NOT NULL COMMENT 'Paciente',
    id_senha BIGINT COMMENT 'Senha associada',
    status_atendimento ENUM(
        'ABERTO','EM_ATENDIMENTO','EM_OBSERVACAO',
        'INTERNADO','FINALIZADO','NAO_ATENDIDO','RETORNO'
    ) NOT NULL COMMENT 'Status do atendimento',
    id_local_atual INT NOT NULL COMMENT 'Local atual',
    id_sala_atual INT COMMENT 'Sala atual',
    id_especialidade INT COMMENT 'Especialidade',
    data_abertura DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de abertura',
    data_fechamento DATETIME COMMENT 'Data de fechamento',
    observacao TEXT COMMENT 'Observações gerais do atendimento',
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa) ON DELETE CASCADE,
    FOREIGN KEY (id_senha) REFERENCES senhas(id_senha) ON DELETE SET NULL,
    FOREIGN KEY (id_local_atual) REFERENCES local_atendimento(id_local) ON DELETE RESTRICT,
    FOREIGN KEY (id_sala_atual) REFERENCES sala(id_sala) ON DELETE SET NULL,
    FOREIGN KEY (id_especialidade) REFERENCES especialidade(id_especialidade) ON DELETE SET NULL,
    INDEX idx_status_local (status_atendimento, id_local_atual),
    INDEX idx_data_abertura (data_abertura)
) ENGINE=InnoDB COMMENT 'Atendimentos de pacientes';

-- Movimentações de atendimento
CREATE TABLE IF NOT EXISTS atendimento_movimentacao (
    id_mov BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento BIGINT COMMENT 'Atendimento movimentado',
    de_local INT COMMENT 'Local de origem',
    para_local INT COMMENT 'Local de destino',
    id_usuario BIGINT COMMENT 'Usuário responsável',
    motivo VARCHAR(255) COMMENT 'Motivo da movimentação',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data da movimentação',
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE SET NULL,
    INDEX idx_atendimento (id_atendimento)
) ENGINE=InnoDB COMMENT 'Histórico de movimentações de atendimentos';

-- Anamneses
CREATE TABLE IF NOT EXISTS anamnese (
    id_anamnese BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento BIGINT COMMENT 'Atendimento associado',
    descricao TEXT COMMENT 'Descrição da anamnese',
    id_usuario BIGINT COMMENT 'Usuário que registrou',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data do registro',
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT 'Anamneses de atendimentos';

-- Prescrições
CREATE TABLE IF NOT EXISTS prescricao (
    id_prescricao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento BIGINT COMMENT 'Atendimento associado',
    tipo ENUM('INTERNA','CONTROLADA','CASA') COMMENT 'Tipo de prescrição',
    descricao TEXT NOT NULL COMMENT 'Descrição da prescrição',
    id_medico BIGINT COMMENT 'Médico responsável',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data da prescrição',
    bloqueada BOOLEAN DEFAULT FALSE COMMENT 'Prescrição bloqueada para edição',
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento) ON DELETE CASCADE,
    FOREIGN KEY (id_medico) REFERENCES medico(id_usuario) ON DELETE SET NULL,
    INDEX idx_atendimento (id_atendimento)
) ENGINE=InnoDB COMMENT 'Prescrições médicas';

-- Sequência para protocolos
CREATE TABLE IF NOT EXISTS protocolo_sequencia (
    id INT AUTO_INCREMENT PRIMARY KEY
) ENGINE=InnoDB COMMENT 'Sequência para geração de protocolos';

-- Log de auditoria
CREATE TABLE IF NOT EXISTS log_auditoria (
    id_log BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_usuario BIGINT COMMENT 'Usuário que realizou a ação',
    acao VARCHAR(100) COMMENT 'Ação realizada (INSERT, UPDATE, etc.)',
    tabela_afetada VARCHAR(100) COMMENT 'Tabela afetada',
    id_registro BIGINT COMMENT 'ID do registro afetado',
    antes TEXT COMMENT 'Estado antes da mudança',
    depois TEXT COMMENT 'Estado depois da mudança',
    justificativa VARCHAR(255) COMMENT 'Justificativa da ação',
    comentario TEXT COMMENT 'Comentários adicionais na auditoria',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data da ação',
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE SET NULL,
    INDEX idx_data_hora (data_hora),
    INDEX idx_tabela (tabela_afetada)
) ENGINE=InnoDB COMMENT 'Logs de auditoria do sistema' PARTITION BY RANGE (YEAR(data_hora)) (PARTITION p2023 VALUES LESS THAN (2024), PARTITION p2024 VALUES LESS THAN (2025), PARTITION p2025 VALUES LESS THAN MAXVALUE);

-- Configurações do sistema
CREATE TABLE IF NOT EXISTS configuracao (
    chave VARCHAR(100) PRIMARY KEY COMMENT 'Chave da configuração',
    valor TEXT COMMENT 'Valor da configuração'
) ENGINE=InnoDB COMMENT 'Configurações gerais do sistema';

-- Recepção de atendimentos
CREATE TABLE IF NOT EXISTS atendimento_recepcao (
    id_atendimento BIGINT PRIMARY KEY COMMENT 'Atendimento associado',
    tipo_atendimento ENUM(
        'CLINICO',
        'PEDIATRICO',
        'EMERGENCIA',
        'EXAME_EXTERNO',
        'MEDICACAO_EXTERNA'
    ) NOT NULL COMMENT 'Tipo de atendimento',
    chegada ENUM(
        'MEIOS_PROPRIOS',
        'AMBULANCIA',
        'POLICIA',
        'OUTROS'
    ) NOT NULL COMMENT 'Forma de chegada',
    prioridade ENUM(
        'AUTISTA',
        'CRIANCA_COLO',
        'GESTANTE',
        'IDOSO',
        'PRIORITARIO_PEDI',
        'PRIORITARIO_ADULTO',
        'NORMAL'
    ) DEFAULT 'NORMAL' COMMENT 'Prioridade na recepção',
    motivo_procura TEXT COMMENT 'Motivo da procura',
    destino_inicial ENUM(
        'TRIAGEM',
        'MEDICO',
        'EMERGENCIA',
        'RX',
        'MEDICACAO'
    ) NOT NULL COMMENT 'Destino inicial',
    id_recepcionista BIGINT NOT NULL COMMENT 'Recepcionista responsável',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data da recepção',
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento) ON DELETE CASCADE,
    FOREIGN KEY (id_recepcionista) REFERENCES usuario(id_usuario) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT 'Detalhes da recepção de atendimentos';

-- Classificação de risco
CREATE TABLE IF NOT EXISTS classificacao_risco (
    id_risco INT AUTO_INCREMENT PRIMARY KEY,
    cor ENUM('VERMELHO','LARANJA','AMARELO','VERDE','AZUL') COMMENT 'Cor da classificação',
    tempo_max INT COMMENT 'Tempo máximo de espera (minutos)',
    descricao VARCHAR(100) COMMENT 'Descrição do risco'
) ENGINE=InnoDB COMMENT 'Classificações de risco (Manchester)';

-- Triagens
CREATE TABLE IF NOT EXISTS triagem (
    id_triagem BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento BIGINT NOT NULL COMMENT 'Atendimento associado',
    id_risco INT NOT NULL COMMENT 'Classificação de risco',
    queixa TEXT COMMENT 'Queixa principal',
    sinais_vitais JSON COMMENT 'Sinais vitais em JSON',
    observacao TEXT COMMENT 'Observações da triagem',
    id_enfermeiro BIGINT NOT NULL COMMENT 'Enfermeiro responsável',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data da triagem',
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento) ON DELETE CASCADE,
    FOREIGN KEY (id_risco) REFERENCES classificacao_risco(id_risco) ON DELETE RESTRICT,
    FOREIGN KEY (id_enfermeiro) REFERENCES usuario(id_usuario) ON DELETE RESTRICT,
    UNIQUE KEY uk_triagem_atendimento (id_atendimento)
) ENGINE=InnoDB COMMENT 'Triagens de pacientes';

-- Reaberturas de atendimento
CREATE TABLE IF NOT EXISTS reabertura_atendimento (
    id_reabertura BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento BIGINT NOT NULL COMMENT 'Atendimento reaberto',
    id_usuario BIGINT NOT NULL COMMENT 'Usuário que reabriu',
    motivo TEXT NOT NULL COMMENT 'Motivo da reabertura',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data da reabertura',
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT 'Histórico de reaberturas';

-- Chamadas no painel
CREATE TABLE IF NOT EXISTS chamada_painel (
    id_chamada BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento BIGINT NOT NULL COMMENT 'Atendimento chamado',
    id_sala INT NOT NULL COMMENT 'Sala de chamada',
    status ENUM('CHAMANDO','ATENDIDO','NAO_COMPARECEU') DEFAULT 'CHAMANDO' COMMENT 'Status da chamada',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data da chamada',
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento) ON DELETE CASCADE,
    FOREIGN KEY (id_sala) REFERENCES sala(id_sala) ON DELETE RESTRICT,
    INDEX idx_painel_status (status, data_hora)
) ENGINE=InnoDB COMMENT 'Chamadas de pacientes no painel';

-- Exames físicos
CREATE TABLE IF NOT EXISTS exame_fisico (
    id_exame BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento BIGINT COMMENT 'Atendimento associado',
    descricao TEXT COMMENT 'Descrição do exame físico',
    id_usuario BIGINT COMMENT 'Usuário que registrou',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data do registro',
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT 'Exames físicos em atendimentos';

-- Hipóteses diagnósticas
CREATE TABLE IF NOT EXISTS hipotese_diagnostica (
    id_hipotese BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento BIGINT COMMENT 'Atendimento associado',
    cid10 VARCHAR(10) COMMENT 'Código CID-10',
    principal BOOLEAN DEFAULT FALSE COMMENT 'Hipótese principal',
    id_medico BIGINT COMMENT 'Médico responsável',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data do registro',
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento) ON DELETE CASCADE,
    FOREIGN KEY (id_medico) REFERENCES medico(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT 'Hipóteses diagnósticas';

-- Exames disponíveis
CREATE TABLE IF NOT EXISTS exame (
    id_exame INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE COMMENT 'Código do exame',
    descricao VARCHAR(255) COMMENT 'Descrição do exame',
    tipo ENUM('LAB','RX','OUTROS') COMMENT 'Tipo de exame'
) ENGINE=InnoDB COMMENT 'Exames disponíveis (lab, RX, etc.)';

-- Solicitações de exames
CREATE TABLE IF NOT EXISTS solicitacao_exame (
    id_solicitacao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento BIGINT COMMENT 'Atendimento associado',
    id_exame INT COMMENT 'Exame solicitado',
    status ENUM('SOLICITADO','COLETADO','RESULTADO') DEFAULT 'SOLICITADO' COMMENT 'Status da solicitação',
    id_medico BIGINT COMMENT 'Médico solicitante',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data da solicitação',
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento) ON DELETE CASCADE,
    FOREIGN KEY (id_exame) REFERENCES exame(id_exame) ON DELETE RESTRICT,
    FOREIGN KEY (id_medico) REFERENCES medico(id_usuario) ON DELETE SET NULL,
    INDEX idx_status (status)
) ENGINE=InnoDB COMMENT 'Solicitações de exames';

-- Retornos de atendimentos
CREATE TABLE IF NOT EXISTS retorno_atendimento (
    id_retorno BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento_origem BIGINT COMMENT 'Atendimento de origem',
    id_atendimento_retorno BIGINT COMMENT 'Atendimento de retorno',
    motivo TEXT COMMENT 'Motivo do retorno',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data do registro',
    FOREIGN KEY (id_atendimento_origem) REFERENCES atendimento(id_atendimento) ON DELETE CASCADE,
    FOREIGN KEY (id_atendimento_retorno) REFERENCES atendimento(id_atendimento) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT 'Retornos associados a atendimentos';

-- Setores
CREATE TABLE IF NOT EXISTS setor (
    id_setor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL COMMENT 'Nome do setor',
    tipo ENUM('OBSERVACAO','INTERNACAO','UTI') NOT NULL COMMENT 'Tipo de setor',
    ativo BOOLEAN DEFAULT TRUE COMMENT 'Setor ativo'
) ENGINE=InnoDB COMMENT 'Setores do hospital';

-- Leitos
CREATE TABLE IF NOT EXISTS leito (
    id_leito INT AUTO_INCREMENT PRIMARY KEY,
    id_setor INT NOT NULL COMMENT 'Setor associado',
    identificacao VARCHAR(50) NOT NULL COMMENT 'Identificação do leito',
    status ENUM('LIVRE','OCUPADO','BLOQUEADO') DEFAULT 'LIVRE' COMMENT 'Status do leito',
    FOREIGN KEY (id_setor) REFERENCES setor(id_setor) ON DELETE CASCADE,
    UNIQUE KEY uk_setor_leito (id_setor, identificacao),
    INDEX idx_status (status)
) ENGINE=InnoDB COMMENT 'Leitos disponíveis';

-- Internações
CREATE TABLE IF NOT EXISTS internacao (
    id_internacao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento BIGINT NOT NULL COMMENT 'Atendimento associado',
    id_leito INT NOT NULL COMMENT 'Leito ocupado',
    tipo ENUM('OBSERVACAO','INTERNACAO') NOT NULL COMMENT 'Tipo de internação',
    data_entrada DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de entrada',
    data_saida DATETIME COMMENT 'Data de saída',
    status ENUM('ATIVA','ENCERRADA') DEFAULT 'ATIVA' COMMENT 'Status da internação',
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento) ON DELETE CASCADE,
    FOREIGN KEY (id_leito) REFERENCES leito(id_leito) ON DELETE RESTRICT,
    INDEX idx_status (status)
) ENGINE=InnoDB COMMENT 'Internações de pacientes';

-- Evoluções médicas
CREATE TABLE IF NOT EXISTS evolucao_medica (
    id_evolucao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_internacao BIGINT NOT NULL COMMENT 'Internação associada',
    descricao TEXT NOT NULL COMMENT 'Descrição da evolução',
    id_medico BIGINT NOT NULL COMMENT 'Médico responsável',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data da evolução',
    FOREIGN KEY (id_internacao) REFERENCES internacao(id_internacao) ON DELETE CASCADE,
    FOREIGN KEY (id_medico) REFERENCES medico(id_usuario) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT 'Evoluções médicas em internações';

-- Prescrições em internação
CREATE TABLE IF NOT EXISTS prescricao_internacao (
    id_prescricao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_internacao BIGINT NOT NULL COMMENT 'Internação associada',
    tipo ENUM('MEDICAMENTO','CUIDADO','DIETA','OUTROS') NOT NULL COMMENT 'Tipo de prescrição',
    descricao TEXT NOT NULL COMMENT 'Descrição da prescrição',
    id_medico BIGINT NOT NULL COMMENT 'Médico responsável',
    ativa BOOLEAN DEFAULT TRUE COMMENT 'Prescrição ativa',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data da prescrição',
    FOREIGN KEY (id_internacao) REFERENCES internacao(id_internacao) ON DELETE CASCADE,
    FOREIGN KEY (id_medico) REFERENCES medico(id_usuario) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT 'Prescrições durante internação';

-- Administração de medicação
CREATE TABLE IF NOT EXISTS administracao_medicacao (
    id_admin BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_prescricao BIGINT NOT NULL COMMENT 'Prescrição associada',
    id_enfermeiro BIGINT NOT NULL COMMENT 'Enfermeiro que administrou',
    dose VARCHAR(50) COMMENT 'Dose administrada',
    via VARCHAR(50) COMMENT 'Via de administração',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data da administração',
    observacao TEXT COMMENT 'Observações da administração',
    FOREIGN KEY (id_prescricao) REFERENCES prescricao_internacao(id_prescricao) ON DELETE CASCADE,
    FOREIGN KEY (id_enfermeiro) REFERENCES usuario(id_usuario) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT 'Administrações de medicação';

-- Evoluções de enfermagem
CREATE TABLE IF NOT EXISTS evolucao_enfermagem (
    id_evolucao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_internacao BIGINT NOT NULL COMMENT 'Internação associada',
    descricao TEXT NOT NULL COMMENT 'Descrição da evolução',
    id_enfermeiro BIGINT NOT NULL COMMENT 'Enfermeiro responsável',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data da evolução',
    FOREIGN KEY (id_internacao) REFERENCES internacao(id_internacao) ON DELETE CASCADE,
    FOREIGN KEY (id_enfermeiro) REFERENCES usuario(id_usuario) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT 'Evoluções de enfermagem';

-- Anotações de enfermagem
CREATE TABLE IF NOT EXISTS anotacao_enfermagem (
    id_anotacao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_internacao BIGINT NOT NULL COMMENT 'Internação associada',
    descricao TEXT NOT NULL COMMENT 'Descrição da anotação',
    id_usuario BIGINT NOT NULL COMMENT 'Usuário que anotou',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data da anotação',
    FOREIGN KEY (id_internacao) REFERENCES internacao(id_internacao) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT 'Anotações de enfermagem';

-- Interconsultas
CREATE TABLE IF NOT EXISTS interconsulta (
    id_interconsulta BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_internacao BIGINT NOT NULL COMMENT 'Internação associada',
    id_especialidade INT NOT NULL COMMENT 'Especialidade solicitada',
    motivo TEXT NOT NULL COMMENT 'Motivo da interconsulta',
    status ENUM('SOLICITADA','RESPONDIDA') DEFAULT 'SOLICITADA' COMMENT 'Status da interconsulta',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data da solicitação',
    FOREIGN KEY (id_internacao) REFERENCES internacao(id_internacao) ON DELETE CASCADE,
    FOREIGN KEY (id_especialidade) REFERENCES especialidade(id_especialidade) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT 'Interconsultas entre especialidades';

-- Observações em atendimentos
CREATE TABLE IF NOT EXISTS atendimento_observacao (
    id_obs BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento BIGINT NOT NULL COMMENT 'Atendimento associado',
    tipo ENUM('OBSERVACAO','INTERNACAO') NOT NULL COMMENT 'Tipo de observação',
    id_leito INT COMMENT 'Leito associado',
    data_inicio DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Início da observação',
    data_fim DATETIME COMMENT 'Fim da observação',
    status ENUM('ATIVO','ALTA','TRANSFERIDO') DEFAULT 'ATIVO' COMMENT 'Status da observação',
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento) ON DELETE CASCADE,
    FOREIGN KEY (id_leito) REFERENCES leito(id_leito) ON DELETE SET NULL,
    UNIQUE KEY uk_atendimento_obs (id_atendimento)
) ENGINE=InnoDB COMMENT 'Observações em atendimentos';

-- Prescrições contínuas
CREATE TABLE IF NOT EXISTS prescricao_continua (
    id_prescricao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento BIGINT NOT NULL COMMENT 'Atendimento associado',
    tipo ENUM('MEDICAMENTOS','CUIDADOS_GERAIS') NOT NULL COMMENT 'Tipo de prescrição contínua',
    id_medico BIGINT NOT NULL COMMENT 'Médico responsável',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data da prescrição',
    ativa BOOLEAN DEFAULT TRUE COMMENT 'Prescrição ativa',
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento) ON DELETE CASCADE,
    FOREIGN KEY (id_medico) REFERENCES medico(id_usuario) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT 'Prescrições contínuas';

-- Itens de prescrição
CREATE TABLE IF NOT EXISTS prescricao_item (
    id_item BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_prescricao BIGINT NOT NULL COMMENT 'Prescrição associada',
    descricao TEXT NOT NULL COMMENT 'Descrição do item',
    dose VARCHAR(100) COMMENT 'Dose',
    via VARCHAR(50) COMMENT 'Via de administração',
    posologia VARCHAR(100) COMMENT 'Posologia',
    observacao TEXT COMMENT 'Observações do item',
    FOREIGN KEY (id_prescricao) REFERENCES prescricao_continua(id_prescricao) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT 'Itens de prescrições contínuas';

-- Evoluções multidisciplinares
CREATE TABLE IF NOT EXISTS evolucao_multidisciplinar (
    id_evolucao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento BIGINT NOT NULL COMMENT 'Atendimento associado',
    area VARCHAR(100) COMMENT 'Área (fisioterapia, nutrição, etc.)',
    descricao TEXT NOT NULL COMMENT 'Descrição da evolução',
    id_usuario BIGINT NOT NULL COMMENT 'Usuário responsável',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data da evolução',
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT 'Evoluções multidisciplinares';

-- Intercorrências
CREATE TABLE IF NOT EXISTS intercorrencia (
    id_intercorrencia BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento BIGINT NOT NULL COMMENT 'Atendimento associado',
    id_internacao BIGINT NULL COMMENT 'Internação associada',
    descricao TEXT NOT NULL COMMENT 'Descrição da intercorrência',
    gravidade ENUM('LEVE','MODERADA','GRAVE') DEFAULT 'LEVE' COMMENT 'Gravidade',
    id_usuario BIGINT NOT NULL COMMENT 'Usuário que registrou',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data do registro',
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento) ON DELETE CASCADE,
    FOREIGN KEY (id_internacao) REFERENCES internacao(id_internacao) ON DELETE SET NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE RESTRICT,
    INDEX idx_intercorrencia_atendimento (id_atendimento),
    INDEX idx_intercorrencia_internacao (id_internacao)
) ENGINE=InnoDB COMMENT 'Intercorrências em atendimentos/internações';

-- Pacientes (versão final)
CREATE TABLE IF NOT EXISTS paciente (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_pessoa BIGINT NOT NULL COMMENT 'Pessoa associada',
    prontuario VARCHAR(50) UNIQUE COMMENT 'Prontuário do paciente',
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de cadastro',
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT 'Pacientes cadastrados';

-- Alocação de locais por usuário
CREATE TABLE IF NOT EXISTS local_usuario (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_usuario BIGINT NOT NULL COMMENT 'Usuário associado',
    id_local INT NOT NULL COMMENT 'Local associado',
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_local) REFERENCES local_atendimento(id_local) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT 'Locais alocados por usuário';

-- Fila de senhas
CREATE TABLE IF NOT EXISTS fila_senha (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_paciente BIGINT NOT NULL COMMENT 'Paciente na fila',
    senha VARCHAR(20) NOT NULL COMMENT 'Senha gerada',
    origem ENUM('TOTEM','RECEPCAO') NOT NULL COMMENT 'Origem da senha',
    prioridade_recepcao ENUM('NORMAL','IDOSO','CRIANCA_COLO','ESPECIAL','EMERGENCIA') DEFAULT 'NORMAL' COMMENT 'Prioridade',
    status ENUM('AGUARDANDO','CHAMANDO','ATENDIDA','NAO_ATENDIDO','CANCELADA') DEFAULT 'AGUARDANDO' COMMENT 'Status da fila',
    id_ffa BIGINT NULL COMMENT 'FFA associada',
    guiche_chamada VARCHAR(50) COMMENT 'Guichê de chamada',
    id_usuario_chamada BIGINT COMMENT 'Usuário que chamou',
    id_usuario_atendimento BIGINT COMMENT 'Usuário que atendeu',
    observacao TEXT COMMENT 'Observações da fila',
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
    atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de atualização',
    FOREIGN KEY (id_paciente) REFERENCES pessoa(id_pessoa) ON DELETE CASCADE,
    FOREIGN KEY (id_ffa) REFERENCES ffa(id) ON DELETE SET NULL,
    FOREIGN KEY (id_usuario_chamada) REFERENCES usuario(id_usuario) ON DELETE SET NULL,
    FOREIGN KEY (id_usuario_atendimento) REFERENCES usuario(id_usuario) ON DELETE SET NULL,
    INDEX idx_status (status)
) ENGINE=InnoDB COMMENT 'Fila de senhas';

-- FFA (Ficha de Atendimento)
CREATE TABLE IF NOT EXISTS ffa (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    gpat VARCHAR(30) UNIQUE COMMENT 'Protocolo GPAT',
    id_paciente BIGINT NOT NULL COMMENT 'Paciente associado',
    status VARCHAR(50) NOT NULL COMMENT 'Status da FFA',
    layout VARCHAR(50) COMMENT 'Layout/posição atual',
    classificacao_manchester ENUM('VERMELHO','LARANJA','AMARELO','VERDE','AZUL') COMMENT 'Classificação Manchester',
    id_usuario_criacao BIGINT COMMENT 'Usuário que criou',
    id_usuario_alteracao BIGINT COMMENT 'Usuário que alterou',
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
    atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de atualização',
    FOREIGN KEY (id_paciente) REFERENCES pessoa(id_pessoa) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario_criacao) REFERENCES usuario(id_usuario) ON DELETE SET NULL,
    FOREIGN KEY (id_usuario_alteracao) REFERENCES usuario(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT 'Fichas de atendimento (FFA)';

-- Auditoria de fila
CREATE TABLE IF NOT EXISTS auditoria_fila (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_fila BIGINT NOT NULL COMMENT 'Fila auditada',
    id_usuario BIGINT COMMENT 'Usuário responsável',
    acao VARCHAR(100) NOT NULL COMMENT 'Ação realizada',
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data da ação',
    FOREIGN KEY (id_fila) REFERENCES fila_senha(id) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT 'Auditoria de filas de senhas';

-- Auditoria de FFA
CREATE TABLE IF NOT EXISTS auditoria_ffa (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_ffa BIGINT NOT NULL COMMENT 'FFA auditada',
    id_usuario BIGINT COMMENT 'Usuário responsável',
    acao TEXT NOT NULL COMMENT 'Ação realizada',
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data da ação',
    FOREIGN KEY (id_ffa) REFERENCES ffa(id) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT 'Auditoria de FFAs';

-- Eventos de fluxo
CREATE TABLE IF NOT EXISTS eventos_fluxo (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    entidade VARCHAR(50) COMMENT 'Entidade (FFA, SENHA, etc.)',
    entidade_id BIGINT COMMENT 'ID da entidade',
    tipo_evento VARCHAR(50) COMMENT 'Tipo de evento',
    descricao TEXT COMMENT 'Descrição do evento',
    id_usuario BIGINT COMMENT 'Usuário envolvido',
    perfil_usuario VARCHAR(50) COMMENT 'Perfil do usuário',
    local VARCHAR(50) COMMENT 'Local do evento',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data do evento',
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT 'Eventos de fluxo do sistema';

-- Fluxo de status
CREATE TABLE IF NOT EXISTS fluxo_status (
    id INT AUTO_INCREMENT PRIMARY KEY,
    status_origem VARCHAR(50) NOT NULL COMMENT 'Status de origem',
    status_destino VARCHAR(50) NOT NULL COMMENT 'Status de destino',
    origem_evento VARCHAR(50) NOT NULL COMMENT 'Origem do evento',
    permitido BOOLEAN DEFAULT TRUE COMMENT 'Transição permitida',
    UNIQUE KEY uk_fluxo (status_origem, status_destino, origem_evento)
) ENGINE=InnoDB COMMENT 'Regras de transição de status';

-- Regras de timeout
CREATE TABLE IF NOT EXISTS regra_timeout (
    id INT AUTO_INCREMENT PRIMARY KEY,
    status_ffa VARCHAR(50) NOT NULL COMMENT 'Status da FFA',
    tempo_limite_min INT NOT NULL COMMENT 'Tempo limite em minutos',
    acao_timeout VARCHAR(50) COMMENT 'Ação em timeout',
    ativa BOOLEAN DEFAULT TRUE COMMENT 'Regra ativa'
) ENGINE=InnoDB COMMENT 'Regras de timeout para status';

-- Plantões
CREATE TABLE IF NOT EXISTS plantao (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_medico BIGINT NOT NULL COMMENT 'Médico no plantão',
    inicio DATETIME NOT NULL COMMENT 'Início do plantão',
    fim DATETIME COMMENT 'Fim do plantão',
    id_local INT COMMENT 'Local do plantão',
    FOREIGN KEY (id_medico) REFERENCES medico(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_local) REFERENCES local_atendimento(id_local) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT 'Plantões de médicos';

-- Médicos (redundante com medico, mas consolidado)
CREATE TABLE IF NOT EXISTS medicos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_pessoa BIGINT NOT NULL COMMENT 'Pessoa associada',
    crm VARCHAR(20) UNIQUE COMMENT 'CRM',
    ativo BOOLEAN DEFAULT TRUE COMMENT 'Médico ativo',
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT 'Médicos (consolidado)';

-- Produtos de farmácia
CREATE TABLE IF NOT EXISTS produtos_farmacia (
    id_produto BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(200) NOT NULL COMMENT 'Nome do produto',
    principio_ativo VARCHAR(200) COMMENT 'Princípio ativo',
    unidade_medida VARCHAR(20) COMMENT 'Unidade de medida',
    tipo ENUM('MEDICAMENTO','INSUMO','OUTRO') COMMENT 'Tipo de produto'
) ENGINE=InnoDB COMMENT 'Produtos da farmácia';

-- Estoque local (farmácia)
CREATE TABLE IF NOT EXISTS estoque_local (
    id_estoque BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_produto BIGINT NOT NULL COMMENT 'Produto em estoque',
    id_local INT NOT NULL COMMENT 'Local do estoque',
    quantidade_atual INT DEFAULT 0 COMMENT 'Quantidade atual',
    min_estoque INT DEFAULT 0 COMMENT 'Mínimo para alerta',
    FOREIGN KEY (id_produto) REFERENCES produtos_farmacia(id_produto) ON DELETE CASCADE,
    FOREIGN KEY (id_local) REFERENCES local_atendimento(id_local) ON DELETE CASCADE,
    UNIQUE KEY uk_produto_local (id_produto, id_local)
) ENGINE=InnoDB COMMENT 'Estoque local de farmácia';

-- Entradas de estoque
CREATE TABLE IF NOT EXISTS entrada_estoque (
    id_entrada BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_estoque BIGINT NOT NULL COMMENT 'Estoque associado',
    id_produto BIGINT NOT NULL COMMENT 'Produto entrado',
    id_local INT NOT NULL COMMENT 'Local da entrada',
    quantidade INT NOT NULL COMMENT 'Quantidade entrada',
    lote VARCHAR(50) COMMENT 'Lote do produto',
    validade DATE COMMENT 'Validade do lote',
    id_usuario_entrada BIGINT COMMENT 'Usuário que entrou',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data da entrada',
    FOREIGN KEY (id_estoque) REFERENCES estoque_local(id_estoque) ON DELETE CASCADE,
    FOREIGN KEY (id_produto) REFERENCES produtos_farmacia(id_produto) ON DELETE RESTRICT,
    FOREIGN KEY (id_local) REFERENCES local_atendimento(id_local) ON DELETE RESTRICT,
    FOREIGN KEY (id_usuario_entrada) REFERENCES usuario(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT 'Entradas de estoque';

-- Dispensações de farmácia
CREATE TABLE IF NOT EXISTS dispensacao_farmacia (
    id_dispensacao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_prescricao BIGINT NULL COMMENT 'Prescrição associada',
    id_produto BIGINT NOT NULL COMMENT 'Produto dispensado',
    id_estoque BIGINT NOT NULL COMMENT 'Estoque de origem',
    quantidade_dispensada INT NOT NULL COMMENT 'Quantidade dispensada',
    id_usuario_farmaceutico BIGINT COMMENT 'Farmacêutico responsável',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data da dispensação',
    FOREIGN KEY (id_prescricao) REFERENCES prescricao(id_prescricao) ON DELETE SET NULL,
    FOREIGN KEY (id_produto) REFERENCES produtos_farmacia(id_produto) ON DELETE RESTRICT,
    FOREIGN KEY (id_estoque) REFERENCES estoque_local(id_estoque) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario_farmaceutico) REFERENCES usuario(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT 'Dispensações de farmácia';

-- Auditoria de estoque
CREATE TABLE IF NOT EXISTS auditoria_estoque (
    id_log BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_produto BIGINT NOT NULL COMMENT 'Produto auditado',
    id_local INT NOT NULL COMMENT 'Local auditado',
    acao VARCHAR(50) NOT NULL COMMENT 'Ação (ENTRADA, SAIDA, etc.)',
    quantidade INT NOT NULL COMMENT 'Quantidade afetada',
    id_usuario BIGINT COMMENT 'Usuário responsável',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data da ação',
    FOREIGN KEY (id_produto) REFERENCES produtos_farmacia(id_produto) ON DELETE CASCADE,
    FOREIGN KEY (id_local) REFERENCES local_atendimento(id_local) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT 'Auditoria de estoque';

-- Retornos de fila
CREATE TABLE IF NOT EXISTS fila_retorno (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_fila BIGINT NOT NULL COMMENT 'Fila associada',
    retorno_em DATETIME NOT NULL COMMENT 'Data de retorno',
    ativo BOOLEAN DEFAULT TRUE COMMENT 'Retorno ativo',
    FOREIGN KEY (id_fila) REFERENCES fila_senha(id) ON DELETE CASCADE,
    UNIQUE KEY uk_fila_retorno (id_fila)
) ENGINE=InnoDB COMMENT 'Retornos de fila de senhas';

-- Novas tabelas: Estoque de limpeza (separado)
CREATE TABLE IF NOT EXISTS estoque_limpeza (
    id_estoque BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_produto BIGINT NOT NULL COMMENT 'Produto de limpeza',
    id_local INT NOT NULL COMMENT 'Local do estoque',
    quantidade_atual INT DEFAULT 0 COMMENT 'Quantidade atual',
    min_estoque INT DEFAULT 0 COMMENT 'Mínimo para alerta',
    FOREIGN KEY (id_produto) REFERENCES produtos_limpeza(id_produto) ON DELETE CASCADE,
    FOREIGN KEY (id_local) REFERENCES local_atendimento(id_local) ON DELETE CASCADE,
    UNIQUE KEY uk_produto_local_limpeza (id_produto, id_local)
) ENGINE=InnoDB COMMENT 'Estoque para itens de limpeza';

-- Produtos de limpeza
CREATE TABLE IF NOT EXISTS produtos_limpeza (
    id_produto BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(200) NOT NULL COMMENT 'Nome do produto',
    tipo ENUM('LIMPEZA','MANUTENCAO','OUTRO') COMMENT 'Tipo de produto'
) ENGINE=InnoDB COMMENT 'Produtos para limpeza e manutenção';

-- Agendamentos
CREATE TABLE IF NOT EXISTS agendamentos (
    id_agendamento BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_pessoa BIGINT NOT NULL COMMENT 'Pessoa agendada',
    id_especialidade INT NOT NULL COMMENT 'Especialidade',
    data_agendada DATETIME NOT NULL COMMENT 'Data agendada',
    status ENUM('AGENDADO','REALIZADO','CANCELADO') DEFAULT 'AGENDADO' COMMENT 'Status do agendamento',
    id_usuario BIGINT COMMENT 'Usuário que agendou',
    observacao TEXT COMMENT 'Observações do agendamento',
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa) ON DELETE CASCADE,
    FOREIGN KEY (id_especialidade) REFERENCES especialidade(id_especialidade) ON DELETE RESTRICT,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE SET NULL,
    INDEX idx_data_agendada (data_agendada)
) ENGINE=InnoDB COMMENT 'Tabela de agendamentos de consultas';

-- Eventos de agendamentos
CREATE TABLE IF NOT EXISTS agendamentos_eventos (
    id_evento BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_agendamento BIGINT NOT NULL COMMENT 'Agendamento associado',
    tipo_evento VARCHAR(50) NOT NULL COMMENT 'Tipo de evento',
    descricao TEXT COMMENT 'Descrição do evento',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Data do evento',
    id_usuario BIGINT COMMENT 'Usuário responsável',
    FOREIGN KEY (id_agendamento) REFERENCES agendamentos(id_agendamento) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT 'Eventos relacionados a agendamentos';


CREATE TABLE produtos_almoxarifado (
    id_produto BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    categoria VARCHAR(100) COMMENT 'Ex: escritório, manutenção, EPI, TI',
    unidade_medida VARCHAR(20),
    ativo BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB COMMENT 'Produtos do almoxarifado';


CREATE TABLE estoque_almoxarifado (
    id_estoque BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_produto BIGINT NOT NULL,
    id_local INT NOT NULL,
    quantidade_atual INT DEFAULT 0,
    min_estoque INT DEFAULT 0,
    FOREIGN KEY (id_produto) REFERENCES produtos_almoxarifado(id_produto),
    FOREIGN KEY (id_local) REFERENCES local_atendimento(id_local),
    UNIQUE KEY uk_produto_local (id_produto, id_local)
) ENGINE=InnoDB COMMENT 'Estoque do almoxarifado por local';


CREATE TABLE almox_entrada (
    id_entrada BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_estoque BIGINT NOT NULL,
    quantidade INT NOT NULL,
    origem VARCHAR(100) COMMENT 'Compra, doação, transferência',
    id_usuario BIGINT,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_estoque) REFERENCES estoque_almoxarifado(id_estoque),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB COMMENT 'Entradas no almoxarifado';


CREATE TABLE almox_saida (
    id_saida BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_estoque BIGINT NOT NULL,
    quantidade INT NOT NULL,
    destino VARCHAR(100) COMMENT 'Setor, sala, manutenção',
    id_usuario BIGINT,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_estoque) REFERENCES estoque_almoxarifado(id_estoque),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB COMMENT 'Saídas do almoxarifado';


CREATE TABLE auditoria_almoxarifado (
    id_log BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_produto BIGINT NOT NULL,
    id_local INT NOT NULL,
    acao ENUM('ENTRADA','SAIDA','AJUSTE'),
    quantidade INT NOT NULL,
    id_usuario BIGINT,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_produto) REFERENCES produtos_almoxarifado(id_produto),
    FOREIGN KEY (id_local) REFERENCES local_atendimento(id_local),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB COMMENT 'Auditoria do almoxarifado';

CREATE TABLE observacoes_eventos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    entidade VARCHAR(50) NOT NULL COMMENT 'FILA_SENHA, FFA, PRESCRICAO, AGENDAMENTO',
    id_entidade BIGINT NOT NULL,
    contexto VARCHAR(50) COMMENT 'MEDICO, ENFERMAGEM, TECNICA, ADMIN',
    tipo VARCHAR(50) COMMENT 'OBSERVACAO, ALERTA, EVASAO, ORIENTACAO',
    texto TEXT NOT NULL,
    id_usuario BIGINT NOT NULL,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    INDEX idx_entidade (entidade, id_entidade)
) ENGINE=InnoDB COMMENT 'Observações e comunicações como eventos';

DROP TABLE IF EXISTS usuario_refresh;

CREATE TABLE usuario_refresh (
  id_refresh BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID do refresh token',
  id_usuario BIGINT NOT NULL COMMENT 'Usuário dono do token',
  token_hash CHAR(64) NOT NULL COMMENT 'Hash do refresh token',
  expires_at DATETIME NOT NULL COMMENT 'Expiração do token',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
  revoked TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Token revogado',
  user_agent VARCHAR(255) DEFAULT NULL COMMENT 'User agent do dispositivo',
  ip VARCHAR(45) DEFAULT NULL COMMENT 'IP de origem',
  CONSTRAINT fk_usuario_refresh_usuario
    FOREIGN KEY (id_usuario)
    REFERENCES usuario(id_usuario)
    ON DELETE CASCADE,
  UNIQUE KEY uk_token_hash (token_hash),
  KEY idx_usuario (id_usuario)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='Refresh tokens de autenticação com rotação e revogação';


CREATE TABLE if not exists ffa_substatus (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_ffa BIGINT NOT NULL,
    categoria ENUM(
        'MEDICACAO',
        'FARMACIA',
        'OBSERVACAO',
        'RX',
        'ECG',
        'COLETA',
        'OUTRO'
    ) NOT NULL,
    status VARCHAR(50) NOT NULL,
    ativo TINYINT(1) DEFAULT 1,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    finalizado_em DATETIME NULL,
    id_usuario BIGINT NULL,
    observacao TEXT,
    FOREIGN KEY (id_ffa) REFERENCES ffa(id) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE SET NULL,
    INDEX idx_ffa_categoria (id_ffa, categoria, ativo)
) ENGINE=InnoDB COMMENT='Substatus assistenciais da FFA';

CREATE TABLE if not exists prescricao_medicacao (
    id_prescricao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_ffa BIGINT NOT NULL,
    id_medico BIGINT NOT NULL,
    descricao TEXT NOT NULL COMMENT 'Descrição livre da prescrição',
    controlada TINYINT(1) DEFAULT 0 COMMENT 'Se exige liberação da farmácia',
    criada_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    ativa TINYINT(1) DEFAULT 1,
    FOREIGN KEY (id_ffa) REFERENCES ffa(id) ON DELETE CASCADE,
    FOREIGN KEY (id_medico) REFERENCES usuario(id_usuario) ON DELETE RESTRICT,
    INDEX idx_ffa (id_ffa)
) ENGINE=InnoDB COMMENT='Prescrições de medicação do PA';

DROP TABLE IF EXISTS ffa_procedimento;

CREATE TABLE ffa_procedimento (
    id_procedimento BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_ffa BIGINT NOT NULL,
    tipo ENUM('RX','ECG','EXAME_LAB','OUTROS') NOT NULL,
    descricao TEXT,
    solicitado_por BIGINT NOT NULL,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    finalizado_em DATETIME NULL,
    ativo TINYINT(1) DEFAULT 1,
    FOREIGN KEY (id_ffa) REFERENCES ffa(id),
    FOREIGN KEY (solicitado_por) REFERENCES usuario(id_usuario),
    INDEX idx_ffa (id_ffa)
) ENGINE=InnoDB COMMENT='Procedimentos solicitados durante o atendimento';


DROP TABLE IF EXISTS fila_operacional;

CREATE TABLE fila_operacional (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_ffa BIGINT NOT NULL,
    tipo ENUM('RX','ECG','LAB','PROCEDIMENTO','MEDICACAO') NOT NULL,
    status ENUM(
        'AGUARDANDO',
        'EM_EXECUCAO',
        'FINALIZADO',
        'CANCELADO'
    ) NOT NULL DEFAULT 'AGUARDANDO',
    prioridade TINYINT DEFAULT 0,
    solicitado_por BIGINT COMMENT 'Usuário (médico)',
    iniciado_em DATETIME NULL,
    finalizado_em DATETIME NULL,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_ffa) REFERENCES ffa(id),
    FOREIGN KEY (solicitado_por) REFERENCES usuario(id_usuario),
    INDEX idx_ffa_status (id_ffa, status),
    INDEX idx_tipo_status (tipo, status)
) ENGINE=InnoDB COMMENT='Fila operacional de execução (RX, ECG, etc)';
-- ===============================
-- DESLIGA TEMPORARIAMENTE FK
-- ===============================
SET FOREIGN_KEY_CHECKS = 0;

-- ===============================
-- DROP TABELA ANTIGA
-- ===============================
DROP TABLE IF EXISTS internacao;
DROP TABLE IF EXISTS internacao_historico;

-- ===============================
-- CRIAÇÃO DA TABELA INTERNACAO
-- ===============================
CREATE TABLE internacao (
    id_internacao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_ffa BIGINT NOT NULL COMMENT 'Episódio assistencial',
    id_leito INT NOT NULL COMMENT 'Leito ocupado',
    tipo ENUM('OBSERVACAO','INTERNACAO') NOT NULL,
    status ENUM('ATIVA','EM_OBSERVACAO','TRANSFERIDA','ENCERRADA') NOT NULL DEFAULT 'ATIVA',
    motivo TEXT COMMENT 'Motivo clínico da internação',
    data_entrada DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_saida DATETIME NULL,
    id_usuario_responsavel BIGINT NOT NULL COMMENT 'Médico ou profissional que internou',
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_ffa) REFERENCES ffa(id),
    FOREIGN KEY (id_leito) REFERENCES leito(id_leito),
    FOREIGN KEY (id_usuario_responsavel) REFERENCES usuario(id_usuario),
    INDEX idx_ffa_status (id_ffa, status),
    INDEX idx_leito_status (id_leito, status)
) ENGINE=InnoDB COMMENT='Internação e observação clínica vinculadas ao FFA';

-- ===============================
-- TABELA DE HISTÓRICO DE INTERNACAO
-- ===============================
CREATE TABLE internacao_historico (
    id_historico BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_internacao BIGINT NOT NULL,
    status_anterior ENUM('ATIVA','EM_OBSERVACAO','TRANSFERIDA','ENCERRADA') NOT NULL,
    status_novo ENUM('ATIVA','EM_OBSERVACAO','TRANSFERIDA','ENCERRADA') NOT NULL,
    data_alteracao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_usuario BIGINT COMMENT 'Usuário que realizou a alteração',
    comentario TEXT COMMENT 'Observação sobre a alteração',
    FOREIGN KEY (id_internacao) REFERENCES internacao(id_internacao) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE SET NULL,
    INDEX idx_internacao_data (id_internacao, data_alteracao)
) ENGINE=InnoDB COMMENT='Histórico de mudanças de status e alterações na internação';

-- ===============================
-- PROCEDURE: INTERNAR PACIENTE
-- ===============================
DELIMITER $$
CREATE PROCEDURE sp_internar_paciente(
    IN p_id_ffa BIGINT,
    IN p_id_leito INT,
    IN p_tipo ENUM('OBSERVACAO','INTERNACAO'),
    IN p_motivo TEXT,
    IN p_id_usuario BIGINT
)
BEGIN
    INSERT INTO internacao (id_ffa, id_leito, tipo, status, motivo, id_usuario_responsavel)
    VALUES (p_id_ffa, p_id_leito, p_tipo, 'ATIVA', p_motivo, p_id_usuario);
END$$
DELIMITER ;

-- ===============================
-- PROCEDURE: TRANSFERIR INTERNACAO
-- ===============================
DELIMITER $$
CREATE PROCEDURE sp_transferir_internacao(
    IN p_id_internacao BIGINT,
    IN p_novo_leito INT,
    IN p_id_usuario BIGINT,
    IN p_comentario TEXT
)
BEGIN
    DECLARE v_status_atual ENUM('ATIVA','EM_OBSERVACAO','TRANSFERIDA','ENCERRADA');

    SELECT status INTO v_status_atual FROM internacao WHERE id_internacao = p_id_internacao;

    -- Atualiza leito e status para TRANSFERIDA
    UPDATE internacao
    SET id_leito = p_novo_leito,
        status = 'TRANSFERIDA',
        atualizado_em = NOW()
    WHERE id_internacao = p_id_internacao;

    -- Insere histórico
    INSERT INTO internacao_historico (id_internacao, status_anterior, status_novo, id_usuario, comentario)
    VALUES (p_id_internacao, v_status_atual, 'TRANSFERIDA', p_id_usuario, p_comentario);
END$$
DELIMITER ;

-- ===============================
-- PROCEDURE: FINALIZAR INTERNACAO
-- ===============================
DELIMITER $$
CREATE PROCEDURE sp_finalizar_internacao(
    IN p_id_internacao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_comentario TEXT
)
BEGIN
    DECLARE v_status_atual ENUM('ATIVA','EM_OBSERVACAO','TRANSFERIDA','ENCERRADA');

    SELECT status INTO v_status_atual FROM internacao WHERE id_internacao = p_id_internacao;

    UPDATE internacao
    SET status = 'ENCERRADA',
        data_saida = NOW(),
        atualizado_em = NOW()
    WHERE id_internacao = p_id_internacao;

    -- Insere histórico
    INSERT INTO internacao_historico (id_internacao, status_anterior, status_novo, id_usuario, comentario)
    VALUES (p_id_internacao, v_status_atual, 'ENCERRADA', p_id_usuario, p_comentario);
END$$
DELIMITER ;

-- ===============================
-- PROCEDURE: ATUALIZAR STATUS INTERNACAO
-- ===============================
DELIMITER $$
CREATE PROCEDURE sp_atualizar_status_internacao(
    IN p_id_internacao BIGINT,
    IN p_novo_status ENUM('ATIVA','EM_OBSERVACAO','TRANSFERIDA','ENCERRADA'),
    IN p_id_usuario BIGINT,
    IN p_comentario TEXT
)
BEGIN
    DECLARE v_status_atual ENUM('ATIVA','EM_OBSERVACAO','TRANSFERIDA','ENCERRADA');

    SELECT status INTO v_status_atual FROM internacao WHERE id_internacao = p_id_internacao;

    UPDATE internacao
    SET status = p_novo_status,
        atualizado_em = NOW()
    WHERE id_internacao = p_id_internacao;

    -- Insere histórico
    INSERT INTO internacao_historico (id_internacao, status_anterior, status_novo, id_usuario, comentario)
    VALUES (p_id_internacao, v_status_atual, p_novo_status, p_id_usuario, p_comentario);
END$$
DELIMITER ;

-- ===============================
-- REATIVA FK
-- ===============================
SET FOREIGN_KEY_CHECKS = 1;



-- ===============================
-- DESLIGA TEMPORARIAMENTE FK
-- ===============================
SET FOREIGN_KEY_CHECKS = 0;

-- ===============================
-- DROP TABELA ANTIGA
-- ===============================
DROP TABLE IF EXISTS fila_operacional;

-- ===============================
-- CRIAÇÃO DA TABELA
-- ===============================
CREATE TABLE fila_operacional (
    id_fila BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_ffa BIGINT NOT NULL COMMENT 'Episódio assistencial',
    tipo ENUM('TRIAGEM','MEDICO','MEDICACAO','EXAME','RX','ECG','PROCEDIMENTO','OBSERVACAO') NOT NULL COMMENT 'Tipo de fila',
    substatus ENUM(
        'AGUARDANDO',
        'EM_EXECUCAO',
        'EM_OBSERVACAO',
        'FINALIZADO',
        'CRITICO'
    ) NOT NULL DEFAULT 'AGUARDANDO' COMMENT 'Substatus do paciente nesta fila',
    prioridade ENUM('VERMELHO','LARANJA','AMARELO','VERDE','AZUL') DEFAULT 'AZUL' COMMENT 'Prioridade de Manchester',
    data_entrada DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Chegada na fila',
    data_inicio DATETIME COMMENT 'Início do atendimento/exame',
    data_fim DATETIME COMMENT 'Término do atendimento/exame',
    id_responsavel BIGINT COMMENT 'Usuário que está atendendo/executando',
    observacao TEXT COMMENT 'Notas ou observações específicas',
    id_local INT COMMENT 'Local ou sala de atendimento',
    FOREIGN KEY (id_ffa) REFERENCES ffa(id),
    FOREIGN KEY (id_responsavel) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_local) REFERENCES local_atendimento(id_local),
    INDEX idx_ffa_tipo_substatus (id_ffa, tipo, substatus),
    INDEX idx_tipo_prioridade (tipo, prioridade, substatus)
) ENGINE=InnoDB COMMENT='Fila operacional de todos os atendimentos, procedimentos, exames, medicação e observação';

-- ===============================
-- REATIVA FK
-- ===============================
SET FOREIGN_KEY_CHECKS = 1;

