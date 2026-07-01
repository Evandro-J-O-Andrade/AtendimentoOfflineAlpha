# MD-AUDITORIA-002 — Core Enterprise Catalog & Alignment

## Status
Documento de Auditoria Arquitetural.  
Mapeamento do Core existente vs. necessário para NEW WAVE Enterprise Platform.

---

## Sumário
- 01. [Core Enterprise Atual (existente no banco)](#core-enterprise-atual-existente-no-banco)
- 02. [Gaps Identificados](#gaps-identificados)
- 03. [Alinhamento Portal First](#alinhamento-portal-first)
- 04. [Roteiro de Ação](#roteiro-de-ação)

---

## 01. Core Enterprise Atual (existente no banco)

### 1.1 IAM / Auth Foundation
| Componente | Tipo | Status | Observações |
|------------|------|--------|-------------|
| `pessoa` | Tabela | ✅ EXISTS | Tabela mestre de identidade humana |
| `usuario` | Tabela | ✅ EXISTS | Credentials + vínculo com pessoa |
| `saas_entidade` | Tabela | ✅ EXISTS | Tenant/root da plataforma |
| `auth_sessao` | Tabela | ✅ EXISTS | Sessão com token, tenant, unidade, local, perfil |
| `auth_token` | Tabela | ✅ EXISTS | Token de autenticação |
| `perfil` | Tabela | ✅ EXISTS | Perfil de acesso (papel) |
| `permissao` | Tabela | ✅ EXISTS | Permissões com `dominio`, `modulo`, `grupo_menu`, `icone`, `ordem_menu` |
| `perfil_permissao` | Tabela | ✅ EXISTS | N:N perfil ↔ permissao |
| `usuario_perfil` | Tabela | ✅ EXISTS | N:N usuario ↔ perfil |
| `usuario_unidade` | Tabela | ✅ EXISTS | N:N usuario ↔ unidade (vínculo organizacional) |
| `usuario_local` | Tabela | ✅ EXISTS | N:N usuario ↔ local/sala (contexto operacional) |

### 1.2 SPs Core Auth
| SP | Status | Função | Alinhamento Portal First |
|----|--------|--------|-------------------------|
| `sp_auth_contexto_get` | ✅ EXISTS | Lista unidades, perfis, locais, contexto atual | ⚠️ **Contexto carregado após login** - precisa ser repensado |
| `sp_auth_contexto_set` | ✅ EXISTS | Define unidade+local+perfil na sessão | ⚠️ **Contexto definido antes de escolher módulo** - anti-pattern |
| `sp_auth_menu_get` | ✅ EXISTS | Monta menu dinâmico por perfil+local | ⚠️ Requer contexto predefinido - **bloqueio para Portal First** |
| `sp_master_login` | ✅ EXISTS | Login monolítico sem contexto inicial | ✅ **JOIA** - já não define contexto |
| `sp_master_routes` | ✅ EXISTS | Orquestrador central | ⚠️ Referencia `sp_auth_assert` que NÃO EXISTE |
| `sp_auth_assert` | ❌ MISSING | Validação de sessão+contexto | 🔴 **CRÍTICO** - falta no dump |

### 1.3 Runtime / Dispatcher
| Componente | Tipo | Status | Observações |
|------------|------|--------|-------------|
| `sp_dispatcher_kernel` | SP | ✅ EXISTS | Enfileira em `runtime_execution_queue` |
| `runtime_execution_queue` | Tabela | ✅ EXISTS | Fila UUID-based, status PENDENTE/CONCLUIDO |
| `runtime_contexto` | Tabela | ✅ EXISTS | Contexto clínico: unidade, local, paciente, ffa |
| `runtime_api_session_token` | Tabela | ✅ EXISTS | Token UUID por sessão (stateless auth) |
| `runtime_lock_semantico` | Tabela | ✅ EXISTS | Lock distribuído |
| `runtime_kernel_locks` | Tabela | ✅ EXISTS | Lock de escrita no dispatcher |

### 1.4 Ledger / Event Store
| SP | Status | Tabela | Observações |
|----|--------|--------|-------------|
| `sp_ledger_registrar_evento` | ✅ EXISTS | `atendimento_evento_ledger` | Registro canônico com fingerprint |
| `sp_ledger_evento_log` | ✅ EXISTS | `atendimento_evento_ledger` | Append-only log |
| `atendimento_evento_ledger` | Tabela | ✅ EXISTS | Evento imutável, UUID, sequência |
| `auditoria_*` | Tabelas | ✅ EXISTS | Multiple audit trails |
| `ledger_*` (raw) | Tabelas | ⚠️ RAW ONLY | Existem em raw JSON, sem docs .md |

---

## 02. Gaps Identificados

### 02.1 🔴 Críticos
| Gap | Severidade | Solução |
|-----|------------|---------|
| `sp_auth_assert` inexistente | 🔴 CRÍTICA | Criar procedure de validação de sessão |
| `sp_auth_menu_get` requer contexto pré-definido | 🔴 CRÍTICA | Refatorar para menu por módulo sem contexto obrigatório |
| Tabela `permissao_local` sem documentação | 🔴 CRÍTICA | Documentar e validar existência |

### 02.2 🟡 Médios
| Gap | Severidade | Solução |
|-----|------------|---------|
| Nomenclatura `sp_auth_contexto_*` não reflete Portal First | 🟡 MÉDIA | Renomear para `sp_module_context_*` |
| Nenhuma tabela `aplicacao` / `application` canônica | 🟡 MÉDIA | Criar tabela para registrar módulos da platforma |
| Nenhuma tabela `workspace` | 🟡 MÉDIA | Criar para estado operacional do usuário |
| Nenhuma SP `sp_workspace_*` | 🟡 MÉDIA | Implementar ciclo de vida workspace |
| Nenhuma SP `sp_module_portal_resolver` | 🟡 MÉDIA | Criar para resolver módulos disponíveis pós-login |

### 02.3 🟢 Baixos
| Gap | Severidade | Solução |
|-----|------------|---------|
| Docs `portal_*` ausentes | 🟢 BAIXO | Documentar tabelas legacy |
| Functions `fn_decision_fingerprint` sem docs detalhados | 🟢 BAIXO | Documentar em procedures_raw |

---

## 03. Alinhamento Portal First

### Fluxo Atual vs. Fluxo Desejado

#### Atual (anti-pattern para NEW WAVE)
```
Login → sp_master_login → sessão SEM contexto
        ↓
sp_auth_contexto_get → unidades, perfis, locais
        ↓
sp_auth_contexto_set → define unidade+local+perfil
        ↓
sp_auth_menu_get → menu (requer contexto pré-definido)
```

#### Desejado (Portal First)
```
Login → sp_master_login → sessão SEM contexto
        ↓
Portal → sp_module_portal_resolver → lista módulos/aplicações permitidas
        ↓
MÉDICO ESCOLHE: HIS
        ↓
HIS → sp_module_context_resolver → unidade + especialidade
        ↓
ENTER → sp_runtime_workspace_open → inicia workspace clínico
```

### Mudanças Estruturais Recomendadas

#### 3.1 SPs — Rename Map
| Atual | Proposto | Justificativa |
|-------|----------|---------------|
| `sp_auth_contexto_get` | `sp_module_context_resolver` | Contexto é responsabilidade do módulo |
| `sp_auth_contexto_set` | `sp_module_context_bind` | Bind acontece após escolha do módulo |
| `sp_auth_menu_get` | `sp_module_menu_resolver` | Menu é por módulo, não por contexto |
| `sp_auth_assert` | `sp_core_session_guard` | Guard de sessão generalizado |

#### 3.2 Tabelas — Necessárias
```sql
-- Tabela de módulos/aplicações da plataforma
CREATE TABLE aplicativo (
    id_aplicativo BIGINT PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(40) UNIQUE NOT NULL, -- 'HIS', 'WORKFORCE', 'FINANCEIRO'
    nome VARCHAR(100) NOT NULL,
    icone VARCHAR(60),
    ordem INT,
    requer_contexto TINYINT DEFAULT 1, -- 0: módulos globais (AVA, Intranet)
    ativo TINYINT DEFAULT 1,
    id_entidade BIGINT UNSIGNED, -- NULL = global
    FOREIGN KEY (id_entidade) REFERENCES saas_entidade(id_entidade)
);

-- Vínculo usuário ↔ aplicativo
CREATE TABLE usuario_aplicativo (
    id_usuario BIGINT,
    id_aplicativo BIGINT,
    id_unidade BIGINT UNSIGNED, -- opcional, escopo do módulo
    ativo TINYINT DEFAULT 1,
    PRIMARY KEY (id_usuario, id_aplicativo),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_aplicativo) REFERENCES aplicativo(id_aplicativo),
    FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade)
);

-- Workspace operacional (stateful em runtime_contexto)
CREATE TABLE workspace (
    id_workspace BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_usuario BIGINT NOT NULL,
    id_aplicativo BIGINT NOT NULL,
    id_sessao BIGINT NOT NULL,
    id_unidade BIGINT UNSIGNED,
    id_local BIGINT,
    contexto_json JSON, -- para módulos que precisam
    ativo TINYINT DEFAULT 1,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_aplicativo) REFERENCES aplicativo(id_aplicativo),
    FOREIGN KEY (id_sessao) REFERENCES auth_sessao(id_sessao),
    FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade),
    FOREIGN KEY (id_local) REFERENCES local(id_local)
);
```

---

## 04. Roteiro de Ação

### Phase 1: Auth Foundation (IMMEDIATE)
- [x] Documentar `permissao_local` (EXISTS no dump, faltava .md)
- [ ] Criar `sp_core_session_guard` (substitui `sp_auth_assert` faltante)
- [ ] Adaptar `sp_auth_menu_get` para aceitar `id_aplicativo` como parâmetro

### Phase 2: Portal / Module Layer (NEXT)
- [ ] Criar tabela `aplicativo` (portal_schema do Kilo tem portal_noticia, portal_comunicado, mas falta tabela canônica de módulos)
- [ ] Criar tabela `usuario_aplicativo`
- [ ] Criar `sp_module_portal_resolver`
- [ ] Criar `sp_module_menu_resolver`

### Phase 3: Context Per Module (NEXT)
- [ ] Renomear `sp_auth_contexto_*` para `sp_module_context_*`
- [ ] Criar tabela `workspace`
- [ ] Criar `sp_workspace_open`, `sp_workspace_close`
- [ ] Adaptar `runtime_contexto` para workspace

### Phase 4: Alinhar Docs (ONGOING)
- [ ] Documentar `ledger_*` em `docs/database/tables`
- [ ] Atualizar MDs referenciados
- [ ] Validar consistência portal_schema vs. pronto_atendimento
- [ ] Documentar diferenças Stage100.sql (modelo simplificado do Kilo) vs. Dump real

---

## 05. Diferenças Stage100 vs. Dump Real

O Stage100.sql do Kilo possui um modelo **simplificado** que **não reflete o dump real**:

| Elemento | Stage100 (Kilo) | Dump Real (pronto_atendimento) | Gap |
|----------|-----------------|-------------------------------|-----|
| `sessao_usuario` | id_usuario, id_perfil, data_login | id_usuario, id_unidade, id_local, id_perfil, token_sessao, id_saas_entidade | 🔴 Crítico |
| `local_operacional` | nome, tipo, id_unidade | nome, id_tipo_local, andar, bloco, id_entidade | ⚠️ Faltando tipo |
| `permissao_local` | ❌ Não existe | ✅ Referenciada em sp_auth_menu_get | 🔴 Crítico |
| Tenant (id_entidade) | ❌ Não existe | ✅ Presente em quase todas as tabelas | 🔴 Crítico |

**Conclusão:** O Stage100.sql é um **modelo de referência**, não uma implementação. O dump real é a fonte da verdade.

---

## Referências
- MD-CONSOLIDADO-001 — Plataforma Enterprise Architecture
- LEI 01 — Portal é a Porta
- MAP-001 — Enterprise Domain Architecture