-- ============================================================
-- Script para corrigir a tabela local (necessária para FK de sessao_usuario)
-- Execute este arquivo no seu banco de dados MySQL
-- ============================================================

-- Verificar se a tabela local tem registros
SELECT 'Verificando registros na tabela local...' AS info;
SELECT COUNT(*) AS total_registros FROM local;

-- Primeiro, verificar se existe a unidade (deve existir pelo seed)
SELECT 'Verificando unidade:' AS info;
SELECT id_unidade, nome FROM unidade LIMIT 5;

-- Inserir locais básicos necessários para o sistema funcionar
-- A tabela local precisa de: id_unidade, id_tipo_local, codigo, nome
-- Os tipos de local (id_tipo_local) já existem no banco (de 1 a 297)

-- Vamos usar tipos de local que existem:
-- 1=RECEPCAO, 2=GUICHE, 3=TRIAGEM, 4=CONSULTORIO, 5=EMERGENCIA, 6=OBSERVACAO, 
-- 7=INTERNACAO, 8=MEDICACAO, 9=PROCEDIMENTO, 10=RX, 14=LABORATORIO, 16=FARMACIA

INSERT INTO local (id_unidade, id_tipo_local, codigo, nome, descricao, andar, bloco, ativo)
SELECT 1, 1, 'RECEP', 'RECEPÇÃO', 'Balcão de atendimento reception', '0', 'A', 1
WHERE NOT EXISTS (SELECT 1 FROM local WHERE codigo = 'RECEP' AND id_unidade = 1);

INSERT INTO local (id_unidade, id_tipo_local, codigo, nome, descricao, andar, bloco, ativo)
SELECT 1, 2, 'GUICHE01', 'GUICHÊ 01', 'Guichê de atendimento 01', '0', 'A', 1
WHERE NOT EXISTS (SELECT 1 FROM local WHERE codigo = 'GUICHE01' AND id_unidade = 1);

INSERT INTO local (id_unidade, id_tipo_local, codigo, nome, descricao, andar, bloco, ativo)
SELECT 1, 3, 'TRIAGEM', 'TRIAGEM', 'Sala de triagem de pacientes', '1', 'A', 1
WHERE NOT EXISTS (SELECT 1 FROM local WHERE codigo = 'TRIAGEM' AND id_unidade = 1);

INSERT INTO local (id_unidade, id_tipo_local, codigo, nome, descricao, andar, bloco, ativo)
SELECT 1, 4, 'CONSULT01', 'CONSULTÓRIO 01', 'Consultório médico 01', '2', 'A', 1
WHERE NOT EXISTS (SELECT 1 FROM local WHERE codigo = 'CONSULT01' AND id_unidade = 1);

INSERT INTO local (id_unidade, id_tipo_local, codigo, nome, descricao, andar, bloco, ativo)
SELECT 1, 4, 'CONSULT02', 'CONSULTÓRIO 02', 'Consultório médico 02', '2', 'A', 1
WHERE NOT EXISTS (SELECT 1 FROM local WHERE codigo = 'CONSULT02' AND id_unidade = 1);

INSERT INTO local (id_unidade, id_tipo_local, codigo, nome, descricao, andar, bloco, ativo)
SELECT 1, 5, 'EMERGENCIA', 'EMERGÊNCIA', 'Área de emergência/pronto socorro', '0', 'A', 1
WHERE NOT EXISTS (SELECT 1 FROM local WHERE codigo = 'EMERGENCIA' AND id_unidade = 1);

INSERT INTO local (id_unidade, id_tipo_local, codigo, nome, descricao, andar, bloco, ativo)
SELECT 1, 6, 'OBS_ADULTO', 'OBSERVAÇÃO ADULTO', 'Ala de observação adulta', '3', 'A', 1
WHERE NOT EXISTS (SELECT 1 FROM local WHERE codigo = 'OBS_ADULTO' AND id_unidade = 1);

INSERT INTO local (id_unidade, id_tipo_local, codigo, nome, descricao, andar, bloco, ativo)
SELECT 1, 7, 'ENFERMARIA', 'ENFERMARIA', 'Ala de enfermaria', '3', 'A', 1
WHERE NOT EXISTS (SELECT 1 FROM local WHERE codigo = 'ENFERMARIA' AND id_unidade = 1);

INSERT INTO local (id_unidade, id_tipo_local, codigo, nome, descricao, andar, bloco, ativo)
SELECT 1, 8, 'SALA_MED', 'SALA DE MEDICAÇÃO', 'Sala de administração de medicamentos', '1', 'B', 1
WHERE NOT EXISTS (SELECT 1 FROM local WHERE codigo = 'SALA_MED' AND id_unidade = 1);

INSERT INTO local (id_unidade, id_tipo_local, codigo, nome, descricao, andar, bloco, ativo)
SELECT 1, 16, 'FARMACIA', 'FARMÁCIA', 'Dispensação de medicamentos', '0', 'B', 1
WHERE NOT EXISTS (SELECT 1 FROM local WHERE codigo = 'FARMACIA' AND id_unidade = 1);

INSERT INTO local (id_unidade, id_tipo_local, codigo, nome, descricao, andar, bloco, ativo)
SELECT 1, 14, 'LABORATORIO', 'LABORATÓRIO', 'Exames laboratoriais', '1', 'B', 1
WHERE NOT EXISTS (SELECT 1 FROM local WHERE codigo = 'LABORATORIO' AND id_unidade = 1);

INSERT INTO local (id_unidade, id_tipo_local, codigo, nome, descricao, andar, bloco, ativo)
SELECT 1, 10, 'RAIO_X', 'RAIO-X', 'Exames de radiografia', '1', 'B', 1
WHERE NOT EXISTS (SELECT 1 FROM local WHERE codigo = 'RAIO_X' AND id_unidade = 1);

-- Verificar se os registros foram inseridos
SELECT 'Registros inseridos na tabela local:' AS info;
SELECT id_local, codigo, nome, descricao, ativo FROM local;

-- Testar se a FK vai funcionar agora
SELECT 'Testando FK com id_local = 1...' AS info;
SELECT * FROM local WHERE id_local = 1;
