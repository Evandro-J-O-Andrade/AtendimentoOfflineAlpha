# REFERÊNCIA TÉCNICA - PROCEDURES E DICIONÁRIO DE DADOS

---

## 📖 PROCEDURES QUICK REFERENCE

### AUTENTICAÇÃO (5 procs)

#### `sp_sessao_abrir`
```sql
CALL sp_sessao_abrir(
    p_id_usuario INT,
    p_id_sistema INT,
    p_id_unidade INT,
    p_id_local_operacional INT,
    p_token VARCHAR(500),
    p_ip_acesso VARCHAR(45),
    p_user_agent VARCHAR(500),
    p_expira_em DATETIME,
    OUT p_id_sessao_usuario BIGINT
);

Descrição: Abre nova sessão com contexto operacional
Retorna: ID da sessão criada (usar em todas operações)
Erros: Usuario inativo, sistema inativo, permissão negada
Auditoria: INSERT auditoria_evento (SESSAO_ABRIR)
```

#### `sp_sessao_assert`
```sql
CALL sp_sessao_assert(p_id_sessao_usuario BIGINT);

Descrição: Valida sessão ativa/vigente (GATE UNIVERSAL)
Retorna: NADA se válida (após, operação continua)
Erros: SQLSTATE 45000 se inválida, expirada ou não existe
Uso: PRIMEIRA LINHA de TODA procedure
```

#### `sp_sessao_encerrar`
```sql
CALL sp_sessao_encerrar(
    p_id_sessao_usuario BIGINT,
    p_motivo VARCHAR(255)
);
```

#### `sp_sessao_contexto_get`
```sql
CALL sp_sessao_contexto_get(
    p_id_sessao_usuario BIGINT,
    OUT p_id_usuario BIGINT,
    OUT p_id_sistema INT,
    OUT p_id_unidade INT,
    OUT p_id_local_operacional INT
);
```

#### `sp_sessao_tem_permissao`
```sql
CALL sp_sessao_tem_permissao(
    p_id_sessao_usuario BIGINT,
    p_permissao VARCHAR(100),
    OUT p_tem TINYINT
);
```

---

### FILA & SENHAS (10 procs)

#### `sp_senha_emitir` ⭐ RECEPÇÃO
```sql
CALL sp_senha_emitir(
    p_id_sessao_usuario BIGINT,
    p_tipo_atendimento ENUM('CLINICO','PEDIATRICO','PRIORITARIO','EMERGENCIA','VISITA','EXAME'),
    p_origem ENUM('TOTEM','RECEPCAO','ADMIN','SAMU'),
    p_id_local_operacional INT,
    OUT p_id_senha BIGINT,
    OUT p_codigo VARCHAR(10)
);

Descrição: Emite nova senha na recepção
Status: GERADA → AGUARDANDO
Retorna: ID da senha e código visual (ex: A001)
Timeline: criada_em, posicionado_em (quando aguardando)
```

#### `sp_senha_chamar_proxima` ⭐ RECEPÇÃO
```sql
CALL sp_senha_chamar_proxima(
    p_id_sessao_usuario BIGINT,
    p_id_local_operacional INT,
    p_lane ENUM('ADULTO','PEDIATRICO','PRIORITARIO'),
    OUT p_id_senha BIGINT,
    OUT p_codigo VARCHAR(10)
);

Descrição: Chama próxima senha da fila
Lógica:
  - SELECT fila_senha WHERE AGUARDANDO + lane + local
  - FOR UPDATE (lock)
  - ORDER BY prioridade DESC, criada_em ASC
  - UPDATE status='CHAMANDO'
Status: AGUARDANDO → CHAMANDO
Timeline: chamada_em = NOW()
Painel: Grita código na TV/Totem
```

#### `sp_recepcao_iniciar_complementacao`
```sql
CALL sp_recepcao_iniciar_complementacao(
    p_id_sessao_usuario BIGINT,
    p_id_senha BIGINT
);

Descrição: Marca início de coleta de dados
Status: CHAMANDO → EM_COMPLEMENTACAO
```

#### `sp_recepcao_complementar_e_abrir_ffa` ⭐⭐ CORE WORKFLOW
```sql
CALL sp_recepcao_complementar_e_abrir_ffa(
    p_id_sessao_usuario BIGINT,
    p_id_senha BIGINT,
    p_nome_completo VARCHAR(200),
    p_cpf VARCHAR(14),
    p_cns VARCHAR(20),
    p_rg VARCHAR(20),
    p_data_nascimento DATE,
    p_sexo ENUM('M','F','O'),
    p_nome_mae VARCHAR(200),
    p_email VARCHAR(254),
    p_telefone VARCHAR(20),
    p_cep VARCHAR(10),
    p_logradouro VARCHAR(255),
    p_numero INT,
    p_complemento VARCHAR(100),
    p_bairro VARCHAR(100),
    p_cidade VARCHAR(120),
    p_uf CHAR(2),
    OUT p_id_pessoa BIGINT,
    OUT p_id_paciente BIGINT,
    OUT p_id_atendimento BIGINT,
    OUT p_id_ffa BIGINT,
    OUT p_gpat VARCHAR(30)
);

Descrição: PROCEDURE MASSIVA (30+ params) - Core do sistema
Lógica:
  1. Valida senha (status CHAMANDO)
  2. Merge pessoa (POR CPF OU CNS)
  3. Cria/atualiza paciente
  4. Gera prontuário = 'PR' + LPAD(pessoa_id, 10, '0')
  5. Cria atendimento (status ABERTO)
  6. Cria FFA (status ABERTO)
  7. Gera GPAT determinístico:
     'GPAT-' + DATE_FORMAT(NOW(),'%Y%m%d') + '-' + LPAD(id_senha, 10, '0')
     Ex: GPAT-20260220-0000000142
  8. Updates senhas (status ENCAMINHADO, links)
  9. Audit: INSERT senha_eventos + auditoria_evento
Status: EM_COMPLEMENTACAO → ENCAMINHADO
Timeline: inicio_complementacao_em, fim_complementacao_em
Erro Comum: CPF já existe, dados inconsistentes
```

#### `sp_recepcao_encaminhar_ffa` ⭐ TRIAGEM
```sql
CALL sp_recepcao_encaminhar_ffa(
    p_id_sessao_usuario BIGINT,
    p_id_ffa BIGINT,
    p_tipo_destino VARCHAR(50)
);

Descrição: Encaminha FFA para triagem/setor
Internamente chama: sp_operacao_encaminhar
Output: Cria fila_operacional tipo=TRIAGEM
```

#### `sp_recepcao_nao_compareceu`
```sql
CALL sp_recepcao_nao_compareceu(
    p_id_sessao_usuario BIGINT,
    p_id_senha BIGINT,
    p_janela_minutos INT,
    p_observacao TEXT
);

Descrição: Marca não-comparecimento numa fila
Abre janela de retorno: retorno_permitido_ate = NOW() + interval p_janela
Status: CHAMANDO → NAO_COMPARECEU
```

#### `sp_senha_retorno_reinserir`
```sql
CALL sp_senha_retorno_reinserir(
    p_id_sessao_usuario BIGINT,
    p_id_senha BIGINT,
    p_janela_retorno_min INT,
    OUT p_id_senha_result BIGINT,
    OUT p_codigo_result VARCHAR(10)
);

Descrição: Reinserir paciente que não compareceu (se ainda em janela)
SE NOW() <= retorno_permitido_ate:
  - UPDATE senha (antiga): posicionado_em = NOW() (volta ao fim da fila)
  - status = AGUARDANDO
SE NOW() > retorno_permitido_ate:
  - UPDATE senha (velha): status = FINALIZADO
  - CALL sp_senha_emitir (nova senha)
```

---

### TRIAGEM (2 procs)

#### `sp_triagem_chamar`
```sql
CALL sp_triagem_chamar(
    p_id_sessao_usuario BIGINT,
    p_id_local_operacional INT,
    OUT p_id_fila BIGINT,
    OUT p_id_ffa BIGINT,
    OUT p_codigo_senha VARCHAR(10)
);

Descrição: Chama próxima triagem
Seleciona: fila_operacional tipo=TRIAGEM, status=AGUARDANDO
Status: AGUARDANDO → CHAMANDO → (enfermeiro coleta dados) → FINALIZADO
```

---

### MÉDICO (7 procs)

#### `sp_medico_chamar`
```sql
CALL sp_medico_chamar(
    p_id_sessao_usuario BIGINT,
    p_id_local_operacional INT,
    OUT p_id_fila BIGINT,
    OUT p_id_ffa BIGINT,
    OUT p_codigo_senha VARCHAR(10)
);

Descrição: Chama próximo paciente para médico
Similar a triagem
```

#### `sp_medico_encaminhar`
```sql
CALL sp_medico_encaminhar(
    p_id_sessao_usuario BIGINT,
    p_id_ffa BIGINT,
    p_id_local_operacional_destino INT,
    p_observacao TEXT
);

Descrição: Encaminha paciente para próximo setor
Internamente chama: sp_operacao_encaminhar
Cria novo fila_operacional no destino
```

#### `sp_medico_marcar_retorno`
```sql
CALL sp_medico_marcar_retorno(
    p_id_sessao_usuario BIGINT,
    p_id_ffa BIGINT,
    p_janela_minutos INT,
    p_observacao TEXT
);

Descrição: Agenda retorno em X minutos
INSERT fila_retorno (data_retorno_agendada)
```

#### `sp_medico_finalizar`
```sql
CALL sp_medico_finalizar(
    p_id_sessao_usuario BIGINT,
    p_id_fila BIGINT,
    p_motivo VARCHAR(255)
);
```

---

### MEDICAÇÃO (3 procs)

#### `sp_medicacao_marcar_executado`
```sql
CALL sp_medicacao_marcar_executado(
    p_id_sessao_usuario BIGINT,
    p_id_fila BIGINT,
    p_observacao TEXT
);

Descrição: Marca medicação como administrada
INSERT administracao_medicacao
UPDATE fila_operacional status=FINALIZADO
```

#### `sp_medicacao_nao_respondeu`
```sql
CALL sp_medicacao_nao_respondeu(
    p_id_sessao_usuario BIGINT,
    p_id_fila BIGINT,
    p_motivo VARCHAR(255)
);
```

---

### OPERAÇÕES (3 procs)

#### `sp_operacao_encaminhar` ⭐ CORE ROUTING
```sql
CALL sp_operacao_encaminhar(
    p_id_sessao_usuario BIGINT,
    p_id_ffa BIGINT,
    p_id_local_operacional_destino INT,
    p_observacao TEXT
);

Descrição: CORE - Encaminha FFA para novo local
Lógica:
  1. Valida FFA (existe, status válido)
  2. Busca local_operacional destino (valida existe)
  3. Determina tipo de fila por local (MAP)
  4. Se existe fila_operacional ativa para este paciente:
     - Finaliza anterior
     - Cria nova
  5. INSERT fila_operacional com:
     - tipo = tipo_fila_mapeado (TRIAGEM, MEDICO, RX, etc)
     - substatus = AGUARDANDO
     - id_local_operacional = destino
     - id_ffa = paciente
     - prioridade = classificacao_risco.prioridade
  6. INSERT fila_operacional_evento tipo=ENCAMINHAR
  7. UPDATE FFA status = EM_TRIAGEM | AGUARDANDO_MEDICO | etc
Auditoria: CALL sp_auditoria_evento_registrar
```

#### `sp_fila_chamar_proxima`
```sql
Helper: Seleciona próxima fila_operacional respeitando prioridade
```

---

### CONFIGURAÇÃO (3 procs)

#### `sp_painel_config_set`
```sql
CALL sp_painel_config_set(
    p_id_sessao_usuario BIGINT,
    p_id_painel INT,
    p_chave VARCHAR(80),
    p_valor_bool TINYINT,
    p_valor_int INT,
    p_valor_decimal DECIMAL(12,4),
    p_valor_text TEXT,
    p_valor_json JSON,
    p_valor_enum VARCHAR(80)
);

Descrição: Set type-safe de configuração painel
Type encoding:
  BOOL → p_valor_bool
  INT → p_valor_int
  DECIMAL → p_valor_decimal
  TEXT → p_valor_text
  JSON → p_valor_json
  ENUM → p_valor_enum
INSERT/UPDATE painel_config ON DUPLICATE KEY UPDATE
Auditoria: log do que mudou
```

#### `sp_painel_filtro_locais_seed`
```sql
CALL sp_painel_filtro_locais_seed(
    p_id_sessao_usuario BIGINT,
    p_painel_codigo VARCHAR(60),
    p_local_tipo VARCHAR(50),
    p_prefix VARCHAR(10),
    p_exclude_prefix VARCHAR(10),
    p_include_nd TINYINT
);

Descrição: Autogenera filtro de locais em JSON
Lógica:
  1. SELECT local_operacional
     WHERE tipo = p_local_tipo
     AND (prefix like p_prefix OR p_prefix IS NULL)
     AND (prefix NOT LIKE p_exclude_prefix OR NULL)
  2. GROUP_CONCAT(JSON_QUOTE(codigo)) → JSON array
     Ex: ["REC01","REC02","REC03","REC04"]
  3. CALL sp_painel_config_set(
       painel_id, 'FILTRO_LOCAIS_CODIGOS_JSON', json_result)
Uso: Quando muda locais → update automático painel
```

#### `sp_painel_seed_especialidades`
```sql
CALL sp_painel_seed_especialidades(
    p_id_sessao_usuario BIGINT,
    p_id_unidade INT,
    p_id_sistema INT
);

Descrição: Cria painéis de especialidades
Cria:
  - PAINEL_RECEPCAO_ADULTO
  - PAINEL_RECEPCAO_PEDI
  - PAINEL_TRIAGEM_ADULTO
  - PAINEL_TRIAGEM_PEDI
  - PAINEL_MEDICO_CLINICO
  - PAINEL_MEDICO_PEDI
  - PAINEL_MEDICACAO_ADULTO
  - PAINEL_MEDICACAO_PEDI
  - PAINEL_RX
Popula cada um com lane_config + location_json_filter
```

---

### PEDIDOS MÉDICOS (2 procs)

#### `sp_pedido_medico_criar`
```sql
CALL sp_pedido_medico_criar(
    p_id_sessao_usuario BIGINT,
    p_id_ffa BIGINT,
    p_id_usuario_solicitante BIGINT,
    p_id_local_operacional INT,
    OUT p_id_pedido BIGINT
);

Descrição: Cria requisição de exame/procedimento
INSERT pedido_medico
```

#### `sp_pedido_medico_item_add`
```sql
CALL sp_pedido_medico_item_add(
    p_id_sessao_usuario BIGINT,
    p_id_pedido BIGINT,
    p_tipo_item VARCHAR(50),
    p_descricao TEXT,
    p_sigtap_codigo VARCHAR(20),
    p_competencia VARCHAR(7),
    OUT p_exige_cat TINYINT,
    OUT p_exige_sinan TINYINT,
    OUT p_id_item BIGINT
);

Descrição: SMART - Adiciona item a pedido
Lógica:
  1. SELECT md_sigtap_procedimento WHERE codigo
  2. Mapeia exige_cat_default(SIGTAP) → CAT necessário?
  3. Mapeia exige_sinan_default(SIGTAP) → SINAN necessário?
  4. Valida competência SUS (mês/ano vigente)
  5. INSERT pedido_medico_item
  6. RETURN flags atualizadas
Auditoria: INSERT evento
```

---

### PROTOCOLO/SEQUÊNCIA (2 procs)

#### `sp_protocolo_emitir`
```sql
CALL sp_protocolo_emitir(
    p_id_sessao_usuario BIGINT,
    p_tipo VARCHAR(20),
    p_chave VARCHAR(50),
    p_data_ref DATE,
    p_id_paciente BIGINT,
    p_id_ffa BIGINT,
    p_id_senha BIGINT,
    OUT p_codigo VARCHAR(30)
);

Descrição: Emite protocolo com código sequencial
Formato: TIPO-YYYYMMDD-NNNNNN
Exemplo: RX-20260220-000001
OUTPUT: Código único
INSERT protocolo_emissao
```

#### `sp_sequencia_proximo_numero`
```sql
-- Helper: Gets next seq number for protocol
SELECT NEXT_VALUE(protocolo_sequencia) INTO @next_num;
```

---

### PACIENTE (1 proc)

#### `sp_paciente_cns_set`
```sql
CALL sp_paciente_cns_set(
    p_id_sessao_usuario BIGINT,
    p_id_paciente BIGINT,
    p_cns VARCHAR(20),
    p_origem VARCHAR(50),
    p_validado TINYINT,
    p_observacao TEXT
);

Descrição: Registra CNS (Cartão Nacional Saúde)
Deativa anterior CNS
INSERT paciente_cns (nova)
UPDATE paciente cns_vigente = nova
Auditoria: INSERT evento
```

---

### HELPERS & VALIDAÇÃO (5 procs)

#### `sp_assert_true`
```sql
CALL sp_assert_true(
    p_condicao TINYINT,
    p_codigo VARCHAR(50),
    p_mensagem VARCHAR(255)
);

Se false: SIGNAL SQLSTATE 45000 com mensagem
Uso: Validações gate keeper
```

#### `sp_assert_not_null`
```sql
CALL sp_assert_not_null(
    p_valor VARCHAR(255),
    p_nome_campo VARCHAR(50),
    p_codigo VARCHAR(50)
);

Se NULL: SIGNAL error
```

#### `sp_raise`
```sql
CALL sp_raise(
    p_codigo VARCHAR(50),
    p_mensagem VARCHAR(255)
);

Trunca para 128 chars
Signals: SQLSTATE 45000, MYSQL_ERRNO 1644
```

#### `sp_permissao_assert`
```sql
CALL sp_permissao_assert(
    p_id_sessao_usuario BIGINT,
    p_permissao VARCHAR(100)
);

Valida: CALL sp_sessao_tem_permissao
Se negada: SIGNAL error
```

---

### AUDITORIA (2 procs)

#### `sp_auditoria_evento_registrar`
```sql
CALL sp_auditoria_evento_registrar(
    p_id_sessao_usuario BIGINT,
    p_entidade VARCHAR(50),
    p_id_entidade BIGINT,
    p_acao VARCHAR(50),
    p_detalhe TEXT,
    p_valor_anterior JSON,
    p_tabela VARCHAR(50),
    p_id_usuario_espelho BIGINT
);

Descrição: Log de evento de negócio (CENTRAL)
Cria coluna em auditoria_evento
Usado por TODAS procedures ao final (sucesso)
```

#### `sp_auditar_erro_sql`
```sql
CALL sp_auditar_erro_sql(
    p_id_sessao_usuario BIGINT,
    p_rotina VARCHAR(100),
    p_contexto TEXT
);

Descrição: Log de erro SQL
Chamado em EXCEPTION HANDLER de procedures
INSERT auditoria_erro
```

---

### TIMEOUT (2 procs)

#### `sp_timeout_ffa`
```sql
CALL sp_timeout_ffa(
    p_id_sessao_usuario BIGINT,
    p_horas_limite INT
);

Descrição: Fecha FFAs abandonadas
UPDATE ffa status=FINALIZADO WHERE criado_em < NOW() - interval
Padrão: 14 horas
```

#### `sp_timeout_procedimento_rx`
```sql
CALL sp_timeout_procedimento_rx(
    p_id_sessao_usuario BIGINT,
    p_horas_limite INT
);

Descrição: Marca RX/procedures para reavaliar (timeout)
UPDATE fila_operacional substatus=REAVALIAR
```

---

### SCHEMA HELPERS (2 procs)

#### `sp_schema_add_column_if_missing`
```sql
CALL sp_schema_add_column_if_missing(
    p_schema VARCHAR(64),
    p_table VARCHAR(64),
    p_column VARCHAR(64),
    p_ddl TEXT
);

Descrição: Migração - adiciona coluna se não existe
ALTER TABLE ... ADD COLUMN ... IF NOT EXISTS
```

---

## 📊 TABELAS POR FREQUÊNCIA DE ACESSO

### TIER 1 (CRÍTICA - acesso constante):
```
senhas                    ← Fila primária
fila_senha               ← Sync com painel
fila_operacional         ← Roteamento
ffa                      ← Documento primário
atendimento              ← Registro visit
pessoa                   ← Dados demográficos
paciente                 ← Extensão pessoa
sessao_usuario           ← Security gate
auditoria_evento         ← Auditoria core
```

### TIER 2 (FREQUENTE - múltiplos acessos/dia):
```
atendimento_sinais_vitais
atendimento_evolucao
atendimento_diagnosticos
atendimento_prescricao
dispensacao_medicacao
administracao_medicacao
estoque_movimento
fila_operacional_evento
```

### TIER 3 (MODERADA - alguns acessos):
```
triagem
internacao
leito
painel_config
locale_operacional
usuario
```

### TIER 4 (BAIXA - referência):
```
md_cid10
md_sigtap_procedimento
md_cnes_estabelecimento
classificacao_risco
especialidade
```

---

## 🔑 ÍNDICES CRÍTICOS (Performance)

```sql
-- Fila (busca + lock)
CREATE UNIQUE INDEX uk_senhas_dia 
  ON senhas(id_sistema, id_unidade, data_ref, codigo);
CREATE INDEX idx_senhas_status_fila 
  ON senhas(status, id_local_operacional, lane, prioridade, criada_em);

-- FFA + Atendimento (lookup)
CREATE INDEX idx_ffa_atendimento 
  ON ffa(id_atendimento);
CREATE INDEX idx_atendimento_paciente 
  ON atendimento(id_paciente, data_ref);

-- Fila operacional (chamada)
CREATE INDEX idx_fila_op_tipo_status 
  ON fila_operacional(tipo, substatus, entrada_original_em);

-- Auditoria (trace)
CREATE INDEX idx_auditoria_evento_user_data 
  ON auditoria_evento(id_sessao_usuario, entidade, criado_em DESC);

-- Estoque (saldo)
CREATE UNIQUE INDEX uk_estoque_almox_produto_local 
  ON estoque_almoxarifado(id_produto, id_local_operacional);

-- Pessoa merge (CPF/CNS)
CREATE UNIQUE INDEX uk_pessoa_cpf 
  ON pessoa(cpf);
CREATE UNIQUE INDEX uk_pessoa_cns 
  ON pessoa(cns);
```

---

## 🔄 TRANSAÇÃO PATTERN

Toda procedure segue padrão:

```sql
PROCEDURE sp_xxxxx(params)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_sqlstate = RETURNED_SQLSTATE,
            v_errno = MYSQL_ERRNO,
            v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_xxxxx', v_msg);
        CALL sp_raise('ERRO_SQL', CONCAT('rotina=sp_xxxxx | state=', v_sqlstate));
    END;
    
    -- Guardrail 1: Validate session
    CALL sp_sessao_assert(p_id_sessao_usuario);
    
    -- Guardrail 2: Validate params
    CALL sp_assert_not_null(p_param1, 'param1', 'PARAM1_NULL');
    CALL sp_assert_true(p_param2 > 0, 'PARAM2_INVALID', 'param2 deve ser > 0');
    
    -- Guardrail 3: Permission check
    CALL sp_permissao_assert(p_id_sessao_usuario, 'RESOURCE:ACTION');
    
    START TRANSACTION;
    
    -- Business logic
    SELECT ... INTO ... FROM tabela WHERE ... FOR UPDATE;
    INSERT INTO ...;
    UPDATE tabela SET ... WHERE id = ...;
    
    -- Audit
    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'ENTIDADE',
        id_entidade,
        'ACAO',
        'detalhe',
        NULL,
        'tabela_name',
        NULL
    );
    
    COMMIT;
    
    -- Return
    SELECT ... OUT params;
END;
```

---

## 📈 ESTATÍSTICAS DO SCHEMA

| Métrica | Valor |
|---------|-------|
| Total Tabelas | 122 |
| Tabelas com FK | 85 |
| Procedures | 80+ |
| Functions | ~25 |
| Views | ~5 |
| Índices Únicos | 35+ |
| Índices Compostos | 45+ |
| Séries Temporais | 8 |
| Campos JSON | 12+ |
| Campos ENUM | 40+ |

---

## 🎯 TIPOS DE DADOS PADRÃO

```sql
-- IDs (primary keys)
BIGINT AUTO_INCREMENT (tabelas com crescimento esperado)
INT AUTO_INCREMENT (tabelas pequenas)

-- Datas
DATETIME (timestamps com timezone implícito UTC)
DATE (apenas datas, sem hora)

-- Strings
VARCHAR(255) - padrão geral
VARCHAR(20) - CPF, telefone, sigla
VARCHAR(10) - código curto
TEXT - narrativa, observação
JSON - dados flexíveis (config, sinais_vitais)

-- Numéricos
DECIMAL(10,2) - preço, dose, quantidade
INT - contador, identificador
TINYINT(1) - booleano
DECIMAL(4,2) - temperatura

-- Flags
TINYINT(1) - 0=false, 1=true

-- Enums
ENUM('VALUE1','VALUE2') - status, tipos (não permite NULL)
VARCHAR(50) - enum flexível (pode ser NULL)
```

---

## 🔐 PADRÃO DE ERRO

Todos erros SQL retornam com formato:
```
SQLSTATE 45000
MYSQL_ERRNO 1644
Message: [CODIGO] mensagem (max 128 chars)

Exemplos:
[SESSAO_INVALIDA] Sessão expirada ou não encontrada
[SENHA_NAO_ENCONTRADA] Senha id=142 não existe
[PERMISSAO_NEGADA] Usuário não tem RECEPCAO:CHAMAR_SENHA
[PARAM_INVALIDO] CPF inválido ou formato incorreto
[PACIENTE_EXISTE] Paciente com CPF=123.456.789-00 já existe
[ESTOQUE_INSUFICIENTE] Medicamento ABC não tem quantidade
```

Backend mapeia SQLSTATE 45000 → HTTP 400/403 + mensagem legível

---

## 🏗️ VIEWS (se desenvolvidas)

```sql
-- vw_fila_hoje
SELECT data, tipo, COUNT(*) atendidos, AVG(tempo_fila) media_tempo
FROM fila_operacional
GROUP BY data, tipo;

-- vw_estoque_alerta
SELECT id_produto, nome, quantidade_atual, min_estoque, status_alerta
FROM estoque_almoxarifado
WHERE quantidade_atual <= min_estoque;

-- vw_usuario_ativo
SELECT id_usuario, login, nome, perfil, ultima_atividade
FROM usuario
JOIN sessao_usuario USING(id_usuario)
WHERE ativo=1 AND expira_em > NOW();

-- vw_audit_acesso_prontuario
SELECT paciente_id, usuario_acesso, acao, criado_em, motivo
FROM auditoria_visualizacao_prontuario
ORDER BY criado_em DESC
LIMIT 100;
```

---

**Referência Técnica Atualizada:** 2026-02-20
**Para Desenvolvimento:** Use esta tabela como guia de chamadas ao backend
