-- seed.sql
-- execute este arquivo no seu banco para criar valores iniciais de exemplo com estrutura similar ao dump real.

-- ============================================
-- ENTIDADE SAAS (obrigatório para FKs)
-- ============================================

INSERT INTO saas_entidade (id_entidade, nome_fantasia, razao_social, cnpj, ativo) VALUES
(1, 'Empresa Exemplo', 'Empresa Exemplo Ltda', '00.000.000/0001-00', 1);

-- ============================================
-- CIDADES
-- ============================================

INSERT INTO cidade (id_cidade, id_entidade, nome, uf) VALUES
(100, 1, 'Cidade Alpha', 'SP'),
(200, 1, 'Cidade Beta', 'SP');

-- ============================================
-- UNIDADES
-- ============================================

INSERT INTO unidade (id_unidade, id_entidade, id_cidade, id_sistema, nome, tipo) VALUES
(10, 1, 100, 1, 'UPA Centro', 'UPA'),
(20, 1, 100, 1, 'Hospital Municipal', 'HOSPITAL'),
(30, 1, 200, 1, 'UPA Zona Norte', 'UPA');

-- ============================================
-- LOCAIS OPERACIONAIS (setores)
-- ============================================

INSERT INTO local_operacional (id_local_operacional, nome, id_unidade) VALUES
(1, 'Recepção', 10),
(2, 'Triagem', 10),
(3, 'Sala 1', 20),
(4, 'Sala 2', 20);

-- ============================================
-- SISTEMAS
-- ============================================

INSERT INTO sistema (id_sistema, nome) VALUES
(1, 'operacional'),
(2, 'assistencial');

-- ============================================
-- PERFIS
-- ============================================

INSERT INTO perfil (id_perfil, nome) VALUES
(1, 'ADMIN'),
(2, 'OPERADOR'),
(3, 'MEDICO');

-- ============================================
-- USUÁRIOS
-- senha padrão: 123456
-- antes de rodar o INSERT você deve substituir os hashes
-- por um bcrypt válido. por exemplo, execute em node:
--    node -e "const b=require('bcryptjs');b.hash('123456',10,(_,h)=>console.log(h));"
-- ou use a procedure `sp_usuario_hash_gerar` do dump e copie o resultado
-- (mas a API atualmente verifica bcrypt apenas, então preferimos bcrypt).
-- ============================================

INSERT INTO usuario (
    id_usuario,
    login,
    senha_hash,
    perfil,
    id_saas_entidade,
    ativo,
    tentativas_login,
    primeiro_login,
    forcar_troca_senha
) VALUES
(1, 'admin',     '<COLE_HASH_AQUI>', 'ADMIN', 1, 1, 0, 0, 0),
(2, 'operador1', '<COLE_HASH_AQUI>', 'OPERADOR', 1, 1, 0, 0, 0),
(3, 'medico1',   '<COLE_HASH_AQUI>', 'MEDICO', 1, 1, 0, 0, 0),
(4, 'bloqueado', '<COLE_HASH_AQUI>', 'OPERADOR', 1, 1, 5, 0, 0);

-- ============================================
-- VÍNCULO USUARIO ↔ UNIDADE
-- ============================================

INSERT INTO usuario_unidade (id_usuario, id_unidade) VALUES
(1, 10),
(1, 20),
(2, 10),
(3, 20),
(4, 30);

-- ============================================
-- VÍNCULO USUARIO ↔ SISTEMA
-- ============================================

INSERT INTO usuario_sistema (id_usuario, id_sistema) VALUES
(1, 1),
(1, 2),
(2, 1),
(3, 2),
(4, 1);

-- ============================================
-- PERFIL POR SISTEMA
-- ============================================

INSERT INTO usuario_sistema_perfil (id_usuario, id_sistema, id_perfil) VALUES
(1, 1, 1),
(1, 2, 1),
(2, 1, 2),
(3, 2, 3),
(4, 1, 2);

-- ============================================
-- VÍNCULO USUARIO ↔ LOCAL_OPERACIONAL
-- ============================================

INSERT INTO usuario_local_operacional (id_usuario, id_local_operacional) VALUES
(1, 1),
(1, 2),
(2, 1),
(3, 3);

-- ============================================
-- CONTEXTO ATIVO
-- ============================================

INSERT INTO usuario_contexto (id_usuario, id_unidade, id_sistema, id_local_operacional, id_perfil) VALUES
(1, 10, 1, 1, 1),
(2, 10, 1, 1, 2),
(3, 20, 2, 3, 3),
(4, 30, 1, 4, 2);

