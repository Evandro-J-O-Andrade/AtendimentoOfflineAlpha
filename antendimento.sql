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

CREATE TABLE IF NOT EXISTS senhas (
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
drop	 table paciente;
CREATE TABLE if not exists paciente (
    id_paciente BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_pessoa BIGINT NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa),
    UNIQUE KEY uk_pessoa_paciente (id_pessoa)
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
DROP FUNCTION IF EXISTS fn_gera_protocolo;

DELIMITER $$



CREATE FUNCTION fn_gera_protocolo(p_id_usuario BIGINT)
RETURNS VARCHAR(30)
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE seq INT;
    DECLARE protocolo VARCHAR(30);

    -- Inserir na tabela de sequência com usuário e timestamp
    INSERT INTO protocolo_sequencia (id_usuario, created_at) 
    VALUES (p_id_usuario, NOW());
    
    -- Pega o ID gerado
    SET seq = LAST_INSERT_ID();

    -- Monta o protocolo GPAT no formato: ANO + GPAT + número sequencial 6 dígitos
    SET protocolo = CONCAT(
        YEAR(NOW()),
        'GPAT/',
        LPAD(seq, 6, '0')
    );

    RETURN protocolo;
END$$

DELIMITER ;


drop table protocolo_sequencia;

CREATE TABLE if not exists protocolo_sequencia (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_usuario BIGINT NOT NULL,
    created_at DATETIME NOT NULL
);



CREATE TABLE IF NOT EXISTS local_usuario (
    id_local_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,                -- Nome do guichê, sala ou local de atendimento
    tipo ENUM('RECEPCAO','MEDICO','TRIAGEM','SUPORTE','ADMIN','GESTAO') NOT NULL DEFAULT 'RECEPCAO',
    ativo TINYINT(1) DEFAULT 1,               -- 1 = ativo, 0 = inativo
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE if not exists fila_senha (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  senha VARCHAR(10) NOT NULL,
  tipo ENUM('CLINICO','PEDIATRICO','EMERGENCIA','EXTERNO') NOT NULL,
  prioridade TINYINT DEFAULT 0,
  status ENUM(
    'AGUARDANDO',
    'CHAMANDO',
    'EM_ATENDIMENTO',
    'NAO_ATENDIDO',
    'FINALIZADO'
  ) NOT NULL DEFAULT 'AGUARDANDO',
  id_paciente BIGINT NULL,
  origem ENUM('TOTEM','MANUAL') NOT NULL,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE if not exists fila_evento (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_fila BIGINT NOT NULL,
  evento ENUM(
    'GERADA',
    'CHAMADA',
    'NAO_ATENDIDO',
    'REENTRADA',
    'ABERTURA_FFA',
    'ENCAMINHAMENTO'
  ) NOT NULL,
  id_usuario BIGINT NULL,
  id_local BIGINT NULL,
  detalhe TEXT NULL,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_fila) REFERENCES fila_senha(id)
);


drop procedure sp_chamar_senha;

DELIMITER $$

CREATE PROCEDURE sp_chamar_senha (
    IN p_id_fila BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_local BIGINT
)
BEGIN
    -- Validação básica
    IF NOT EXISTS (
        SELECT 1
        FROM fila_senha
        WHERE id = p_id_fila
          AND status = 'AGUARDANDO'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Senha inválida ou não está aguardando';
    END IF;

    -- Atualiza status para CHAMANDO
    UPDATE fila_senha
    SET status = 'CHAMANDO'
    WHERE id = p_id_fila;

    -- Aqui futuramente entra auditoria
    -- Aqui futuramente entra integração com painel / voz

END$$

DELIMITER ;

DROP VIEW IF EXISTS vw_fila_recepcao;

CREATE VIEW vw_fila_recepcao AS
SELECT
  f.id,
  f.senha,
  f.tipo,
  f.prioridade,
  f.status,
  f.criado_em
FROM fila_senha f
WHERE f.status IN ('AGUARDANDO','CHAMANDO')
ORDER BY
  f.prioridade DESC,
  f.criado_em ASC;



UPDATE fila_senha
SET status = 'AGUARDANDO'
WHERE id = 123;

CALL sp_chamar_senha(45, 10, 2);

CREATE OR REPLACE VIEW vw_fila_recepcao AS
SELECT
    f.id,
    f.senha,
    f.tipo,
    f.prioridade,
    f.status,
    f.criado_em
FROM fila_senha f
WHERE f.status IN ('AGUARDANDO','CHAMANDO')
ORDER BY
    f.prioridade DESC,
    f.criado_em ASC;

SELECT id, senha, status, tipo, prioridade, criado_em
FROM fila_senha
ORDER BY criado_em DESC
LIMIT 20;


INSERT INTO fila_senha (
  senha,
  tipo,
  prioridade,
  status,
  criado_em
) VALUES (
  'A001',
  'CLINICO',
  0,
  'AGUARDANDO',
  NOW()
);


CALL sp_chamar_senha(1, 10, 2);

ALTER TABLE fila_senha
ADD origem ENUM('TOTEM','RECEPCAO','SAMU') NOT NULL DEFAULT 'TOTEM',
ADD gerada_manual TINYINT(1) DEFAULT 0;

drop procedure sp_gerar_senha;
DELIMITER $$

CREATE PROCEDURE sp_gerar_senha (
    IN p_tipo ENUM('CLINICO','PEDIATRICO','EMERGENCIA','EXTERNO'),
    IN p_origem ENUM('TOTEM','MANUAL'),
    IN p_prioridade TINYINT,
    IN p_id_paciente BIGINT
)
BEGIN
    DECLARE v_seq INT DEFAULT 0;
    DECLARE v_senha VARCHAR(10);

    -- Garante prioridade mínima
    IF p_prioridade IS NULL THEN
        SET p_prioridade = 0;
    END IF;

    -- Calcula próximo número da senha por TIPO no DIA
    SELECT COUNT(*) + 1
    INTO v_seq
    FROM fila_senha
    WHERE tipo = p_tipo
      AND DATE(criado_em) = CURDATE();

    -- Monta senha (C, P, E, X)
    SET v_senha = CONCAT(
        CASE p_tipo
            WHEN 'CLINICO' THEN 'C'
            WHEN 'PEDIATRICO' THEN 'P'
            WHEN 'EMERGENCIA' THEN 'E'
            WHEN 'EXTERNO' THEN 'X'
        END,
        LPAD(v_seq, 3, '0')
    );

    -- Insere na fila
    INSERT INTO fila_senha (
        senha,
        tipo,
        prioridade,
        status,
        id_paciente,
        origem,
        criado_em,
        atualizado_em
    ) VALUES (
        v_senha,
        p_tipo,
        p_prioridade,
        'AGUARDANDO',
        p_id_paciente,
        p_origem,
        NOW(),
        NOW()
    );

    -- Retorna dados para o frontend
    SELECT
        LAST_INSERT_ID() AS id_fila,
        v_senha          AS senha,
        p_tipo           AS tipo,
        p_prioridade     AS prioridade,
        p_origem         AS origem;

END$$

DELIMITER ;

CALL sp_gerar_senha('CLINICO','TOTEM',0,NULL);
CALL sp_gerar_senha('EMERGENCIA','TOTEM',10,NULL);
CALL sp_gerar_senha('CLINICO','MANUAL',5,12345);

SELECT * FROM fila_senha ORDER BY criado_em DESC;

CREATE TABLE if not exists fila_retorno (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_fila BIGINT NOT NULL,
    retorno_em DATETIME NOT NULL,
    ativo TINYINT(1) DEFAULT 1,
    criado_em DATETIME DEFAULT NOW(),
    FOREIGN KEY (id_fila) REFERENCES fila_senha(id)
);

drop procedure sp_nao_atendido;

DELIMITER $$

CREATE PROCEDURE sp_nao_atendido (
    IN p_id_fila BIGINT,
    IN p_delay_minutos INT
)
BEGIN
    -- Validação
    IF NOT EXISTS (
        SELECT 1
        FROM fila_senha
        WHERE id = p_id_fila
          AND status = 'CHAMANDO'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Senha não está em chamada';
    END IF;

    -- Atualiza status
    UPDATE fila_senha
    SET status = 'NAO_ATENDIDO',
        atualizado_em = NOW()
    WHERE id = p_id_fila;

    -- Agenda retorno
    INSERT INTO fila_retorno (
        id_fila,
        retorno_em
    ) VALUES (
        p_id_fila,
        DATE_ADD(NOW(), INTERVAL p_delay_minutos MINUTE)
    );

END$$

DELIMITER ;

CALL sp_nao_atendido(1, 5);

CREATE OR REPLACE VIEW vw_fila_pronta AS
SELECT f.*
FROM fila_senha f
LEFT JOIN fila_retorno r ON r.id_fila = f.id AND r.ativo = 1
WHERE
    f.status = 'AGUARDANDO'
    OR (
        f.status = 'NAO_ATENDIDO'
        AND r.retorno_em <= NOW()
    )
ORDER BY f.prioridade DESC, f.criado_em ASC;

drop table ffa;

CREATE TABLE IF NOT EXISTS ffa (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_paciente BIGINT NOT NULL,
    gpat VARCHAR(30) NOT NULL,                     -- protocolo hospitalar
    status ENUM(
        'EM_ATENDIMENTO',
        'OBSERVACAO',
        'INTERNACAO',
        'ALTA',
        'TRANSFERENCIA',
        'ABERTO',
        'EM_TRIAGEM'
    ) NOT NULL,
    layout VARCHAR(50) DEFAULT 'TRIAGEM',          -- layout inicial
    id_usuario_criacao BIGINT NOT NULL,            -- usuário que criou a FFA
    id_usuario_alteracao BIGINT DEFAULT NULL,      -- usuário que alterou por último
    criado_em DATETIME DEFAULT NOW(),
    atualizado_em DATETIME DEFAULT NOW() ON UPDATE NOW()
);


ALTER TABLE fila_senha
ADD id_ffa BIGINT NULL;

DELIMITER $$

CREATE PROCEDURE sp_iniciar_atendimento (
    IN p_id_fila BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_id_paciente BIGINT;
    DECLARE v_id_ffa BIGINT;

    -- Validação
    IF NOT EXISTS (
        SELECT 1 FROM fila_senha
        WHERE id = p_id_fila
          AND status = 'CHAMANDO'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Senha não está em chamada';
    END IF;

    -- Obtém paciente
    SELECT id_paciente
    INTO v_id_paciente
    FROM fila_senha
    WHERE id = p_id_fila;

    -- Cria FFA
    INSERT INTO ffa (
        id_paciente,
        status
    ) VALUES (
        v_id_paciente,
        'EM_ATENDIMENTO'
    );

    SET v_id_ffa = LAST_INSERT_ID();

    -- Vincula fila à FFA
    UPDATE fila_senha
    SET status = 'EM_ATENDIMENTO',
        id_ffa = v_id_ffa,
        atualizado_em = NOW()
    WHERE id = p_id_fila;

END$$

DELIMITER 

DELIMITER $$

CREATE PROCEDURE sp_abrir_ffa (
    IN p_id_fila BIGINT,
    IN p_id_paciente BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_id_ffa BIGINT;
    DECLARE v_gpat VARCHAR(30);

    -- Valida senha
    IF NOT EXISTS (
        SELECT 1 FROM fila_senha
        WHERE id = p_id_fila
          AND status = 'CHAMANDO'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Senha inválida para abertura de FFA';
    END IF;

    -- Gera protocolo / GPAT
    SET v_gpat = fn_gera_protocolo();

    -- Cria FFA
    INSERT INTO ffa (
        id_paciente,
        gpat,
        status,
        criado_em,
        atualizado_em
    ) VALUES (
        p_id_paciente,
        v_gpat,
        'EM_ATENDIMENTO',
        NOW(),
        NOW()
    );

    SET v_id_ffa = LAST_INSERT_ID();

    -- Vincula senha à FFA (interno, não exibido ao paciente)
    UPDATE fila_senha
    SET id_paciente = p_id_paciente,
        id_ffa = v_id_ffa,
        status = 'EM_ATENDIMENTO',
        atualizado_em = NOW()
    WHERE id = p_id_fila;

    -- Aqui entram triggers de auditoria

    -- Retorno para o frontend
    SELECT
        v_id_ffa AS id_ffa,
        v_gpat   AS gpat;

END$$

DELIMITER ;


drop procedure sp_finalizar_atendimento;
DELIMITER $$

CREATE PROCEDURE sp_finalizar_atendimento (
    IN p_id_ffa BIGINT,
    IN p_status_final ENUM('ALTA','TRANSFERENCIA')
)
BEGIN
    DECLARE v_status_atual VARCHAR(30);

    -- Verifica se a FFA existe e está ativa
    SELECT status
    INTO v_status_atual
    FROM ffa
    WHERE id = p_id_ffa;

    IF v_status_atual IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FFA não encontrada';
    END IF;

    IF v_status_atual IN ('ALTA','TRANSFERENCIA') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FFA já está finalizada';
    END IF;

    -- Finaliza a FFA
    UPDATE ffa
    SET status = p_status_final,
        atualizado_em = NOW()
    WHERE id = p_id_ffa;

    -- Finaliza a senha vinculada
    UPDATE fila_senha
    SET status = 'FINALIZADO',
        atualizado_em = NOW()
    WHERE id_ffa = p_id_ffa;

    -- Aqui entra trigger de auditoria

END$$

DELIMITER ;

CALL sp_finalizar_atendimento(1, 'ALTA');

CALL sp_finalizar_atendimento(1, 'TRANSFERENCIA');


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_abre_ffa$$

CREATE PROCEDURE sp_abre_ffa(
    IN p_id_fila BIGINT,        -- corresponde a fila_senha.id
    IN p_id_usuario BIGINT,     -- usuário que abre a FFA
    IN p_id_paciente BIGINT,    -- paciente vinculado
    OUT p_id_ffa BIGINT,        -- retorna o id da FFA criada
    OUT p_gpat VARCHAR(30)      -- retorna o GPAT gerado
)
BEGIN
    DECLARE v_status VARCHAR(50);

    -- 1️⃣ Verifica se já existe FFA aberta para essa fila
    SELECT id, status INTO p_id_ffa, v_status
    FROM ffa
    WHERE id_paciente = p_id_paciente
      AND status IN ('ABERTO','EM_TRIAGEM')
    ORDER BY criado_em DESC
    LIMIT 1;

    -- 2️⃣ Se não existir, cria nova FFA
    IF p_id_ffa IS NULL THEN
        -- Gera GPAT usando o usuário que abriu a FFA
        SET p_gpat = fn_gera_protocolo(p_id_usuario);

        -- Insere nova FFA
        INSERT INTO ffa (
            id_paciente,
            gpat,
            status,
            layout,
            id_usuario_criacao,
            criado_em,
            atualizado_em
        ) VALUES (
            p_id_paciente,
            p_gpat,
            'ABERTO',
            'TRIAGEM',
            p_id_usuario,
            NOW(),
            NOW()
        );

        SET p_id_ffa = LAST_INSERT_ID();

        -- Atualiza fila_senha com o id_ffa
        UPDATE fila_senha
        SET id_ffa = p_id_ffa
        WHERE id = p_id_fila;

        -- Auditoria: criação de FFA
        INSERT INTO auditoria_ffa (
            id_ffa,
            id_usuario,
            acao,
            timestamp
        ) VALUES (
            p_id_ffa,
            p_id_usuario,
            CONCAT('CRIACAO: FFA aberta para paciente ', p_id_paciente),
            NOW()
        );

    ELSE
        -- Se já existe, retorna GPAT existente
        SELECT gpat INTO p_gpat FROM ffa WHERE id = p_id_ffa;
    END IF;
END$$

DELIMITER ;


-- Mudar delimitador
DELIMITER $$

DROP TRIGGER IF EXISTS trg_auditoria_ffa$$

CREATE TRIGGER trg_auditoria_ffa
AFTER UPDATE ON ffa
FOR EACH ROW
BEGIN
    DECLARE v_acao VARCHAR(50);

    -- Detecta mudanças de status
    IF NEW.status <> OLD.status THEN
        SET v_acao = CONCAT('STATUS: ', OLD.status, ' -> ', NEW.status);
        INSERT INTO auditoria_ffa (
            id_ffa,
            id_usuario,
            acao,
            timestamp
        ) VALUES (
            NEW.id,
            NEW.id_usuario_alteracao,  -- usuário que fez a alteração
            v_acao,
            NOW()
        );
    END IF;

    -- Detecta mudanças de layout
    IF NEW.layout <> OLD.layout THEN
        SET v_acao = CONCAT('LAYOUT: ', OLD.layout, ' -> ', NEW.layout);
        INSERT INTO auditoria_ffa (
            id_ffa,
            id_usuario,
            acao,
            timestamp
        ) VALUES (
            NEW.id,
            NEW.id_usuario_alteracao,
            v_acao,
            NOW()
        );
    END IF;
END$$

-- Voltar delimitador para padrão
DELIMITER ;

ALTER TABLE ffa
ADD COLUMN layout VARCHAR(50) DEFAULT 'TRIAGEM';



CREATE TABLE IF NOT EXISTS paciente (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome_completo VARCHAR(200) NOT NULL,
    nome_social VARCHAR(200),
    cpf VARCHAR(14),
    cns VARCHAR(20),
    data_nascimento DATE,
    sexo ENUM('M','F','O'),
    nome_mae VARCHAR(200),
    criado_em DATETIME DEFAULT NOW(),
    atualizado_em DATETIME DEFAULT NOW() ON UPDATE NOW()
);

CREATE OR REPLACE VIEW vw_painel_triagem AS
SELECT
    f.id AS id_ffa,
    f.gpat,
    f.id_paciente,
    f.status,
    f.layout,
    p.nome_completo AS paciente_nome
FROM ffa f
JOIN paciente p ON p.id = f.id_paciente
WHERE f.status IN ('ABERTO','EM_TRIAGEM')
ORDER BY f.criado_em ASC;


CREATE TABLE IF NOT EXISTS protocolo_sequencia (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,  -- sequência única
    id_usuario BIGINT NOT NULL,            -- usuário que gerou o protocolo
    created_at DATETIME NOT NULL DEFAULT NOW()  -- data/hora da geração
);


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_abre_ffa$$

CREATE PROCEDURE sp_abre_ffa(
    IN p_id_senha BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_paciente BIGINT,
    OUT p_id_ffa BIGINT,
    OUT p_gpat VARCHAR(30)
)
BEGIN
    DECLARE v_status_inicial VARCHAR(20);
    DECLARE v_layout_inicial VARCHAR(50);

    -- Status e layout inicial
    SET v_status_inicial = 'ABERTO';
    SET v_layout_inicial = 'TRIAGEM';

    -- Gerar GPAT
    SET p_gpat = fn_gera_protocolo(p_id_usuario);

    -- Criar FFA
    INSERT INTO ffa (
        id_paciente,
        gpat,
        status,
        layout,
        id_usuario_criacao,
        criado_em
    ) VALUES (
        p_id_paciente,
        p_gpat,
        v_status_inicial,
        v_layout_inicial,
        p_id_usuario,
        NOW()
    );

    SET p_id_ffa = LAST_INSERT_ID();

    -- Registrar auditoria inicial
    INSERT INTO auditoria_ffa (
        id_ffa,
        id_senha,
        id_usuario,
        acao,
        timestamp
    ) VALUES (
        p_id_ffa,
        p_id_senha,
        p_id_usuario,
        'ABERTURA',
        NOW()
    );
END$$

DELIMITER ;


DELIMITER $$

DROP TRIGGER IF EXISTS trg_auditoria_ffa$$

CREATE TRIGGER trg_auditoria_ffa
AFTER UPDATE ON ffa
FOR EACH ROW
BEGIN
    DECLARE v_acao VARCHAR(100);

    -- Detecta mudanças de status
    IF NEW.status <> OLD.status THEN
        SET v_acao = CONCAT('STATUS: ', OLD.status, ' -> ', NEW.status);
        INSERT INTO auditoria_ffa (
            id_ffa,
            id_usuario,
            acao,
            timestamp
        ) VALUES (
            NEW.id,
            NEW.id_usuario_alteracao,  -- usuário que fez a alteração
            v_acao,
            NOW()
        );
    END IF;

    -- Detecta mudanças de layout
    IF NEW.layout <> OLD.layout THEN
        SET v_acao = CONCAT('LAYOUT: ', OLD.layout, ' -> ', NEW.layout);
        INSERT INTO auditoria_ffa (
            id_ffa,
            id_usuario,
            acao,
            timestamp
        ) VALUES (
            NEW.id,
            NEW.id_usuario_alteracao,  -- usuário que fez a alteração
            v_acao,
            NOW()
        );
    END IF;
END$$

DELIMITER ;


-- ============================================
-- 1️⃣ Criar paciente de teste
-- ============================================
INSERT INTO paciente (
    nome_completo,
    nome_social,
    cpf,
    cns,
    data_nascimento,
    sexo,
    nome_mae,
    criado_em
) VALUES (
    'João da Silva',
    'João',
    '123.456.789-00',
    '123456789012345',
    '2000-01-01',
    'M',
    'Maria da Silva',
    NOW()
);

SET @id_paciente_teste = LAST_INSERT_ID();

-- ============================================
-- 2️⃣ Registrar senha do totem
-- ============================================
INSERT INTO fila_senha (id_paciente, criado_em)
VALUES (@id_paciente_teste, NOW());

SET @id_senha_teste = LAST_INSERT_ID();

-- ============================================
-- 3️⃣ Abrir FFA usando sp_abre_ffa
-- ============================================
SET @id_usuario = 1;  -- usuário recepção de teste
CALL sp_abre_ffa(
    @id_senha_teste,
    @id_usuario,
    @id_paciente_teste,
    @id_ffa_teste,
    @gpat_teste
);

-- Conferir saída
SELECT @id_ffa_teste AS id_ffa, @gpat_teste AS GPAT;

-- ============================================
-- 4️⃣ Conferir FFA criada
-- ============================================
SELECT * FROM ffa WHERE id = @id_ffa_teste;

-- ============================================
-- 5️⃣ Consultar painel de triagem
-- ============================================
SELECT * FROM vw_painel_triagem;

-- ============================================
-- 6️⃣ Atualizar status e layout da FFA
-- ============================================
UPDATE ffa
SET status = 'EM_ATENDIMENTO',
    layout = 'SALA_1',
    id_usuario_alteracao = @id_usuario
WHERE id = @id_ffa_teste;

-- ============================================
-- 7️⃣ Conferir auditoria automática
-- ============================================
SELECT * FROM auditoria_ffa
WHERE id_ffa = @id_ffa_teste
ORDER BY timestamp ASC;


-- 1️⃣ Desabilitar temporariamente checagem de FK
SET FOREIGN_KEY_CHECKS = 0;

-- 2️⃣ Dropar tabela antiga se existir
DROP TABLE IF EXISTS fila_senha;

-- 3️⃣ Criar tabela nova completa


DROP TABLE IF EXISTS fila_senha;

CREATE TABLE fila_senha (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,  -- compatível com fila_evento.id_fila
    senha BIGINT NOT NULL,                           -- senha gerada pelo Totem
    id_paciente BIGINT NOT NULL,                     -- paciente vinculado
    criado_em DATETIME NOT NULL DEFAULT NOW(),      -- data/hora de entrada na fila
    origem ENUM('TOTEM','RECEPCAO','SAMU') NOT NULL DEFAULT 'TOTEM',
    gerada_manual TINYINT(1) DEFAULT 0,             -- indica se foi abertura manual
    id_ffa BIGINT NULL,                              -- vinculo com FFA, se já aberta
    CONSTRAINT fk_fila_senha_ffa
        FOREIGN KEY (id_ffa) REFERENCES ffa(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

DELIMITER $$

DROP TRIGGER IF EXISTS trg_fila_senha_auto$$

CREATE TRIGGER trg_fila_senha_auto
BEFORE INSERT ON fila_senha
FOR EACH ROW
BEGIN
    DECLARE v_max BIGINT;

    -- Se a senha não for preenchida, gera a próxima automaticamente
    IF NEW.senha IS NULL OR NEW.senha = 0 THEN
        SELECT COALESCE(MAX(senha), 0) + 1 INTO v_max FROM fila_senha;
        SET NEW.senha = v_max;
    END IF;
END$$

DELIMITER ;

CREATE TABLE IF NOT EXISTS auditoria_ffa (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_ffa BIGINT NOT NULL,                -- FFA vinculada
    id_usuario BIGINT NOT NULL,            -- usuário que realizou a ação
    acao VARCHAR(255) NOT NULL,            -- descrição da ação
    timestamp DATETIME NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_auditoria_ffa_ffa
        FOREIGN KEY (id_ffa) REFERENCES ffa(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

--- ============================================
-- 0️⃣ Variáveis de controle
-- ============================================
SET @id_usuario = 1;  -- usuário de recepção de teste

-- ============================================
-- 1️⃣ Criar paciente de teste
-- ============================================
INSERT INTO paciente (
    nome_completo,
    nome_social,
    cpf,
    cns,
    data_nascimento,
    sexo,
    nome_mae,
    criado_em
) VALUES (
    'João da Silva',
    'João',
    '123.456.789-00',
    '123456789012345',
    '2000-01-01',
    'M',
    'Maria da Silva',
    NOW()
);

SET @id_paciente_teste = LAST_INSERT_ID();

-- ============================================
-- 2️⃣ Inserir na fila_senha (trigger gera senha automaticamente)
-- ============================================
INSERT INTO fila_senha (id_paciente)
VALUES (@id_paciente_teste);

SET @id_fila_teste = LAST_INSERT_ID();

-- ============================================
-- 3️⃣ Abrir FFA usando sp_abre_ffa
-- ============================================
CALL sp_abre_ffa(
    @id_fila_teste,        -- ID da fila_senha
    @id_usuario,           -- usuário que abre a FFA
    @id_paciente_teste,    -- paciente vinculado
    @id_ffa_teste,         -- OUT: ID da FFA criada
    @gpat_teste            -- OUT: GPAT gerado
);

-- Conferir saída
SELECT @id_ffa_teste AS id_ffa, @gpat_teste AS GPAT;

-- ============================================
-- 4️⃣ Conferir FFA criada
-- ============================================
SELECT * FROM ffa WHERE id = @id_ffa_teste;

-- ============================================
-- 5️⃣ Consultar painel de triagem
-- ============================================
SELECT * FROM vw_painel_triagem;

-- ============================================
-- 6️⃣ Atualizar status e layout da FFA
-- ============================================
UPDATE ffa
SET status = 'EM_ATENDIMENTO',
    layout = 'SALA_1',
    id_usuario_alteracao = @id_usuario
WHERE id = @id_ffa_teste;

-- ============================================
-- 7️⃣ Conferir auditoria automática
-- ============================================
SELECT * FROM auditoria_ffa
WHERE id_ffa = @id_ffa_teste
ORDER BY timestamp ASC;


CREATE OR REPLACE VIEW vw_painel_triagem AS
SELECT
    f.id AS id_ffa,
    f.gpat,
    f.id_paciente,
    f.status,
    f.layout,
    p.nome_completo AS paciente_nome,
    fs.senha,
    fs.origem
FROM ffa f
JOIN paciente p ON p.id = f.id_paciente
LEFT JOIN fila_senha fs ON fs.id_ffa = f.id
WHERE f.status IN ('ABERTO', 'EM_TRIAGEM')
ORDER BY fs.criado_em ASC;


CREATE OR REPLACE VIEW vw_painel_atendimento AS
SELECT
    f.id AS id_ffa,
    f.gpat,
    f.id_paciente,
    f.status,
    f.layout,
    p.nome_completo AS paciente_nome,
    fs.senha,
    fs.origem
FROM ffa f
JOIN paciente p ON p.id = f.id_paciente
LEFT JOIN fila_senha fs ON fs.id_ffa = f.id
WHERE f.status IN ('EM_ATENDIMENTO', 'OBSERVACAO')
ORDER BY fs.criado_em ASC;


CREATE OR REPLACE VIEW vw_painel_internacao AS
SELECT
    f.id AS id_ffa,
    f.gpat,
    f.id_paciente,
    f.status,
    f.layout,
    p.nome_completo AS paciente_nome,
    fs.senha,
    fs.origem
FROM ffa f
JOIN paciente p ON p.id = f.id_paciente
LEFT JOIN fila_senha fs ON fs.id_ffa = f.id
WHERE f.status = 'INTERNACAO'
ORDER BY fs.criado_em ASC;

CREATE OR REPLACE VIEW vw_painel_clinico AS
SELECT
    f.id AS id_ffa,
    f.gpat,
    f.id_paciente,
    f.status,
    f.layout,
    p.nome_completo AS paciente_nome,
    fs.senha,
    fs.origem,
    fs.classificacao_manchester,
    fs.criado_em AS hora_chegada
FROM ffa f
JOIN paciente p ON p.id = f.id_paciente
LEFT JOIN fila_senha fs ON fs.id_ffa = f.id
WHERE f.status IN ('ABERTO','EM_TRIAGEM','EM_ATENDIMENTO','OBSERVACAO')
ORDER BY
    CASE fs.classificacao_manchester
        WHEN 'VERMELHO' THEN 1
        WHEN 'LARANJA' THEN 2
        WHEN 'AMARELO' THEN 3
        WHEN 'VERDE' THEN 4
        WHEN 'AZUL' THEN 5
        ELSE 6
    END,
    fs.criado_em ASC;

ALTER TABLE fila_senha
ADD COLUMN prioridade_temporaria ENUM('NORMAL','IDOSO','CRIANCA_COLO','ESPECIAL','EMERGENCIA') DEFAULT 'NORMAL',
ADD COLUMN prioridade_recepcao ENUM('NORMAL','IDOSO','CRIANCA_COLO','ESPECIAL','EMERGENCIA') DEFAULT NULL;


CREATE OR REPLACE VIEW vw_fila_totem AS
SELECT
    fs.id AS id_fila,
    fs.senha,
    fs.id_paciente,
    fs.prioridade_temporaria,
    fs.criado_em AS hora_chegada
FROM fila_senha fs
WHERE fs.id_ffa IS NULL  -- apenas senhas ainda não associadas a FFA
ORDER BY FIELD(fs.prioridade_temporaria,'EMERGENCIA','ESPECIAL','CRIANCA_COLO','IDOSO','NORMAL'),
         fs.criado_em ASC;


CREATE OR REPLACE VIEW vw_fila_recepcao AS
SELECT
    fs.id AS id_fila,
    fs.senha,
    fs.id_paciente,
    fs.prioridade_recepcao,
    fs.prioridade_temporaria,
    f.status,
    f.layout,
    fs.criado_em AS hora_chegada
FROM fila_senha fs
LEFT JOIN ffa f ON fs.id_ffa = f.id
ORDER BY
    CASE
        WHEN fs.prioridade_recepcao='EMERGENCIA' THEN 1
        WHEN fs.prioridade_recepcao='ESPECIAL' THEN 2
        WHEN fs.prioridade_recepcao='CRIANCA_COLO' THEN 3
        WHEN fs.prioridade_recepcao='IDOSO' THEN 4
        ELSE 5
    END,
    fs.criado_em ASC;
ALTER TABLE ffa
ADD COLUMN classificacao_manchester ENUM('VERMELHO','LARANJA','AMARELO','VERDE','AZUL') DEFAULT NULL;


CREATE OR REPLACE VIEW vw_painel_clinico AS
SELECT
    f.id AS id_ffa,
    f.gpat,
    f.id_paciente,
    f.status,
    f.layout,
    p.nome_completo AS paciente_nome,
    fs.senha,
    fs.prioridade_recepcao,
    f.classificacao_manchester,
    fs.criado_em AS hora_chegada
FROM ffa f
JOIN paciente p ON p.id = f.id_paciente
LEFT JOIN fila_senha fs ON fs.id_ffa = f.id
WHERE f.status IN ('ABERTO','EM_TRIAGEM','EM_ATENDIMENTO','OBSERVACAO')
ORDER BY
    CASE f.classificacao_manchester
        WHEN 'VERMELHO' THEN 1
        WHEN 'LARANJA' THEN 2
        WHEN 'AMARELO' THEN 3
        WHEN 'VERDE' THEN 4
        WHEN 'AZUL' THEN 5
        ELSE 6
    END,
    fs.criado_em ASC;
    
    CREATE OR REPLACE VIEW vw_painel_chamada AS
SELECT
    fs.senha,
    fs.prioridade_recepcao,
    f.layout AS local_atendimento
FROM fila_senha fs
JOIN ffa f ON fs.id_ffa = f.id
WHERE f.status IN ('ABERTO','EM_TRIAGEM','EM_ATENDIMENTO')
ORDER BY
    CASE fs.prioridade_recepcao
        WHEN 'EMERGENCIA' THEN 1
        WHEN 'ESPECIAL' THEN 2
        WHEN 'CRIANCA_COLO' THEN 3
        WHEN 'IDOSO' THEN 4
        ELSE 5
    END,
    fs.criado_em ASC
LIMIT 1;


CREATE OR REPLACE VIEW vw_fila_totem AS
SELECT
    fs.id AS id_fila,
    fs.senha,
    fs.id_paciente,
    fs.prioridade_temporaria,
    fs.criado_em AS hora_chegada
FROM fila_senha fs
WHERE fs.id_ffa IS NULL
ORDER BY FIELD(fs.prioridade_temporaria,'EMERGENCIA','ESPECIAL','CRIANCA_COLO','IDOSO','NORMAL'),
         fs.criado_em ASC;

CREATE OR REPLACE VIEW vw_fila_recepcao AS
SELECT
    fs.id AS id_fila,
    fs.senha,
    fs.id_paciente,
    fs.prioridade_recepcao,
    fs.prioridade_temporaria,
    f.status,
    f.layout,
    fs.criado_em AS hora_chegada
FROM fila_senha fs
LEFT JOIN ffa f ON fs.id_ffa = f.id
ORDER BY
    CASE
        WHEN fs.prioridade_recepcao='EMERGENCIA' THEN 1
        WHEN fs.prioridade_recepcao='ESPECIAL' THEN 2
        WHEN fs.prioridade_recepcao='CRIANCA_COLO' THEN 3
        WHEN fs.prioridade_recepcao='IDOSO' THEN 4
        ELSE 5
    END,
    fs.criado_em ASC;
    
CREATE OR REPLACE VIEW vw_painel_clinico AS
SELECT
    f.id AS id_ffa,
    f.gpat,
    f.id_paciente,
    f.status,
    f.layout,
    p.nome_completo AS paciente_nome,
    fs.senha,
    fs.prioridade_recepcao,
    f.classificacao_manchester,
    fs.criado_em AS hora_chegada
FROM ffa f
JOIN paciente p ON p.id = f.id_paciente
LEFT JOIN fila_senha fs ON fs.id_ffa = f.id
WHERE f.status IN ('ABERTO','EM_TRIAGEM','EM_ATENDIMENTO','OBSERVACAO')
ORDER BY
    CASE f.classificacao_manchester
        WHEN 'VERMELHO' THEN 1
        WHEN 'LARANJA' THEN 2
        WHEN 'AMARELO' THEN 3
        WHEN 'VERDE' THEN 4
        WHEN 'AZUL' THEN 5
        ELSE 6
    END,
    fs.criado_em ASC;
    
    CREATE OR REPLACE VIEW vw_painel_chamada AS
SELECT
    fs.senha,
    fs.prioridade_recepcao,
    f.layout AS local_atendimento
FROM fila_senha fs
JOIN ffa f ON fs.id_ffa = f.id
WHERE f.status IN ('ABERTO','EM_TRIAGEM','EM_ATENDIMENTO')
ORDER BY
    CASE fs.prioridade_recepcao
        WHEN 'EMERGENCIA' THEN 1
        WHEN 'ESPECIAL' THEN 2
        WHEN 'CRIANCA_COLO' THEN 3
        WHEN 'IDOSO' THEN 4
        ELSE 5
    END,
    fs.criado_em ASC
LIMIT 1;



DELIMITER $$

DROP TRIGGER IF EXISTS trg_fila_senha_prioridade_temporaria$$

CREATE TRIGGER trg_fila_senha_prioridade_temporaria
BEFORE INSERT ON fila_senha
FOR EACH ROW
BEGIN
    -- Define prioridade temporária baseada no tipo de paciente (ex.: emergência manual, idoso, etc.)
    -- Para agora, se não for especificado, coloca 'NORMAL'
    IF NEW.prioridade_temporaria IS NULL THEN
        SET NEW.prioridade_temporaria = 'NORMAL';
    END IF;
END$$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_confirma_prioridade_recepcao$$

CREATE PROCEDURE sp_confirma_prioridade_recepcao(
    IN p_id_fila BIGINT,
    IN p_prioridade ENUM('NORMAL','IDOSO','CRIANCA_COLO','ESPECIAL','EMERGENCIA'),
    IN p_id_usuario BIGINT
)
BEGIN
    -- Atualiza prioridade oficial da recepção
    UPDATE fila_senha
    SET prioridade_recepcao = p_prioridade
    WHERE id = p_id_fila;

    -- Auditoria opcional
    INSERT INTO auditoria_fila (id_fila, id_usuario, acao, timestamp)
    VALUES (p_id_fila, p_id_usuario, CONCAT('Prioridade recepção setada para ', p_prioridade), NOW());
END$$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_atualiza_classificacao_manchester$$

CREATE PROCEDURE sp_atualiza_classificacao_manchester(
    IN p_id_ffa BIGINT,
    IN p_classificacao ENUM('VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
    IN p_id_usuario BIGINT
)
BEGIN
    -- Atualiza classificação Manchester na FFA
    UPDATE ffa
    SET classificacao_manchester = p_classificacao,
        id_usuario_alteracao = p_id_usuario,
        atualizado_em = NOW()
    WHERE id = p_id_ffa;

    -- Auditoria opcional
    INSERT INTO auditoria_ffa (id_ffa, id_usuario, acao, timestamp)
    VALUES (p_id_ffa, p_id_usuario, CONCAT('Classificação Manchester atualizada para ', p_classificacao), NOW());
END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_atualiza_classificacao_manchester$$

CREATE PROCEDURE sp_atualiza_classificacao_manchester(
    IN p_id_ffa BIGINT,
    IN p_classificacao ENUM('VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
    IN p_id_usuario BIGINT
)
BEGIN
    -- Atualiza classificação Manchester na FFA
    UPDATE ffa
    SET classificacao_manchester = p_classificacao,
        id_usuario_alteracao = p_id_usuario,
        atualizado_em = NOW()
    WHERE id = p_id_ffa;

    -- Auditoria opcional
    INSERT INTO auditoria_ffa (id_ffa, id_usuario, acao, timestamp)
    VALUES (p_id_ffa, p_id_usuario, CONCAT('Classificação Manchester atualizada para ', p_classificacao), NOW());
END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_inicio_triagem$$

CREATE PROCEDURE sp_inicio_triagem(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    -- Atualiza status para triagem em andamento
    UPDATE ffa
    SET status = 'EM_TRIAGEM_ATENDIMENTO',
        layout = 'TRIAGEM',
        id_usuario_alteracao = p_id_usuario,
        atualizado_em = NOW()
    WHERE id = p_id_ffa;

    -- Auditoria
    INSERT INTO auditoria_ffa (id_ffa, id_usuario, acao, timestamp)
    VALUES (p_id_ffa, p_id_usuario, 'INICIOU TRIAGEM', NOW());
END$$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_finaliza_triagem$$

CREATE PROCEDURE sp_finaliza_triagem(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_layout_medico VARCHAR(50) -- ex: SALA_1
)
BEGIN
    -- Atualiza status para aguardando médico
    UPDATE ffa
    SET status = 'AGUARDANDO_CHAMADA_MEDICO',
        layout = p_layout_medico,
        id_usuario_alteracao = p_id_usuario,
        atualizado_em = NOW()
    WHERE id = p_id_ffa;

    -- Auditoria
    INSERT INTO auditoria_ffa (id_ffa, id_usuario, acao, timestamp)
    VALUES (p_id_ffa, p_id_usuario, 'TRIAGEM FINALIZADA, AGUARDANDO MEDICO', NOW());
END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_inicio_atendimento_medico$$

CREATE PROCEDURE sp_inicio_atendimento_medico(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_procedimento VARCHAR(50) -- MEDICACAO / RX / EXAMES / etc.
)
BEGIN
    -- Define status específico do procedimento
    UPDATE ffa
    SET status = CONCAT('EM_ATENDIMENTO_', UPPER(p_procedimento)),
        layout = p_procedimento,
        id_usuario_alteracao = p_id_usuario,
        atualizado_em = NOW()
    WHERE id = p_id_ffa;

    -- Auditoria
    INSERT INTO auditoria_ffa (id_ffa, id_usuario, acao, timestamp)
    VALUES (p_id_ffa, p_id_usuario, CONCAT('INICIOU ATENDIMENTO: ', p_procedimento), NOW());
END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_finaliza_atendimento$$

CREATE PROCEDURE sp_finaliza_atendimento(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_status_final ENUM('ALTA','AGUARDANDO_RETORNO','INTERNACAO','TRANSFERENCIA')
)
BEGIN
    -- Atualiza status final
    UPDATE ffa
    SET status = p_status_final,
        layout = 'FINALIZADO',
        id_usuario_alteracao = p_id_usuario,
        atualizado_em = NOW()
    WHERE id = p_id_ffa;

    -- Auditoria
    INSERT INTO auditoria_ffa (id_ffa, id_usuario, acao, timestamp)
    VALUES (p_id_ffa, p_id_usuario, CONCAT('FINALIZOU ATENDIMENTO: ', p_status_final), NOW());
END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_inicio_procedimento$$

CREATE PROCEDURE sp_inicio_procedimento(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_procedimento ENUM('MEDICACAO','RX','EXAMES')
)
BEGIN
    -- Atualiza status específico do procedimento
    UPDATE ffa
    SET status = CONCAT('EM_ATENDIMENTO_', UPPER(p_procedimento)),
        layout = p_procedimento,
        id_usuario_alteracao = p_id_usuario,
        atualizado_em = NOW()
    WHERE id = p_id_ffa;

    -- Auditoria
    INSERT INTO auditoria_ffa (id_ffa, id_usuario, acao, timestamp)
    VALUES (p_id_ffa, p_id_usuario, CONCAT('INICIOU PROCEDIMENTO: ', p_procedimento), NOW());
END$$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_finaliza_procedimento$$

CREATE PROCEDURE sp_finaliza_procedimento(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_status_final ENUM('ALTA','AGUARDANDO_RETORNO','INTERNACAO','TRANSFERENCIA')
)
BEGIN
    -- Atualiza status final após procedimento
    UPDATE ffa
    SET status = p_status_final,
        layout = 'FINALIZADO',
        id_usuario_alteracao = p_id_usuario,
        atualizado_em = NOW()
    WHERE id = p_id_ffa;

    -- Auditoria
    INSERT INTO auditoria_ffa (id_ffa, id_usuario, acao, timestamp)
    VALUES (p_id_ffa, p_id_usuario, CONCAT('FINALIZOU PROCEDIMENTO, STATUS: ', p_status_final), NOW());
END$$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_cancelar_chamada$$

CREATE PROCEDURE sp_cancelar_chamada(
    IN p_id_fila BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_id_ffa BIGINT;

    -- Pega a FFA vinculada
    SELECT id_ffa INTO v_id_ffa
    FROM fila_senha
    WHERE id = p_id_fila;

    -- Atualiza status da FFA e da fila
    UPDATE ffa
    SET status = 'CANCELADA',
        id_usuario_alteracao = p_id_usuario,
        atualizado_em = NOW()
    WHERE id = v_id_ffa;

    UPDATE fila_senha
    SET origem = 'RECEPCAO', -- registra alteração
        gerada_manual = 1
    WHERE id = p_id_fila;

    -- Auditoria
    INSERT INTO auditoria_ffa (id_ffa, id_usuario, acao, timestamp)
    VALUES (v_id_ffa, p_id_usuario, 'CHAMADA CANCELADA / NAO ATENDIDO', NOW());
END$$

DELIMITER ;

DELIMITER $$

DROP TRIGGER IF EXISTS trg_update_painel_ffa$$

CREATE TRIGGER trg_update_painel_ffa
AFTER UPDATE ON ffa
FOR EACH ROW
BEGIN
    -- Aqui podemos colocar lógica para atualizar view ou enviar evento
    -- Ex: atualizar vw_painel_clinico, vw_painel_recepcao, etc.
    -- Dependendo do frontend, pode ser polling ou websocket
END$$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_chama_paciente$$

CREATE PROCEDURE sp_chama_paciente(
    IN p_id_fila BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_id_ffa BIGINT;

    -- Pega a FFA vinculada à fila
    SELECT id_ffa INTO v_id_ffa
    FROM fila_senha
    WHERE id = p_id_fila;

    -- Atualiza status na fila
    UPDATE fila_senha
    SET status = 'CHAMANDO'
    WHERE id = p_id_fila;

    -- Auditoria
    INSERT INTO auditoria_ffa (id_ffa, id_usuario, acao, timestamp)
    VALUES (v_id_ffa, p_id_usuario, 'PACIENTE CHAMADO NA RECEPCAO', NOW());
END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_inicio_triagem$$

CREATE PROCEDURE sp_inicio_triagem(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_classificacao ENUM('VERMELHO','LARANJA','AMARELO','VERDE','AZUL')
)
BEGIN
    -- Inicia triagem
    UPDATE ffa
    SET status = 'EM_TRIAGEM_ATENDIMENTO',
        classificacao_manchester = p_classificacao,
        layout = 'TRIAGEM',
        id_usuario_alteracao = p_id_usuario,
        atualizado_em = NOW()
    WHERE id = p_id_ffa;

    -- Auditoria
    INSERT INTO auditoria_ffa (id_ffa, id_usuario, acao, timestamp)
    VALUES (p_id_ffa, p_id_usuario, CONCAT('TRIAGEM INICIADA, CLASSIFICACAO: ', p_classificacao), NOW());
END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_inicio_atendimento_medico$$

CREATE PROCEDURE sp_inicio_atendimento_medico(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    UPDATE ffa
    SET status = 'EM_ATENDIMENTO_MEDICO',
        layout = 'MEDICO',
        id_usuario_alteracao = p_id_usuario,
        atualizado_em = NOW()
    WHERE id = p_id_ffa;

    INSERT INTO auditoria_ffa (id_ffa, id_usuario, acao, timestamp)
    VALUES (p_id_ffa, p_id_usuario, 'INICIO ATENDIMENTO MEDICO', NOW());
END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_cancelar_chamada$$

CREATE PROCEDURE sp_cancelar_chamada(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_status_final ENUM('CANCELADA','NAO_ATENDIDO','ALTA','AGUARDANDO_RETORNO','INTERNACAO','TRANSFERENCIA')
)
BEGIN
    -- Atualiza status final na FFA
    UPDATE ffa
    SET status = p_status_final,
        layout = CASE
                    WHEN p_status_final IN ('ALTA','AGUARDANDO_RETORNO') THEN 'FINALIZADO'
                    ELSE layout
                 END,
        id_usuario_alteracao = p_id_usuario,
        atualizado_em = NOW()
    WHERE id = p_id_ffa;

    -- Auditoria
    INSERT INTO auditoria_ffa (id_ffa, id_usuario, acao, timestamp)
    VALUES (p_id_ffa, p_id_usuario, CONCAT('STATUS FINAL: ', p_status_final), NOW());
END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_inicio_procedimento$$

CREATE PROCEDURE sp_inicio_procedimento(
    IN p_id_ffa BIGINT,                 -- ID da FFA do paciente
    IN p_id_usuario BIGINT,             -- Usuário que iniciou o procedimento
    IN p_procedimento ENUM('MEDICACAO','RX','EXAMES')  -- Tipo de procedimento
)
BEGIN
    -- Atualiza status da FFA de acordo com o procedimento
    UPDATE ffa
    SET status = CASE 
                    WHEN p_procedimento = 'MEDICACAO' THEN 'EM_ATENDIMENTO_MEDICACAO'
                    WHEN p_procedimento = 'RX' THEN 'EM_ATENDIMENTO_RX'
                    WHEN p_procedimento = 'EXAMES' THEN 'EM_ATENDIMENTO_EXAMES'
                 END,
        layout = p_procedimento,
        id_usuario_alteracao = p_id_usuario,
        atualizado_em = NOW()
    WHERE id = p_id_ffa;

    -- Auditoria
    INSERT INTO auditoria_ffa (id_ffa, id_usuario, acao, timestamp)
    VALUES (p_id_ffa, p_id_usuario, CONCAT('INICIO PROCEDIMENTO: ', p_procedimento), NOW());
END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_finaliza_procedimento$$

CREATE PROCEDURE sp_finaliza_procedimento(
    IN p_id_ffa BIGINT, 
    IN p_id_usuario BIGINT, 
    IN p_status_final ENUM('ALTA','AGUARDANDO_RETORNO','INTERNACAO','TRANSFERENCIA')
)
BEGIN
    -- Atualiza status final da FFA
    UPDATE ffa
    SET status = p_status_final,
        layout = CASE 
                    WHEN p_status_final IN ('ALTA','AGUARDANDO_RETORNO') THEN 'FINALIZADO'
                    ELSE layout
                 END,
        id_usuario_alteracao = p_id_usuario,
        atualizado_em = NOW()
    WHERE id = p_id_ffa;

    -- Auditoria do procedimento finalizado
    INSERT INTO auditoria_ffa (id_ffa, id_usuario, acao, timestamp)
    VALUES (p_id_ffa, p_id_usuario, CONCAT('PROCEDIMENTO FINALIZADO, STATUS: ', p_status_final), NOW());
END$$

DELIMITER ;

CREATE OR REPLACE VIEW vw_painel_clinico_completo AS
SELECT
    f.id AS id_ffa,
    f.gpat,
    f.id_paciente,
    p.nome_completo AS paciente_nome,
    fs.senha,
    fs.prioridade_recepcao,
    f.classificacao_manchester,
    f.status AS status_ffa,
    f.layout AS layout_ffa,
    fs.criado_em AS hora_chegada,
    CASE
        WHEN f.status LIKE 'EM_ATENDIMENTO_MEDICACAO%' THEN 'MEDICACAO'
        WHEN f.status LIKE 'EM_ATENDIMENTO_RX%' THEN 'RX'
        WHEN f.status LIKE 'EM_ATENDIMENTO_EXAMES%' THEN 'EXAMES'
        ELSE NULL
    END AS procedimento_atual
FROM ffa f
JOIN paciente p ON p.id = f.id_paciente
LEFT JOIN fila_senha fs ON fs.id_ffa = f.id
WHERE f.status IN (
    'ABERTO', 'EM_TRIAGEM_AGUARDANDO', 'EM_TRIAGEM_ATENDIMENTO',
    'AGUARDANDO_CHAMADA_MEDICO', 'EM_ATENDIMENTO_MEDICO',
    'EM_ATENDIMENTO_MEDICACAO', 'EM_ATENDIMENTO_RX', 'EM_ATENDIMENTO_EXAMES'
)
ORDER BY 
    CASE f.classificacao_manchester
        WHEN 'VERMELHO' THEN 1
        WHEN 'LARANJA' THEN 2
        WHEN 'AMARELO' THEN 3
        WHEN 'VERDE' THEN 4
        WHEN 'AZUL' THEN 5
        ELSE 6
    END,
    fs.criado_em ASC;

CREATE OR REPLACE VIEW vw_painel_totem AS
SELECT
    fs.id AS id_fila,
    fs.senha,
    fs.prioridade_recepcao,
    fs.criado_em AS hora_geracao
FROM fila_senha fs
LEFT JOIN ffa f ON f.id = fs.id_ffa
WHERE fs.id_ffa IS NULL OR f.status IN ('ABERTO');

CREATE OR REPLACE VIEW vw_painel_recepcao AS
SELECT
    vpc.id_ffa,
    vpc.paciente_nome,
    vpc.senha,
    vpc.prioridade_recepcao,
    vpc.status_ffa,
    vpc.hora_chegada
FROM vw_painel_clinico_completo vpc
WHERE vpc.status_ffa IN (
    'ABERTO',
    'EM_TRIAGEM_AGUARDANDO',
    'EM_TRIAGEM_ATENDIMENTO',
    'AGUARDANDO_CHAMADA_MEDICO'
)
ORDER BY 
    vpc.prioridade_recepcao DESC,
    vpc.hora_chegada ASC;


CREATE OR REPLACE VIEW vw_painel_triagem AS
SELECT
    vpc.id_ffa,
    vpc.paciente_nome,
    vpc.senha,
    vpc.classificacao_manchester,
    vpc.status_ffa,
    vpc.hora_chegada
FROM vw_painel_clinico_completo vpc
WHERE vpc.status_ffa IN ('EM_TRIAGEM_AGUARDANDO','EM_TRIAGEM_ATENDIMENTO')
ORDER BY
    CASE vpc.classificacao_manchester
        WHEN 'VERMELHO' THEN 1
        WHEN 'LARANJA' THEN 2
        WHEN 'AMARELO' THEN 3
        WHEN 'VERDE' THEN 4
        WHEN 'AZUL' THEN 5
        ELSE 6
    END,
    vpc.hora_chegada ASC;


CREATE OR REPLACE VIEW vw_painel_medico AS
SELECT
    vpc.id_ffa,
    vpc.paciente_nome,
    vpc.senha,
    vpc.status_ffa,
    vpc.layout_ffa,
    vpc.procedimento_atual,
    vpc.classificacao_manchester,
    vpc.hora_chegada
FROM vw_painel_clinico_completo vpc
WHERE vpc.status_ffa IN (
    'AGUARDANDO_CHAMADA_MEDICO',
    'EM_ATENDIMENTO_MEDICO',
    'EM_ATENDIMENTO_MEDICACAO',
    'EM_ATENDIMENTO_RX',
    'EM_ATENDIMENTO_EXAMES'
)
ORDER BY 
    CASE vpc.classificacao_manchester
        WHEN 'VERMELHO' THEN 1
        WHEN 'LARANJA' THEN 2
        WHEN 'AMARELO' THEN 3
        WHEN 'VERDE' THEN 4
        WHEN 'AZUL' THEN 5
        ELSE 6
    END,
    vpc.hora_chegada ASC;

CREATE OR REPLACE VIEW vw_painel_procedimentos AS
SELECT
    vpc.id_ffa,
    vpc.paciente_nome,
    vpc.procedimento_atual,
    vpc.status_ffa,
    vpc.hora_chegada
FROM vw_painel_clinico_completo vpc
WHERE vpc.procedimento_atual IS NOT NULL
ORDER BY 
    vpc.procedimento_atual,
    vpc.hora_chegada ASC;

INSERT INTO paciente (nome_completo, cpf, cns, data_nascimento, sexo, nome_mae, criado_em, atualizado_em)
VALUES ('João da Silva', '123.456.789-00', '123456789012345', '2000-01-01', 'M', 'Maria da Silva', NOW(), NOW());

SET @id_paciente_teste = LAST_INSERT_ID();

INSERT INTO fila_senha (id_paciente, criado_em, origem, gerada_manual)
VALUES (@id_paciente_teste, NOW(), 'TOTEM', 0);

SET @id_fila_teste = LAST_INSERT_ID();

CALL sp_abre_ffa(
    @id_fila_teste,
    1,                 -- id_usuario da recepção
    @id_paciente_teste,
    @id_ffa_teste,     -- OUT: ID da FFA criada
    @gpat_teste        -- OUT: GPAT gerado
);

CALL sp_inicio_triagem(
    @id_ffa_teste,   -- ID da FFA
    2,               -- usuário da triagem
    'TRIAGEM_1'      -- sala de triagem
);


UPDATE ffa
SET classificacao_manchester = 'AMARELO',
    id_usuario_alteracao = 2,
    atualizado_em = NOW()
WHERE id = @id_ffa_teste;


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_inicio_triagem$$

CREATE PROCEDURE sp_inicio_triagem(
    IN p_id_ffa BIGINT,        -- ID da FFA
    IN p_id_usuario BIGINT,    -- usuário da triagem
    IN p_sala VARCHAR(50)      -- sala de triagem
)
BEGIN
    DECLARE v_classificacao ENUM('VERMELHO','LARANJA','AMARELO','VERDE','AZUL');

    -- Define classificação padrão temporária
    SET v_classificacao = 'AZUL';

    -- Atualiza status da FFA para EM_TRIAGEM e layout para painel da triagem
    UPDATE ffa
    SET status = 'EM_TRIAGEM',
        layout = p_sala,
        classificacao_manchester = v_classificacao,
        id_usuario_alteracao = p_id_usuario,
        atualizado_em = NOW()
    WHERE id = p_id_ffa;

    -- Auditoria da ação
    INSERT INTO auditoria_ffa (
        id_ffa,
        id_usuario,
        acao,
        timestamp
    ) VALUES (
        p_id_ffa,
        p_id_usuario,
        CONCAT('INICIO TRIAGEM: FFA em ', p_sala, ', classificacao ', v_classificacao),
        NOW()
    );
END$$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_finaliza_triagem$$

CREATE PROCEDURE sp_finaliza_triagem(
    IN p_id_ffa BIGINT,                           -- ID da FFA
    IN p_id_usuario BIGINT,                       -- Usuário que finaliza a triagem
    IN p_classificacao ENUM('VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),  -- Classificação Manchester
    IN p_sala_medico VARCHAR(50)                 -- Sala do painel médico
)
BEGIN
    -- Atualiza FFA: muda status, layout e classificação
    UPDATE ffa
    SET status = 'AGUARDANDO_CHAMADA_MEDICO',    -- agora válido no ENUM
        layout = p_sala_medico,
        classificacao_manchester = p_classificacao,
        id_usuario_alteracao = p_id_usuario,
        atualizado_em = NOW()
    WHERE id = p_id_ffa;

    -- Auditoria da ação
    INSERT INTO auditoria_ffa (
        id_ffa,
        id_usuario,
        acao,
        timestamp
    ) VALUES (
        p_id_ffa,
        p_id_usuario,
        CONCAT('FINALIZA TRIAGEM: classificacao ', p_classificacao, ', encaminhado para ', p_sala_medico),
        NOW()
    );
END$$

DELIMITER ;

CALL sp_finaliza_triagem(
    @id_ffa_teste,     -- ID da FFA
    2,                 -- id_usuario da triagem
    'AMARELO',         -- classificação Manchester real
    'PAINEL_MEDICO'    -- sala/painel médico
);

-- 1️⃣ Desabilita temporariamente safe updates
SET SQL_SAFE_UPDATES = 0;

-- 2️⃣ Atualiza status antigos usando JOIN com subselect derivado

-- Triagem e recepção
UPDATE ffa
JOIN (SELECT id, status FROM ffa) AS tmp ON ffa.id = tmp.id
SET ffa.status = 'ABERTO'
WHERE tmp.status = 'ABERTO';

UPDATE ffa
JOIN (SELECT id, status FROM ffa) AS tmp ON ffa.id = tmp.id
SET ffa.status = 'EM_TRIAGEM'
WHERE tmp.status = 'EM_TRIAGEM';

UPDATE ffa
JOIN (SELECT id, status FROM ffa) AS tmp ON ffa.id = tmp.id
SET ffa.status = 'AGUARDANDO_CHAMADA_MEDICO'
WHERE tmp.status = 'EM_TRIAGEM_FINALIZADA';

-- Atendimento médico
UPDATE ffa
JOIN (SELECT id, status FROM ffa) AS tmp ON ffa.id = tmp.id
SET ffa.status = 'CHAMANDO_MEDICO'
WHERE tmp.status = 'CHAMANDO';

UPDATE ffa
JOIN (SELECT id, status FROM ffa) AS tmp ON ffa.id = tmp.id
SET ffa.status = 'EM_ATENDIMENTO_MEDICO'
WHERE tmp.status = 'EM_ATENDIMENTO';

UPDATE ffa
JOIN (SELECT id, status FROM ffa) AS tmp ON ffa.id = tmp.id
SET ffa.status = 'OBSERVACAO'
WHERE tmp.status = 'OBSERVACAO';

-- Procedimentos específicos
UPDATE ffa
JOIN (SELECT id, status FROM ffa) AS tmp ON ffa.id = tmp.id
SET ffa.status = 'MEDICACAO'
WHERE tmp.status = 'MEDICACAO';

UPDATE ffa
JOIN (SELECT id, status FROM ffa) AS tmp ON ffa.id = tmp.id
SET ffa.status = 'AGUARDANDO_MEDICACAO'
WHERE tmp.status = 'AGUARDANDO_MEDICACAO';

UPDATE ffa
JOIN (SELECT id, status FROM ffa) AS tmp ON ffa.id = tmp.id
SET ffa.status = 'AGUARDANDO_RX'
WHERE tmp.status = 'AGUARDANDO_RX';

UPDATE ffa
JOIN (SELECT id, status FROM ffa) AS tmp ON ffa.id = tmp.id
SET ffa.status = 'EM_RX'
WHERE tmp.status = 'EM_RX';

UPDATE ffa
JOIN (SELECT id, status FROM ffa) AS tmp ON ffa.id = tmp.id
SET ffa.status = 'AGUARDANDO_COLETA'
WHERE tmp.status = 'AGUARDANDO_COLETA';

UPDATE ffa
JOIN (SELECT id, status FROM ffa) AS tmp ON ffa.id = tmp.id
SET ffa.status = 'EM_COLETA'
WHERE tmp.status = 'EM_COLETA';

UPDATE ffa
JOIN (SELECT id, status FROM ffa) AS tmp ON ffa.id = tmp.id
SET ffa.status = 'AGUARDANDO_ECG'
WHERE tmp.status = 'AGUARDANDO_ECG';

UPDATE ffa
JOIN (SELECT id, status FROM ffa) AS tmp ON ffa.id = tmp.id
SET ffa.status = 'EM_ECG'
WHERE tmp.status = 'EM_ECG';

-- Encerramento / outros
UPDATE ffa
JOIN (SELECT id, status FROM ffa) AS tmp ON ffa.id = tmp.id
SET ffa.status = 'ALTA'
WHERE tmp.status = 'ALTA';

UPDATE ffa
JOIN (SELECT id, status FROM ffa) AS tmp ON ffa.id = tmp.id
SET ffa.status = 'TRANSFERENCIA'
WHERE tmp.status = 'TRANSFERENCIA';

UPDATE ffa
JOIN (SELECT id, status FROM ffa) AS tmp ON ffa.id = tmp.id
SET ffa.status = 'INTERNACAO'
WHERE tmp.status = 'INTERNACAO';

UPDATE ffa
JOIN (SELECT id, status FROM ffa) AS tmp ON ffa.id = tmp.id
SET ffa.status = 'FINALIZADO'
WHERE tmp.status = 'FINALIZADO';

UPDATE ffa
JOIN (SELECT id, status FROM ffa) AS tmp ON ffa.id = tmp.id
SET ffa.status = 'AGUARDANDO_RETORNO'
WHERE tmp.status = 'AGUARDANDO_RETORNO';

UPDATE ffa
JOIN (SELECT id, status FROM ffa) AS tmp ON ffa.id = tmp.id
SET ffa.status = 'EMERGENCIA'
WHERE tmp.status = 'EMERGENCIA';

-- 3️⃣ Alterar coluna status para o ENUM completo
ALTER TABLE ffa 
MODIFY COLUMN status ENUM(
    -- Triagem e recepção
    'ABERTO',
    'EM_TRIAGEM',
    'AGUARDANDO_CHAMADA_MEDICO',

    -- Atendimento médico
    'CHAMANDO_MEDICO',
    'EM_ATENDIMENTO_MEDICO',
    'OBSERVACAO',

    -- Procedimentos específicos
    'MEDICACAO',
    'AGUARDANDO_MEDICACAO',
    'AGUARDANDO_RX',
    'EM_RX',
    'AGUARDANDO_COLETA',
    'EM_COLETA',
    'AGUARDANDO_ECG',
    'EM_ECG',

    -- Encerramento
    'ALTA',
    'TRANSFERENCIA',
    'INTERNACAO',
    'FINALIZADO',
    'AGUARDANDO_RETORNO',
    'EMERGENCIA'
) NOT NULL;

-- 4️⃣ Reativa safe updates (opcional)
SET SQL_SAFE_UPDATES = 1;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_abre_ffa$$

CREATE PROCEDURE sp_abre_ffa(
    IN p_id_fila BIGINT,        -- fila_senha.id
    IN p_id_usuario BIGINT,     -- usuário que abre a FFA
    IN p_id_paciente BIGINT,    -- paciente vinculado
    OUT p_id_ffa BIGINT,        -- retorna o id da FFA criada
    OUT p_gpat VARCHAR(30)      -- retorna o GPAT gerado
)
BEGIN
    DECLARE v_status VARCHAR(50);

    -- Verifica se já existe FFA aberta
    SELECT id, status INTO p_id_ffa, v_status
    FROM ffa
    WHERE id_paciente = p_id_paciente
      AND status IN ('ABERTO','EM_TRIAGEM','AGUARDANDO_CHAMADA_MEDICO')
    ORDER BY criado_em DESC
    LIMIT 1;

    -- Se não existir, cria nova FFA
    IF p_id_ffa IS NULL THEN
        -- Gera GPAT
        SET p_gpat = fn_gera_protocolo(p_id_usuario);

        -- Insere nova FFA
        INSERT INTO ffa (
            id_paciente,
            gpat,
            status,
            layout,
            id_usuario_criacao,
            criado_em,
            atualizado_em
        ) VALUES (
            p_id_paciente,
            p_gpat,
            'ABERTO',
            'TRIAGEM',
            p_id_usuario,
            NOW(),
            NOW()
        );

        SET p_id_ffa = LAST_INSERT_ID();

        -- Atualiza fila_senha com o id_ffa
        UPDATE fila_senha
        SET id_ffa = p_id_ffa
        WHERE id = p_id_fila;

        -- Auditoria
        INSERT INTO auditoria_ffa (
            id_ffa,
            id_usuario,
            acao,
            timestamp
        ) VALUES (
            p_id_ffa,
            p_id_usuario,
            CONCAT('CRIACAO: FFA aberta para paciente ', p_id_paciente),
            NOW()
        );

    ELSE
        -- Se já existe, retorna GPAT existente
        SELECT gpat INTO p_gpat FROM ffa WHERE id = p_id_ffa;
    END IF;
END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_inicio_triagem$$

CREATE PROCEDURE sp_inicio_triagem(
    IN p_id_ffa BIGINT,        -- FFA
    IN p_id_usuario BIGINT,    -- triagem
    IN p_sala VARCHAR(50)      -- sala de triagem
)
BEGIN
    -- Atualiza FFA com status de triagem
    UPDATE ffa
    SET status = 'EM_TRIAGEM',
        layout = p_sala,
        id_usuario_alteracao = p_id_usuario,
        atualizado_em = NOW()
    WHERE id = p_id_ffa;

    -- Auditoria
    INSERT INTO auditoria_ffa (
        id_ffa,
        id_usuario,
        acao,
        timestamp
    ) VALUES (
        p_id_ffa,
        p_id_usuario,
        CONCAT('INICIO TRIAGEM em ', p_sala),
        NOW()
    );
END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_finaliza_triagem$$

CREATE PROCEDURE sp_finaliza_triagem(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_classificacao_manchester ENUM('VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
    IN p_layout VARCHAR(50) -- painel médico
)
BEGIN
    -- Atualiza FFA com status e classificação
    UPDATE ffa
    SET status = 'AGUARDANDO_CHAMADA_MEDICO',
        layout = p_layout,
        classificacao_manchester = p_classificacao_manchester,
        id_usuario_alteracao = p_id_usuario,
        atualizado_em = NOW()
    WHERE id = p_id_ffa;

    -- Auditoria
    INSERT INTO auditoria_ffa (
        id_ffa,
        id_usuario,
        acao,
        timestamp
    ) VALUES (
        p_id_ffa,
        p_id_usuario,
        CONCAT('FINALIZA TRIAGEM com classificação ', p_classificacao_manchester),
        NOW()
    );
END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_atualiza_status_clinico$$

CREATE PROCEDURE sp_atualiza_status_clinico(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_novo_status ENUM(
        'CHAMANDO_MEDICO','EM_ATENDIMENTO_MEDICO','OBSERVACAO',
        'MEDICACAO','AGUARDANDO_MEDICACAO',
        'AGUARDANDO_RX','EM_RX',
        'AGUARDANDO_COLETA','EM_COLETA',
        'AGUARDANDO_ECG','EM_ECG',
        'ALTA','TRANSFERENCIA','INTERNACAO',
        'FINALIZADO','AGUARDANDO_RETORNO','EMERGENCIA'
    ),
    IN p_layout VARCHAR(50)
)
BEGIN
    -- Atualiza status, layout e usuário
    UPDATE ffa
    SET status = p_novo_status,
        layout = p_layout,
        id_usuario_alteracao = p_id_usuario,
        atualizado_em = NOW()
    WHERE id = p_id_ffa;

    -- Auditoria
    INSERT INTO auditoria_ffa (
        id_ffa,
        id_usuario,
        acao,
        timestamp
    ) VALUES (
        p_id_ffa,
        p_id_usuario,
        CONCAT('ATUALIZA STATUS para ', p_novo_status),
        NOW()
    );
END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_fluxo_procedimentos$$

CREATE PROCEDURE sp_fluxo_procedimentos(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_procedimento ENUM('MEDICACAO','RX','COLETA','ECG'),
    IN p_layout_padrao VARCHAR(50) -- layout do painel para este procedimento
)
BEGIN
    DECLARE v_status_aguardando VARCHAR(50);
    DECLARE v_status_em VARCHAR(50);

    -- Define status de acordo com o procedimento
    IF p_procedimento = 'MEDICACAO' THEN
        SET v_status_aguardando = 'AGUARDANDO_MEDICACAO';
        SET v_status_em = 'MEDICACAO';
    ELSEIF p_procedimento = 'RX' THEN
        SET v_status_aguardando = 'AGUARDANDO_RX';
        SET v_status_em = 'EM_RX';
    ELSEIF p_procedimento = 'COLETA' THEN
        SET v_status_aguardando = 'AGUARDANDO_COLETA';
        SET v_status_em = 'EM_COLETA';
    ELSEIF p_procedimento = 'ECG' THEN
        SET v_status_aguardando = 'AGUARDANDO_ECG';
        SET v_status_em = 'EM_ECG';
    END IF;

    -- Atualiza FFA para status aguardando procedimento
    UPDATE ffa
    SET status = v_status_aguardando,
        layout = p_layout_padrao,
        id_usuario_alteracao = p_id_usuario,
        atualizado_em = NOW()
    WHERE id = p_id_ffa;

    -- Auditoria: aguardando procedimento
    INSERT INTO auditoria_ffa (
        id_ffa,
        id_usuario,
        acao,
        timestamp
    ) VALUES (
        p_id_ffa,
        p_id_usuario,
        CONCAT('AGUARDANDO ', p_procedimento),
        NOW()
    );

    -- Simula início do procedimento (pode ser chamado quando paciente entra no procedimento)
    UPDATE ffa
    SET status = v_status_em,
        layout = p_layout_padrao,
        id_usuario_alteracao = p_id_usuario,
        atualizado_em = NOW()
    WHERE id = p_id_ffa;

    -- Auditoria: em procedimento
    INSERT INTO auditoria_ffa (
        id_ffa,
        id_usuario,
        acao,
        timestamp
    ) VALUES (
        p_id_ffa,
        p_id_usuario,
        CONCAT('EM ', p_procedimento),
        NOW()
    );
END$$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_fluxo_procedimentos_fila$$

CREATE PROCEDURE sp_fluxo_procedimentos_fila(
    IN p_procedimento ENUM('MEDICACAO','RX','COLETA','ECG'),
    IN p_id_usuario BIGINT,
    IN p_layout_padrao VARCHAR(50)
)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_id_ffa BIGINT;
    DECLARE v_prioridade INT;
    DECLARE cur CURSOR FOR
        SELECT f.id
        FROM ffa f
        JOIN fila_senha fs ON fs.id_ffa = f.id
        WHERE f.status IN (
            CASE p_procedimento
                WHEN 'MEDICACAO' THEN 'AGUARDANDO_MEDICACAO'
                WHEN 'RX' THEN 'AGUARDANDO_RX'
                WHEN 'COLETA' THEN 'AGUARDANDO_COLETA'
                WHEN 'ECG' THEN 'AGUARDANDO_ECG'
            END
        )
        ORDER BY 
            CASE f.classificacao_manchester
                WHEN 'VERMELHO' THEN 1
                WHEN 'LARANJA' THEN 2
                WHEN 'AMARELO' THEN 3
                WHEN 'VERDE' THEN 4
                WHEN 'AZUL' THEN 5
                ELSE 6
            END,
            fs.criado_em ASC;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_id_ffa;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Atualiza status para "em procedimento"
        UPDATE ffa
        SET status = CASE p_procedimento
                        WHEN 'MEDICACAO' THEN 'MEDICACAO'
                        WHEN 'RX' THEN 'EM_RX'
                        WHEN 'COLETA' THEN 'EM_COLETA'
                        WHEN 'ECG' THEN 'EM_ECG'
                     END,
            layout = p_layout_padrao,
            id_usuario_alteracao = p_id_usuario,
            atualizado_em = NOW()
        WHERE id = v_id_ffa;

        -- Auditoria
        INSERT INTO auditoria_ffa (
            id_ffa,
            id_usuario,
            acao,
            timestamp
        ) VALUES (
            v_id_ffa,
            p_id_usuario,
            CONCAT('INICIA PROCEDIMENTO: ', p_procedimento),
            NOW()
        );

    END LOOP;

    CLOSE cur;
END$$

DELIMITER ;

CALL sp_fluxo_procedimentos_fila('MEDICACAO', 2, 'PAINEL_MEDICACAO');
CALL sp_fluxo_procedimentos_fila('RX', 2, 'PAINEL_RX');
CALL sp_fluxo_procedimentos_fila('COLETA', 2, 'PAINEL_COLETA');
CALL sp_fluxo_procedimentos_fila('ECG', 2, 'PAINEL_ECG');


DROP VIEW IF EXISTS vw_fila_pronta;

CREATE VIEW vw_fila_pronta AS
SELECT
    f.id,
    f.gpat,
    f.id_paciente,
    f.status,
    f.layout,
    f.classificacao_manchester,
    f.criado_em,
    f.atualizado_em
FROM ffa f
WHERE f.status IN (
    'AGUARDANDO_CHAMADA_MEDICO',
    'AGUARDANDO_RETORNO',
    'EMERGENCIA'
)
ORDER BY
    FIELD(
        f.classificacao_manchester,
        'VERMELHO',
        'LARANJA',
        'AMARELO',
        'VERDE',
        'AZUL'
    ),
    f.criado_em;

SELECT * FROM vw_fila_pronta;

CREATE TABLE if not exists pessoa_contato (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_pessoa BIGINT NOT NULL,
    tipo ENUM('EMAIL','TELEFONE','WHATSAPP'),
    valor VARCHAR(150),
    principal BOOLEAN DEFAULT 0,
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa)
);

CREATE TABLE if not exists acompanhante (
    id_acompanhante BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_pessoa BIGINT NOT NULL,
    id_ffa BIGINT NOT NULL,
    tipo ENUM(
        'PAI',
        'MAE',
        'RESPONSAVEL_LEGAL',
        'ACOMPANHANTE',
        'OUTRO'
    ) NOT NULL,
    observacao VARCHAR(255),
    ativo BOOLEAN DEFAULT TRUE,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa),
    FOREIGN KEY (id_ffa) REFERENCES ffa(id),

    UNIQUE KEY uk_acompanhante_por_ffa (id_pessoa, id_ffa)
);

CREATE TABLE if not exists logradouro (
    id_logradouro BIGINT AUTO_INCREMENT PRIMARY KEY,
    cep VARCHAR(9) NOT NULL,
    logradouro VARCHAR(200) NOT NULL,
    numero VARCHAR(20),
    complemento VARCHAR(100),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    uf CHAR(2),
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE if not exists pessoa_logradouro (
    id_pessoa BIGINT NOT NULL,
    id_logradouro BIGINT NOT NULL,
    principal BOOLEAN DEFAULT TRUE,
    data_inicio DATE NOT NULL,
    data_fim DATE NULL,
    ativo BOOLEAN DEFAULT TRUE,

    PRIMARY KEY (id_pessoa, id_logradouro, data_inicio),
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa),
    FOREIGN KEY (id_logradouro) REFERENCES logradouro(id_logradouro)
);

CREATE INDEX idx_pessoa_logradouro_ativo
    ON pessoa_logradouro (id_pessoa, ativo);

CREATE INDEX idx_pessoa_logradouro_principal
    ON pessoa_logradouro (id_pessoa, principal);

DELIMITER $$

CREATE TRIGGER trg_endereco_principal
BEFORE INSERT ON pessoa_logradouro
FOR EACH ROW
BEGIN
    IF NEW.principal = 1 THEN
        UPDATE pessoa_logradouro
        SET principal = 0
        WHERE id_pessoa = NEW.id_pessoa
          AND ativo = 1;
    END IF;
END$$

DELIMITER ;

CREATE TABLE if not exists evento_ffa (
    id_evento BIGINT AUTO_INCREMENT PRIMARY KEY,

    id_ffa BIGINT NOT NULL,
    id_paciente BIGINT NULL,
    id_usuario BIGINT NULL,

    origem ENUM(
        'PAINEL_TOTEM',
        'PAINEL_RECEPCAO',
        'PAINEL_TRIAGEM',
        'PAINEL_MEDICO',
        'PAINEL_PROCEDIMENTO',
        'PAINEL_SATISFACAO',
        'SISTEMA'
    ) NOT NULL,

    tipo_evento ENUM(
        -- Totem / senha
        'GERAR_SENHA',
        'IMPRIMIR_SENHA',

        -- Recepção
        'CHAMAR_SENHA',
        'CONFIRMAR_PRESENCA',
        'CRIAR_FFA',

        -- Triagem
        'INICIO_TRIAGEM',
        'FINAL_TRIAGEM',

        -- Médico
        'CHAMADA_MEDICA',
        'INICIO_ATENDIMENTO_MEDICO',
        'FINAL_ATENDIMENTO_MEDICO',

        -- Procedimentos
        'CHAMADA_PROCEDIMENTO',
        'INICIO_PROCEDIMENTO',
        'FINAL_PROCEDIMENTO',

        -- Sistema
        'STATUS_AUTOMATICO',
        'NAO_COMPARECEU',
        'TIMEOUT',

        -- Satisfação
        'AVALIACAO_ATENDIMENTO'
    ) NOT NULL,

    status_origem ENUM(
        'ABERTO','EM_TRIAGEM','AGUARDANDO_CHAMADA_MEDICO',
        'CHAMANDO_MEDICO','EM_ATENDIMENTO_MEDICO',
        'OBSERVACAO','AGUARDANDO_MEDICACAO','MEDICACAO',
        'AGUARDANDO_RX','EM_RX',
        'AGUARDANDO_COLETA','EM_COLETA',
        'AGUARDANDO_ECG','EM_ECG',
        'ALTA','TRANSFERENCIA','INTERNACAO',
        'FINALIZADO','AGUARDANDO_RETORNO','EMERGENCIA'
    ) NULL,

    status_destino ENUM(
        'ABERTO','EM_TRIAGEM','AGUARDANDO_CHAMADA_MEDICO',
        'CHAMANDO_MEDICO','EM_ATENDIMENTO_MEDICO',
        'OBSERVACAO','AGUARDANDO_MEDICACAO','MEDICACAO',
        'AGUARDANDO_RX','EM_RX',
        'AGUARDANDO_COLETA','EM_COLETA',
        'AGUARDANDO_ECG','EM_ECG',
        'ALTA','TRANSFERENCIA','INTERNACAO',
        'FINALIZADO','AGUARDANDO_RETORNO','EMERGENCIA'
    ) NULL,

    payload JSON NULL,   -- dados extras (sala, guichê, nota satisfação, etc)

    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_evento_ffa (id_ffa),
    INDEX idx_evento_tipo (tipo_evento),
    INDEX idx_evento_origem (origem)
);

CREATE TABLE if not exists fluxo_status (
    status_origem VARCHAR(50),
    status_destino VARCHAR(50),
    origem_evento VARCHAR(50),
    permitido BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (status_origem, status_destino, origem_evento)
);

INSERT INTO fluxo_status VALUES
('ABERTO','EM_TRIAGEM','PAINEL_TRIAGEM',TRUE),
('EM_TRIAGEM','AGUARDANDO_CHAMADA_MEDICO','PAINEL_TRIAGEM',TRUE),
('AGUARDANDO_CHAMADA_MEDICO','CHAMANDO_MEDICO','PAINEL_MEDICO',TRUE),
('CHAMANDO_MEDICO','EM_ATENDIMENTO_MEDICO','PAINEL_MEDICO',TRUE),
('EM_ATENDIMENTO_MEDICO','AGUARDANDO_RX','PAINEL_MEDICO',TRUE),
('AGUARDANDO_RX','EM_RX','PAINEL_PROCEDIMENTO',TRUE),
('EM_RX','AGUARDANDO_CHAMADA_MEDICO','PAINEL_PROCEDIMENTO',TRUE);


DELIMITER $$

CREATE PROCEDURE sp_transicao_status (
    IN p_id_ffa BIGINT,
    IN p_status_destino VARCHAR(50),
    IN p_origem VARCHAR(50),
    IN p_tipo_evento VARCHAR(50),
    IN p_layout VARCHAR(50),
    IN p_id_usuario BIGINT,
    IN p_payload JSON
)
BEGIN
    DECLARE v_status_atual VARCHAR(50);
    DECLARE v_permitido INT DEFAULT 0;

    -- 1️⃣ Status atual
    SELECT status INTO v_status_atual
    FROM ffa
    WHERE id = p_id_ffa
    FOR UPDATE;

    -- 2️⃣ Valida transição
    SELECT COUNT(*) INTO v_permitido
    FROM fluxo_status
    WHERE status_origem = v_status_atual
      AND status_destino = p_status_destino
      AND origem_evento = p_origem
      AND permitido = TRUE;

    IF v_permitido = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transição de status não permitida';
    END IF;

    -- 3️⃣ Atualiza FFA
    UPDATE ffa
    SET status = p_status_destino,
        layout = p_layout,
        id_usuario_alteracao = p_id_usuario,
        atualizado_em = NOW()
    WHERE id = p_id_ffa;

    -- 4️⃣ Registra evento
    INSERT INTO evento_ffa (
        id_ffa,
        id_usuario,
        origem,
        tipo_evento,
        status_origem,
        status_destino,
        payload
    ) VALUES (
        p_id_ffa,
        p_id_usuario,
        p_origem,
        p_tipo_evento,
        v_status_atual,
        p_status_destino,
        p_payload
    );

END$$
DELIMITER ;

CREATE TABLE if not exists regra_timeout (
    status VARCHAR(50),
    minutos INT,
    evento_timeout VARCHAR(50)
);


CALL sp_transicao_status(
    4,
    'CHAMANDO_MEDICO',
    'PAINEL_MEDICO',
    'CHAMADA_MEDICA',
    'SALA_2',
    10,
    JSON_OBJECT('sala','SALA_2')
);

SELECT id, status, layout
FROM ffa
WHERE id = 4;


INSERT INTO fluxo_status (
    status_origem,
    status_destino,
    origem_evento,
    permitido
) VALUES (
    'AGUARDANDO_CHAMADA_MEDICO',
    'CHAMANDO_MEDICO',
    'PAINEL_MEDICO',
    TRUE
);

CALL sp_transicao_status(
    4,
    'AGUARDANDO_RX',
    'PAINEL_MEDICO',
    'SOLICITACAO_RX',
    'RX',
    10,
    JSON_OBJECT('origem','MEDICO')
);

CALL sp_transicao_status(
    4,
    'ALTA',
    'PAINEL_MEDICO',
    'ALTA_MEDICA',
    'FINAL',
    10,
    NULL
);


INSERT INTO fluxo_status (
    status_origem,
    status_destino,
    origem_evento,
    permitido
) VALUES (
    'EM_ATENDIMENTO_MEDICO',
    'ALTA',
    'PAINEL_MEDICO',
    TRUE
);

CALL sp_transicao_status(
    4,
    'ALTA',
    'PAINEL_MEDICO',
    'ALTA_MEDICA',
    'FINAL',
    10,
    NULL
);

ALTER TABLE auditoria_ffa 
MODIFY COLUMN tipo_evento ENUM(
  'CRIACAO',
  'STATUS',
  'LAYOUT',
  'CHAMADA_MEDICA',
  'SOLICITACAO_RX',
  'SOLICITACAO_MEDICACAO',
  'ALTA_MEDICA',
  'TRANSFERENCIA',
  'INTERNACAO'
) NOT NULL;

ALTER TABLE auditoria_ffa
ADD COLUMN tipo_evento ENUM(
  'CRIACAO',
  'STATUS',
  'LAYOUT',
  'CHAMADA_MEDICA',
  'SOLICITACAO_RX',
  'SOLICITACAO_MEDICACAO',
  'ALTA_MEDICA',
  'TRANSFERENCIA',
  'INTERNACAO'
) NOT NULL AFTER id_usuario;

DELIMITER $$

CREATE PROCEDURE sp_registra_evento_rx (
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    INSERT INTO auditoria_ffa (
        id_ffa,
        id_usuario,
        tipo_evento,
        acao,
        timestamp
    ) VALUES (
        p_id_ffa,
        p_id_usuario,
        'SOLICITACAO_RX',
        'Paciente encaminhado para RX',
        NOW()
    );
END$$

DELIMITER ;

CALL sp_registra_evento_rx(4, 10);

CREATE TABLE if not exists status_timeout (
    status ENUM(
        'AGUARDANDO_CHAMADA_MEDICO',
        'CHAMANDO_MEDICO',
        'AGUARDANDO_RX',
        'CHAMANDO_RX'
    ) PRIMARY KEY,
    tempo_max_segundos INT NOT NULL,
    status_fallback ENUM(
        'AGUARDANDO_CHAMADA_MEDICO',
        'AGUARDANDO_RX'
    ) NOT NULL
);


CREATE TABLE IF NOT EXISTS status_timeout (
    status ENUM(
        'AGUARDANDO_CHAMADA_MEDICO',
        'CHAMANDO_MEDICO',
        'AGUARDANDO_RX',
        'CHAMANDO_RX',
        'AGUARDANDO_MEDICACAO',
        'EM_MEDICACAO'
    ) PRIMARY KEY,

    tempo_max_segundos INT NOT NULL,
    status_fallback ENUM(
        'AGUARDANDO_CHAMADA_MEDICO',
        'AGUARDANDO_RX',
        'AGUARDANDO_MEDICACAO'
    ) NOT NULL,

    ativo BOOLEAN DEFAULT TRUE
);
INSERT INTO status_timeout (status, tempo_max_segundos, status_fallback) VALUES
('CHAMANDO_MEDICO',     60,  'AGUARDANDO_CHAMADA_MEDICO'),
('CHAMANDO_RX',         90,  'AGUARDANDO_RX'),
('EM_MEDICACAO',      1800,  'AGUARDANDO_MEDICACAO');


DELIMITER $$

CREATE PROCEDURE sp_verifica_timeouts()
BEGIN
    DECLARE v_id_ffa BIGINT;
    DECLARE v_status_atual VARCHAR(50);
    DECLARE v_status_fallback VARCHAR(50);
    DECLARE v_tempo_max INT;
    DECLARE v_ultimo_evento DATETIME;
    DECLARE done INT DEFAULT 0;

    DECLARE cur CURSOR FOR
        SELECT 
            f.id,
            f.status,
            st.status_fallback,
            st.tempo_max_segundos,
            MAX(a.timestamp) AS ultimo_evento
        FROM ffa f
        JOIN status_timeout st ON st.status = f.status AND st.ativo = TRUE
        JOIN auditoria_ffa a ON a.id_ffa = f.id
        WHERE f.status NOT IN ('ALTA','TRANSFERENCIA','INTERNACAO')
        GROUP BY f.id, f.status, st.status_fallback, st.tempo_max_segundos;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_id_ffa, v_status_atual, v_status_fallback, v_tempo_max, v_ultimo_evento;
        IF done = 1 THEN
            LEAVE read_loop;
        END IF;

        IF TIMESTAMPDIFF(SECOND, v_ultimo_evento, NOW()) > v_tempo_max THEN
            CALL sp_transicao_status(
                v_id_ffa,
                v_status_fallback,
                'SISTEMA',
                'TIMEOUT',
                NULL,
                NULL,
                JSON_OBJECT('status_origem', v_status_atual)
            );
        END IF;
    END LOOP;

    CLOSE cur;
END$$

DELIMITER ;

CREATE OR REPLACE VIEW vw_proxima_chamada_medico AS
SELECT 
    f.id AS id_ffa,
    f.classificacao_manchester,
    f.criado_em
FROM ffa f
WHERE f.status = 'AGUARDANDO_CHAMADA_MEDICO'
ORDER BY
    FIELD(f.classificacao_manchester,'VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
    f.criado_em
LIMIT 1;


DELIMITER $$

CREATE PROCEDURE sp_chamada_automatica_medico()
BEGIN
    DECLARE v_id_ffa BIGINT;

    SELECT id_ffa INTO v_id_ffa
    FROM vw_proxima_chamada_medico
    LIMIT 1;

    IF v_id_ffa IS NOT NULL THEN
        CALL sp_transicao_status(
            v_id_ffa,
            'CHAMANDO_MEDICO',
            'SISTEMA',
            'CHAMADA_MEDICA',
            'SALA_AUTO',
            NULL,
            JSON_OBJECT('automatica', true)
        );
    END IF;
END$$

DELIMITER ;
SHOW CREATE VIEW vw_painel_alta_transferencia;


DROP VIEW IF EXISTS vw_painel_alta_transferencia;

DROP VIEW IF EXISTS vw_painel_alta_transferencia;

CREATE VIEW vw_painel_alta_transferencia AS
SELECT
    f.id                    AS id_ffa,
    p.nome_completo         AS paciente,
    f.status,
    f.layout,
    f.classificacao_manchester,
    f.atualizado_em
FROM ffa f
JOIN pessoa p ON p.id_pessoa = f.id_paciente
WHERE f.status IN ('ALTA_MEDICA', 'TRANSFERENCIA');
SHOW CREATE VIEW vw_painel_atendimento;


SELECT * FROM vw_painel_alta_transferencia;

DROP VIEW IF EXISTS vw_painel_atendimento;


CREATE DEFINER = CURRENT_USER
SQL SECURITY DEFINER
VIEW vw_painel_atendimento AS
SELECT
    f.id                      AS id_ffa,
    f.gpat                    AS gpat,
    p.id_pessoa               AS id_pessoa,
    p.nome_completo            AS paciente,
    f.status                  AS status,
    f.layout                  AS layout,
    f.classificacao_manchester,
    f.atualizado_em
FROM ffa f
INNER JOIN pessoa p 
    ON p.id_pessoa = f.id_paciente
WHERE f.status IN (
    -- Fila / atendimento médico
    'AGUARDANDO_CHAMADA_MEDICO',
    'CHAMANDO_MEDICO',
    'EM_ATENDIMENTO_MEDICO',

    -- Permanência assistida
    'OBSERVACAO',
    'MEDICACAO',
    'AGUARDANDO_MEDICACAO',

    -- Exames e procedimentos
    'AGUARDANDO_RX',
    'EM_RX',
    'AGUARDANDO_COLETA',
    'EM_COLETA',
    'AGUARDANDO_ECG',
    'EM_ECG'
);

DROP VIEW IF EXISTS vw_painel_clinico;

CREATE DEFINER = CURRENT_USER
SQL SECURITY DEFINER
VIEW vw_painel_clinico AS
SELECT
    f.id                      AS id_ffa,
    f.gpat                    AS gpat,
    p.id_pessoa               AS id_pessoa,
    p.nome_completo            AS paciente,
    f.status                  AS status,
    f.layout                  AS layout,
    f.classificacao_manchester,
    f.atualizado_em
FROM ffa f
INNER JOIN pessoa p 
    ON p.id_pessoa = f.id_paciente
WHERE f.status IN (
    -- Recepção / triagem
    'ABERTO',
    'EM_TRIAGEM',

    -- Fila médica
    'AGUARDANDO_CHAMADA_MEDICO',
    'CHAMANDO_MEDICO',
    'EM_ATENDIMENTO_MEDICO',

    -- Permanência clínica
    'OBSERVACAO',
    'MEDICACAO',
    'AGUARDANDO_MEDICACAO',

    -- Exames / procedimentos
    'AGUARDANDO_RX',
    'EM_RX',
    'AGUARDANDO_COLETA',
    'EM_COLETA',
    'AGUARDANDO_ECG',
    'EM_ECG'
);
SELECT * FROM vw_painel_clinico;

SHOW FULL TABLES
WHERE Table_type = 'VIEW';

DROP VIEW IF EXISTS
    vw_painel_alta_transferencia,
    vw_painel_atendimento,
    vw_painel_chamada,
    vw_painel_clinico,
    vw_painel_clinico_completo,
    vw_painel_internacao,
    vw_painel_medico,
    vw_painel_procedimentos,
    vw_painel_recepcao,
    vw_painel_totem,
    vw_painel_triagem,
    vw_fila_atendimento,
    vw_fila_atual,
    vw_fila_pronta,
    vw_fila_recepcao,
    vw_fila_totem,
    vw_fila_triagem,
    vw_proxima_chamada_medico;
    
  CREATE VIEW vw_ffa_core AS
SELECT
    f.id                  AS id_ffa,
    f.gpat,
    f.id_paciente,
    p.nome_completo        AS paciente,
    f.status,
    f.layout,
    f.classificacao_manchester,
    f.atualizado_em,
    f.criado_em
FROM ffa f
JOIN pessoa p ON p.id_pessoa = f.id_paciente;

CREATE VIEW vw_fila_core AS
SELECT
    fs.id,
    fs.id_ffa,
    fs.senha,
    fs.prioridade_recepcao,
    fs.prioridade_temporaria,
    fs.criado_em
FROM fila_senha fs;

CREATE VIEW vw_painel_recepcao AS
SELECT
    c.id_ffa,
    c.gpat,
    c.paciente,
    c.status,
    f.senha,
    f.prioridade_recepcao,
    f.criado_em AS hora_chegada
FROM vw_ffa_core c
LEFT JOIN vw_fila_core f ON f.id_ffa = c.id_ffa
WHERE c.status IN ('ABERTO','EM_TRIAGEM');

CREATE VIEW vw_painel_totem AS
SELECT
    id,
    senha,
    prioridade_temporaria,
    criado_em
FROM vw_fila_core
WHERE id_ffa IS NULL;

CREATE VIEW vw_painel_triagem AS
SELECT
    id_ffa,
    gpat,
    paciente,
    status,
    classificacao_manchester
FROM vw_ffa_core
WHERE status IN ('EM_TRIAGEM');

CREATE VIEW vw_painel_medico AS
SELECT
    id_ffa,
    gpat,
    paciente,
    status,
    classificacao_manchester
FROM vw_ffa_core
WHERE status IN (
    'AGUARDANDO_CHAMADA_MEDICO',
    'CHAMANDO_MEDICO',
    'EM_ATENDIMENTO_MEDICO',
    'OBSERVACAO'
);

CREATE VIEW vw_painel_medicacao AS
SELECT
    id_ffa,
    gpat,
    paciente,
    status
FROM vw_ffa_core
WHERE status IN ('AGUARDANDO_MEDICACAO','MEDICACAO');

CREATE VIEW vw_painel_rx AS
SELECT
    id_ffa,
    gpat,
    paciente,
    status
FROM vw_ffa_core
WHERE status IN ('AGUARDANDO_RX','EM_RX');

CREATE VIEW vw_painel_ecg AS
SELECT
    id_ffa,
    gpat,
    paciente,
    status
FROM vw_ffa_core
WHERE status IN ('AGUARDANDO_ECG','EM_ECG');

CREATE VIEW vw_painel_alta_transferencia AS
SELECT
    id_ffa,
    gpat,
    paciente,
    status,
    atualizado_em
FROM vw_ffa_core
WHERE status IN ('ALTA','TRANSFERENCIA','INTERNACAO');

CREATE VIEW vw_painel_clinico_completo AS
SELECT
    c.id_ffa,
    c.gpat,
    c.paciente,
    c.status,
    c.classificacao_manchester,
    f.senha,
    f.prioridade_recepcao,
    f.criado_em AS hora_chegada
FROM vw_ffa_core c
LEFT JOIN vw_fila_core f ON f.id_ffa = c.id_ffa
WHERE c.status NOT IN ('FINALIZADO')
ORDER BY
    FIELD(c.classificacao_manchester,'VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
    f.criado_em;

CREATE TABLE if not exists prioridade_social (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(30) UNIQUE NOT NULL,
    descricao VARCHAR(100) NOT NULL,
    peso INT NOT NULL,
    ativo TINYINT(1) DEFAULT 1
);

INSERT INTO prioridade_social (codigo, descricao, peso) VALUES
('IDOSO', 'Paciente idoso', 20),
('AUTISTA', 'Paciente com TEA', 25),
('PCD', 'Pessoa com deficiência', 20),
('GESTANTE', 'Gestante', 15),
('CRIANCACOLO', 'Criança de colo', 15);

CREATE TABLE if not exists ffa_prioridade (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_ffa BIGINT NOT NULL,
    codigo_prioridade VARCHAR(30) NOT NULL,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    ativo TINYINT(1) DEFAULT 1
);

DELIMITER $$

CREATE FUNCTION fn_score_prioridade_social(p_id_ffa BIGINT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_score INT;

    SELECT COALESCE(SUM(ps.peso), 0)
    INTO v_score
    FROM ffa_prioridade fp
    JOIN prioridade_social ps ON ps.codigo = fp.codigo_prioridade
    WHERE fp.id_ffa = p_id_ffa
      AND fp.ativo = 1
      AND ps.ativo = 1;


    RETURN v_score;
END$$

DELIMITER ;

drop view  vw_fila_atendimento_v2;

CREATE OR REPLACE VIEW vw_fila_atendimento_v2 AS
SELECT
    f.id,
    f.gpat,
    f.id_paciente,
    f.status,
    f.layout,
    f.classificacao_manchester,
    f.criado_em,
    fn_score_prioridade_social(f.id) AS prioridade_score
FROM ffa f
WHERE f.status = 'AGUARDANDO_CHAMADA_MEDICO'
ORDER BY
    FIELD(
        f.classificacao_manchester,
        'VERMELHO','LARANJA','AMARELO','VERDE','AZUL'
    ),
    prioridade_score DESC,
    f.criado_em;

SELECT *
FROM vw_fila_atendimento_v2
ORDER BY
  FIELD(classificacao_manchester,'VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
  prioridade_score DESC,
  criado_em;

ALTER TABLE ffa
ADD COLUMN linha_assistencial ENUM(
    'CLINICA',
    'PEDIATRICA'
) NOT NULL DEFAULT 'CLINICA';

DELIMITER $$

CREATE FUNCTION fn_idade_em_anos(p_data_nascimento DATE)
RETURNS INT
DETERMINISTIC
RETURN TIMESTAMPDIFF(YEAR, p_data_nascimento, CURDATE());

DELIMITER ;

DELIMITER $$

CREATE FUNCTION fn_linha_assistencial(p_data_nascimento DATE)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE idade INT;

    SET idade = TIMESTAMPDIFF(YEAR, p_data_nascimento, CURDATE());

    IF idade < 12 THEN
        RETURN 'PEDIATRICA';
    END IF;

    RETURN 'CLINICA';
END$$

DELIMITER ;

drop procedure sp_definir_linha_assistencial_ffa;
DELIMITER $$

CREATE PROCEDURE sp_definir_linha_assistencial_ffa (
    IN p_id_ffa BIGINT
)
BEGIN
    DECLARE v_data_nascimento DATE;
    DECLARE v_linha VARCHAR(20);

    -- Busca data de nascimento do paciente da FFA
    SELECT p.data_nascimento
      INTO v_data_nascimento
      FROM ffa f
      JOIN pessoa p ON p.id_pessoa = f.id_paciente
     WHERE f.id = p_id_ffa;

    -- Define linha assistencial
    SET v_linha = fn_linha_assistencial(v_data_nascimento);

    -- Atualiza FFA
    UPDATE ffa
       SET linha_assistencial = v_linha,
           layout = CASE
               WHEN v_linha = 'PEDIATRICA' THEN 'PAINEL_PEDIATRICO'
               ELSE 'PAINEL_CLINICO'
           END
     WHERE id = p_id_ffa;
END$$

DELIMITER ;
CALL sp_definir_linha_assistencial_ffa(4);
SELECT id, linha_assistencial, layout FROM ffa WHERE id = 4;


CREATE OR REPLACE VIEW vw_prioridade_ffa AS
SELECT
    f.id AS id_ffa,

    (
      CASE f.classificacao_manchester
        WHEN 'VERMELHO' THEN 100
        WHEN 'LARANJA'  THEN 80
        WHEN 'AMARELO'  THEN 60
        WHEN 'VERDE'    THEN 40
        WHEN 'AZUL'     THEN 20
        ELSE 10
      END
    +
      IF(fs.prioridade_recepcao = 'IDOSO', 10, 0)
    +
      IF(fs.prioridade_recepcao = 'PCD', 15, 0)
    +
      IF(fs.prioridade_recepcao = 'CRIANCA_COLO', 10, 0)
    ) AS prioridade_score

FROM ffa f
LEFT JOIN fila_senha fs ON fs.id_ffa = f.id;


CREATE OR REPLACE VIEW vw_fila_atendimento AS
SELECT
    f.id,
    f.gpat,
    p.nome_completo,
    f.status,
    f.layout,
    f.classificacao_manchester,
    pr.prioridade_score,
    f.criado_em
FROM ffa f
JOIN pessoa p ON p.id_pessoa = f.id_paciente
JOIN vw_prioridade_ffa pr ON pr.id_ffa = f.id
WHERE f.status = 'AGUARDANDO_CHAMADA_MEDICO'

ORDER BY
    pr.prioridade_score DESC,
    f.criado_em ASC;


CREATE OR REPLACE VIEW vw_fila_totem AS
SELECT
    fs.id AS id_fila,
    fs.senha,
    fs.id_paciente,
    p.nome_completo AS paciente_nome,
    fs.prioridade_recepcao,
    fs.criado_em AS hora_chegada
FROM fila_senha fs
JOIN pessoa p ON p.id_pessoa = fs.id_paciente
WHERE fs.id_ffa IS NULL
ORDER BY
    CASE fs.prioridade_recepcao
        WHEN 'IDOSO' THEN 3
        WHEN 'CRIANCA' THEN 2
        WHEN 'ESPECIAL' THEN 1
        ELSE 0
    END DESC,
    fs.criado_em ASC;

CREATE OR REPLACE VIEW vw_painel_recepcao AS
SELECT
    f.id AS id_ffa,
    f.gpat,
    f.id_paciente,
    p.nome_completo AS paciente_nome,
    fs.senha,
    fs.prioridade_recepcao,
    f.status,
    f.layout,
    fs.criado_em AS hora_chegada
FROM ffa f
JOIN pessoa p ON p.id_pessoa = f.id_paciente
LEFT JOIN fila_senha fs ON fs.id_ffa = f.id
WHERE f.status IN ('ABERTO','EM_TRIAGEM','AGUARDANDO_CHAMADA_MEDICO')
ORDER BY
    CASE fs.prioridade_recepcao
        WHEN 'IDOSO' THEN 3
        WHEN 'CRIANCA' THEN 2
        WHEN 'ESPECIAL' THEN 1
        ELSE 0
    END DESC,
    fs.criado_em ASC;


CREATE OR REPLACE VIEW vw_painel_clinico AS
SELECT
    f.id AS id_ffa,
    f.gpat,
    f.id_paciente,
    f.status,
    f.layout,
    p.nome_completo AS paciente_nome,
    f.classificacao_manchester,
    fs.criado_em AS hora_chegada,
    fs.prioridade_recepcao
FROM ffa f
JOIN pessoa p ON p.id_pessoa = f.id_paciente
LEFT JOIN fila_senha fs ON fs.id_ffa = f.id
WHERE f.status IN ('ABERTO','EM_TRIAGEM','EM_ATENDIMENTO','OBSERVACAO')
ORDER BY
    FIELD(f.classificacao_manchester,'VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
    CASE fs.prioridade_recepcao
        WHEN 'IDOSO' THEN 3
        WHEN 'CRIANCA' THEN 2
        WHEN 'ESPECIAL' THEN 1
        ELSE 0
    END DESC,
    fs.criado_em ASC;


CREATE OR REPLACE VIEW vw_painel_clinico_completo AS
SELECT
    f.id AS id_ffa,
    f.gpat,
    f.id_paciente,
    f.status,
    f.layout,
    p.nome_completo AS paciente_nome,
    f.classificacao_manchester,
    fs.criado_em AS hora_chegada,
    fs.prioridade_recepcao
FROM ffa f
JOIN pessoa p ON p.id_pessoa = f.id_paciente
LEFT JOIN fila_senha fs ON fs.id_ffa = f.id
ORDER BY
    FIELD(f.classificacao_manchester,'VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
    CASE fs.prioridade_recepcao
        WHEN 'IDOSO' THEN 3
        WHEN 'CRIANCA' THEN 2
        WHEN 'ESPECIAL' THEN 1
        ELSE 0
    END DESC,
    fs.criado_em ASC;


CREATE OR REPLACE VIEW vw_fila_totem AS
SELECT
    fs.id AS id_fila,
    fs.senha,
    fs.id_paciente,
    p.nome_completo AS paciente_nome,
    fs.prioridade_recepcao,
    fs.criado_em AS hora_chegada
FROM fila_senha fs
JOIN pessoa p ON p.id_pessoa = fs.id_paciente
WHERE fs.id_ffa IS NULL
ORDER BY
    CASE fs.prioridade_recepcao
        WHEN 'IDOSO' THEN 3
        WHEN 'CRIANCA' THEN 2
        WHEN 'ESPECIAL' THEN 1
        ELSE 0
    END DESC,
    fs.criado_em ASC;
    
    CREATE OR REPLACE VIEW vw_painel_recepcao AS
SELECT
    f.id AS id_ffa,
    f.gpat,
    f.id_paciente,
    p.nome_completo AS paciente_nome,
    fs.senha,
    fs.prioridade_recepcao,
    f.status,
    f.layout,
    fs.criado_em AS hora_chegada
FROM ffa f
JOIN pessoa p ON p.id_pessoa = f.id_paciente
LEFT JOIN fila_senha fs ON fs.id_ffa = f.id
WHERE f.status IN ('ABERTO','EM_TRIAGEM','AGUARDANDO_CHAMADA_MEDICO')
ORDER BY
    CASE fs.prioridade_recepcao
        WHEN 'IDOSO' THEN 3
        WHEN 'CRIANCA' THEN 2
        WHEN 'ESPECIAL' THEN 1
        ELSE 0
    END DESC,
    fs.criado_em ASC;

CREATE OR REPLACE VIEW vw_painel_clinico AS
SELECT
    f.id AS id_ffa,
    f.gpat,
    f.id_paciente,
    f.status,
    f.layout,
    p.nome_completo AS paciente_nome,
    f.classificacao_manchester,
    fs.prioridade_recepcao,
    fs.criado_em AS hora_chegada
FROM ffa f
JOIN pessoa p ON p.id_pessoa = f.id_paciente
LEFT JOIN fila_senha fs ON fs.id_ffa = f.id
WHERE f.status IN ('ABERTO','EM_TRIAGEM','EM_ATENDIMENTO','OBSERVACAO')
ORDER BY
    FIELD(f.classificacao_manchester,'VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
    CASE fs.prioridade_recepcao
        WHEN 'IDOSO' THEN 3
        WHEN 'CRIANCA' THEN 2
        WHEN 'ESPECIAL' THEN 1
        ELSE 0
    END DESC,
    fs.criado_em ASC;

CREATE OR REPLACE VIEW vw_painel_clinico_completo AS
SELECT
    f.id AS id_ffa,
    f.gpat,
    f.id_paciente,
    f.status,
    f.layout,
    p.nome_completo AS paciente_nome,
    f.classificacao_manchester,
    fs.prioridade_recepcao,
    fs.criado_em AS hora_chegada
FROM ffa f
JOIN pessoa p ON p.id_pessoa = f.id_paciente
LEFT JOIN fila_senha fs ON fs.id_ffa = f.id
ORDER BY
    FIELD(f.classificacao_manchester,'VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
    CASE fs.prioridade_recepcao
        WHEN 'IDOSO' THEN 3
        WHEN 'CRIANCA' THEN 2
        WHEN 'ESPECIAL' THEN 1
        ELSE 0
    END DESC,
    fs.criado_em ASC;

CREATE OR REPLACE VIEW vw_painel_alta_transferencia AS
SELECT
    f.id AS id_ffa,
    f.gpat,
    f.id_paciente,
    p.nome_completo AS paciente,
    f.status,
    f.layout,
    f.classificacao_manchester,
    fs.prioridade_recepcao,
    fs.criado_em AS hora_chegada
FROM ffa f
JOIN pessoa p ON p.id_pessoa = f.id_paciente
LEFT JOIN fila_senha fs ON fs.id_ffa = f.id
WHERE f.status IN ('ALTA','TRANSFERENCIA')
ORDER BY
    FIELD(f.classificacao_manchester,'VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
    CASE fs.prioridade_recepcao
        WHEN 'IDOSO' THEN 3
        WHEN 'CRIANCA' THEN 2
        WHEN 'ESPECIAL' THEN 1
        ELSE 0
    END DESC,
    fs.criado_em ASC;
    
CREATE OR REPLACE VIEW vw_painel_atendimento AS
SELECT
    f.id AS id_ffa,
    f.gpat,
    f.id_paciente,
    p.nome_completo AS paciente_nome,
    f.status,
    f.layout,
    f.classificacao_manchester,
    fs.prioridade_recepcao,
    fs.criado_em AS hora_chegada
FROM ffa f
JOIN pessoa p ON p.id_pessoa = f.id_paciente
LEFT JOIN fila_senha fs ON fs.id_ffa = f.id
WHERE f.status NOT IN ('FINALIZADO','ALTA','TRANSFERENCIA')
ORDER BY
    FIELD(f.classificacao_manchester,'VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
    CASE fs.prioridade_recepcao
        WHEN 'IDOSO' THEN 3
        WHEN 'CRIANCA' THEN 2
        WHEN 'ESPECIAL' THEN 1
        ELSE 0
    END DESC,
    fs.criado_em ASC;
    

CREATE OR REPLACE VIEW vw_painel_atendimento AS
SELECT
    f.id AS id_ffa,
    f.gpat,
    f.id_paciente,
    p.nome_completo AS paciente_nome,
    f.status,
    f.layout,
    f.classificacao_manchester,
    fs.prioridade_recepcao,
    fs.criado_em AS hora_chegada
FROM ffa f
JOIN pessoa p ON p.id_pessoa = f.id_paciente
LEFT JOIN fila_senha fs ON fs.id_ffa = f.id
WHERE f.status NOT IN ('FINALIZADO','ALTA','TRANSFERENCIA')
ORDER BY
    FIELD(f.classificacao_manchester,'VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
    CASE fs.prioridade_recepcao
        WHEN 'IDOSO' THEN 3
        WHEN 'CRIANCA' THEN 2
        WHEN 'ESPECIAL' THEN 1
        ELSE 0
    END DESC,
    fs.criado_em ASC;

CREATE OR REPLACE VIEW vw_painel_medico AS
SELECT
    f.id AS id_ffa,
    f.gpat,
    f.id_paciente,
    p.nome_completo AS paciente_nome,
    f.status,
    f.layout,
    f.classificacao_manchester,
    fs.prioridade_recepcao,
    fs.criado_em AS hora_chegada
FROM ffa f
JOIN pessoa p ON p.id_pessoa = f.id_paciente
LEFT JOIN fila_senha fs ON fs.id_ffa = f.id
WHERE f.status IN ('CHAMANDO_MEDICO','EM_ATENDIMENTO_MEDICO','OBSERVACAO')
ORDER BY
    FIELD(f.classificacao_manchester,'VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
    CASE fs.prioridade_recepcao
        WHEN 'IDOSO' THEN 3
        WHEN 'CRIANCA' THEN 2
        WHEN 'ESPECIAL' THEN 1
        ELSE 0
    END DESC,
    fs.criado_em ASC;

CREATE OR REPLACE VIEW vw_painel_procedimentos AS
SELECT
    f.id AS id_ffa,
    f.gpat,
    f.id_paciente,
    p.nome_completo AS paciente_nome,
    f.status,
    f.layout,
    f.classificacao_manchester,
    fs.prioridade_recepcao,
    fs.criado_em AS hora_chegada
FROM ffa f
JOIN pessoa p ON p.id_pessoa = f.id_paciente
LEFT JOIN fila_senha fs ON fs.id_ffa = f.id
WHERE f.status IN ('AGUARDANDO_MEDICACAO','MEDICACAO','AGUARDANDO_RX','EM_RX','AGUARDANDO_COLETA','EM_COLETA','AGUARDANDO_ECG','EM_ECG')
ORDER BY
    FIELD(f.classificacao_manchester,'VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
    CASE fs.prioridade_recepcao
        WHEN 'IDOSO' THEN 3
        WHEN 'CRIANCA' THEN 2
        WHEN 'ESPECIAL' THEN 1
        ELSE 0
    END DESC,
    fs.criado_em ASC;

CREATE OR REPLACE VIEW vw_painel_totem AS
SELECT
    fs.id AS id_fila,
    fs.senha,
    fs.id_paciente,
    p.nome_completo AS paciente_nome,
    fs.prioridade_recepcao,
    fs.criado_em AS hora_chegada
FROM fila_senha fs
JOIN pessoa p ON p.id_pessoa = fs.id_paciente
WHERE fs.id_ffa IS NULL
ORDER BY
    CASE fs.prioridade_recepcao
        WHEN 'IDOSO' THEN 3
        WHEN 'CRIANCA' THEN 2
        WHEN 'ESPECIAL' THEN 1
        ELSE 0
    END DESC,
    fs.criado_em ASC;

CREATE TABLE IF NOT EXISTS plantao (
    id_plantao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_usuario BIGINT NOT NULL,       -- médico ou profissional de saúde
    data_inicio DATETIME NOT NULL,
    data_fim DATETIME NOT NULL,
    tipo_plantao ENUM('DIURNO','NOTURNO') NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

drop table medicos;
-- Médicos
CREATE TABLE IF NOT EXISTS medicos (
    id_medico BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_usuario BIGINT NOT NULL, -- vincula ao usuário do HIS
    nome VARCHAR(150) NOT NULL,
    crm VARCHAR(20) UNIQUE,
    id_especialidade INT,
    ativo BOOLEAN DEFAULT TRUE,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_especialidade) REFERENCES especialidade(id_especialidade)
);

drop table plantoes;
-- Plantões
CREATE TABLE IF NOT EXISTS plantoes (
    id_plantao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_medico BIGINT NOT NULL,
    data DATE NOT NULL,
    turno ENUM('DIA','NOITE','24H','CUSTOM') NOT NULL,
    hora_inicio TIME DEFAULT NULL,
    hora_fim TIME DEFAULT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_medico) REFERENCES medicos(id_medico)
);


CREATE OR REPLACE VIEW vw_medicos_plantao AS
SELECT
    m.id_medico,
    m.nome,
    m.crm,
    m.id_especialidade,
    p.data,
    p.turno,
    COALESCE(p.hora_inicio, CASE p.turno
        WHEN 'DIA' THEN '07:00:00'
        WHEN 'NOITE' THEN '19:00:00'
        WHEN '24H' THEN '00:00:00'
        ELSE NULL
    END) AS hora_inicio,
    COALESCE(p.hora_fim, CASE p.turno
        WHEN 'DIA' THEN '19:00:00'
        WHEN 'NOITE' THEN '07:00:00'
        WHEN '24H' THEN '23:59:59'
        ELSE NULL
    END) AS hora_fim
FROM medicos m
JOIN plantoes p ON p.id_medico = m.id_medico
WHERE m.ativo = 1
  AND p.ativo = 1;

DELIMITER $$

CREATE PROCEDURE sp_medicos_disponiveis(
    IN p_data DATE,
    IN p_hora TIME
)
BEGIN
    SELECT
        m.id_medico,
        m.nome,
        m.crm,
        m.id_especialidade,
        p.turno,
        p.hora_inicio,
        p.hora_fim
    FROM medicos m
    JOIN plantoes p ON p.id_medico = m.id_medico
    WHERE m.ativo = 1
      AND p.ativo = 1
      AND p.data = p_data
      AND p_hora BETWEEN COALESCE(p.hora_inicio, '00:00:00')
                     AND COALESCE(p.hora_fim, '23:59:59');
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_abrir_ffa_com_plantao(
    IN p_id_paciente BIGINT,
    IN p_id_usuario BIGINT,
    OUT p_id_ffa BIGINT
)
BEGIN
    DECLARE v_id_medico BIGINT;

    -- Seleciona primeiro médico disponível na linha assistencial do paciente
    SELECT id_medico
      INTO v_id_medico
      FROM vw_medicos_plantao
     WHERE CURTIME() BETWEEN hora_inicio AND hora_fim
     LIMIT 1;

    IF v_id_medico IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nenhum médico disponível no plantão atual';
    END IF;

    -- Chama SP de abertura de FFA existente
    CALL sp_abre_ffa(
        NULL,        -- se houver fila, pode passar id_fila
        p_id_usuario,
        p_id_paciente,
        p_id_ffa,
        NULL         -- GPAT será gerado pela SP
    );
END$$

DELIMITER ;


-- Apaga a tabela se já existir
DROP TABLE IF EXISTS plantao;

-- Cria a tabela de plantões
CREATE TABLE if not exists plantao (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_medico BIGINT NOT NULL,          -- FK para tabela de médicos
    nome_medico VARCHAR(200) NOT NULL,  -- Nome do médico (redundante para exibição rápida)
    tipo_plantao ENUM('CLINICO','PEDIATRIA','EMERGENCIA') NOT NULL,
    inicio_plantao DATETIME NOT NULL,
    fim_plantao DATETIME NOT NULL,
    ativo TINYINT(1) DEFAULT 1,         -- 1 = ativo, 0 = inativo
    criado_em DATETIME DEFAULT NOW(),
    atualizado_em DATETIME DEFAULT NOW() ON UPDATE NOW()
);

-- Opcional: exemplo de inserção
INSERT INTO plantao (id_medico, nome_medico, tipo_plantao, inicio_plantao, fim_plantao, ativo)
VALUES
(1, 'Dr. Carlos Silva', 'CLINICO', '2025-12-31 07:00:00', '2025-12-31 19:00:00', 1),
(2, 'Dra. Ana Souza', 'PEDIATRIA', '2025-12-31 07:00:00', '2025-12-31 19:00:00', 1),
(3, 'Dr. Rafael Lima', 'EMERGENCIA', '2025-12-31 19:00:00', '2026-01-01 07:00:00', 1);

-- View pronta para painel / TTS / recepção
CREATE OR REPLACE VIEW vw_plantao_ativo AS
SELECT 
    p.id,
    p.id_medico,
    p.nome_medico,
    p.tipo_plantao,
    p.inicio_plantao,
    p.fim_plantao
FROM plantao p
WHERE p.ativo = 1
  AND NOW() BETWEEN p.inicio_plantao AND p.fim_plantao
ORDER BY FIELD(p.tipo_plantao, 'EMERGENCIA','PEDIATRIA','CLINICO'), p.inicio_plantao;


CREATE OR REPLACE VIEW vw_ffa_com_plantao AS
SELECT 
    f.id AS id_ffa,
    f.gpat AS senha,
    f.id_paciente,
    p.nome_completo AS nome_paciente,
    pl.id_medico,
    pl.nome_medico,
    pl.tipo_plantao,
    f.status,
    f.criado_em,
    f.atualizado_em
FROM ffa f
JOIN pessoa p ON f.id_paciente = p.id_pessoa
LEFT JOIN plantao pl 
    ON NOW() BETWEEN pl.inicio_plantao AND pl.fim_plantao
    AND pl.ativo = 1
ORDER BY FIELD(pl.tipo_plantao, 'EMERGENCIA','PEDIATRIA','CLINICO'), f.criado_em;


DROP PROCEDURE IF EXISTS sp_chama_paciente;

DELIMITER $$

CREATE PROCEDURE sp_chama_paciente(IN p_id_ffa BIGINT)
BEGIN
    -- Atualiza status da FFA
    UPDATE ffa
    SET status = 'CHAMANDO_MEDICO',
        atualizado_em = NOW()
    WHERE id = p_id_ffa;

    -- Retorna dados para painel/TTS
    SELECT 
        f.gpat AS senha,
        p.nome_completo AS nome_paciente,
        pl.nome_medico,
        pl.tipo_plantao,
        CONCAT('Atenção paciente ', p.nome_completo, ', comparecer à sala ', pl.tipo_plantao, ' chamado pelo médico ', pl.nome_medico) AS tts_texto
    FROM ffa f
    JOIN pessoa p ON f.id_paciente = p.id_pessoa
    LEFT JOIN plantao pl 
        ON NOW() BETWEEN pl.inicio_plantao AND pl.fim_plantao
        AND pl.ativo = 1
    WHERE f.id = p_id_ffa;
END$$

DELIMITER ;

CREATE OR REPLACE VIEW vw_senhas_chamadas AS
SELECT 
    f.gpat AS senha,
    f.status,
    p.nome_completo AS nome_paciente,
    pl.nome_medico,
    pl.tipo_plantao
FROM ffa f
JOIN pessoa p ON f.id_paciente = p.id_pessoa
LEFT JOIN plantao pl
    ON NOW() BETWEEN pl.inicio_plantao AND pl.fim_plantao
    AND pl.ativo = 1
WHERE f.status IN ('CHAMANDO_MEDICO','AGUARDANDO_CHAMADA_MEDICO')
ORDER BY f.criado_em;


-- ================================
-- 1️⃣ View: FFA com Plantão
-- ================================
DROP VIEW IF EXISTS vw_ffa_com_plantao;

CREATE OR REPLACE VIEW vw_ffa_com_plantao AS
SELECT 
    f.id AS id_ffa,
    f.gpat AS senha,
    f.id_paciente,
    p.nome_completo AS nome_paciente,
    pl.id_medico,
    pl.nome_medico,
    pl.tipo_plantao,
    f.status,
    f.criado_em,
    f.atualizado_em
FROM ffa f
JOIN pessoa p ON f.id_paciente = p.id_pessoa
LEFT JOIN plantao pl 
    ON NOW() BETWEEN pl.inicio_plantao AND pl.fim_plantao
    AND pl.ativo = 1
ORDER BY FIELD(pl.tipo_plantao, 'EMERGENCIA','PEDIATRIA','CLINICO'), f.criado_em;

-- ================================
-- 2️⃣ View: Senhas chamadas para Recepção/Totem
-- ================================
DROP VIEW IF EXISTS vw_senhas_chamadas;

CREATE OR REPLACE VIEW vw_senhas_chamadas AS
SELECT 
    f.gpat AS senha,
    f.status,
    p.nome_completo AS nome_paciente,
    pl.nome_medico,
    pl.tipo_plantao
FROM ffa f
JOIN pessoa p ON f.id_paciente = p.id_pessoa
LEFT JOIN plantao pl
    ON NOW() BETWEEN pl.inicio_plantao AND pl.fim_plantao
    AND pl.ativo = 1
WHERE f.status IN ('CHAMANDO_MEDICO','AGUARDANDO_CHAMADA_MEDICO')
ORDER BY f.criado_em;

-- ================================
-- 3️⃣ SP: Chamar paciente e gerar TTS
-- ================================
DROP PROCEDURE IF EXISTS sp_chama_paciente;

DELIMITER $$

CREATE PROCEDURE sp_chama_paciente(IN p_id_ffa BIGINT)
BEGIN
    -- Atualiza status da FFA
    UPDATE ffa
    SET status = 'CHAMANDO_MEDICO',
        atualizado_em = NOW()
    WHERE id = p_id_ffa;

    -- Retorna dados para painel/TTS
    SELECT 
        f.gpat AS senha,
        p.nome_completo AS nome_paciente,
        pl.nome_medico,
        pl.tipo_plantao,
        CONCAT('Atenção paciente ', p.nome_completo, ', comparecer à sala ', pl.tipo_plantao, ' chamado pelo médico ', pl.nome_medico) AS tts_texto
    FROM ffa f
    JOIN pessoa p ON f.id_paciente = p.id_pessoa
    LEFT JOIN plantao pl 
        ON NOW() BETWEEN pl.inicio_plantao AND pl.fim_plantao
        AND pl.ativo = 1
    WHERE f.id = p_id_ffa;
END$$

DELIMITER ;


DROP TABLE IF EXISTS auditoria_excecoes;

CREATE TABLE auditoria_excecoes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_ffa BIGINT NOT NULL,
    id_paciente BIGINT NOT NULL,
    motivo VARCHAR(255) NOT NULL,
    chamado_por VARCHAR(200) DEFAULT NULL,  -- pode ser médico ou recepção
    criado_em DATETIME DEFAULT NOW()
);


DROP VIEW IF EXISTS vw_proxima_chamada_medico;

CREATE OR REPLACE VIEW vw_proxima_chamada_medico AS
SELECT 
    f.id AS id_ffa,
    f.gpat AS senha,
    p.nome_completo AS nome_paciente,
    pl.nome_medico,
    pl.tipo_plantao,
    f.status,
    f.classificacao_manchester,
    -- Flag de prioridade absoluta
    CASE 
        WHEN pl.tipo_plantao = 'PEDIATRIA' AND f.classificacao_manchester = 'VERMELHO' THEN 1
        ELSE 2
    END AS prioridade_pediatrico_vermelho
FROM ffa f
JOIN pessoa p ON f.id_paciente = p.id_pessoa
LEFT JOIN plantao pl 
    ON NOW() BETWEEN pl.inicio_plantao AND pl.fim_plantao
    AND pl.ativo = 1
ORDER BY 
    prioridade_pediatrico_vermelho,
    FIELD(f.classificacao_manchester, 'VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
    f.criado_em;


DROP PROCEDURE IF EXISTS sp_auditoria_excecao;

DELIMITER $$

CREATE PROCEDURE sp_auditoria_excecao(
    IN p_id_ffa BIGINT,
    IN p_motivo VARCHAR(255),
    IN p_chamado_por VARCHAR(200)
)
BEGIN
    -- Registra exceção apenas quando a prioridade é aplicada manualmente
    INSERT INTO auditoria_excecoes (id_ffa, id_paciente, motivo, chamado_por)
    SELECT f.id, f.id_paciente, p_motivo, p_chamado_por
    FROM ffa f
    WHERE f.id = p_id_ffa;
END$$

DELIMITER ;

DROP TABLE IF EXISTS senhas;

CREATE TABLE senhas (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,

  numero INT NOT NULL,
  prefixo VARCHAR(5) NOT NULL, -- A, B, C, P etc

  tipo_atendimento ENUM(
    'CLINICO',
    'PEDIATRICO',
    'PRIORITARIO',
    'EMERGENCIA',
    'VISITA',
    'EXAME'
  ) NOT NULL,

  status ENUM(
    'GERADA',
    'EM_FILA',
    'CHAMADA',
    'EM_ATENDIMENTO_RECEPCAO',
    'CONVERTIDA_FFA',
    'NAO_COMPARECEU',
    'CANCELADA',
    'EXPIRADA'
  ) NOT NULL DEFAULT 'GERADA',

  origem ENUM('TOTEM', 'RECEPCAO', 'ADMIN') NOT NULL,

  id_ffa BIGINT NULL, -- vínculo com a FFA após conversão

  guiche_chamada VARCHAR(20) NULL,
  id_usuario_chamada BIGINT NULL,

  criada_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  chamada_em DATETIME NULL,
  atendida_em DATETIME NULL,
  cancelada_em DATETIME NULL,

  observacao VARCHAR(255) NULL,

  INDEX idx_status (status),
  INDEX idx_tipo (tipo_atendimento),
  INDEX idx_criada_em (criada_em),
  INDEX idx_ffa (id_ffa)
);


DROP TABLE IF EXISTS eventos_fluxo;

CREATE TABLE eventos_fluxo (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,

  entidade ENUM(
    'SENHA',
    'FFA'
  ) NOT NULL,

  id_entidade BIGINT NOT NULL,

  tipo_evento ENUM(
    'SENHA_GERADA',
    'SENHA_CHAMADA',
    'SENHA_CANCELADA',
    'SENHA_NAO_COMPARECEU',
    'SENHA_CONVERTIDA_FFA',

    'FFA_ABERTA',
    'INICIO_TRIAGEM',
    'FIM_TRIAGEM',

    'ENCAMINHADO',
    'RETORNO',
    'FINALIZADO'
  ) NOT NULL,

  descricao VARCHAR(255) NULL,

  id_usuario BIGINT NULL,
  perfil_usuario VARCHAR(50) NULL,

  local VARCHAR(50) NULL, -- guichê, sala, triagem

  data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  INDEX idx_entidade (entidade, id_entidade),
  INDEX idx_tipo_evento (tipo_evento),
  INDEX idx_data (data_hora)
);



DELIMITER $$

CREATE PROCEDURE sp_chamar_senha (
  IN p_id_senha BIGINT,
  IN p_guiche VARCHAR(20),
  IN p_id_usuario BIGINT,
  IN p_perfil VARCHAR(50)
)
BEGIN
  UPDATE senhas
     SET status = 'CHAMADA',
         guiche_chamada = p_guiche,
         id_usuario_chamada = p_id_usuario,
         chamada_em = NOW()
   WHERE id = p_id_senha
     AND status IN ('GERADA','EM_FILA');

  INSERT INTO eventos_fluxo (
    entidade, entidade_id, tipo_evento,
    descricao, id_usuario, perfil_usuario, local
  ) VALUES (
    'SENHA', p_id_senha, 'SENHA_CHAMADA',
    CONCAT('Senha chamada no guichê ', p_guiche),
    p_id_usuario, p_perfil, p_guiche
  );
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_senha_nao_compareceu (
  IN p_id_senha BIGINT,
  IN p_id_usuario BIGINT,
  IN p_perfil VARCHAR(50)
)
BEGIN
  UPDATE senhas
     SET status = 'NAO_COMPARECEU'
   WHERE id = p_id_senha
     AND status = 'CHAMADA';

  INSERT INTO eventos_fluxo (
    entidade, entidade_id, tipo_evento,
    descricao, id_usuario, perfil_usuario
  ) VALUES (
    'SENHA', p_id_senha, 'SENHA_NAO_COMPARECEU',
    'Paciente não compareceu à chamada',
    p_id_usuario, p_perfil
  );
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_cancelar_senha (
  IN p_id_senha BIGINT,
  IN p_motivo VARCHAR(255),
  IN p_id_usuario BIGINT,
  IN p_perfil VARCHAR(50)
)
BEGIN
  UPDATE senhas
     SET status = 'CANCELADA',
         cancelada_em = NOW(),
         observacao = p_motivo
   WHERE id = p_id_senha
     AND status NOT IN ('ATENDIDA','CANCELADA');

  INSERT INTO eventos_fluxo (
    entidade, entidade_id, tipo_evento,
    descricao, id_usuario, perfil_usuario
  ) VALUES (
    'SENHA', p_id_senha, 'SENHA_CANCELADA',
    p_motivo,
    p_id_usuario, p_perfil
  );
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_converter_senha_em_ffa (
  IN p_id_senha BIGINT,
  IN p_id_paciente BIGINT,
  IN p_id_usuario BIGINT,
  IN p_perfil VARCHAR(50)
)
BEGIN
  DECLARE v_id_ffa BIGINT;

  -- cria FFA
  INSERT INTO ffa (
    id_paciente,
    status,
    criada_em
  ) VALUES (
    p_id_paciente,
    'ABERTA',
    NOW()
  );

  SET v_id_ffa = LAST_INSERT_ID();

  -- vincula senha à FFA
  UPDATE senhas
     SET status = 'ATENDIDA',
         atendida_em = NOW(),
         id_ffa = v_id_ffa
   WHERE id = p_id_senha
     AND status = 'CHAMADA';

  -- evento senha
  INSERT INTO eventos_fluxo (
    entidade, entidade_id, tipo_evento,
    descricao, id_usuario, perfil_usuario
  ) VALUES (
    'SENHA', p_id_senha, 'SENHA_CONVERTIDA_FFA',
    CONCAT('Senha convertida em FFA ', v_id_ffa),
    p_id_usuario, p_perfil
  );

  -- evento FFA
  INSERT INTO eventos_fluxo (
    entidade, entidade_id, tipo_evento,
    descricao, id_usuario, perfil_usuario
  ) VALUES (
    'FFA', v_id_ffa, 'FFA_ABERTA',
    'Ficha aberta na recepção',
    p_id_usuario, p_perfil
  );
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_bloquear_senha_convertida
BEFORE UPDATE ON senhas
FOR EACH ROW
BEGIN
  IF OLD.id_ffa IS NOT NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Senha já convertida em FFA não pode ser alterada';
  END IF;
END$$

DELIMITER ;



CREATE OR REPLACE VIEW vw_fila_recepcao AS
SELECT
    s.id AS id_senha,
    s.numero,
    s.prefixo,
    s.tipo_atendimento,
    s.status,
    s.origem,
    s.guiche_chamada,
    s.id_usuario_chamada,
    s.prioridade,
    s.criada_em,
    s.chamada_em,
    s.atendida_em,
    s.cancelada_em,
    s.observacao,
    s.id_ffa,
    
    -- tempo de espera em minutos
    TIMESTAMPDIFF(MINUTE, s.criada_em, NOW()) AS tempo_espera,

    -- flag se já pode ser chamada
    CASE
        WHEN s.status IN ('GERADA','EM_FILA') THEN 1
        ELSE 0
    END AS pode_chamar

FROM
    senhas s

ORDER BY
    -- prioridade primeiro, depois tipo de atendimento, depois hora de criação
    s.prioridade DESC,
    FIELD(s.tipo_atendimento, 'EMERGENCIA', 'PRIORITARIO', 'CLINICO', 'PEDIATRICO', 'VISITA', 'EXAME') ASC,
    s.criada_em ASC;


CREATE OR REPLACE VIEW vw_senhas_ativas AS
SELECT
    s.id AS id_senha,
    s.numero,
    s.prefixo,
    s.tipo_atendimento,
    s.status,
    s.origem,
    s.guiche_chamada,
    s.id_usuario_chamada,
    s.prioridade,
    s.criada_em,
    s.chamada_em,
    s.atendida_em,
    s.cancelada_em,
    s.observacao,
    s.id_ffa
FROM
    senhas s
WHERE
    s.status NOT IN ('ATENDIDA', 'NAO_COMPARECEU', 'CANCELADA', 'EXPIRADA')
ORDER BY
    s.prioridade DESC,
    FIELD(s.tipo_atendimento, 'EMERGENCIA', 'PRIORITARIO', 'CLINICO', 'PEDIATRICO', 'VISITA', 'EXAME') ASC,
    s.criada_em ASC;

CREATE OR REPLACE VIEW vw_senhas_chamadas AS
SELECT
    s.id AS id_senha,
    s.numero,
    s.prefixo,
    s.tipo_atendimento,
    s.status,
    s.origem,
    s.guiche_chamada,
    s.id_usuario_chamada,
    s.prioridade,
    s.criada_em,
    s.chamada_em,
    s.atendida_em,
    s.cancelada_em,
    s.observacao,
    s.id_ffa
FROM
    senhas s
WHERE
    s.status = 'CHAMADA'
ORDER BY
    s.chamada_em ASC;

CREATE OR REPLACE VIEW vw_senhas_historico AS
SELECT
    s.id AS id_senha,
    s.numero,
    s.prefixo,
    s.tipo_atendimento,
    s.status,
    s.origem,
    s.guiche_chamada,
    s.id_usuario_chamada,
    s.prioridade,
    s.criada_em,
    s.chamada_em,
    s.atendida_em,
    s.cancelada_em,
    s.observacao,
    s.id_ffa
FROM
    senhas s
WHERE
    s.status IN ('ATENDIDA', 'NAO_COMPARECEU', 'CANCELADA', 'EXPIRADA')
ORDER BY
    s.criada_em DESC;
    
   
   DROP TABLE IF EXISTS eventos_fluxo;

    CREATE TABLE if not exists eventos_fluxo (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  entidade ENUM('SENHA', 'FFA') NOT NULL,
  entidade_id BIGINT NOT NULL,
  tipo_evento ENUM(
    'SENHA_GERADA',
    'SENHA_CHAMADA',
    'SENHA_CANCELADA',
    'FFA_ABERTA',
    'INICIO_TRIAGEM',
    'FIM_TRIAGEM',
    'ENCAMINHADO',
    'RETORNO',
    'FINALIZADO'
  ) NOT NULL,
  descricao VARCHAR(255) NULL,
  id_usuario BIGINT NULL,
  perfil_usuario VARCHAR(50) NULL,
  local VARCHAR(50) NULL,
  data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_entidade (entidade, entidade_id),
  INDEX idx_tipo_evento (tipo_evento),
  INDEX idx_data (data_hora)
);


CREATE OR REPLACE VIEW vw_eventos_senha AS
SELECT
    e.id AS id_evento,
    e.entidade_id AS id_senha,
    e.tipo_evento,
    e.descricao,
    e.id_usuario,
    e.perfil_usuario,
    e.local,
    e.data_hora
FROM
    eventos_fluxo e
WHERE
    e.entidade = 'SENHA'
ORDER BY
    e.entidade_id ASC,
    e.data_hora ASC;


DELIMITER $$

CREATE PROCEDURE fn_gera_senha(
    IN p_prefixo VARCHAR(5),
    IN p_tipo ENUM('CLINICO','PEDIATRICO','PRIORITARIO','EMERGENCIA','VISITA','EXAME'),
    IN p_origem ENUM('TOTEM','RECEPCAO','ADMIN'),
    OUT p_id_senha BIGINT
)
BEGIN
    DECLARE v_numero INT;

    -- Pega o último número para o prefixo
    SELECT IFNULL(MAX(numero),0)+1 INTO v_numero
    FROM senhas
    WHERE prefixo = p_prefixo;

    -- Insere a senha
    INSERT INTO senhas(
        numero, prefixo, tipo_atendimento, status, origem, criada_em
    ) VALUES (
        v_numero, p_prefixo, p_tipo, 'GERADA', p_origem, NOW()
    );

    SET p_id_senha = LAST_INSERT_ID();

    -- Cria evento de auditoria
    INSERT INTO eventos_fluxo(
        entidade, entidade_id, tipo_evento, descricao, data_hora
    ) VALUES (
        'SENHA', p_id_senha, 'SENHA_GERADA', CONCAT('Senha ', p_prefixo, v_numero,' gerada'), NOW()
    );
END$$

DELIMITER ;

drop procedure sp_chamar_senha;
DELIMITER $$

CREATE PROCEDURE sp_chamar_senha(
    IN p_id_senha BIGINT,
    IN p_guiche VARCHAR(20),
    IN p_id_usuario BIGINT,
    IN p_perfil_usuario VARCHAR(50)
)
BEGIN
    -- Atualiza status
    UPDATE senhas
    SET status = 'CHAMADA',
        guiche_chamada = p_guiche,
        id_usuario_chamada = p_id_usuario,
        chamada_em = NOW()
    WHERE id = p_id_senha;

    -- Evento de auditoria
    INSERT INTO eventos_fluxo(
        entidade, entidade_id, tipo_evento, descricao, id_usuario, perfil_usuario, local, data_hora
    ) VALUES (
        'SENHA', p_id_senha, 'SENHA_CHAMADA', CONCAT('Senha chamada no guichê ', p_guiche),
        p_id_usuario, p_perfil_usuario, p_guiche, NOW()
    );
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_atender_senha(
    IN p_id_senha BIGINT,
    IN p_id_usuario BIGINT,
    IN p_perfil_usuario VARCHAR(50)
)
BEGIN
    UPDATE senhas
    SET status = 'ATENDIDA',
        atendida_em = NOW()
    WHERE id = p_id_senha;

    INSERT INTO eventos_fluxo(
        entidade, entidade_id, tipo_evento, descricao, id_usuario, perfil_usuario, data_hora
    ) VALUES (
        'SENHA', p_id_senha, 'FFA_ABERTA', 'Atendimento iniciado para a senha',
        p_id_usuario, p_perfil_usuario, NOW()
    );
END$$

DELIMITER ;

drop procedure sp_cancelar_senha;

DELIMITER $$

CREATE PROCEDURE sp_cancelar_senha(
    IN p_id_senha BIGINT,
    IN p_id_usuario BIGINT,
    IN p_perfil_usuario VARCHAR(50),
    IN p_motivo VARCHAR(255)
)
BEGIN
    UPDATE senhas
    SET status = 'CANCELADA',
        cancelada_em = NOW(),
        observacao = p_motivo
    WHERE id = p_id_senha;

    INSERT INTO eventos_fluxo(
        entidade, entidade_id, tipo_evento, descricao, id_usuario, perfil_usuario, data_hora
    ) VALUES (
        'SENHA', p_id_senha, 'SENHA_CANCELADA', p_motivo, p_id_usuario, p_perfil_usuario, NOW()
    );
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_senha_gerada
AFTER INSERT ON senhas
FOR EACH ROW
BEGIN
    INSERT INTO eventos_fluxo(
        entidade, entidade_id, tipo_evento, descricao, data_hora
    )
    VALUES (
        'SENHA',
        NEW.id,
        'SENHA_GERADA',
        CONCAT('Senha ', NEW.prefixo, NEW.numero, ' gerada automaticamente'),
        NOW()
    );
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_senha_status_change
AFTER UPDATE ON senhas
FOR EACH ROW
BEGIN
    -- Quando a senha é chamada
    IF OLD.status != 'CHAMADA' AND NEW.status = 'CHAMADA' THEN
        INSERT INTO eventos_fluxo(
            entidade, entidade_id, tipo_evento, descricao, id_usuario, perfil_usuario, local, data_hora
        )
        VALUES (
            'SENHA',
            NEW.id,
            'SENHA_CHAMADA',
            CONCAT('Senha chamada no guichê ', NEW.guiche_chamada),
            NEW.id_usuario_chamada,
            NULL,  -- perfil vai ser preenchido via procedure que chama
            NEW.guiche_chamada,
            NOW()
        );
    END IF;

    -- Quando a senha é atendida → abrir FFA
    IF OLD.status != 'ATENDIDA' AND NEW.status = 'ATENDIDA' THEN
        INSERT INTO eventos_fluxo(
            entidade, entidade_id, tipo_evento, descricao, id_usuario, perfil_usuario, local, data_hora
        )
        VALUES (
            'SENHA',
            NEW.id,
            'FFA_ABERTA',
            'Atendimento iniciado e FFA criada',
            NEW.id_usuario_chamada,
            NULL,
            NEW.guiche_chamada,
            NOW()
        );
    END IF;

    -- Quando a senha é cancelada
    IF OLD.status != 'CANCELADA' AND NEW.status = 'CANCELADA' THEN
        INSERT INTO eventos_fluxo(
            entidade, entidade_id, tipo_evento, descricao, id_usuario, perfil_usuario, local, data_hora
        )
        VALUES (
            'SENHA',
            NEW.id,
            'SENHA_CANCELADA',
            NEW.observacao,
            NEW.id_usuario_chamada,
            NULL,
            NEW.guiche_chamada,
            NOW()
        );
    END IF;

END$$

DELIMITER ;
DELIMITER $$

CREATE TRIGGER trg_ffa_criada
AFTER INSERT ON ffa
FOR EACH ROW
BEGIN
    INSERT INTO eventos_fluxo(
        entidade,
        entidade_id,
        tipo_evento,
        descricao,
        id_usuario,
        perfil_usuario,
        local,
        data_hora
    )
    VALUES (
        'FFA',
        NEW.id,
        'FFA_ABERTA',
        CONCAT('FFA criada automaticamente com layout ', NEW.layout),
        NEW.id_usuario_criacao,
        NULL, -- perfil do usuário se quiser adicionar
        NEW.layout,
        NOW()
    );
END$$

DELIMITER ;


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

CREATE TABLE IF NOT EXISTS senhas (
    id_senha BIGINT AUTO_INCREMENT PRIMARY KEY,
    numero INT NOT NULL,
    origem ENUM('TOTEM','RECEPCAO','TOTEM_PRI_PEDI','TOTEM_PRI_ADULTO'),
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    chamada BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS totem_feedback (
    id_feedback BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_senha BIGINT NULL,
    origem VARCHAR(50) NULL,
    nota INT NULL,
    comentario TEXT NULL,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_senha) REFERENCES senhas(id_senha)
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
    FOREIGN KEY (id_senha) REFERENCES senhas(id_senha),
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

CREATE TABLE IF NOT EXISTS paciente (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_pessoa BIGINT NOT NULL,
    -- ... Colunas restantes não definidas, mas a redefinição é a última
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa)
);
-- ... outras tabelas para o fluxo e estoque (local_usuario, fila_senha, ffa, auditoria_fila, auditoria_ffa, eventos_fluxo, fluxo_status, regra_timeout, plantao, medicos, produtos_farmacia, estoque_local, entrada_estoque, dispensacao_farmacia, auditoria_estoque)

-- O script contém uma redefinição explícita de 'paciente' mais adiante, então usaremos a última estrutura válida:
DROP TABLE IF EXISTS paciente;
CREATE TABLE IF NOT EXISTS paciente (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_pessoa BIGINT NOT NULL,
    prontuario VARCHAR(50) UNIQUE,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa)
);

CREATE TABLE IF NOT EXISTS local_usuario (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_usuario BIGINT NOT NULL,
    id_local INT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_local) REFERENCES local_atendimento(id_local)
);

CREATE TABLE IF NOT EXISTS fila_senha (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_paciente BIGINT NOT NULL,
    senha VARCHAR(20) NOT NULL,
    origem ENUM('TOTEM','RECEPCAO') NOT NULL,
    prioridade_recepcao ENUM('NORMAL','IDOSO','CRIANCA_COLO','ESPECIAL','EMERGENCIA') DEFAULT 'NORMAL',
    status ENUM('AGUARDANDO','CHAMANDO','ATENDIDA','NAO_ATENDIDO','CANCELADA') DEFAULT 'AGUARDANDO',
    id_ffa BIGINT NULL,
    guiche_chamada VARCHAR(50),
    id_usuario_chamada BIGINT,
    id_usuario_atendimento BIGINT,
    observacao TEXT,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_paciente) REFERENCES pessoa(id_pessoa)
);

CREATE TABLE IF NOT EXISTS ffa ( -- Ficha de Atendimento
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    gpat VARCHAR(30) UNIQUE,
    id_paciente BIGINT NOT NULL,
    status VARCHAR(50) NOT NULL,
    layout VARCHAR(50), -- Onde o paciente está (Ex: TRIAGEM, CONSULTORIO A)
    classificacao_manchester ENUM('VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
    id_usuario_criacao BIGINT,
    id_usuario_alteracao BIGINT,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_paciente) REFERENCES pessoa(id_pessoa),
    FOREIGN KEY (id_usuario_criacao) REFERENCES usuario(id_usuario)
);

CREATE TABLE IF NOT EXISTS auditoria_fila (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_fila BIGINT NOT NULL,
    id_usuario BIGINT,
    acao VARCHAR(100) NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_fila) REFERENCES fila_senha(id)
);

CREATE TABLE IF NOT EXISTS auditoria_ffa (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_ffa BIGINT NOT NULL,
    id_usuario BIGINT,
    acao TEXT NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_ffa) REFERENCES ffa(id)
);

CREATE TABLE IF NOT EXISTS eventos_fluxo (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    entidade VARCHAR(50), -- FFA, SENHA, etc
    entidade_id BIGINT,
    tipo_evento VARCHAR(50),
    descricao TEXT,
    id_usuario BIGINT,
    perfil_usuario VARCHAR(50),
    local VARCHAR(50),
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS fluxo_status (
    id INT AUTO_INCREMENT PRIMARY KEY,
    status_origem VARCHAR(50) NOT NULL,
    status_destino VARCHAR(50) NOT NULL,
    origem_evento VARCHAR(50) NOT NULL,
    permitido BOOLEAN DEFAULT TRUE,
    UNIQUE KEY uk_fluxo (status_origem, status_destino, origem_evento)
);

CREATE TABLE IF NOT EXISTS regra_timeout (
    id INT AUTO_INCREMENT PRIMARY KEY,
    status_ffa VARCHAR(50) NOT NULL,
    tempo_limite_min INT NOT NULL,
    acao_timeout VARCHAR(50),
    ativa BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS plantao (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_medico BIGINT NOT NULL,
    inicio DATETIME NOT NULL,
    fim DATETIME,
    id_local INT,
    FOREIGN KEY (id_medico) REFERENCES medico(id_usuario),
    FOREIGN KEY (id_local) REFERENCES local_atendimento(id_local)
);

CREATE TABLE IF NOT EXISTS medicos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_pessoa BIGINT NOT NULL,
    crm VARCHAR(20) UNIQUE,
    ativo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa)
);

CREATE TABLE IF NOT EXISTS produtos_farmacia (
    id_produto BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    principio_ativo VARCHAR(200),
    unidade_medida VARCHAR(20),
    tipo ENUM('MEDICAMENTO','INSUMO','OUTRO')
);

CREATE TABLE IF NOT EXISTS estoque_local (
    id_estoque BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_produto BIGINT NOT NULL,
    id_local INT NOT NULL,
    quantidade_atual INT DEFAULT 0,
    min_estoque INT DEFAULT 0,
    FOREIGN KEY (id_produto) REFERENCES produtos_farmacia(id_produto),
    FOREIGN KEY (id_local) REFERENCES local_atendimento(id_local),
    UNIQUE KEY uk_produto_local (id_produto, id_local)
);

CREATE TABLE IF NOT EXISTS entrada_estoque (
    id_entrada BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_estoque BIGINT NOT NULL,
    id_produto BIGINT NOT NULL,
    id_local INT NOT NULL,
    quantidade INT NOT NULL,
    lote VARCHAR(50),
    validade DATE,
    id_usuario_entrada BIGINT,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_estoque) REFERENCES estoque_local(id_estoque),
    FOREIGN KEY (id_produto) REFERENCES produtos_farmacia(id_produto),
    FOREIGN KEY (id_local) REFERENCES local_atendimento(id_local)
);

CREATE TABLE IF NOT EXISTS dispensacao_farmacia (
    id_dispensacao BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_prescricao BIGINT NULL,
    id_produto BIGINT NOT NULL,
    id_estoque BIGINT NOT NULL,
    quantidade_dispensada INT NOT NULL,
    id_usuario_farmaceutico BIGINT,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_prescricao) REFERENCES prescricao(id_prescricao),
    FOREIGN KEY (id_produto) REFERENCES produtos_farmacia(id_produto),
    FOREIGN KEY (id_estoque) REFERENCES estoque_local(id_estoque)
);

CREATE TABLE IF NOT EXISTS auditoria_estoque (
    id_log BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_produto BIGINT NOT NULL,
    id_local INT NOT NULL,
    acao VARCHAR(50) NOT NULL,
    quantidade INT NOT NULL,
    id_usuario BIGINT,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS fila_retorno (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_fila BIGINT NOT NULL,
    retorno_em DATETIME NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_fila) REFERENCES fila_senha(id),
    UNIQUE KEY uk_fila_retorno (id_fila)

);

-- Médico
INSERT INTO observacoes_eventos
(entidade, id_entidade, contexto, tipo, texto, id_usuario)
VALUES
('FFA', 12345, 'MEDICO', 'ORIENTACAO',
 'Paciente aguardar 30 minutos antes da medicação', 10);
 
CREATE OR REPLACE VIEW vw_observacoes_ffa AS
SELECT
    o.id,
    o.tipo,
    o.contexto,
    o.texto,
    o.criado_em,
    p.nome AS autor,
    u.login AS autor_login
FROM observacoes_eventos o
JOIN usuario u  ON u.id_usuario = o.id_usuario
JOIN pessoa  p  ON p.id_pessoa  = u.id_pessoa
WHERE o.entidade = 'FFA';


CREATE OR REPLACE VIEW vw_observacoes_senha AS
SELECT
    o.id,
    o.id_entidade AS id_senha,
    o.tipo,
    o.contexto,
    o.texto,
    o.criado_em,
    p.nome AS autor
FROM observacoes_eventos o
JOIN usuario u ON u.id_usuario = o.id_usuario
JOIN pessoa p ON p.id_pessoa = u.id_pessoa
WHERE o.entidade = 'SENHA';

CREATE OR REPLACE VIEW vw_observacoes_atendimento AS
SELECT
    o.id,
    o.id_entidade AS id_atendimento,
    o.tipo,
    o.contexto,
    o.texto,
    o.criado_em,
    p.nome AS autor
FROM observacoes_eventos o
JOIN usuario u ON u.id_usuario = o.id_usuario
JOIN pessoa p ON p.id_pessoa = u.id_pessoa
WHERE o.entidade = 'ATENDIMENTO';

CREATE OR REPLACE VIEW vw_observacoes_ffa AS
SELECT
    o.id,
    o.tipo,
    o.contexto,
    o.texto,
    o.criado_em,
    p.nome_completo AS autor,
    u.login AS autor_login
FROM observacoes_eventos o
JOIN usuario u ON u.id_usuario = o.id_usuario
JOIN pessoa  p ON p.id_pessoa  = u.id_pessoa
WHERE o.entidade = 'FFA';

CREATE OR REPLACE VIEW vw_usuario_identidade AS
SELECT
    u.id_usuario,
    u.login,
    p.nome_completo,
    u.ativo
FROM usuario u
JOIN pessoa p ON p.id_pessoa = u.id_pessoa;

CREATE OR REPLACE VIEW vw_observacoes_ffa AS
SELECT
    o.id,
    o.tipo,
    o.contexto,
    o.texto,
    o.criado_em,
    COALESCE(p.nome_social, p.nome_completo) AS autor,
    u.login AS autor_login
FROM observacoes_eventos o
JOIN usuario u ON u.id_usuario = o.id_usuario
JOIN pessoa  p ON p.id_pessoa  = u.id_pessoa
WHERE o.entidade = 'FFA';
-- Adiciona a coluna senha se ainda não existir
ALTER TABLE usuario ADD COLUMN senha VARCHAR(150) NOT NULL AFTER login;

-- Adiciona a coluna senha_expira_em se ainda não existir
ALTER TABLE usuario ADD COLUMN senha_expira_em DATE DEFAULT NULL AFTER primeiro_login;
