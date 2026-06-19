-- Portal Corporativo - Tabelas Canônicas

-- Tabela de categorias de notícias do portal
CREATE TABLE IF NOT EXISTS portal_categoria (
    id_portal_categoria BIGINT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    cor_etiqueta VARCHAR(20) DEFAULT NULL,
    ativo TINYINT DEFAULT 1,
    criado_em DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
    atualizado_em DATETIME(6) DEFAULT NULL,
    id_entidade BIGINT UNSIGNED DEFAULT NULL,
    PRIMARY KEY (id_portal_categoria),
    KEY idx_portal_categoria_entidade (id_entidade),
    CONSTRAINT fk_portal_categoria_entidade FOREIGN KEY (id_entidade) REFERENCES saas_entidade(id_entidade)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabela de notícias do portal corporativo
CREATE TABLE IF NOT EXISTS portal_noticia (
    id_portal_noticia BIGINT NOT NULL AUTO_INCREMENT,
    titulo VARCHAR(255) NOT NULL,
    conteudo LONGTEXT,
    resumo TEXT,
    id_categoria BIGINT DEFAULT NULL,
    id_autor BIGINT UNSIGNED DEFAULT NULL,
    id_unidade BIGINT UNSIGNED DEFAULT NULL,
    id_saas_entidade BIGINT UNSIGNED DEFAULT NULL,
    publicado_em DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
    expira_em DATETIME(6) DEFAULT NULL,
    ativo TINYINT DEFAULT 1,
    prioridade TINYINT DEFAULT 0,
    visualizacoes INT DEFAULT 0,
    anexos JSON DEFAULT NULL,
    tags JSON DEFAULT NULL,
    criado_em DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
    atualizado_em DATETIME(6) DEFAULT NULL,
    PRIMARY KEY (id_portal_noticia),
    KEY idx_portal_noticia_categoria (id_categoria),
    KEY idx_portal_noticia_autor (id_autor),
    KEY idx_portal_noticia_unidade (id_unidade),
    KEY idx_portal_noticia_entidade (id_saas_entidade),
    KEY idx_portal_noticia_publicado (publicado_em),
    CONSTRAINT fk_portal_noticia_categoria FOREIGN KEY (id_categoria) REFERENCES portal_categoria(id_portal_categoria),
    CONSTRAINT fk_portal_noticia_autor FOREIGN KEY (id_autor) REFERENCES usuario(id_usuario),
    CONSTRAINT fk_portal_noticia_unidade FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade),
    CONSTRAINT fk_portal_noticia_entidade FOREIGN KEY (id_saas_entidade) REFERENCES saas_entidade(id_entidade)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Permissões para o Portal
INSERT IGNORE INTO permissao (codigo, nome, descricao, dominio, nome_procedure, acao_frontend, grupo_menu, icone, ordem_menu) VALUES
('PORTAL.NOTICIA.CRIAR', 'Criar Notícia', 'Permite criar notícias no portal corporativo', 'PORTAL', 'sp_executor_portal_noticia_criar', 'portal_noticia_criar', 'Portal', 'Newspaper', 10),
('PORTAL.NOTICIA.LISTAR', 'Listar Notícias', 'Permite listar notícias do portal', 'PORTAL', 'sp_executor_portal_noticia_listar', 'portal_noticia_listar', 'Portal', 'List', 20),
('PORTAL.NOTICIA.EDITAR', 'Editar Notícia', 'Permite editar notícias do portal', 'PORTAL', 'sp_executor_portal_noticia_editar', 'portal_noticia_editar', 'Portal', 'Edit', 30),
('PORTAL.MODULOS', 'Módulos do Portal', 'Lista módulos disponíveis no portal', 'PORTAL', 'sp_executor_portal_modulos', 'portal_modulos', 'Portal', 'Grid', 1);

-- Procedure executor para criar notícia
DELIMITER ;;
CREATE PROCEDURE IF NOT EXISTS sp_executor_portal_noticia_criar(
    IN p_id_sessao BIGINT,
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT,
    IN p_payload JSON
)
SQL SECURITY INVOKER
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        GET DIAGNOSTICS CONDITION 1 @msg = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('sucesso', FALSE, 'mensagem', @msg) AS resultado;
    END;
    
    DECLARE v_id BIGINT;
    DECLARE v_id_usuario BIGINT UNSIGNED;
    DECLARE v_id_unidade BIGINT UNSIGNED;
    DECLARE v_id_saas BIGINT UNSIGNED;
    
    START TRANSACTION;
    
    SELECT id_usuario, id_unidade, id_saas_entidade 
    INTO v_id_usuario, v_id_unidade, v_id_saas
    FROM sessao_usuario WHERE id_sessao_usuario = p_id_sessao LIMIT 1;
    
    INSERT INTO portal_noticia (
        titulo, conteudo, resumo, id_categoria, id_autor, id_unidade, id_saas_entidade, expira_em, prioridade, tags
    ) VALUES (
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.titulo')),
        JSON_EXTRACT(p_payload, '$.conteudo'),
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.resumo')),
        JSON_EXTRACT(p_payload, '$.id_categoria'),
        v_id_usuario,
        v_id_unidade,
        v_id_saas,
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.expira_em')),
        JSON_EXTRACT(p_payload, '$.prioridade'),
        JSON_EXTRACT(p_payload, '$.tags')
    );
    
    SET v_id = LAST_INSERT_ID();
    
    COMMIT;
    
    SELECT JSON_OBJECT(
        'sucesso', TRUE,
        'id', v_id,
        'mensagem', 'Notícia criada com sucesso'
    ) AS resultado;
END;;
DELIMITER ;

-- Procedure executor para listar notícias
DELIMITER ;;
CREATE PROCEDURE IF NOT EXISTS sp_executor_portal_noticia_listar(
    IN p_id_sessao BIGINT,
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT,
    IN p_payload JSON
)
SQL SECURITY INVOKER
proc: BEGIN
    DECLARE v_id_saas BIGINT;
    DECLARE v_sql TEXT;
    
    SELECT id_saas_entidade INTO v_id_saas FROM sessao_usuario WHERE id_sessao_usuario = p_id_sessao LIMIT 1;
    
    SET @limit_val = COALESCE(JSON_EXTRACT(p_payload, '$.limit'), 20);
    SET @offset_val = COALESCE(JSON_EXTRACT(p_payload, '$.offset'), 0);
    
    SET @sql = 'SELECT pn.id_portal_noticia, pn.titulo, pn.resumo, pn.conteudo, pn.publicado_em, pn.prioridade, pn.visualizacoes, pn.tags, pc.nome as categoria_nome FROM portal_noticia pn LEFT JOIN portal_categoria pc ON pn.id_categoria = pc.id_portal_categoria WHERE pn.ativo = 1';
    
    IF v_id_saas IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' AND pn.id_saas_entidade = ', v_id_saas);
    END IF;
    
    SET @sql = CONCAT(@sql, ' ORDER BY pn.prioridade DESC, pn.publicado_em DESC LIMIT ', @limit_val, ' OFFSET ', @offset_val);
    
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END;;
DELIMITER ;

-- Procedure executor para módulos do portal
DELIMITER ;;
CREATE PROCEDURE IF NOT EXISTS sp_executor_portal_modulos(
    IN p_id_sessao BIGINT,
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT,
    IN p_payload JSON
)
SQL SECURITY INVOKER
proc: BEGIN
    SELECT JSON_ARRAYAGG(
        JSON_OBJECT(
            'codigo', codigo,
            'nome', nome,
            'acao_frontend', acao_frontend,
            'icone', icone
        )
    ) AS resultado
    FROM permissao 
    WHERE dominio = 'PORTAL' AND ativo = 1 AND acao_frontend IS NOT NULL;
END;;
DELIMITER ;