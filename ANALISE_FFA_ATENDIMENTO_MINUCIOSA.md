# 🔍 ANÁLISE MINUCIOSA: FFA vs ATENDIMENTO

## 📊 ANÁLISE DA ESTRUTURA ATUAL

---

# 🏗️ TABELA `FFA` (Fluxo Financeiro Assistencial)

## Estrutura Atual (lines 6274-6299):

```sql
CREATE TABLE `ffa` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint DEFAULT NULL,        -- ⚠️ PROBLEMA CRÍTICO!
  `id_paciente` bigint NOT NULL,                -- ✅
  `gpat` varchar(30) DEFAULT NULL,              -- ✅
  `status` enum('ABERTO','EM_TRIAGEM',...) NOT NULL,  -- ✅
  `layout` varchar(50) DEFAULT NULL,
  `id_usuario_criacao` bigint NOT NULL,
  `id_usuario_alteracao` bigint DEFAULT NULL,
  `criado_em` datetime NOT NULL,
  `atualizado_em` datetime DEFAULT NULL,
  `classificacao_manchester` enum(...),
  `linha_assistencial` varchar(50),
  `id_senha` bigint DEFAULT NULL,
  `classificacao_cor` enum(...),
  `tempo_limite` datetime DEFAULT NULL,
  `data_criacao` datetime DEFAULT CURRENT_TIMESTAMP,
  `id_gpat` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_ffa_atendimento` (`id_atendimento`),
  CONSTRAINT `fk_ffa_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`)
);
```

### ✅ CORRETO ( PRESENTE):
| Campo | Status | Observação |
|-------|--------|------------|
| `id` | ✅ PK | OK |
| `id_paciente` | ✅ | Vincula ao paciente |
| `id_senha` | ✅ | Referência à senha de origem |
| `gpat` | ✅ | Código GPAT |
| `status` | ✅ | Estado clínico completo |
| `classificacao_manchester` | ✅ | Classificação de risco |
| `classificacao_cor` | ✅ | Cor de classificação |
| `id_usuario_criacao` | ✅ | Usuário que criou |
| `id_usuario_alteracao` | ✅ | Usuário que alterou |
| `criado_em` | ✅ | Timestamp criação |
| `atualizado_em` | ✅ | Timestamp atualização |

---

### ❌ FALTANDO ( CRÍTICO ):

| Campo | Por que é necessário |
|-------|----------------------|
| `id_saas_entidade` | **OBRIGATÓRIO** - Multi-tenant |
| `id_unidade` | **OBRIGATÓRIO** - Unidade operacional |
| `id_sessao_usuario` | Auditoria de sessão |
| `id_local_operacional` | Local atual do paciente |
| `id_local_operacional_anterior` | Histórico de localização |
| `id_profissional_principal` | Profissional responsável |
| `contexto_fluxo` | Contexto do fluxo (triagem, consulta, etc) |
| `prioridade_atendimento` | Prioridade dinâmica |
| `risco_dinamico` | Risco calculado em tempo real |

---

### 💣 PROBLEMA CRÍTICO ENCONTRADO:

```
🚨 CICLO DETECTADO: ffa → atendimento (FK)
```

```sql
-- NO MODELO ATUAL:
ffa.id_atendimento → atendimento.id_atendimento  ❌

-- DEVERIA SER:
atendimento.id_ffa → ffa.id  ✅
```

**Isso inverte a hierarquia natural do sistema!**

---

# 🏗️ TABELA `ATENDIMENTO`

## Estrutura Atual (lines 994-1009):

```sql
CREATE TABLE `atendimento` (
  `id_atendimento` bigint NOT NULL AUTO_INCREMENT,
  `id_saas_entidade` bigint NOT NULL,
  `id_unidade` bigint NOT NULL,
  `id_ffa` bigint NOT NULL,
  `id_paciente` bigint NOT NULL,
  `status_atendimento` enum('ABERTO','EM_ATENDIMENTO','EM_OBSERVACAO','FINALIZADO','CANCELADO') DEFAULT 'ABERTO',
  `data_abertura` datetime(6) NOT NULL,
  `data_fechamento` datetime(6) DEFAULT NULL,
  `criado_em` datetime(6) NOT NULL,
  `atualizado_em` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id_atendimento`),
  KEY `idx_ffa` (`id_ffa`),
  KEY `idx_paciente` (`id_paciente`),
  KEY `idx_saas` (`id_saas_entidade`)
);
```

### ✅ CORRETO ( PRESENTE):
| Campo | Status | Observação |
|-------|--------|------------|
| `id_atendimento` | ✅ PK | OK |
| `id_saas_entidade` | ✅ | Multi-tenant! |
| `id_unidade` | ✅ | Unidade operacional! |
| `id_ffa` | ✅ | Referência à FFA |
| `id_paciente` | ✅ | Paciente |
| `status_atendimento` | ✅ | Estado |
| `data_abertura` | ✅ | Início |
| `data_fechamento` | ✅ | Término |
| `criado_em` | ✅ | Timestamp |
| `atualizado_em` | ✅ | Timestamp |

---

### ❌ FALTANDO ( CRÍTICO ):

| Campo | Por que é necessário |
|-------|----------------------|
| `id_sessao_usuario` | Auditoria de sessão |
| `id_usuario_abertura` | Quem abriu |
| `id_usuario_responsavel` | Profissional responsável |
| `id_local_operacional` | Local atual |
| `tipo_atendimento` | Tipo (consulta, emergência, etc) |
| `id_especialidade` | Especialidade do atendimento |
| `natureza_atendimento` | SUS/Convênio/Particular |
| `motivo` | Motivo da visita |
| `id_senha` | Senha de origem |
| `contexto_fluxo` | Contexto operacional |

---

# 🔄 ANÁLISE DO FLUXO ATUAL

## Fluxo Detectado (PROBLEMA):

```
senha (origem)
   ↓
atendimento (CRIA FFA primeiro!)
   ↓
ffa.id_atendimento → atendimento  ❌ CICLO!
   ↓
atendimento_evento
```

## Fluxo CORRETO (ESPERADO):

```
senha (origem)
   ↓
ffa (caso clínico - RAIZ)
   ↓
atendimento (execução operacional - DEPENDE DE FFA!)
   ↓
atendimento_evento
```

---

# 🎯 VERIFICAÇÃO: PONTOS QUE BATEM

## ✅ O que está correto:

| Ponto | Status | Observação |
|-------|--------|------------|
| FFA → paciente | ✅ | `id_paciente` presente |
| FFA → senha | ✅ | `id_senha` presente |
| atendimento → ffa | ✅ | `id_ffa` presente |
| atendimento → saas | ✅ | `id_saas_entidade` presente |
| atendimento → unidade | ✅ | `id_unidade` presente |
| atendimento → paciente | ✅ | `id_paciente` presente |

---

# ❌ O QUE FALTA (RESUMO)

## Em `ffa`:

| # | Campo | Prioridade |
|---|-------|------------|
| 1 | `id_saas_entidade` | 🔴 CRÍTICA |
| 2 | `id_unidade` | 🔴 CRÍTICA |
| 3 | `id_sessao_usuario` | 🟡 ALTA |
| 4 | `id_local_operacional` | 🟡 ALTA |
| 5 | `id_profissional_principal` | 🟡 ALTA |
| 6 | Remover `id_atendimento` | 🔴 CRÍTICA |

## Em `atendimento`:

| # | Campo | Prioridade |
|---|-------|------------|
| 1 | `id_sessao_usuario` | 🟡 ALTA |
| 2 | `id_usuario_abertura` | 🟡 ALTA |
| 3 | `id_usuario_responsavel` | 🟡 ALTA |
| 4 | `id_local_operacional` | 🟡 ALTA |
| 5 | `tipo_atendimento` | 🟡 ALTA |
| 6 | `natureza_atendimento` | 🟡 ALTA |
| 7 | `id_senha` | 🟡 ALTA |

---

# 🚀 PLANO DE CORREÇÃO

## STAGE 1: CORRIGIR FFA (CRÍTICO)

```sql
-- 1. Adicionar campos multi-tenant
ALTER TABLE `ffa` 
  ADD COLUMN `id_saas_entidade` bigint NOT NULL AFTER `id`,
  ADD COLUMN `id_unidade` bigint NOT NULL AFTER `id_saas_entidade`;

-- 2. Adicionar campos operacionais
ALTER TABLE `ffa`
  ADD COLUMN `id_sessao_usuario` bigint DEFAULT NULL AFTER `id_unidade`,
  ADD COLUMN `id_local_operacional` bigint DEFAULT NULL AFTER `id_sessao_usuario`,
  ADD COLUMN `id_local_operacional_anterior` bigint DEFAULT NULL AFTER `id_local_operacional`,
  ADD COLUMN `id_profissional_principal` bigint DEFAULT NULL AFTER `id_local_operacional_anterior`,
  ADD COLUMN `contexto_fluxo` varchar(60) DEFAULT NULL AFTER `id_profissional_principal`,
  ADD COLUMN `prioridade_atendimento` int DEFAULT '0' AFTER `contexto_fluxo`,
  ADD COLUMN `risco_dinamico` varchar(20) DEFAULT NULL AFTER `prioridade_atendimento`;

-- 3. ⚠️ REMOVER FK PROBLEMÁTICA (cuidado com dados!)
-- Primeiro verificar se há dados usando id_atendimento
SELECT id, id_atendimento FROM ffa WHERE id_atendimento IS NOT NULL;

-- Se houver dados, migrar primeiro:
-- UPDATE ffa f 
--   INNER JOIN atendimento a ON f.id = a.id_ffa 
--   SET f.id_atendimento = a.id_atendimento;

-- Depois remover a FK:
-- ALTER TABLE ffa DROP FOREIGN KEY fk_ffa_atendimento;
-- ALTER TABLE ffa DROP COLUMN id_atendimento;
```

## STAGE 2: ENRIQUECER ATENDIMENTO

```sql
ALTER TABLE atendimento
  ADD COLUMN `id_sessao_usuario` bigint DEFAULT NULL AFTER `id_unidade`,
  ADD COLUMN `id_usuario_abertura` bigint DEFAULT NULL AFTER `id_sessao_usuario`,
  ADD COLUMN `id_usuario_responsavel` bigint DEFAULT NULL AFTER `id_usuario_abertura`,
  ADD COLUMN `id_local_operacional` bigint DEFAULT NULL AFTER `id_usuario_responsavel`,
  ADD COLUMN `tipo_atendimento` enum('CONSULTA','EMERGENCIA','INTERNACAO','PROCEDIMENTO','EXAME') DEFAULT 'CONSULTA' AFTER `id_local_operacional`,
  ADD COLUMN `id_especialidade` bigint DEFAULT NULL AFTER `tipo_atendimento`,
  ADD COLUMN `natureza_atendimento` enum('SUS','CONVENIO','PARTICULAR') DEFAULT 'SUS' AFTER `id_especialidade`,
  ADD COLUMN `motivo` varchar(500) DEFAULT NULL AFTER `natureza_atendimento`,
  ADD COLUMN `id_senha` bigint DEFAULT NULL AFTER `motivo`;
```

---

# 📊 FLUXO CORRIGIDO

## Hierarquia FINAL:

```
┌─────────────────────────────────────────────┐
│           SaaS (id_saas_entidade)           │
└─────────────────────┬───────────────────────┘
                      ↓
┌─────────────────────────────────────────────┐
│              UNIDADE (id_unidade)            │
└─────────────────────┬───────────────────────┘
                      ↓
┌─────────────────────────────────────────────┐
│  SENHA (ticket de entrada)                   │
│  - id_senha                                   │
│  - id_paciente                                │
│  - id_saas_entidade ✓                        │
│  - id_unidade ✓                              │
└─────────────────────┬───────────────────────┘
                      ↓
┌─────────────────────────────────────────────┐
│  FFA (CASO CLÍNICO - RAIZ)                   │
│  - id (PK)                                    │
│  - id_senha ✓                                 │
│  - id_paciente ✓                             │
│  - id_saas_entidade ✓ [FALTA ADICIONAR]      │
│  - id_unidade ✓ [FALTA ADICIONAR]            │
│  - id_local_operacional [FALTA]              │
│  - contexto_fluxo                             │
│  - status (estado clínico)                    │
└─────────────────────┬───────────────────────┘
                      ↓
┌─────────────────────────────────────────────┐
│  ATENDIMENTO (execução operacional)          │
│  - id_atendimento (PK)                       │
│  - id_ffa ✓ (FK para FFA)                    │
│  - id_saas_entidade ✓                        │
│  - id_unidade ✓                              │
│  - id_local_operacional [FALTA]              │
│  - tipo_atendimento [FALTA]                  │
└─────────────────────┬───────────────────────┘
                      ↓
┌─────────────────────────────────────────────┐
│  MÓDULOS ESPECIALIZADOS                      │
│  - anamnese (vinculada a FFA)                │
│  - diagnostico (vinculado a FFA)            │
│  - evolucao (vinculada a FFA)                │
│  - prescricao (vinculada a FFA)              │
│  - estoque_movimento (vinculado a FFA)       │
└─────────────────────────────────────────────┘
```

---

# 🎯 CONCLUSÃO

## ✅ O que bate com a análise anterior:

1. **FFA é a raiz clínica** - Confirmado
2. **atendimento depende de FFA** - Confirmado (tem id_ffa)
3. **Modelo SaaS parcial** - atendimento tem, FFA NÃO tem

## ❌ O que falta:

1. **id_saas_entidade em FFA** - CRÍTICO
2. **id_unidade em FFA** - CRÍTICO  
3. **Remover ciclo FFA → atendimento** - CRÍTICO
4. **Campos operacionais em ambas** - ALTO

## 🧠 REGRA DEFINITIVA:

> **FFA = RAIZ CLÍNICA**
> **atendimento = DEPENDENTE DE FFA**
> **Qualquer saída (estoque, faturamento, etc) = vinculada a FFA**

---

*Documento gerado a partir da análise minuciosa do Dump20260324.sql*
