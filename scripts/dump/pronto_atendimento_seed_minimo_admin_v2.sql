-- Seed mínimo para ambiente limpo (opcional)
-- Cria: cidade, sistema, unidade, local_operacional, perfis base e usuário admin.
-- Senha padrão do usuário admin: admin

START TRANSACTION;

-- Cidade
INSERT INTO cidade (nome, uf) VALUES ('Cidade Teste', 'SP');
SET @id_cidade = LAST_INSERT_ID();

-- Sistema (contexto operacional)
INSERT INTO sistema (nome, descricao) VALUES ('PA', 'Pronto Atendimento');
SET @id_sistema = LAST_INSERT_ID();

-- Unidade
INSERT INTO unidade (id_cidade, nome) VALUES (@id_cidade, 'Unidade Alpha');
SET @id_unidade = LAST_INSERT_ID();

-- Local operacional (ex.: recepção)
INSERT INTO local_operacional (id_unidade, id_sistema, codigo, nome, tipo, sala, ativo)
VALUES (@id_unidade, @id_sistema, 'RECEPCAO_01', 'RECEPCAO 01', 'RECEPCAO', '01', 1);
SET @id_local_operacional = LAST_INSERT_ID();

-- Perfis base (adapte conforme seu padrão)
INSERT INTO perfil (nome) VALUES
('ADMIN_MASTER'),
('RECEPCAO'),
('TRIAGEM'),
('MEDICO'),
('ENFERMAGEM'),
('FARMACEUTICO');

SET @id_perfil_admin = (SELECT id_perfil FROM perfil WHERE nome='ADMIN_MASTER' ORDER BY id_perfil DESC LIMIT 1);

-- Pessoa + Usuário
INSERT INTO pessoa (nome_completo) VALUES ('Admin Sistema');
SET @id_pessoa = LAST_INSERT_ID();

INSERT INTO usuario (id_pessoa, nome, login, senha_hash)
VALUES (@id_pessoa, 'Admin Sistema', 'admin', '$2y$10$ncxBu.mkS/.iYuZ78wnkD.jqO34X6PnWLuOqZ2VSd0CZj6eZ2VZNS');
SET @id_usuario = LAST_INSERT_ID();

-- Vincular usuário ao sistema/perfil (fonte da verdade)
INSERT INTO usuario_sistema (id_usuario, id_sistema, id_perfil)
VALUES (@id_usuario, @id_sistema, @id_perfil_admin);

-- Vincular usuário ao local operacional
INSERT INTO usuario_local_operacional (id_usuario, id_local_operacional)
VALUES (@id_usuario, @id_local_operacional);

COMMIT;

-- Fim do seed
