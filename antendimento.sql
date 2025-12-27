CREATE DATABASE IF NOT EXISTS pronto_atendimento
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

USE pronto_atendimento;

CREATE TABLE IF NOT EXISTS pessoa (
    id_pessoa BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome_completo VARCHAR(200) NOT NULL,
    nome_social VARCHAR(200),
    cpf VARCHAR(14),
    cns VARCHAR(20),
    data_nascimento DATE,
    sexo ENUM('M','F','O'),
    nome_mae VARCHAR(200),
    telefone VARCHAR(20),
    email VARCHAR(150),
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_cpf (cpf),
    UNIQUE KEY uk_cns (cns)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS usuario (
    id_usuario BIGINT AUTO_INCREMENT PRIMARY KEY,
    login VARCHAR(100) NOT NULL UNIQUE,
    senha_hash VARCHAR(255) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    id_pessoa BIGINT,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa)
);

CREATE TABLE IF NOT EXISTS perfil (
    id_perfil INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS usuario_perfil (
    id_usuario BIGINT,
    id_perfil INT,
    PRIMARY KEY (id_usuario, id_perfil),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_perfil) REFERENCES perfil(id_perfil)
);

CREATE TABLE IF NOT EXISTS especialidade (
    id_especialidade INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    ativa BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS medico (
    id_usuario BIGINT PRIMARY KEY,
    crm VARCHAR(20) NOT NULL,
    uf_crm CHAR(2) NOT NULL,
    UNIQUE KEY uk_crm (crm, uf_crm),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE IF NOT EXISTS medico_especialidade (
    id_usuario BIGINT,
    id_especialidade INT,
    PRIMARY KEY (id_usuario, id_especialidade),
    FOREIGN KEY (id_usuario) REFERENCES medico(id_usuario),
    FOREIGN KEY (id_especialidade) REFERENCES especialidade(id_especialidade)
);

CREATE TABLE IF NOT EXISTS local_atendimento (
    id_local INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS sala (
    id_sala INT AUTO_INCREMENT PRIMARY KEY,
    nome_exibicao VARCHAR(100) NOT NULL,
    id_local INT NOT NULL,
    id_especialidade INT,
    ativa BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_local) REFERENCES local_atendimento(id_local),
    FOREIGN KEY (id_especialidade) REFERENCES especialidade(id_especialidade)
);

CREATE TABLE IF NOT EXISTS usuario_alocacao (
    id_alocacao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_usuario BIGINT NOT NULL,
    id_sala INT NOT NULL,
    id_especialidade INT,
    inicio DATETIME DEFAULT CURRENT_TIMESTAMP,
    fim DATETIME,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_sala) REFERENCES sala(id_sala),
    FOREIGN KEY (id_especialidade) REFERENCES especialidade(id_especialidade)
);

CREATE TABLE IF NOT EXISTS senha (
    id_senha BIGINT AUTO_INCREMENT PRIMARY KEY,
    numero INT NOT NULL,
    origem ENUM('TOTEM','RECEPCAO','TOTEM_PRI_PEDI','TOTEM_PRI_ADULTO'),
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    chamada BOOLEAN DEFAULT FALSE
);

-- Tabela para armazenar feedbacks do Totem (pesquisa de satisfação)
CREATE TABLE IF NOT EXISTS totem_feedback (
    id_feedback BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_senha BIGINT NULL,
    origem VARCHAR(50) NULL,
    nota INT NULL,
    comentario TEXT NULL,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_senha) REFERENCES senha(id_senha)
);

CREATE TABLE IF NOT EXISTS atendimento (
    id_atendimento BIGINT AUTO_INCREMENT PRIMARY KEY,
    protocolo VARCHAR(30) NOT NULL UNIQUE,
    id_pessoa BIGINT NOT NULL,
    id_senha BIGINT,
    status_atendimento ENUM(
        'ABERTO','EM_ATENDIMENTO','EM_OBSERVACAO',
        'INTERNADO','FINALIZADO','NAO_ATENDIDO','RETORNO'
    ) NOT NULL,
    id_local_atual INT NOT NULL,
    id_sala_atual INT,
    id_especialidade INT,
    data_abertura DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_fechamento DATETIME,
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa),
    FOREIGN KEY (id_senha) REFERENCES senha(id_senha),
    FOREIGN KEY (id_local_atual) REFERENCES local_atendimento(id_local),
    FOREIGN KEY (id_sala_atual) REFERENCES sala(id_sala),
    FOREIGN KEY (id_especialidade) REFERENCES especialidade(id_especialidade),
    INDEX idx_status_local (status_atendimento, id_local_atual)
);



CREATE TABLE IF NOT EXISTS atendimento_movimentacao (
    id_mov BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento BIGINT,
    de_local INT,
    para_local INT,
    id_usuario BIGINT,
    motivo VARCHAR(255),
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE IF NOT EXISTS anamnese (
    id_anamnese BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento BIGINT,
    descricao TEXT,
    id_usuario BIGINT,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE IF NOT EXISTS prescricao (
    id_prescricao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento BIGINT,
    tipo ENUM('INTERNA','CONTROLADA','CASA'),
    descricao TEXT NOT NULL,
    id_medico BIGINT,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    bloqueada BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento),
    FOREIGN KEY (id_medico) REFERENCES medico(id_usuario)
);

CREATE TABLE IF NOT EXISTS protocolo_sequencia (
    id INT AUTO_INCREMENT PRIMARY KEY
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS log_auditoria (
    id_log BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_usuario BIGINT,
    acao VARCHAR(100),
    tabela_afetada VARCHAR(100),
    id_registro BIGINT,
    antes TEXT,
    depois TEXT,
    justificativa VARCHAR(255),
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP
);






DELIMITER ;




CREATE VIEW vw_fila_atendimento AS
SELECT
    a.id_atendimento,
    a.protocolo,
    p.nome_completo,
    a.status_atendimento,
    l.nome AS local
FROM atendimento a
JOIN pessoa p ON p.id_pessoa = a.id_pessoa
JOIN local_atendimento l ON l.id_local = a.id_local_atual
WHERE a.status_atendimento IN ('ABERTO','EM_ATENDIMENTO','EM_OBSERVACAO');

CREATE TABLE IF NOT EXISTS configuracao (
    chave VARCHAR(100) PRIMARY KEY,
    valor TEXT
);

CREATE TABLE IF NOT EXISTS atendimento_recepcao (
    id_atendimento BIGINT PRIMARY KEY,
    tipo_atendimento ENUM(
        'CLINICO',
        'PEDIATRICO',
        'EMERGENCIA',
        'EXAME_EXTERNO',
        'MEDICACAO_EXTERNA'
    ) NOT NULL,
    chegada ENUM(
        'MEIOS_PROPRIOS',
        'AMBULANCIA',
        'POLICIA',
        'OUTROS'
    ) NOT NULL,
    prioridade ENUM(
        'AUTISTA',
        'CRIANCA_COLO',
        'GESTANTE',
        'IDOSO',
        'PRIORITARIO_PEDI',
        'PRIORITARIO_ADULTO',
        'NORMAL'
    ) DEFAULT 'NORMAL',
    motivo_procura TEXT,
    destino_inicial ENUM(
        'TRIAGEM',
        'MEDICO',
        'EMERGENCIA',
        'RX',
        'MEDICACAO'
    ) NOT NULL,
    id_recepcionista BIGINT NOT NULL,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento),
    FOREIGN KEY (id_recepcionista) REFERENCES usuario(id_usuario)
);

CREATE TABLE IF NOT EXISTS classificacao_risco (
    id_risco INT AUTO_INCREMENT PRIMARY KEY,
    cor ENUM('VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
    tempo_max INT,
    descricao VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS triagem (
    id_triagem BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento BIGINT NOT NULL,
    id_risco INT NOT NULL,
    queixa TEXT,
    sinais_vitais JSON,
    observacao TEXT,
    id_enfermeiro BIGINT NOT NULL,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento),
    FOREIGN KEY (id_risco) REFERENCES classificacao_risco(id_risco),
    FOREIGN KEY (id_enfermeiro) REFERENCES usuario(id_usuario),
    UNIQUE KEY uk_triagem_atendimento (id_atendimento)
);

CREATE TABLE IF NOT EXISTS reabertura_atendimento (
    id_reabertura BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento BIGINT NOT NULL,
    id_usuario BIGINT NOT NULL,
    motivo TEXT NOT NULL,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

DELIMITER $$

CREATE PROCEDURE sp_abrir_atendimento(
    IN p_id_pessoa BIGINT,
    IN p_id_senha BIGINT,
    IN p_id_local INT,
    IN p_id_especialidade INT
)
BEGIN
    INSERT INTO atendimento (
        protocolo,
        id_pessoa,
        id_senha,
        status_atendimento,
        id_local_atual,
        id_especialidade
    )
    VALUES (
        fn_gera_protocolo(),
        p_id_pessoa,
        p_id_senha,
        'ABERTO',
        p_id_local,
        p_id_especialidade
    );
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_mover_atendimento(
    IN p_id_atendimento BIGINT,
    IN p_novo_local INT,
    IN p_nova_sala INT,
    IN p_usuario BIGINT,
    IN p_motivo TEXT
)
BEGIN
    INSERT INTO atendimento_movimentacao (
        id_atendimento,
        de_local,
        para_local,
        id_usuario,
        motivo
    )
    SELECT
        id_atendimento,
        id_local_atual,
        p_novo_local,
        p_usuario,
        p_motivo
    FROM atendimento
    WHERE id_atendimento = p_id_atendimento;

    UPDATE atendimento
    SET id_local_atual = p_novo_local,
        id_sala_atual = p_nova_sala
    WHERE id_atendimento = p_id_atendimento;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_finalizar_atendimento(
    IN p_id_atendimento BIGINT
)
BEGIN
    UPDATE atendimento
    SET status_atendimento = 'FINALIZADO',
        data_fechamento = NOW()
    WHERE id_atendimento = p_id_atendimento;
END$$

DELIMITER ;


============================================


DELIMITER $$

CREATE PROCEDURE sp_gerar_senha(
    IN p_origem ENUM('TOTEM','RECEPCAO')
)
BEGIN
    DECLARE prox_num INT;

    SELECT IFNULL(MAX(numero),0) + 1 INTO prox_num FROM senha
    WHERE DATE(data_hora) = CURDATE();

    INSERT INTO senha (numero, origem)
    VALUES (prox_num, p_origem);
END$$

DELIMITER ;




DROP PROCEDURE IF EXISTS sp_abre_atendimento;
DROP PROCEDURE IF EXISTS sp_abrir_atendimento;

DELIMITER $$
CREATE PROCEDURE sp_abrir_atendimento(
    IN p_id_pessoa BIGINT,
    IN p_id_senha BIGINT,
    IN p_id_local INT,
    IN p_id_especialidade INT
)
BEGIN
    INSERT INTO atendimento (
        protocolo,
        id_pessoa,
        id_senha,
        status_atendimento,
        id_local_atual,
        id_especialidade
    )
    VALUES (
        fn_gera_protocolo(),
        p_id_pessoa,
        p_id_senha,
        'ABERTO',
        p_id_local,
        p_id_especialidade
    );
END$$
DELIMITER ;




DELIMITER $$

CREATE PROCEDURE sp_registrar_recepcao(
    IN p_id_atendimento BIGINT,
    IN p_tipo ENUM('CLINICO','PEDIATRICO','EMERGENCIA','EXAME_EXTERNO','MEDICACAO_EXTERNA'),
    IN p_chegada ENUM('MEIOS_PROPRIOS','AMBULANCIA','POLICIA','OUTROS'),
    IN p_prioridade ENUM('AUTISTA','CRIANCA_COLO','GESTANTE','IDOSO','NORMAL'),
    IN p_motivo TEXT,
    IN p_destino ENUM('TRIAGEM','MEDICO','EMERGENCIA','RX','MEDICACAO'),
    IN p_usuario BIGINT
)
BEGIN
    INSERT INTO atendimento_recepcao (
        id_atendimento,
        tipo_atendimento,
        chegada,
        prioridade,
        motivo_procura,
        destino_inicial,
        id_recepcionista
    )
    VALUES (
        p_id_atendimento,
        p_tipo,
        p_chegada,
        p_prioridade,
        p_motivo,
        p_destino,
        p_usuario
    );
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_registrar_triagem(
    IN p_id_atendimento BIGINT,
    IN p_id_risco INT,
    IN p_queixa TEXT,
    IN p_sinais JSON,
    IN p_obs TEXT,
    IN p_enfermeiro BIGINT
)
BEGIN
    INSERT INTO triagem (
        id_atendimento,
        id_risco,
        queixa,
        sinais_vitais,
        observacao,
        id_enfermeiro
    )
    VALUES (
        p_id_atendimento,
        p_id_risco,
        p_queixa,
        p_sinais,
        p_obs,
        p_enfermeiro
    );

    UPDATE atendimento
    SET status_atendimento = 'EM_ATENDIMENTO'
    WHERE id_atendimento = p_id_atendimento;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_chamar_paciente(
    IN p_id_atendimento BIGINT,
    IN p_id_sala INT
)
BEGIN
    INSERT INTO chamada_painel (
        id_atendimento,
        id_sala,
        status
    )
    VALUES (
        p_id_atendimento,
        p_id_sala,
        'CHAMANDO'
    );
END$$

DELIMITER ;

DROP TRIGGER IF EXISTS trg_auditoria_atendimento_update;

DELIMITER $$
CREATE TRIGGER trg_auditoria_atendimento_update
AFTER UPDATE ON atendimento
FOR EACH ROW
BEGIN
    IF OLD.status_atendimento <> NEW.status_atendimento THEN
        INSERT INTO log_auditoria (
            id_usuario,
            acao,
            tabela_afetada,
            id_registro,
            antes,
            depois
        )
        VALUES (
            NULL,
            'UPDATE_STATUS',
            'atendimento',
            OLD.id_atendimento,
            OLD.status_atendimento,
            NEW.status_atendimento
        );
    END IF;
END$$
DELIMITER ;


DROP TRIGGER IF EXISTS trg_movimentacao_atendimento;
DELIMITER $$

CREATE TRIGGER trg_movimentacao_atendimento
BEFORE UPDATE ON atendimento
FOR EACH ROW
BEGIN
    IF OLD.id_local_atual <> NEW.id_local_atual
       OR OLD.id_sala_atual <> NEW.id_sala_atual THEN

        INSERT INTO atendimento_movimentacao (
            id_atendimento,
            de_local,
            para_local,
            id_usuario,
            motivo
        )
        VALUES (
            OLD.id_atendimento,
            OLD.id_local_atual,
            NEW.id_local_atual,
            NULL,
            'Movimentação automática'
        );
    END IF;
END$$
DELIMITER ;


CREATE TABLE IF NOT EXISTS chamada_painel (
    id_chamada BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento BIGINT NOT NULL,
    id_sala INT NOT NULL,
    status ENUM('CHAMANDO','ATENDIDO','NAO_COMPARECEU') DEFAULT 'CHAMANDO',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento),
    FOREIGN KEY (id_sala) REFERENCES sala(id_sala),
    INDEX idx_painel_status (status, data_hora)
);

DROP PROCEDURE IF EXISTS sp_chamar_paciente;
DELIMITER $$

CREATE PROCEDURE sp_chamar_paciente(
    IN p_id_atendimento BIGINT,
    IN p_id_sala INT
)
BEGIN
    INSERT INTO chamada_painel (id_atendimento, id_sala)
    VALUES (p_id_atendimento, p_id_sala);

    UPDATE senha
    SET chamada = TRUE
    WHERE id_senha = (
        SELECT id_senha FROM atendimento
        WHERE id_atendimento = p_id_atendimento
    );
END$$
DELIMITER ;

CREATE TABLE IF NOT EXISTS exame_fisico (
    id_exame BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento BIGINT,
    descricao TEXT,
    id_usuario BIGINT,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE IF NOT EXISTS hipotese_diagnostica (
    id_hipotese BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento BIGINT,
    cid10 VARCHAR(10),
    principal BOOLEAN DEFAULT FALSE,
    id_medico BIGINT,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento),
    FOREIGN KEY (id_medico) REFERENCES medico(id_usuario)
);

CREATE TABLE IF NOT EXISTS exame (
    id_exame INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE,
    descricao VARCHAR(255),
    tipo ENUM('LAB','RX','OUTROS')
);

CREATE TABLE IF NOT EXISTS solicitacao_exame (
    id_solicitacao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento BIGINT,
    id_exame INT,
    status ENUM('SOLICITADO','COLETADO','RESULTADO') DEFAULT 'SOLICITADO',
    id_medico BIGINT,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento),
    FOREIGN KEY (id_exame) REFERENCES exame(id_exame),
    FOREIGN KEY (id_medico) REFERENCES medico(id_usuario)
);

CREATE TABLE IF NOT EXISTS retorno_atendimento (
    id_retorno BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento_origem BIGINT,
    id_atendimento_retorno BIGINT,
    motivo TEXT,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_atendimento_origem) REFERENCES atendimento(id_atendimento),
    FOREIGN KEY (id_atendimento_retorno) REFERENCES atendimento(id_atendimento)
);

CREATE VIEW vw_historico_paciente AS
SELECT
    p.nome_completo,
    a.protocolo,
    a.status_atendimento,
    a.data_abertura,
    a.data_fechamento,
    l.nome AS local
FROM atendimento a
JOIN pessoa p ON p.id_pessoa = a.id_pessoa
JOIN local_atendimento l ON l.id_local = a.id_local_atual;

CREATE TABLE IF NOT EXISTS setor (
    id_setor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo ENUM('OBSERVACAO','INTERNACAO','UTI') NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS leito (
    id_leito INT AUTO_INCREMENT PRIMARY KEY,
    id_setor INT NOT NULL,
    identificacao VARCHAR(50) NOT NULL,
    status ENUM('LIVRE','OCUPADO','BLOQUEADO') DEFAULT 'LIVRE',
    FOREIGN KEY (id_setor) REFERENCES setor(id_setor),
    UNIQUE KEY uk_setor_leito (id_setor, identificacao)
);

CREATE TABLE IF NOT EXISTS internacao (
    id_internacao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento BIGINT NOT NULL,
    id_leito INT NOT NULL,
    tipo ENUM('OBSERVACAO','INTERNACAO') NOT NULL,
    data_entrada DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_saida DATETIME,
    status ENUM('ATIVA','ENCERRADA') DEFAULT 'ATIVA',
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento),
    FOREIGN KEY (id_leito) REFERENCES leito(id_leito)
   
);



CREATE TABLE IF NOT EXISTS evolucao_medica (
    id_evolucao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_internacao BIGINT NOT NULL,
    descricao TEXT NOT NULL,
    id_medico BIGINT NOT NULL,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_internacao) REFERENCES internacao(id_internacao),
    FOREIGN KEY (id_medico) REFERENCES medico(id_usuario)
);

CREATE TABLE IF NOT EXISTS prescricao_internacao (
    id_prescricao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_internacao BIGINT NOT NULL,
    tipo ENUM('MEDICAMENTO','CUIDADO','DIETA','OUTROS') NOT NULL,
    descricao TEXT NOT NULL,
    id_medico BIGINT NOT NULL,
    ativa BOOLEAN DEFAULT TRUE,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_internacao) REFERENCES internacao(id_internacao),
    FOREIGN KEY (id_medico) REFERENCES medico(id_usuario)
);

CREATE TABLE IF NOT EXISTS administracao_medicacao (
    id_admin BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_prescricao BIGINT NOT NULL,
    id_enfermeiro BIGINT NOT NULL,
    dose VARCHAR(50),
    via VARCHAR(50),
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    observacao TEXT,
    FOREIGN KEY (id_prescricao) REFERENCES prescricao_internacao(id_prescricao),
    FOREIGN KEY (id_enfermeiro) REFERENCES usuario(id_usuario)
);

CREATE TABLE IF NOT EXISTS evolucao_enfermagem (
    id_evolucao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_internacao BIGINT NOT NULL,
    descricao TEXT NOT NULL,
    id_enfermeiro BIGINT NOT NULL,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_internacao) REFERENCES internacao(id_internacao),
    FOREIGN KEY (id_enfermeiro) REFERENCES usuario(id_usuario)
);
CREATE TABLE IF NOT EXISTS anotacao_enfermagem (
    id_anotacao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_internacao BIGINT NOT NULL,
    descricao TEXT NOT NULL,
    id_usuario BIGINT NOT NULL,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_internacao) REFERENCES internacao(id_internacao),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE IF NOT EXISTS interconsulta (
    id_interconsulta BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_internacao BIGINT NOT NULL,
    id_especialidade INT NOT NULL,
    motivo TEXT NOT NULL,
    status ENUM('SOLICITADA','RESPONDIDA') DEFAULT 'SOLICITADA',
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_internacao) REFERENCES internacao(id_internacao),
    FOREIGN KEY (id_especialidade) REFERENCES especialidade(id_especialidade)
);
DROP PROCEDURE IF EXISTS sp_internar_paciente;
DELIMITER $$

CREATE PROCEDURE sp_internar_paciente(
    IN p_id_atendimento BIGINT,
    IN p_id_leito INT,
    IN p_tipo ENUM('OBSERVACAO','INTERNACAO')
)
BEGIN
    INSERT INTO internacao (id_atendimento, id_leito, tipo)
    VALUES (p_id_atendimento, p_id_leito, p_tipo);

    UPDATE leito SET status = 'OCUPADO' WHERE id_leito = p_id_leito;
    UPDATE atendimento SET status_atendimento = 'INTERNADO'
    WHERE id_atendimento = p_id_atendimento;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_alta_internacao;
DELIMITER $$

CREATE PROCEDURE sp_alta_internacao(
    IN p_id_internacao BIGINT
)
BEGIN
    UPDATE internacao
    SET status = 'ENCERRADA', data_saida = NOW()
    WHERE id_internacao = p_id_internacao;

    UPDATE leito
    SET status = 'LIVRE'
    WHERE id_leito = (
        SELECT id_leito FROM internacao WHERE id_internacao = p_id_internacao
    );
END$$
DELIMITER ;

CREATE VIEW vw_mapa_leitos AS
SELECT
    s.nome AS setor,
    l.identificacao AS leito,
    l.status,
    p.nome_completo AS paciente,
    a.protocolo
FROM leito l
JOIN setor s ON s.id_setor = l.id_setor
LEFT JOIN internacao i ON i.id_leito = l.id_leito AND i.status = 'ATIVA'
LEFT JOIN atendimento a ON a.id_atendimento = i.id_atendimento
LEFT JOIN pessoa p ON p.id_pessoa = a.id_pessoa;
DROP TRIGGER IF EXISTS trg_bloqueia_atendimento_finalizado;
DELIMITER $$


CREATE TRIGGER trg_bloqueia_atendimento_finalizado
BEFORE UPDATE ON atendimento
FOR EACH ROW
BEGIN
    IF OLD.status_atendimento IN ('FINALIZADO','NAO_ATENDIDO')
       AND OLD.status_atendimento <> NEW.status_atendimento THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Atendimento finalizado/encerrado não pode ser alterado';
    END IF;
END$$
DELIMITER ;
DROP TRIGGER IF EXISTS trg_unica_internacao_ativa;
DELIMITER $$

CREATE TRIGGER trg_unica_internacao_ativa
BEFORE INSERT ON internacao
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM internacao
        WHERE id_atendimento = NEW.id_atendimento
          AND status = 'ATIVA'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Já existe internação ativa para este atendimento';
    END IF;
END$$
DELIMITER ;
DROP TRIGGER IF EXISTS trg_prescricao_atendimento_fechado;
DELIMITER $$

CREATE TRIGGER trg_prescricao_atendimento_fechado
BEFORE INSERT ON prescricao
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM atendimento
        WHERE id_atendimento = NEW.id_atendimento
          AND status_atendimento IN ('FINALIZADO','NAO_ATENDIDO')
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não é possível prescrever em atendimento encerrado';
    END IF;
END$$
DELIMITER ;
DROP TRIGGER IF EXISTS trg_bloqueia_update_prescricao;
DELIMITER $$

CREATE TRIGGER trg_bloqueia_update_prescricao
BEFORE UPDATE ON prescricao
FOR EACH ROW
BEGIN
    IF OLD.bloqueada = TRUE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Prescrição bloqueada não pode ser alterada';
    END IF;
END$$
DELIMITER ;
DROP TRIGGER IF EXISTS trg_leito_ocupado;
DELIMITER $$

CREATE TRIGGER trg_leito_ocupado
BEFORE INSERT ON internacao
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM leito
        WHERE id_leito = NEW.id_leito
          AND status <> 'LIVRE'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Leito não disponível';
    END IF;
END$$
DELIMITER ;
DROP TRIGGER IF EXISTS trg_finalizacao_com_internacao;
DELIMITER $$

CREATE TRIGGER trg_finalizacao_com_internacao
BEFORE UPDATE ON atendimento
FOR EACH ROW
BEGIN
    IF NEW.status_atendimento = 'FINALIZADO'
       AND EXISTS (
           SELECT 1 FROM internacao
           WHERE id_atendimento = OLD.id_atendimento
             AND status = 'ATIVA'
       ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Finalize a internação antes de encerrar o atendimento';
    END IF;
END$$
DELIMITER ;
DROP TRIGGER IF EXISTS trg_admin_medicacao_duplicada;
DELIMITER $$

CREATE TRIGGER trg_admin_medicacao_duplicada
BEFORE INSERT ON administracao_medicacao
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM administracao_medicacao
        WHERE id_prescricao = NEW.id_prescricao
          AND DATE(data_hora) = CURDATE()
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Medicação já administrada hoje';
    END IF;
END$$
DELIMITER ;
DROP TRIGGER IF EXISTS trg_auditoria_prescricao;
DELIMITER $$

CREATE TRIGGER trg_auditoria_prescricao
AFTER INSERT ON prescricao
FOR EACH ROW
BEGIN
    INSERT INTO log_auditoria (
        acao,
        tabela_afetada,
        id_registro,
        depois
    )
    VALUES (
        'INSERT',
        'prescricao',
        NEW.id_prescricao,
        NEW.descricao
    );
END$$
DELIMITER ;
DELIMITER $$

CREATE PROCEDURE sp_reabrir_atendimento (
    IN p_id_atendimento BIGINT,
    IN p_usuario BIGINT,
    IN p_motivo TEXT
)
BEGIN
    INSERT INTO reabertura_atendimento (
        id_atendimento,
        id_usuario,
        motivo
    ) VALUES (
        p_id_atendimento,
        p_usuario,
        p_motivo
    );

    UPDATE atendimento
    SET status_atendimento = 'RETORNO',
        data_fechamento = NULL
    WHERE id_atendimento = p_id_atendimento;
END$$

DELIMITER ;

CREATE VIEW vw_gestor_atendimentos_status AS
SELECT
    status_atendimento,
    COUNT(*) AS total
FROM atendimento
GROUP BY status_atendimento;

CREATE VIEW vw_produtividade_medico AS
SELECT
    u.id_usuario,
    p.nome_completo AS medico,
    COUNT(a.id_atendimento) AS atendimentos_realizados
FROM atendimento a
JOIN prescricao pr ON pr.id_atendimento = a.id_atendimento
JOIN usuario u ON u.id_usuario = pr.id_medico
JOIN pessoa p ON p.id_pessoa = u.id_pessoa
WHERE a.status_atendimento = 'FINALIZADO'
GROUP BY u.id_usuario, p.nome_completo;

CREATE VIEW vw_produtividade_enfermagem AS
SELECT
    u.id_usuario,
    p.nome_completo AS enfermeiro,
    COUNT(t.id_triagem) AS triagens_realizadas
FROM triagem t
JOIN usuario u ON u.id_usuario = t.id_enfermeiro
JOIN pessoa p ON p.id_pessoa = u.id_pessoa
GROUP BY u.id_usuario, p.nome_completo;
CREATE VIEW vw_tempo_atendimento AS
SELECT
    id_atendimento,
    protocolo,
    TIMESTAMPDIFF(MINUTE, data_abertura, data_fechamento) AS tempo_minutos
FROM atendimento
WHERE status_atendimento = 'FINALIZADO';
CREATE VIEW vw_tempo_medio_atendimento AS
SELECT
    AVG(TIMESTAMPDIFF(MINUTE, data_abertura, data_fechamento)) AS tempo_medio_minutos
FROM atendimento
WHERE status_atendimento = 'FINALIZADO';
CREATE VIEW vw_origem_pacientes AS
SELECT
    chegada,
    COUNT(*) AS total
FROM atendimento_recepcao
GROUP BY chegada;
CREATE VIEW vw_tipo_atendimento AS
SELECT
    tipo_atendimento,
    COUNT(*) AS total
FROM atendimento_recepcao
GROUP BY tipo_atendimento;
CREATE VIEW vw_classificacao_risco AS
SELECT
    cr.cor,
    COUNT(t.id_triagem) AS total
FROM triagem t
JOIN classificacao_risco cr ON cr.id_risco = t.id_risco
GROUP BY cr.cor;
CREATE VIEW vw_base_faturamento AS
SELECT
    a.id_atendimento,
    a.protocolo,
    p.nome_completo,
    ar.tipo_atendimento,
    a.data_abertura,
    a.data_fechamento
FROM atendimento a
JOIN pessoa p ON p.id_pessoa = a.id_pessoa
JOIN atendimento_recepcao ar ON ar.id_atendimento = a.id_atendimento
WHERE a.status_atendimento = 'FINALIZADO';
CREATE VIEW vw_auditoria_status AS
SELECT
    tabela_afetada,
    id_registro,
    antes,
    depois,
    data_hora
FROM log_auditoria
WHERE acao = 'UPDATE_STATUS';
CREATE VIEW vw_atendimentos_diarios AS
SELECT
    DATE(data_abertura) AS dia,
    COUNT(*) AS total
FROM atendimento
GROUP BY DATE(data_abertura);
CREATE VIEW vw_nao_atendidos AS
SELECT
    COUNT(*) AS total
FROM atendimento
WHERE status_atendimento = 'NAO_ATENDIDO';
DELIMITER $$

CREATE PROCEDURE sp_buscar_ou_criar_pessoa (
    IN p_nome VARCHAR(200),
    IN p_cpf VARCHAR(14),
    IN p_cns VARCHAR(20),
    IN p_data_nascimento DATE,
    IN p_sexo ENUM('M','F','O'),
    OUT p_id_pessoa BIGINT
)
BEGIN
    -- 1. Tenta localizar por CPF
    IF p_cpf IS NOT NULL AND p_cpf <> '' THEN
        SELECT id_pessoa INTO p_id_pessoa
        FROM pessoa
        WHERE cpf = p_cpf
        LIMIT 1;
    END IF;

    -- 2. Se não achou, tenta CNS
    IF p_id_pessoa IS NULL AND p_cns IS NOT NULL AND p_cns <> '' THEN
        SELECT id_pessoa INTO p_id_pessoa
        FROM pessoa
        WHERE cns = p_cns
        LIMIT 1;
    END IF;

    -- 3. Se não existir, cria
    IF p_id_pessoa IS NULL THEN
        INSERT INTO pessoa (
            nome_completo,
            cpf,
            cns,
            data_nascimento,
            sexo
        ) VALUES (
            p_nome,
            p_cpf,
            p_cns,
            p_data_nascimento,
            p_sexo
        );

        SET p_id_pessoa = LAST_INSERT_ID();
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_abertura_recepcao (
    IN p_nome VARCHAR(200),
    IN p_cpf VARCHAR(14),
    IN p_cns VARCHAR(20),
    IN p_data_nascimento DATE,
    IN p_sexo ENUM('M','F','O'),
    IN p_tipo ENUM('CLINICO','PEDIATRICO','EMERGENCIA','EXAME_EXTERNO','MEDICACAO_EXTERNA'),
    IN p_chegada ENUM('MEIOS_PROPRIOS','AMBULANCIA','POLICIA','OUTROS'),
    IN p_prioridade ENUM('AUTISTA','CRIANCA_COLO','GESTANTE','IDOSO','NORMAL'),
    IN p_motivo TEXT,
    IN p_destino ENUM('TRIAGEM','MEDICO','EMERGENCIA','RX','MEDICACAO'),
    IN p_usuario BIGINT
)
BEGIN
    DECLARE v_id_pessoa BIGINT;
    DECLARE v_id_senha BIGINT;
    DECLARE v_id_atendimento BIGINT;

    -- Pessoa
    CALL sp_buscar_ou_criar_pessoa(
        p_nome, p_cpf, p_cns, p_data_nascimento, p_sexo, v_id_pessoa
    );

    -- Senha
    CALL sp_gerar_senha('RECEPCAO');
    SET v_id_senha = LAST_INSERT_ID();

    -- Atendimento
    CALL sp_abre_atendimento(
        v_id_pessoa,
        v_id_senha,
        1, -- local inicial (ex: recepção)
        NULL
    );
    SET v_id_atendimento = LAST_INSERT_ID();

    -- Recepção
    CALL sp_registrar_recepcao(
        v_id_atendimento,
        p_tipo,
        p_chegada,
        p_prioridade,
        p_motivo,
        p_destino,
        p_usuario
    );
END$$

DELIMITER ;

CREATE TABLE IF NOT EXISTS atendimento_observacao (
    id_obs BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento BIGINT NOT NULL,
    tipo ENUM('OBSERVACAO','INTERNACAO') NOT NULL,
    id_leito INT,
    data_inicio DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_fim DATETIME,
    status ENUM('ATIVO','ALTA','TRANSFERIDO') DEFAULT 'ATIVO',
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento),
    FOREIGN KEY (id_leito) REFERENCES leito(id_leito),
    UNIQUE KEY uk_atendimento_obs (id_atendimento)
);


CREATE TABLE IF NOT EXISTS prescricao_continua (
    id_prescricao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento BIGINT NOT NULL,
    tipo ENUM('MEDICAMENTOS','CUIDADOS_GERAIS') NOT NULL,
    id_medico BIGINT NOT NULL,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    ativa BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento),
    FOREIGN KEY (id_medico) REFERENCES medico(id_usuario)
);
CREATE TABLE IF NOT EXISTS prescricao_item (
    id_item BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_prescricao BIGINT NOT NULL,
    descricao TEXT NOT NULL,
    dose VARCHAR(100),
    via VARCHAR(50),
    posologia VARCHAR(100),
    observacao TEXT,
    FOREIGN KEY (id_prescricao) REFERENCES prescricao_continua(id_prescricao)
);

CREATE TABLE IF NOT EXISTS evolucao_multidisciplinar (
    id_evolucao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_atendimento BIGINT NOT NULL,
    area VARCHAR(100), -- fisioterapia, nutrição, etc
    descricao TEXT NOT NULL,
    id_usuario BIGINT NOT NULL,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);
CREATE TABLE IF NOT EXISTS intercorrencia (
    id_intercorrencia BIGINT AUTO_INCREMENT PRIMARY KEY,

    id_atendimento BIGINT NOT NULL,
    id_internacao BIGINT NULL,

    descricao TEXT NOT NULL,

    gravidade ENUM('LEVE','MODERADA','GRAVE') DEFAULT 'LEVE',

    id_usuario BIGINT NOT NULL,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento),
    FOREIGN KEY (id_internacao) REFERENCES internacao(id_internacao),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),

    INDEX idx_intercorrencia_atendimento (id_atendimento),
    INDEX idx_intercorrencia_internacao (id_internacao)
);

DELIMITER $$

CREATE PROCEDURE sp_entrar_observacao (
    IN p_id_atendimento BIGINT,
    IN p_tipo ENUM('OBSERVACAO','INTERNACAO'),
    IN p_id_leito INT
)
BEGIN
    UPDATE atendimento
    SET status_atendimento = 
        CASE 
            WHEN p_tipo = 'INTERNACAO' THEN 'INTERNADO'
            ELSE 'EM_OBSERVACAO'
        END
    WHERE id_atendimento = p_id_atendimento;

    INSERT INTO atendimento_observacao (
        id_atendimento,
        tipo,
        id_leito
    )
    VALUES (
        p_id_atendimento,
        p_tipo,
        p_id_leito
    );
END$$
delimiter; 

CREATE OR REPLACE VIEW vw_paciente_observacao AS
SELECT
    a.id_atendimento,
    a.protocolo,
    p.nome_completo,
    o.tipo,
    CONCAT(s.nome, ' - Leito ', l.identificacao) AS leito,
    l.status AS status_leito,
    a.status_atendimento,
    o.data_inicio
FROM atendimento a
JOIN pessoa p 
    ON p.id_pessoa = a.id_pessoa
JOIN atendimento_observacao o 
    ON o.id_atendimento = a.id_atendimento
LEFT JOIN leito l 
    ON l.id_leito = o.id_leito
LEFT JOIN setor s
    ON s.id_setor = l.id_setor
WHERE o.status = 'ATIVO';

DELIMITER $$

CREATE TRIGGER trg_ocupa_leito
AFTER INSERT ON atendimento_observacao
FOR EACH ROW
BEGIN
    IF NEW.id_leito IS NOT NULL THEN
        UPDATE leito
        SET status = 'OCUPADO'
        WHERE id_leito = NEW.id_leito;
    END IF;
END$$

DELIMITER ;
DELIMITER $$

CREATE TRIGGER trg_libera_leito
AFTER UPDATE ON atendimento_observacao
FOR EACH ROW
BEGIN
    IF OLD.status = 'ATIVO' AND NEW.status <> 'ATIVO' THEN
        UPDATE leito
        SET status = 'LIVRE'
        WHERE id_leito = OLD.id_leito;
    END IF;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_encerrar_internacao
AFTER UPDATE ON internacao
FOR EACH ROW
BEGIN
    IF OLD.status = 'ATIVA' AND NEW.status = 'ENCERRADA' THEN
        UPDATE atendimento
        SET status_atendimento = 'FINALIZADO',
            data_fechamento = NOW()
        WHERE id_atendimento = NEW.id_atendimento;
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_alta_internacao
AFTER UPDATE ON internacao
FOR EACH ROW
BEGIN
    IF OLD.status = 'ATIVO' AND NEW.status <> 'ATIVO' THEN
        UPDATE atendimento
        SET status_atendimento = 'FINALIZADO',
            data_fechamento = NOW()
        WHERE id_atendimento = NEW.id_atendimento;
    END IF;
END$$

DELIMITER ;



DELIMITER $$

CREATE TRIGGER trg_bloqueia_anamnese_finalizado
BEFORE INSERT ON anamnese
FOR EACH ROW
BEGIN
    IF (SELECT status_atendimento 
        FROM atendimento 
        WHERE id_atendimento = NEW.id_atendimento) = 'FINALIZADO' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Atendimento finalizado. Não é permitido incluir anamnese.';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_bloqueia_prescricao
BEFORE UPDATE ON prescricao
FOR EACH ROW
BEGIN
    IF OLD.bloqueada = TRUE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Prescrição bloqueada. Não pode ser alterada.';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_uma_internacao_ativa
BEFORE INSERT ON internacao
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM internacao 
        WHERE id_atendimento = NEW.id_atendimento 
          AND status = 'ATIVA'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Já existe uma internação/observação ativa para este atendimento.';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_nao_atendido
BEFORE UPDATE ON atendimento
FOR EACH ROW
BEGIN
    IF NEW.status_atendimento = 'NAO_ATENDIDO'
       AND OLD.status_atendimento IN ('ABERTO','EM_ATENDIMENTO') THEN
        SET NEW.data_fechamento = NOW();
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_audit_prescricao_insert
AFTER INSERT ON prescricao
FOR EACH ROW
BEGIN
    INSERT INTO log_auditoria (
        id_usuario,
        acao,
        tabela_afetada,
        id_registro,
        depois
    )
    VALUES (
        NEW.id_medico,
        'INSERT',
        'prescricao',
        NEW.id_prescricao,
        NEW.descricao
    );
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_reabertura_status
AFTER INSERT ON reabertura_atendimento
FOR EACH ROW
BEGIN
    UPDATE atendimento
    SET status_atendimento = 'RETORNO',
        data_fechamento = NULL
    WHERE id_atendimento = NEW.id_atendimento;
END$$

DELIMITER ;

CREATE OR REPLACE VIEW vw_fila_atual AS
SELECT
    a.id_atendimento,
    a.protocolo,
    p.nome_completo,
    a.status_atendimento,
    l.nome AS local_atual,
    s.nome_exibicao AS sala,
    a.data_abertura,
    TIMESTAMPDIFF(MINUTE, a.data_abertura, NOW()) AS tempo_espera_min
FROM atendimento a
JOIN pessoa p ON p.id_pessoa = a.id_pessoa
JOIN local_atendimento l ON l.id_local = a.id_local_atual
LEFT JOIN sala s ON s.id_sala = a.id_sala_atual
WHERE a.status_atendimento IN ('ABERTO','EM_ATENDIMENTO','EM_OBSERVACAO');

CREATE OR REPLACE VIEW vw_tempo_medio_atendimento AS
SELECT
    DATE(a.data_abertura) AS data,
    COUNT(*) AS total_atendimentos,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, a.data_abertura, a.data_fechamento)),2) AS tempo_medio_min
FROM atendimento a
WHERE a.status_atendimento = 'FINALIZADO'
GROUP BY DATE(a.data_abertura);

CREATE OR REPLACE VIEW vw_ocupacao_leitos AS
SELECT
    s.nome AS setor,
    COUNT(l.id_leito) AS total_leitos,
    SUM(CASE WHEN l.status = 'OCUPADO' THEN 1 ELSE 0 END) AS ocupados,
    SUM(CASE WHEN l.status = 'LIVRE' THEN 1 ELSE 0 END) AS livres,
    ROUND(
        (SUM(CASE WHEN l.status = 'OCUPADO' THEN 1 ELSE 0 END) / COUNT(l.id_leito)) * 100,
        2
    ) AS taxa_ocupacao_percent
FROM leito l
JOIN setor s ON s.id_setor = l.id_setor
GROUP BY s.nome;

CREATE OR REPLACE VIEW vw_tempo_internacao AS
SELECT
    i.tipo,
    COUNT(*) AS total_pacientes,
    ROUND(
        AVG(TIMESTAMPDIFF(HOUR, i.data_entrada, IFNULL(i.data_saida, NOW()))),
        2
    ) AS tempo_medio_horas
FROM internacao i
GROUP BY i.tipo;

CREATE OR REPLACE VIEW vw_produtividade_medica AS
SELECT
    u.id_usuario,
    p.nome_completo AS medico,
    COUNT(DISTINCT a.id_atendimento) AS atendimentos_realizados
FROM atendimento a
JOIN anamnese an ON an.id_atendimento = a.id_atendimento
JOIN usuario u ON u.id_usuario = an.id_usuario
JOIN pessoa p ON p.id_pessoa = u.id_pessoa
WHERE a.status_atendimento = 'FINALIZADO'
GROUP BY u.id_usuario, p.nome_completo;

CREATE OR REPLACE VIEW vw_produtividade_medica AS
SELECT
    u.id_usuario,
    p.nome_completo AS medico,
    COUNT(DISTINCT a.id_atendimento) AS atendimentos_realizados
FROM atendimento a
JOIN (
    SELECT id_atendimento, id_usuario FROM anamnese
    UNION
    SELECT id_atendimento, id_medico AS id_usuario FROM prescricao
) atos ON atos.id_atendimento = a.id_atendimento
JOIN usuario u ON u.id_usuario = atos.id_usuario
JOIN pessoa p ON p.id_pessoa = u.id_pessoa
WHERE a.status_atendimento = 'FINALIZADO'
GROUP BY u.id_usuario, p.nome_completo;

CREATE OR REPLACE VIEW vw_retorno_paciente AS
SELECT
    a.id_atendimento,
    a.protocolo,
    p.nome_completo,
    r.data_hora AS data_retorno,
    r.motivo
FROM reabertura_atendimento r
JOIN atendimento a ON a.id_atendimento = r.id_atendimento
JOIN pessoa p ON p.id_pessoa = a.id_pessoa;

CREATE OR REPLACE VIEW vw_nao_atendidos AS
SELECT
    a.protocolo,
    p.nome_completo,
    a.data_abertura,
    a.data_fechamento,
    TIMESTAMPDIFF(MINUTE, a.data_abertura, a.data_fechamento) AS tempo_espera
FROM atendimento a
JOIN pessoa p ON p.id_pessoa = a.id_pessoa
WHERE a.status_atendimento = 'NAO_ATENDIDO';

CREATE OR REPLACE VIEW vw_fila_atendimento AS
SELECT
    a.id_atendimento,
    a.protocolo,
    p.nome_completo,
    ar.tipo_atendimento,
    ar.prioridade,
    a.status_atendimento,
    l.nome AS local_atual,
    a.data_abertura
FROM atendimento a
JOIN pessoa p ON p.id_pessoa = a.id_pessoa
LEFT JOIN atendimento_recepcao ar ON ar.id_atendimento = a.id_atendimento
JOIN local_atendimento l ON l.id_local = a.id_local_atual
WHERE a.status_atendimento IN ('ABERTO','EM_ATENDIMENTO','EM_OBSERVACAO');

CREATE OR REPLACE VIEW vw_fila_triagem AS
SELECT
    a.id_atendimento,
    a.protocolo,
    p.nome_completo,
    ar.prioridade,
    ar.motivo_procura,
    a.data_abertura
FROM atendimento a
JOIN pessoa p ON p.id_pessoa = a.id_pessoa
JOIN atendimento_recepcao ar ON ar.id_atendimento = a.id_atendimento
LEFT JOIN triagem t ON t.id_atendimento = a.id_atendimento
WHERE ar.destino_inicial = 'TRIAGEM'
AND t.id_triagem IS NULL;

CREATE OR REPLACE VIEW vw_pacientes_internados AS
SELECT
    i.id_internacao,
    a.id_atendimento,
    a.protocolo,
    p.nome_completo,
    i.tipo,
    l.identificacao AS leito,
    i.status,
    i.data_entrada
FROM internacao i
JOIN atendimento a ON a.id_atendimento = i.id_atendimento
JOIN pessoa p ON p.id_pessoa = a.id_pessoa
JOIN leito l ON l.id_leito = i.id_leito
WHERE i.status = 'ATIVA';

CREATE OR REPLACE VIEW vw_produtividade_medica AS
SELECT
    u.id_usuario,
    pe.nome_completo AS medico,
    COUNT(DISTINCT a.id_atendimento) AS atendimentos_realizados
FROM atendimento a
JOIN (
    SELECT id_atendimento, id_usuario FROM anamnese
    UNION
    SELECT id_atendimento, id_medico AS id_usuario FROM prescricao
) atos ON atos.id_atendimento = a.id_atendimento
JOIN usuario u ON u.id_usuario = atos.id_usuario
JOIN pessoa pe ON pe.id_pessoa = u.id_pessoa
WHERE a.status_atendimento = 'FINALIZADO'
GROUP BY u.id_usuario, pe.nome_completo;

CREATE OR REPLACE VIEW vw_produtividade_enfermagem AS
SELECT
    u.id_usuario,
    p.nome_completo AS profissional,
    COUNT(DISTINCT t.id_triagem) AS triagens_realizadas
FROM triagem t
JOIN usuario u ON u.id_usuario = t.id_enfermeiro
JOIN pessoa p ON p.id_pessoa = u.id_pessoa
GROUP BY u.id_usuario, p.nome_completo;

CREATE OR REPLACE VIEW vw_atendimentos_por_local AS
SELECT
    l.nome AS local,
    COUNT(*) AS total_atendimentos
FROM atendimento a
JOIN local_atendimento l ON l.id_local = a.id_local_atual
GROUP BY l.nome;

CREATE OR REPLACE VIEW vw_atendimentos_por_tipo AS
SELECT
    tipo_atendimento,
    COUNT(*) AS total
FROM atendimento_recepcao
GROUP BY tipo_atendimento;

CREATE OR REPLACE VIEW vw_receitas_controladas AS
SELECT
    pr.id_prescricao,
    a.protocolo,
    pe.nome_completo AS paciente,
    pm.nome_completo AS medico,
    pr.data_hora
FROM prescricao pr
JOIN atendimento a ON a.id_atendimento = pr.id_atendimento
JOIN pessoa pe ON pe.id_pessoa = a.id_pessoa
JOIN usuario um ON um.id_usuario = pr.id_medico
JOIN pessoa pm ON pm.id_pessoa = um.id_pessoa
WHERE pr.tipo = 'CONTROLADA';

CREATE OR REPLACE VIEW vw_historico_paciente AS
SELECT
    a.id_atendimento,
    a.protocolo,
    a.data_abertura,
    a.data_fechamento,
    a.status_atendimento,
    p.nome_completo
FROM atendimento a
JOIN pessoa p ON p.id_pessoa = a.id_pessoa;

CREATE OR REPLACE VIEW vw_auditoria AS
SELECT
    la.data_hora,
    u.login,
    la.acao,
    la.tabela_afetada,
    la.id_registro,
    la.antes,
    la.depois
FROM log_auditoria la
LEFT JOIN usuario u ON u.id_usuario = la.id_usuario
ORDER BY la.data_hora DESC;

CREATE TABLE IF NOT EXISTS enfermagem (
    id_usuario BIGINT PRIMARY KEY,
    coren VARCHAR(20) NOT NULL,
    uf_coren CHAR(2) NOT NULL,
    tipo ENUM('ENFERMEIRO','TECNICO') NOT NULL,
    UNIQUE KEY uk_coren (coren, uf_coren),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE IF NOT EXISTS permissao (
    id_permissao INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(100) UNIQUE NOT NULL,
    descricao VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS perfil_permissao (
    id_perfil INT,
    id_permissao INT,
    PRIMARY KEY (id_perfil, id_permissao),
    FOREIGN KEY (id_perfil) REFERENCES perfil(id_perfil),
    FOREIGN KEY (id_permissao) REFERENCES permissao(id_permissao)
);

CREATE VIEW vw_usuario_permissoes AS
SELECT
    u.id_usuario,
    u.login,
    pe.codigo AS permissao
FROM usuario u
JOIN usuario_perfil up ON up.id_usuario = u.id_usuario
JOIN perfil_permissao pp ON pp.id_perfil = up.id_perfil
JOIN permissao pe ON pe.id_permissao = pp.id_permissao;


INSERT INTO perfil_permissao
SELECT p.id_perfil, pe.id_permissao
FROM perfil p, permissao pe
WHERE p.nome = 'RECEPCAO'
AND pe.codigo IN ('ABRIR_ATENDIMENTO');


INSERT INTO perfil (nome) VALUES
('ADMIN'),
('GESTAO'),
('RECEPCAO'),
('ENFERMAGEM'),
('MEDICO'),
('FARMACIA'),
('AUDITORIA');



INSERT INTO permissao (codigo, descricao) VALUES
('ABRIR_ATENDIMENTO', 'Abrir atendimento'),
('REGISTRAR_TRIAGEM', 'Registrar triagem'),
('REALIZAR_ANAMNESE', 'Registrar anamnese'),
('PRESCREVER', 'Emitir prescrição'),
('FINALIZAR_ATENDIMENTO', 'Finalizar atendimento'),
('REABRIR_ATENDIMENTO', 'Reabrir atendimento'),
('ADMINISTRAR_MEDICACAO', 'Administrar medicação'),
('VER_RELATORIOS', 'Acessar relatórios'),
('VER_AUDITORIA', 'Visualizar auditoria');


INSERT INTO perfil_permissao
SELECT p.id_perfil, pe.id_permissao
FROM perfil p, permissao pe
WHERE p.nome = 'ENFERMAGEM'
AND pe.codigo IN (
    'REGISTRAR_TRIAGEM',
    'ADMINISTRAR_MEDICACAO'
);

INSERT INTO perfil_permissao
SELECT p.id_perfil, pe.id_permissao
FROM perfil p, permissao pe
WHERE p.nome = 'MEDICO'
AND pe.codigo IN (
    'REALIZAR_ANAMNESE',
    'PRESCREVER',
    'FINALIZAR_ATENDIMENTO'
);

INSERT INTO perfil_permissao
SELECT p.id_perfil, pe.id_permissao
FROM perfil p, permissao pe
WHERE p.nome = 'GESTAO'
AND pe.codigo IN ('VER_RELATORIOS');

INSERT INTO perfil_permissao
SELECT p.id_perfil, pe.id_permissao
FROM perfil p, permissao pe
WHERE p.nome = 'AUDITORIA'
AND pe.codigo IN ('VER_AUDITORIA');


ALTER TABLE perfil_permissao ADD COLUMN permissao VARCHAR(255);

CREATE TABLE IF NOT EXISTS permissao_procedure (
    id_perfil INT,
    procedure_nome VARCHAR(100),
    PRIMARY KEY(id_perfil, procedure_nome),
    FOREIGN KEY (id_perfil) REFERENCES perfil(id_perfil)
);


DELIMITER $$

CREATE PROCEDURE sp_abrir_atendimento_segura(
    IN p_id_usuario BIGINT,
    IN p_id_pessoa BIGINT,
    IN p_id_senha BIGINT,
    IN p_id_local INT,
    IN p_id_especialidade INT,
    OUT p_id_atendimento BIGINT
)
BEGIN
    -- Verifica permissão do usuário
    IF NOT EXISTS (
        SELECT 1
        FROM usuario_perfil up
        JOIN permissao_procedure pp ON up.id_perfil = pp.id_perfil
        WHERE up.id_usuario = p_id_usuario
          AND pp.procedure_nome = 'sp_abrir_atendimento'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Permissão negada para abrir atendimento';
    ELSE
        -- Chama a procedure real de abertura de atendimento
        CALL sp_abrir_atendimento(p_id_pessoa, p_id_senha, p_id_local, p_id_especialidade);
        
        -- Retorna o ID do atendimento criado
        SET p_id_atendimento = LAST_INSERT_ID();
    END IF;
END$$

DELIMITER ;

-- Variável para receber o id_atendimento
SET @id_atendimento = 0;

-- Chamada da procedure segura
CALL sp_abrir_atendimento_segura(1, 123, 456, 1, NULL, @id_atendimento);

-- Verificar o resultado
SELECT @id_atendimento;


DELIMITER $$

CREATE PROCEDURE sp_internar_paciente_segura(
    IN p_id_usuario BIGINT,
    IN p_id_atendimento BIGINT,
    IN p_id_leito INT,
    IN p_tipo ENUM('OBSERVACAO','INTERNACAO'),
    OUT p_id_internacao BIGINT
)
BEGIN
    -- Verifica permissão
    IF NOT EXISTS (
        SELECT 1
        FROM usuario_perfil up
        JOIN permissao_procedure pp ON up.id_perfil = pp.id_perfil
        WHERE up.id_usuario = p_id_usuario
          AND pp.procedure_nome = 'sp_internar_paciente'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Permissão negada para internar paciente';
    ELSE
        -- Chama a procedure original
        CALL sp_internar_paciente(p_id_atendimento, p_id_leito, p_tipo);
        
        -- Retorna o ID da internação criada
        SET p_id_internacao = LAST_INSERT_ID();
    END IF;
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_alta_internacao_segura(
    IN p_id_usuario BIGINT,
    IN p_id_internacao BIGINT
)
BEGIN
    -- Verifica permissão
    IF NOT EXISTS (
        SELECT 1
        FROM usuario_perfil up
        JOIN permissao_procedure pp ON up.id_perfil = pp.id_perfil
        WHERE up.id_usuario = p_id_usuario
          AND pp.procedure_nome = 'sp_alta_internacao'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Permissão negada para dar alta na internação';
    ELSE
        -- Chama a procedure original
        CALL sp_alta_internacao(p_id_internacao);
    END IF;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS sp_abrir_atendimento_segura;

DELIMITER $$

CREATE PROCEDURE sp_abrir_atendimento_segura(
    IN p_id_usuario BIGINT,
    IN p_id_pessoa BIGINT,
    IN p_id_senha BIGINT,
    IN p_id_local INT,
    IN p_id_especialidade INT,
    OUT p_id_atendimento_result BIGINT   -- OUT opcional para capturar ID criado
)
BEGIN
    -- 1. Verifica permissão
    IF NOT EXISTS (
        SELECT 1
        FROM usuario_perfil up
        JOIN permissao_procedure pp ON up.id_perfil = pp.id_perfil
        WHERE up.id_usuario = p_id_usuario
          AND pp.procedure_nome = 'sp_abrir_atendimento'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Permissão negada para abrir atendimento';
    ELSE
        -- 2. Chama a procedure original
        CALL sp_abrir_atendimento(
            p_id_usuario,
            p_id_pessoa,
            p_id_senha,
            p_id_local,
            p_id_especialidade
        );

        -- 3. Se a procedure original gera um ID, captura o valor
        SET p_id_atendimento_result = LAST_INSERT_ID();
    END IF;
END$$

DELIMITER ;
-- Garante que o banco de dados 'pronto_atendimento' está em uso
USE pronto_atendimento;

-- Cria a tabela 'documento' com os tipos de dados corretos para as chaves estrangeiras
CREATE TABLE IF NOT EXISTS documento (
    id_documento BIGINT AUTO_INCREMENT PRIMARY KEY, -- Alterado para BIGINT para consistência
    id_atendimento BIGINT NOT NULL,              -- Corrigido para BIGINT
    tipo ENUM('RECEITA','EXAME','ATESTADO','EVOLUCAO','ALTA','RETORNO') NOT NULL,
    conteudo LONGTEXT,
    id_usuario BIGINT NOT NULL,                  -- Corrigido para BIGINT
    data_geracao DATETIME DEFAULT CURRENT_TIMESTAMP, -- Adicionado DEFAULT para data
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento) ON DELETE RESTRICT,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Garante que o banco de dados 'pronto_atendimento' está em uso
USE pronto_atendimento;

-- Cria a tabela 'nao_atendido' com os tipos de dados corretos para as chaves estrangeiras
CREATE TABLE IF NOT EXISTS nao_atendido (
    id_nao_atendido BIGINT AUTO_INCREMENT PRIMARY KEY, -- Alterado para BIGINT para consistência
    id_atendimento BIGINT NOT NULL,                 -- Corrigido para BIGINT
    motivo TEXT,
    id_usuario BIGINT NOT NULL,                     -- Corrigido para BIGINT
    data_registro DATETIME DEFAULT CURRENT_TIMESTAMP, -- Adicionado DEFAULT para data
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento) ON DELETE RESTRICT,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS pedido_exame (
  id_pedido_exame INT AUTO_INCREMENT PRIMARY KEY,
  id_atendimento INT NOT NULL,
  id_usuario_medico INT NOT NULL,
  status ENUM('SOLICITADO','COLETADO','REALIZADO','CANCELADO') NOT NULL,
  data_solicitacao DATETIME,
  data_execucao DATETIME,
  FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento) ON DELETE RESTRICT,
  FOREIGN KEY (id_usuario_medico) REFERENCES usuario(id_usuario) ON DELETE RESTRICT,
  INDEX idx_atendimento (id_atendimento),
  INDEX idx_status (status)
);

CREATE TABLE IF NOT EXISTS sigpat_procedimento (
  id_sigpat INT AUTO_INCREMENT PRIMARY KEY,
  codigo_sigpat VARCHAR(20) UNIQUE NOT NULL,
  descricao TEXT NOT NULL,
  grupo VARCHAR(100),
  subgrupo VARCHAR(100),
  tipo ENUM('EXAME','RX','PROCEDIMENTO') NOT NULL,
  ativo BOOLEAN DEFAULT TRUE,
  INDEX idx_grupo (grupo),
  INDEX idx_tipo (tipo)
);

-- Garante que o banco de dados 'pronto_atendimento' está em uso
USE pronto_atendimento;

-- 1. Tabela prescricao_medica (Corrigido para BIGINT)
CREATE TABLE IF NOT EXISTS prescricao_medica (
    id_prescricao BIGINT AUTO_INCREMENT PRIMARY KEY, -- Alterado para BIGINT
    id_atendimento BIGINT NOT NULL,                 -- Corrigido para BIGINT
    id_usuario_medico BIGINT NOT NULL,              -- Corrigido para BIGINT
    data_prescricao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento) ON DELETE RESTRICT,
    FOREIGN KEY (id_usuario_medico) REFERENCES usuario(id_usuario) ON DELETE RESTRICT,
    INDEX idx_atendimento (id_atendimento)
) ENGINE=InnoDB;

-- 2. Tabela prescricao_item (Chave estrangeira corrigida para BIGINT)
CREATE TABLE IF NOT EXISTS prescricao_item (
    id_item BIGINT AUTO_INCREMENT PRIMARY KEY, -- Alterado para BIGINT
    id_prescricao BIGINT NOT NULL,           -- Corrigido para BIGINT
    medicamento VARCHAR(150),
    dose VARCHAR(50),
    via VARCHAR(50),
    frequencia VARCHAR(50),
    duracao VARCHAR(50),
    FOREIGN KEY (id_prescricao) REFERENCES prescricao_medica(id_prescricao) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 3. Tabela pedido_exame (Corrigido para BIGINT)
CREATE TABLE IF NOT EXISTS pedido_exame (
    id_pedido_exame BIGINT AUTO_INCREMENT PRIMARY KEY, -- Alterado para BIGINT
    id_atendimento BIGINT NOT NULL,                   -- Corrigido para BIGINT
    id_usuario_medico BIGINT NOT NULL,                -- Corrigido para BIGINT
    status ENUM('SOLICITADO','COLETADO','REALIZADO','CANCELADO') NOT NULL,
    data_solicitacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_execucao DATETIME,
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento) ON DELETE RESTRICT,
    FOREIGN KEY (id_usuario_medico) REFERENCES usuario(id_usuario) ON DELETE RESTRICT,
    INDEX idx_atendimento (id_atendimento),
    INDEX idx_status (status)
) ENGINE=InnoDB;

-- 4. Tabela pedido_exame_item (Chave estrangeira corrigida para BIGINT, Referência SIGPAT comentada)
CREATE TABLE IF NOT EXISTS pedido_exame_item (
    id_item BIGINT AUTO_INCREMENT PRIMARY KEY, -- Alterado para BIGINT
    id_pedido_exame BIGINT NOT NULL,         -- Corrigido para BIGINT
    id_sigpat INT NOT NULL,                  -- Mantido INT (assumindo que 'sigpat_procedimento' usa INT)
    observacao TEXT,
    FOREIGN KEY (id_pedido_exame) REFERENCES pedido_exame(id_pedido_exame) ON DELETE RESTRICT
    -- FOREIGN KEY (id_sigpat) REFERENCES sigpat_procedimento(id_sigpat) ON DELETE RESTRICT
    -- COMENTADO: A tabela 'sigpat_procedimento' precisa ser criada antes de adicionar esta FK.
) ENGINE=InnoDB;

-- Garante que o banco de dados 'pronto_atendimento' está em uso
USE pronto_atendimento;

-- Cria a tabela 'historico_status' com os tipos de dados corretos para as chaves estrangeiras
CREATE TABLE IF NOT EXISTS historico_status (
    id_historico BIGINT AUTO_INCREMENT PRIMARY KEY, -- Alterado para BIGINT para consistência
    id_atendimento BIGINT NOT NULL,              -- Corrigido para BIGINT
    status VARCHAR(30) NOT NULL,
    id_usuario BIGINT,                           -- Corrigido para BIGINT
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP, -- Adicionado DEFAULT para data
    FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento) ON DELETE RESTRICT,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS triagem (
  id_triagem INT AUTO_INCREMENT PRIMARY KEY,
  id_atendimento INT NOT NULL,
  id_usuario INT NOT NULL,
  sinais_vitais JSON,
  classificacao_risco VARCHAR(30),
  observacoes TEXT,
  data_triagem DATETIME,
  FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento) ON DELETE RESTRICT,
  FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE RESTRICT
);
CREATE TABLE IF NOT EXISTS paciente (
  id_paciente INT AUTO_INCREMENT PRIMARY KEY,
  nome_completo VARCHAR(150) NOT NULL,
  cpf VARCHAR(14) UNIQUE,
  cns VARCHAR(20),
  data_nascimento DATE,
  sexo CHAR(1),
  nome_mae VARCHAR(150),
  telefone VARCHAR(20),
  endereco TEXT,
  ativo BOOLEAN DEFAULT TRUE,
  INDEX idx_nome (nome_completo),
  INDEX idx_cns (cns)
);
CREATE OR REPLACE VIEW vw_sidebar_fila AS
SELECT
    a.id_atendimento,
    a.protocolo AS numero_atendimento, -- CORRIGIDO: usa 'protocolo' e renomeia
    p.nome_completo,
    a.status_atendimento,
    cr.cor AS classificacao_risco,    -- OBTIDO: através da tabela 'triagem'
    ar.prioridade,                    -- OBTIDO: através da tabela 'atendimento_recepcao'
    TIMESTAMPDIFF(MINUTE, a.data_abertura, NOW()) AS tempo
FROM atendimento a
JOIN pessoa p ON p.id_pessoa = a.id_pessoa
-- Junta para obter a prioridade (do cadastro na recepção)
LEFT JOIN atendimento_recepcao ar ON ar.id_atendimento = a.id_atendimento
-- Junta para obter a classificação de risco
LEFT JOIN triagem t ON t.id_atendimento = a.id_atendimento
LEFT JOIN classificacao_risco cr ON cr.id_risco = t.id_risco
-- CORRIGIDO: Filtra para mostrar apenas atendimentos ativos/abertos
WHERE a.status_atendimento NOT IN ('FINALIZADO', 'NAO_ATENDIDO')
ORDER BY 
    CASE ar.prioridade
        WHEN 'GESTANTE' THEN 1
        WHEN 'IDOSO' THEN 2
        WHEN 'AUTISTA' THEN 3
        WHEN 'CRIANCA_COLO' THEN 4
        ELSE 5
    END,
    CASE cr.cor
        WHEN 'VERMELHO' THEN 1
        WHEN 'LARANJA' THEN 2
        WHEN 'AMARELO' THEN 3
        WHEN 'VERDE' THEN 4
        WHEN 'AZUL' THEN 5
        ELSE 6
    END,
    a.data_abertura ASC;
    
CREATE OR REPLACE VIEW vw_busca AS
SELECT
    -- CORRIGIDO: Usa 'protocolo' no lugar de 'numero_atendimento'
    a.protocolo AS numero_atendimento,
    p.nome_completo,
    p.cpf,
    p.cns,
    a.status_atendimento
FROM atendimento a
-- CORRIGIDO: Junta com a tabela 'pessoa' usando id_pessoa
JOIN pessoa p ON p.id_pessoa = a.id_pessoa;

USE pronto_atendimento;

-- Adiciona a coluna que calcula o ID da pessoa apenas se o atendimento estiver ATIVO
ALTER TABLE atendimento
ADD COLUMN uk_atendimento_ativo BIGINT AS (
    CASE 
        WHEN status_atendimento IN ('FINALIZADO', 'NAO_ATENDIDO') THEN NULL 
        ELSE id_pessoa 
    END
) VIRTUAL;

-- Cria o índice UNIQUE sobre a coluna gerada
CREATE UNIQUE INDEX uk_pessoa_atendimento_ativo
ON atendimento (uk_atendimento_ativo);


-- EXEMPLO DE SP DE BUSCA PARA O COMPONENTE ATENDIMENTO.JSX
DROP PROCEDURE IF EXISTS sp_buscar_ficha_atendimento;

DELIMITER $$
CREATE PROCEDURE sp_buscar_ficha_atendimento(
    IN p_id_atendimento BIGINT
)
BEGIN

    -- 1. DADOS BASE E PACIENTE (JOIN 1:1)
    SELECT
        a.protocolo,
        a.status_atendimento,
        a.data_abertura,
        p.nome_completo,
        p.cpf,
        p.cns,
        ar.motivo_procura,
        ar.tipo_atendimento
    FROM atendimento a
    JOIN pessoa p ON p.id_pessoa = a.id_pessoa
    LEFT JOIN atendimento_recepcao ar ON ar.id_atendimento = a.id_atendimento
    WHERE a.id_atendimento = p_id_atendimento;

    -- 2. DADOS DE TRIAGEM E RISCO (JOIN 1:1)
    SELECT
        t.queixa,
        t.sinais_vitais, -- Campo JSON
        cr.cor,
        cr.descricao AS risco_descricao,
        t.data_hora AS dt_triagem
    FROM triagem t
    JOIN classificacao_risco cr ON cr.id_risco = t.id_risco
    WHERE t.id_atendimento = p_id_atendimento;

    -- 3. ANAMNESES E EXAMES FÍSICOS (LISTA 1:N)
    (SELECT 'ANAMNESE' AS tipo, descricao, data_hora FROM anamnese WHERE id_atendimento = p_id_atendimento)
    UNION ALL
    (SELECT 'EXAME_FISICO' AS tipo, descricao, data_hora FROM exame_fisico WHERE id_atendimento = p_id_atendimento)
    ORDER BY data_hora DESC;

    -- 4. PRESCRIÇÕES ATIVAS (LISTA 1:N)
    -- Prescrição Mestra
    SELECT
        pc.id_prescricao,
        pc.tipo,
        pc.data_hora,
        GROUP_CONCAT(pi.descricao SEPARATOR '; ') AS itens_prescritos
    FROM prescricao_continua pc
    JOIN prescricao_item pi ON pi.id_prescricao = pc.id_prescricao
    WHERE pc.id_atendimento = p_id_atendimento AND pc.ativa = TRUE
    GROUP BY pc.id_prescricao
    ORDER BY pc.data_hora DESC;
    
    -- 5. SOLICITAÇÕES DE EXAME (LISTA 1:N)
    SELECT
        se.id_solicitacao,
        e.descricao AS exame_nome,
        se.status,
        se.data_hora
    FROM solicitacao_exame se
    JOIN exame e ON e.id_exame = se.id_exame
    WHERE se.id_atendimento = p_id_atendimento
    ORDER BY se.data_hora DESC;

END$$
DELIMITER ;

-- PESSOA ADMIN
INSERT INTO pessoa (nome_completo, cpf, data_nascimento, sexo)
VALUES ('Administrador Master', '00000000000', '1980-01-02', 'O')
ON DUPLICATE KEY UPDATE nome_completo = VALUES(nome_completo);

SET @id_pessoa_admin = (
    SELECT id_pessoa FROM pessoa WHERE cpf = '00000000000'
);

-- USUÁRIO ADMIN
INSERT INTO usuario (login, senha_hash, ativo, id_pessoa)
VALUES (
    'admin',
    '$2y$10$R/9eO6N7wQ1wVq2SjT3hwuF1eFf8c1s.pZ/3v2A2A8b2Q9R/P4S8A',
    1,
    @id_pessoa_admin
)
ON DUPLICATE KEY UPDATE
    senha_hash = VALUES(senha_hash),
    ativo = 1,
    id_pessoa = VALUES(id_pessoa);

SET @id_usuario_admin = (
    SELECT id_usuario FROM usuario WHERE login = 'admin'
);

-- PERFIL ADMIN
INSERT INTO usuario_perfil (id_usuario, id_perfil)
SELECT
    @id_usuario_admin,
    id_perfil
FROM perfil
WHERE nome = 'ADMIN'
ON DUPLICATE KEY UPDATE id_perfil = id_perfil;


INSERT INTO usuario_perfil (id_usuario, id_perfil)
SELECT 
    @id_usuario_admin,
    p.id_perfil
FROM perfil p
WHERE p.nome = 'ADMIN'
ON DUPLICATE KEY UPDATE
    usuario_perfil.id_perfil = usuario_perfil.id_perfil;

CREATE TABLE IF NOT EXISTS sessao (
    id_sessao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_usuario BIGINT NOT NULL,
    token CHAR(64) NOT NULL UNIQUE,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    expira_em DATETIME,
    ativo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);
USE pronto_atendimento;

-- 1. Garante que o ID da pessoa 'Administrador Master' está na variável
SET @id_pessoa_admin = (
    SELECT id_pessoa FROM pessoa WHERE cpf = '00000000000'
);

-- 2. Atualiza (ou insere) o usuário com o hash correto para a senha '123456'
-- (O hash abaixo é o mesmo que você já usou no script)
INSERT INTO usuario (login, senha_hash, ativo, id_pessoa)
VALUES (
    'admin',
    '$2y$10$R/9eO6N7wQ1wVq2SjT3hwuF1eFf8c1s.pZ/3v2A2A8b2Q9R/P4S8A',
    TRUE,
    @id_pessoa_admin
)
ON DUPLICATE KEY UPDATE
    senha_hash = VALUES(senha_hash),
    ativo = 1,
    id_pessoa = VALUES(id_pessoa);

-- 3. Confirma o ID do usuário
SET @id_usuario_admin = (
    SELECT id_usuario FROM usuario WHERE login = 'admin'
);

-- 4. Garante que o perfil ADMIN está associado
INSERT INTO usuario_perfil (id_usuario, id_perfil)
SELECT 
    @id_usuario_admin,
    p.id_perfil
FROM perfil p
WHERE p.nome = 'admin'
ON DUPLICATE KEY UPDATE
    usuario_perfil.id_perfil = usuario_perfil.id_perfil;
    
    USE pronto_atendimento;

UPDATE usuario
SET senha_hash = '$2y$10$dwht9oLbGLKgdF/vBjAK6OL.FyjIQ0.8QaokhpRRGBb0CnK8gdI8y' 
WHERE login = 'admin';

SELECT 'Senha do usuário admin atualizada com sucesso!' AS Status;


CREATE TABLE IF NOT EXISTS farmaco (
    id_farmaco BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome_comercial VARCHAR(150) NOT NULL,
    principio_ativo VARCHAR(150),
    tipo ENUM('CONTROLADO','PADRAO','HEMODERIVADO') NOT NULL,
    unidade_medida VARCHAR(20) -- ex: mg, ml, UI
);

CREATE TABLE IF NOT EXISTS estoque_local (
    id_estoque BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_farmaco BIGINT NOT NULL,
    id_local INT NOT NULL, -- ex: Farmácia Central, Farmácia da Emergência
    quantidade_atual INT NOT NULL DEFAULT 0,
    min_estoque INT DEFAULT 0,
    FOREIGN KEY (id_farmaco) REFERENCES farmaco(id_farmaco),
    FOREIGN KEY (id_local) REFERENCES local_atendimento(id_local),
    UNIQUE KEY uk_farmaco_local (id_farmaco, id_local)
);


CREATE TABLE IF NOT EXISTS dispensacao_farmacia (
    id_dispensacao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_prescricao BIGINT NOT NULL, -- Qual prescrição gerou o pedido (FK para prescricao_medica)
    id_prescricao_item BIGINT NOT NULL, -- Qual item da prescrição está sendo atendido (FK para prescricao_item)
    id_farmaco BIGINT NOT NULL,
    id_estoque BIGINT NOT NULL, -- De qual local de estoque (estoque_local) saiu
    quantidade_dispensada DECIMAL(10, 2) NOT NULL,
    id_usuario_farmaceutico BIGINT NOT NULL, -- Quem liberou/dispensou
    data_hora_dispensacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_prescricao) REFERENCES prescricao(id_prescricao),
    FOREIGN KEY (id_prescricao_item) REFERENCES prescricao_item(id_item),
    FOREIGN KEY (id_farmaco) REFERENCES farmaco(id_farmaco),
    FOREIGN KEY (id_estoque) REFERENCES estoque_local(id_estoque),
    FOREIGN KEY (id_usuario_farmaceutico) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB;

DELIMITER $$

CREATE TRIGGER trg_baixa_estoque_dispensacao
AFTER INSERT ON dispensacao_farmacia
FOR EACH ROW
BEGIN
    -- Subtrai a quantidade dispensada do estoque
    UPDATE estoque_local
    SET quantidade_atual = quantidade_atual - NEW.quantidade_dispensada
    WHERE id_estoque = NEW.id_estoque;
    
    -- Opcional: Adicionar lógica para alerta de estoque mínimo
    -- Se a quantidade_atual < min_estoque, insira um alerta em uma tabela de log/alerta.
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_registrar_recepcao(
    IN p_id_atendimento BIGINT,
    IN p_tipo ENUM('CLINICO','PEDIATRICO','EMERGENCIA','EXAME_EXTERNO','MEDICACAO_EXTERNA'),
    IN p_chegada ENUM('MEIOS_PROPRIOS','AMBULANCIA','POLICIA','OUTROS'),
    IN p_prioridade ENUM('AUTISTA','CRIANCA_COLO','GESTANTE','IDOSO','NORMAL'),
    IN p_motivo TEXT,
    IN p_destino ENUM('TRIAGEM','MEDICO','EMERGENCIA','RX','MEDICACAO'),
    IN p_usuario BIGINT
)
BEGIN
    -- Calcula prioridade automaticamente quando não fornecida
    DECLARE v_prioridade ENUM('AUTISTA','CRIANCA_COLO','GESTANTE','IDOSO','PRIORITARIO_PEDI','PRIORITARIO_ADULTO','NORMAL');
    DECLARE v_data_nasc DATE;
    DECLARE v_idade INT;
    DECLARE v_origem VARCHAR(50);

    SET v_prioridade = p_prioridade;

    IF v_prioridade IS NULL OR v_prioridade = '' THEN
        -- tenta inferir a partir da origem da senha (TOTEM_PRI_PEDI / TOTEM_PRI_ADULTO)
        SELECT s.origem INTO v_origem
        FROM atendimento a
        JOIN senha s ON s.id_senha = a.id_senha
        WHERE a.id_atendimento = p_id_atendimento
        LIMIT 1;

        IF v_origem = 'TOTEM_PRI_PEDI' THEN
            SET v_prioridade = 'PRIORITARIO_PEDI';
        ELSEIF v_origem = 'TOTEM_PRI_ADULTO' THEN
            SET v_prioridade = 'PRIORITARIO_ADULTO';
        ELSE
            -- fallback para cálculo por idade
            SELECT pe.data_nascimento INTO v_data_nasc
            FROM pessoa pe
            JOIN atendimento a ON a.id_pessoa = pe.id_pessoa
            WHERE a.id_atendimento = p_id_atendimento
            LIMIT 1;

            IF v_data_nasc IS NOT NULL THEN
                SET v_idade = TIMESTAMPDIFF(YEAR, v_data_nasc, CURDATE());

                IF v_idade >= 60 THEN
                    SET v_prioridade = 'IDOSO';
                ELSEIF v_idade <= 2 THEN
                    SET v_prioridade = 'CRIANCA_COLO';
                ELSE
                    SET v_prioridade = 'NORMAL';
                END IF;
            ELSE
                SET v_prioridade = 'NORMAL';
            END IF;
        END IF;
    END IF;

    INSERT INTO atendimento_recepcao (
        id_atendimento,
        tipo_atendimento,
        chegada,
        prioridade,
        motivo_procura,
        destino_inicial,
        id_recepcionista
    )
    VALUES (
        p_id_atendimento,
        p_tipo,
        p_chegada,
        v_prioridade,
        p_motivo,
        p_destino,
        p_usuario
    );
END$$

DELIMITER ;

-- Procedure to ensure schema exists (idempotent)
DELIMITER $$
CREATE PROCEDURE sp_ensure_schema()
BEGIN
    -- Core tables (created in dependency order to satisfy FKs)
    CREATE TABLE IF NOT EXISTS pessoa (
        id_pessoa BIGINT AUTO_INCREMENT PRIMARY KEY,
        nome_completo VARCHAR(200) NOT NULL
    );

    CREATE TABLE IF NOT EXISTS usuario (
        id_usuario BIGINT AUTO_INCREMENT PRIMARY KEY,
        login VARCHAR(100) NOT NULL UNIQUE,
        senha_hash VARCHAR(255) NOT NULL,
        ativo BOOLEAN DEFAULT TRUE,
        id_pessoa BIGINT
    );

    CREATE TABLE IF NOT EXISTS perfil (
        id_perfil INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR(50) NOT NULL UNIQUE
    );

    CREATE TABLE IF NOT EXISTS usuario_perfil (
        id_usuario BIGINT,
        id_perfil INT,
        PRIMARY KEY (id_usuario, id_perfil)
    );

    CREATE TABLE IF NOT EXISTS especialidade (
        id_especialidade INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR(100) NOT NULL UNIQUE
    );

    CREATE TABLE IF NOT EXISTS local_atendimento (
        id_local INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR(100) NOT NULL UNIQUE
    );

    CREATE TABLE IF NOT EXISTS sala (
        id_sala INT AUTO_INCREMENT PRIMARY KEY,
        nome_exibicao VARCHAR(100) NOT NULL,
        id_local INT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS senha (
        id_senha BIGINT AUTO_INCREMENT PRIMARY KEY,
        numero INT NOT NULL,
        origem ENUM('TOTEM','RECEPCAO','TOTEM_PRI_PEDI','TOTEM_PRI_ADULTO'),
        data_hora DATETIME DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS totem_feedback (
        id_feedback BIGINT AUTO_INCREMENT PRIMARY KEY,
        id_senha BIGINT NULL,
        origem VARCHAR(50) NULL,
        nota INT NULL,
        comentario TEXT NULL,
        data_hora DATETIME DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS atendimento (
        id_atendimento BIGINT AUTO_INCREMENT PRIMARY KEY,
        protocolo VARCHAR(30) NOT NULL UNIQUE,
        id_pessoa BIGINT NOT NULL,
        id_senha BIGINT
    );

    CREATE TABLE IF NOT EXISTS atendimento_recepcao (
        id_recepcao BIGINT AUTO_INCREMENT PRIMARY KEY,
        id_atendimento BIGINT,
        id_usuario BIGINT,
        prioridade ENUM('NORMAL','IDOSO','CRIANCA_COLO','PRIORITARIO_PEDI','PRIORITARIO_ADULTO')
    );

    CREATE TABLE IF NOT EXISTS atendimento_movimentacao (
        id_mov BIGINT AUTO_INCREMENT PRIMARY KEY,
        id_atendimento BIGINT
    );

    CREATE TABLE IF NOT EXISTS classificacao_risco (
        id_risco INT AUTO_INCREMENT PRIMARY KEY,
        cor ENUM('VERMELHO','LARANJA','AMARELO','VERDE','AZUL')
    );

    CREATE TABLE IF NOT EXISTS triagem (
        id_triagem BIGINT AUTO_INCREMENT PRIMARY KEY,
        id_atendimento BIGINT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS prescricao_medica (
        id_prescricao BIGINT AUTO_INCREMENT PRIMARY KEY,
        id_atendimento BIGINT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS prescricao_item (
        id_item BIGINT AUTO_INCREMENT PRIMARY KEY,
        id_prescricao BIGINT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS pedido_exame (
        id_pedido_exame BIGINT AUTO_INCREMENT PRIMARY KEY,
        id_atendimento BIGINT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS pedido_exame_item (
        id_item BIGINT AUTO_INCREMENT PRIMARY KEY,
        id_pedido_exame BIGINT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS chamada_painel (
        id_chamada BIGINT AUTO_INCREMENT PRIMARY KEY,
        id_atendimento BIGINT
    );

    CREATE TABLE IF NOT EXISTS historico_status (
        id_historico BIGINT AUTO_INCREMENT PRIMARY KEY,
        id_atendimento BIGINT NOT NULL
    );

END$$
DELIMITER ;
DELIMITER $$

CREATE FUNCTION fn_gera_protocolo()
RETURNS VARCHAR(30)
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE seq INT;

    INSERT INTO protocolo_sequencia VALUES (NULL);
    SET seq = LAST_INSERT_ID();

    RETURN CONCAT(
        YEAR(NOW()),
        'GPAT/',
        LPAD(seq, 6, '0')
    );
END$$