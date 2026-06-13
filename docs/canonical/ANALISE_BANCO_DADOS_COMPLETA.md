# 📊 ANÁLISE COMPLETA DO BANCO DE DADOS - PRONTO ATENDIMENTO

## 🔍 RESUMO EXECUTIVO

| Métrica | Valor |
|---------|-------|
| **Total de Tabelas** | ~300+ |
| **Banco** | MySQL 8.0 |
| **Encoding** | utf8mb4 |
| **Collation** | utf8mb4_unicode_ci / utf8mb4_0900_ai_ci |
| **Arquitetura** | SaaS Multi-tenant com suporte a edge/offline |

---

# 🧱 1. MAPA DE CLASSIFICAÇÃO DAS TABELAS

## 🔴 CORE (NÚCLEO - NÃO MEXER)

Estas são as tabelas fundamentais que sustentam toda a arquitetura do sistema.

| Tabela | Descrição | Campos Principais | Observação |
|--------|-----------|------------------|------------|
| `senha` | Ticket/fila de atendimento | id_senha, id_saas_entidade, id_unidade, codigo_visual, prioridade, id_fluxo_status, contexto_fluxo, id_ffa, id_paciente | ✅ Ja tem id_saas_entidade e id_unidade |
| `ffa` | Fluxo Financeiro Assistencial (caso clínico) | id, id_saas_entidade, id_unidade, id_pessoa, id_paciente, id_senha, estado, contexto_fluxo | ✅ Estrutura SaaS completa |
| `paciente` | Cadastro de pacientes | id, id_saas_entidade, id_pessoa, nome, data_nascimento, cpf, cns | ✅ Ja multi-tenant |
| `atendimento` | Registro de atendimento | id_atendimento, id_saas_entidade, id_unidade, id_ffa, id_paciente, status_atendimento | ✅ Completo |
| `atendimento_evento` | Log de eventos do atendimento | id_evento, id_saas_entidade, id_unidade, id_ffa, id_atendimento, dominio, tipo_evento | ✅ Motor de eventos principal |

### Hierarquia Confirmada:
```
senha → ffa → paciente → atendimento → atendimento_evento
   ↓
id_saas_entidade (multi-tenant)
id_unidade (unidade operacional)
```

---

## 🟡 OPERACIONAIS (DOMÍNIO DO NEGÓCIO)

### 1. Módulo de Recepção e Triagem

| Tabela | Descrição | Problema |
|--------|-----------|----------|
| `triagem` | Dados da triagem | ✅ Estruturada |
| `atendimento_triagem` | Triagem por atendimento | ⚠️ Duplicação com triagem? |
| `classificacao_risco` | Classificação de risco | ✅ Referência |
| `fila_operacional` | Fila operacional | ✅ Estruturada |
| `fila_senha` | Vinculo senha-fila | ✅ Estruturada |

### 2. Módulo Assistencial

| Tabela | Descrição | Problema |
|--------|-----------|----------|
| `atendimento_anamnese` | Anamnese por FFA | ⚠️ POSSÍVEL DUPLICAÇÃO |
| `anamnese` | Anamnese por atendimento | ⚠️ POSSÍVEL DUPLICAÇÃO |
| `atendimento_diagnostico` | Diagnóstico por FFA | ⚠️ POSSÍVEL DUPLICAÇÃO |
| `atendimento_diagnosticos` | Diagnóstico por atendimento | ⚠️ POSSÍVEL DUPLICAÇÃO |
| `atendimento_evolucao` | Evolução clínica por FFA | ✅ Estruturado |
| `atendimento_exame_fisico` | Exame físico por FFA | ✅ Estruturado |
| `prescricao` | Prescrições | ✅ Múltiplas versões |
| `prescricao_medica` | Prescrição médica | |
| `prescricao_internacao` | Prescrição internação | |
| `evolucao_medica` | Evolução médica | ⚠️ Duplicação potencial |
| `evolucao_enfermagem` | Evolução enfermagem | ⚠️ Duplicação potencial |

### 3. Módulo de Internação

| Tabela | Descrição |
|--------|-----------|
| `internacao` | Registro de internação |
| `internacao_prescricao` | Prescrição de internação |
| `internacao_movimentacao` | Movimentação leitos |
| `leito` | Cadastro de leitos |
| `hospital_leitos` | Configuração leitos |

### 4. Módulo Social eween Assistance

| Tabela | Descrição |
|--------|-----------|
| `assistencia_social_atendimento` | Atendimento social |
| `assistencia_social_evento` | Eventos social |
| `acompanhante` | Acompanhantes |
| `prioridade_social` | Priorização social |

### 5. Módulo de Agenda e Agendamento

| Tabela | Descrição |
|--------|-----------|
| `agendamento` | Agendamentos |
| `agenda_disponibilidade` | Disponibilidade profissional |
| `agendamentos_eventos` | Eventos de agendamento |
| `servico_agendamento` | Serviços agendáveis |

### 6. Módulo de Alertas

| Tabela | Descrição |
|--------|-----------|
| `alerta` | Cadastro de alertas |
| `alerta_consumo` | Consumo de alertas |
| `alerta_destinatario` | Destinatários |
| `alerta_regra` | Regras de alerta |

### 7. Módulo de Estoque/Farmácia

| Tabela | Descrição |
|--------|-----------|
| `estoque_item` | Itens de estoque |
| `estoque_movimentacao` | Movimentações |
| `estoque_produto` | Produtos |
| `farm_dispensacao` | Dispensação farmácia |
| `gpat` | Dispensação GPAT |

---

## 🟢 AUTH E SESSÃO (CORE DE SEGURANÇA)

| Tabela | Descrição | Status |
|--------|-----------|--------|
| `usuario` | Cadastro de usuários | ✅ |
| `sessao_usuario` | Sessões ativas | ✅ |
| `perfil` | Perfis de acesso | ✅ |
| `permissao` | Permissões | ✅ |
| `usuario_perfil` | Vinculo usuário-perfil | ✅ |
| `auth_token` | Tokens de autenticação | ✅ |
| `usuario_refresh_token` | Refresh tokens | ✅ |

---

## 🔵 MULTI-TENANT E CONTEXTO

| Tabela | Descrição | Status |
|--------|-----------|--------|
| `saas_entidade` | Entidades SaaS (clientes) | ✅ |
| `unidade` | Unidades operacionais | ✅ |
| `local_operacional` | Locais internos | ✅ |
| `sistema` | Sistemas registrados | ✅ |
| `tenant_registry` | Registro de tenants | ✅ |

---

## 🟣 RUNTIME E DISTRIBUÍDO (TÉCNICO)

### Tabelas de Estado e Sincronismo

| Tabela | Descrição |
|--------|-----------|
| `assistencial_checkpoint_global` | Checkpoint global |
| `assistencial_snapshot_runtime` | Snapshots de estado |
| `assistencial_runtime_federado` | Estado federado |
| `assistencial_runtime_panel` | Painel runtime |
| `assistencial_watchdog_fila` | Monitor fila |
| `assistencial_telemetria_runtime` | Telemetria |
| `assistencial_quorum_clinico` | Quorum clínico |

### Tabelas de Ledger e Auditoria

| Tabela | Descrição |
|--------|-----------|
| `atendimento_evento_ledger` | Ledger de eventos |
| `kernel_ledger` | Ledger do kernel |
| `auditoria_evento` | Auditoria de eventos |
| `log_auditoria` | Log geral |
| `ledger_evento_sincronizacao` | Sincronização |

### Tabelas de Lock e Concorrência

| Tabela | Descrição |
|--------|-----------|
| `runtime_lock_semantico` | Locks semânticos |
| `runtime_concurrency_guard` | Guards de concorrência |
| `kernel_single_writer_lock` | Lock writers |
| `kernel_runtime_single_writer_lock` | Runtime locks |

---

# ⚠️ 2. PROBLEMAS IDENTIFICADOS

## 🔴 PROBLEMA 1: Multi-Tenant Incompleto

### Tabelas QUE TÊM id_saas_entidade:
```sql
agendamento
atendimento
atendimento_anamnese
atendimento_diagnostico
atendimento_evolucao
atendimento_exame_fisico
atendimento_evento
atendimento_evento_ledger
assistencia_social_atendimento
ffa
paciente
senha
agenda_disponibilidade
```

### Tabelas que NÃO TÊM id_saas_entidade:
```sql
anamnese         -- ❌ DEPENDE DE atendimento (indireto)
diagnostico      -- ❌ DEPENDE DE atendimento
prescricao       -- ❌ genérica
prescricao_medica
evolucao_medica
evolucao_enfermagem
atendimento_diagnosticos  -- diferente de atendimento_diagnostico
triagem
internacao
leito
local_operacional  -- ⚠️ precisa contexto
```

### ✅ CORREÇÃO NECESSÁRIA:
Todas as tabelas do domínio clínico DEVEM ter:
```sql
id_saas_entidade  -- obrigatório
id_unidade        -- obrigatório para operações
id_ffa           -- referência ao caso clínico (quando aplicável)
id_usuario       -- usuário da operação
id_sessao_usuario -- sessão do usuário
criado_em        -- timestamp
```

---

## 🔴 PROBLEMA 2: Duplicação de Dados Clínicos

### 🔍 Anamnese - 2 TABELS:

| Campo | `anamnese` | `atendimento_anamnese` |
|-------|-----------|------------------------|
| id | id_anamnese | id |
| Vinculo | id_atendimento | id_ffa |
| Campos | descricao, id_usuario | queixa_principal, historico_doenca, antecedentes_pessoais |
| Auditoria | básico | completo (ip, device_info, sessao) |

**DIAGNÓSTICO**: 
- `anamnese` = modelo antigo (vinculado a atendimento)
- `atendimento_anamnese` = modelo novo (vinculado a FFA, mais completo)

**AÇÃO**: Migrar dados de `anamnese` para `atendimento_anamnese`, depois dropar `anamnese`

---

### 🔍 Diagnóstico - 2 TABELAS:

| Campo | `atendimento_diagnosticos` | `atendimento_diagnostico` |
|-------|---------------------------|--------------------------|
| id | id | id |
| Vinculo | id_atendimento | id_ffa |
| Campos | codigo_cid, descricao, tipo | codigo_cid, principal, ip_origem |
| Auditoria | básico | completo |

**DIAGNÓSTICO**: Mesmo problema - modelo velho vs novo

**AÇÃO**: Unificar em `atendimento_diagnostico` (mais completo)

---

### 🔍 Evolução - MÚLTIPLAS TABELAS:

```
atendimento_evolucao    → evolução por FFA (nova)
evolucao_medica         → evolução médica (velha?)
evolucao_enfermagem     → evolução enfermagem (velha?)
evolucao_multidisciplinar
ffa_evolucao            → evolução na FFA
prontuario_evolucao     → evolução no prontuário
```

**DIAGNÓSTICO**: Excesso de tabelas de evolução

**AÇÃO**: Consolidar em `atendimento_evolucao` como modelo canônico

---

## 🔴 PROBLEMA 3: Campos Obrigatórios Ausentes

### Padrão Atual (parte das tabelas):
```sql
id_saas_entidade  -- ✅ presente
id_unidade        -- ✅ presente
id_ffa            -- ⚠️ inconsistente
id_usuario        -- ⚠️ inconsistente
id_sessao_usuario -- ⚠️ inconsistente
criado_em         -- ⚠️ inconsistente
```

### Padrão CORRETO (deveria ser):
```sql
-- OBRIGATÓRIOS:
id_saas_entidade  bigint NOT NULL  -- multi-tenant
id_unidade        bigint NOT NULL  -- unidade operacional
criado_em        datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)

-- OPICIONAIS (conforme contexto):
id_ffa           bigint DEFAULT NULL   -- caso clínico
id_paciente      bigint DEFAULT NULL   -- paciente
id_usuario       bigint DEFAULT NULL   -- usuário responsável
id_sessao_usuario bigint DEFAULT NULL  -- sessão do usuário
atualizado_em    datetime(6) DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(6)

-- AUDITORIA:
criado_por       bigint NOT NULL
id_sessao_criacao bigint DEFAULT NULL
hash_estado      char(64) DEFAULT NULL  -- para sync
uuid_sync        char(36) DEFAULT NULL  -- identificação única
versao_sync      bigint DEFAULT 0       -- versão para sync
```

---

# 📋 3. ANÁLISE DETALHADA POR MÓDULO

## 🔍 MÓDULO: SENHA (ENTRY POINT)

### Estrutura Atual:
```sql
senha (
  id_senha PK
  id_saas_entidade NOT NULL  ✅
  id_unidade NOT NULL         ✅
  id_local DEFAULT NULL
  codigo_visual NOT NULL
  prioridade DEFAULT 0
  id_fluxo_status NOT NULL
  contexto_fluxo NOT NULL
  id_atendimento NULL
  id_ffa NULL
  id_paciente NULL
  origem NOT NULL
  dispositivo
  id_sessao_usuario
  ordem_fila DEFAULT 0
  chamada_sequencial DEFAULT 0
  chamado_em
  executado_em
  cancelado DEFAULT 0
  cancelado_em
  cancelado_por
  nao_compareceu DEFAULT 0
  nao_compareceu_em
  retorno_permitido_ate
  retorno_utilizado DEFAULT 0
  retorno_em
  uuid_sync
  versao_sync DEFAULT 0
  hash_estado
  estado_snapshot JSON
  criado_em
  atualizado_em
  risco_dinamico
  risco_dinamico_em
  risco_dinamico_origem
)
```

### ✅ CORRETO:
- Multi-tenant completo
- Tracking de risco dinâmico
- Suporte a sync (uuid, versao, hash)
- Contexto de sessão

### ⚠️ MELHORIAS POSSÍVEIS:
```sql
-- Adicionar:
id_senha_original   bigint DEFAULT NULL  -- para retornos
motivo_cancelamento varchar(255) DEFAULT NULL
motivo_nao_compareceu varchar(255) DEFAULT NULL
```

---

## 🔍 MÓDULO: FFA (Caso Clínico)

### Estrutura Atual:
```sql
ffa (
  id PK
  id_saas_entidade NOT NULL  ✅
  id_unidade NOT NULL         ✅
  id_senha NULL
  id_pessoa NOT NULL
  id_paciente NOT NULL
  gpat VARCHAR
  estado NOT NULL
  contexto_fluxo NOT NULL
  prioridade DEFAULT 0
  id_local_operacional_atual
  id_local_operacional_anterior
  ...
)
```

### ✅ CORRETO:
- Vinculado a senha (origem)
- Multi-tenant completo
- Tracking de estado

### ⚠️ FALTA:
```sql
-- Para completo ciclo de vida:
id_atendimento          bigint DEFAULT NULL  -- vínculo direto
data_inicio_atendimento  datetime
data_fim_atendimento    datetime
status_clinico          varchar(50)  -- ALTA, INTERNADO, TRANSFERIDO, OBITO
```

---

## 🔍 MÓDULO: ATENDIMENTO

### Estrutura Atual:
```sql
atendimento (
  id_atendimento PK
  id_saas_entidade NOT NULL  ✅
  id_unidade NOT NULL         ✅
  id_ffa NOT NULL
  id_paciente NOT NULL
  status_atendimento
  data_abertura
  data_fechamento
  criado_em
  atualizado_em
)
```

### ⚠️ PROBLEMA: Tabela muito simples
Não contempla:
- Tipo de atendimento (consulta, emergência, internação)
- Especialidade
- Profissional responsável
- Motivo da visita
- Natureza do atendimento (SUS, convênio, particular)

### ✅ CORREÇÃO:
```sql
ALTER TABLE atendimento ADD COLUMN:
  tipo_atendimento        enum('CONSULTA','EMERGENCIA','INTERNACAO','PROCEDIMENTO','EXAME')
  id_especialidade        bigint DEFAULT NULL
  id_profissional         bigint DEFAULT NULL
  motivo                  varchar(500) DEFAULT NULL
  natureza                enum('SUS','CONVENIO','PARTICULAR') DEFAULT 'SUS'
```

---

## 🔍 MÓDULO: EVENTOS (LEDGER)

### Tabelas de Evento Identificadas:

| Tabela | Uso | Status |
|--------|-----|--------|
| `atendimento_evento` | Eventos principal | ✅ Completo |
| `atendimento_evento_ledger` | Ledger append-only | ✅ Completo |
| `senha_eventos` | Eventos de senha | ✅ Completo |
| `fila_operacional_evento` | Eventos fila | ✅ |
| `assistencia_social_evento` | Eventos social | ✅ |
| `auditoria_evento` | Auditoria | ✅ |
| `evento_ffa` | Eventos FFA | ⚠️ pode ser redundante |

### ✅ CORRETO: Modelo de eventos está bem estruturado

### ⚠️ CONSOLIDAR:
Eliminar redundâncias e ter APENAS:
- `atendimento_evento` como source of truth
- `atendimento_evento_ledger` para auditoria append-only
- Evento específico por módulo (se necessário)

---

# 🚀 4. PLANO DE CORREÇÃO POR ESTÁGIO

## 🔴 STAGE 1: CORREÇÃO MULTI-TENANT (CRÍTICO)

### 1.1 Adicionar id_saas_entidade onde falta:

```sql
-- Tabelas que precisam de id_saas_entidade:
ALTER TABLE anamnese ADD COLUMN id_saas_entidade bigint NOT NULL AFTER id_anamnese;
ALTER TABLE anamnese ADD COLUMN id_unidade bigint NOT NULL AFTER id_saas_entidade;

ALTER TABLE diagnostico ADD COLUMN id_saas_entidade bigint NOT NULL;
ALTER TABLE diagnostico ADD COLUMN id_unidade bigint NOT NULL;

-- E assim por diante para todas as tabelas do domínio clínico
```

### 1.2 Padronizar campos obrigatórios:

```sql
-- Criar procedure para padronização
CREATE PROCEDURE sp_padroniza_campos_auditoria()
BEGIN
  -- Adicionar em todas as tabelas do domínio:
  -- id_saas_entidade, id_unidade, criado_em, criado_por
END;
```

---

## 🟡 STAGE 2: CONSOLIDAÇÃO DE DUPLICATAS

### 2.1 Anamnese → atendimento_anamnese

```sql
-- Migrar dados
INSERT INTO atendimento_anamnese 
  (id_saas_entidade, id_unidade, id_ffa, id_usuario, id_sessao_usuario, 
   historico_doenca, ip_origem, criado_em)
SELECT 
  a.id_saas_entidade, at.id_unidade, at.id_ffa, a.id_usuario, NULL,
  a.descricao, NULL, a.data_hora
FROM anamnese a
JOIN atendimento at ON a.id_atendimento = at.id_atendimento;

-- Após migração:
DROP TABLE anamnese;
```

### 2.2 Diagnosticos → atendimento_diagnostico

```sql
-- Similar, migrar e consolidar
```

---

## 🟡 STAGE 3: ENRIQUECIMENTO DO ATENDIMENTO

```sql
ALTER TABLE atendimento ADD COLUMN:
  tipo_atendimento enum('CONSULTA','EMERGENCIA','INTERNACAO','PROCEDIMENTO','EXAME') DEFAULT 'CONSULTA',
  id_especialidade bigint DEFAULT NULL,
  id_profissional_principal bigint DEFAULT NULL,
  motivo_atendimento text,
  natureza_atendimento enum('SUS','CONVENIO','PARTICULAR') DEFAULT 'SUS',
  id_local_atual bigint DEFAULT NULL,
  data_inicio datetime(6) DEFAULT NULL,
  data_termino datetime(6) DEFAULT NULL;
```

---

## 🔵 STAGE 4: IMPLEMENTAR CAMPOS PADRÃO

### Padrão Opcional para todas as tabelas:

```sql
-- Tabela exemplo:
CREATE TABLE exemplo (
  id_exemplo bigint NOT NULL AUTO_INCREMENT,
  
  -- 🔴 MULTI-TENANT (OBRIGATÓRIO)
  id_saas_entidade bigint NOT NULL,
  id_unidade bigint NOT NULL,
  
  -- 📝 DADOS DO REGISTRO
  campo1 varchar(255),
  campo2 text,
  
  -- 🕐 TIMESTAMPS (OBRIGATÓRIO)
  criado_em datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  atualizado_em datetime(6) DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(6),
  
  -- 👤 AUDITORIA BÁSICA
  criado_por bigint DEFAULT NULL,
  id_sessao_criacao bigint DEFAULT NULL,
  
  -- 🔄 SYNC (para sistemas distribuídos)
  uuid_sync char(36) DEFAULT NULL,
  versao_sync bigint DEFAULT 0,
  hash_estado char(64) DEFAULT NULL,
  
  PRIMARY KEY (id_exemplo),
  KEY idx_tenant (id_saas_entidade, id_unidade),
  KEY idx_sync (uuid_sync)
);
```

---

## 🟣 STAGE 5: LIMPEZA DE TABELAS TÉCNICAS

### Tabelas que podem ser consolidadas/_removidas:

| Tabela | Ação | Motivo |
|--------|------|--------|
| `evento_ffa` | Analisar | Pode ser redundante com `atendimento_evento` |
| `evento_geral` | Analisar | Genérica demais |
| `observacoes_eventos` | Analisar | Propósito overlap |
| Runtime locks | Manter | São técnicas e necessárias |

---

# 📊 5. RESUMO: O QUE FALTA PARA SaaS COMPLETO

## ✅ JÁ TEM:
- [x] Entidades SaaS (saas_entidade)
- [x] Unidades (unidade)
- [x] Sistema multi-tenant (senha, ffa, atendimento)
- [x] Eventos e ledger
- [x] Auth e permissões
- [x] Suporte a sync offline

## ❌ FALTA IMPLEMENTAR:

| Item | Prioridade | Esforço |
|------|------------|---------|
| id_saas_entidade em todas tabelas clínicas | 🔴 Alta | Médio |
| Padronizar campos de auditoria | 🔴 Alta | Médio |
| Consolidar anamnese/diagnostico | 🟡 Média | Alto |
| Enriquecher atendimento | 🟡 Média | Baixo |
| Definir FKs entre módulos | 🟡 Média | Alto |
| Documentar modelo de eventos | 🟢 Baixa | Médio |

---

# 🎯 CONCLUSÃO

## Diagnóstico Final:

Seu banco NÃO está errado. Está **AVANÇADO mas INCOMPLETO**.

### O que você construiu é impressionante:
- ✅ Modelo de tickets/senhas robusto
- ✅ FFA como centro do universo clínico
- ✅ Sistema de eventos completo
- ✅ Suporte a edge/federado
- ✅ Checkpoints e quorum clínico

### O que precisa ajustar:
- ❌ Multi-tenant não está 100% consistente
- ❌ Algumas duplicações de dados clínicos
- ❌ Campos de auditoria não padronizados

### Próximo passo recomendado:
1. Criar script de auditoria de campos faltantes
2. Aplicar Stage 1 (multi-tenant)
3. Consolidar duplicatas
4. Documentar

---

*Documento gerado automaticamente a partir do Dump20260324.sql*
*Total de tabelas analisadas: ~300+*
