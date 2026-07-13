# BR-CATALOG

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Catálogo de regras de negócio da plataforma.
```

---

## 1. Objetivo

Este documento é o **catálogo oficial de Business Rules** da plataforma New Wave Enterprise.

Ele serve para:
- Centralizar as leis de comportamento da plataforma
- Evitar fragmentação por módulo/produto
- Permitir rastreabilidade de regra transversal
- Orientar implementação e auditoria

Não é objetivo deste documento documentar regras específicas de produto.
Regras de produto pertencem aos domínios consumidores.

---

## 2. Classificação das Business Rules

### 2.1 Categorias canônicas

| Categoria | Sigla | Descrição | Escopo |
|-----------|-------|-----------|--------|
| Kernel | BR-KERNEL | Regras universais do Kernel Enterprise | Transversal |
| Core | BR-CORE | Regras do Core Platform | Transversal |
| Security | BR-SECURITY | Regras de segurança e acesso | Transversal |
| Runtime | BR-RUNTIME | Regras de execução e runtime | Transversal |
| Data | BR-DATA | Regras de dados e isolamento | Transversal |
| Integration | BR-INTEGRATION | Regras de integração externa | Transversal |
| Audit | BR-AUDIT | Regras de auditoria e evidência | Transversal |
| Product | BR-PRODUCT | Regras específicas de produto | Produto |

### 2.2 Regra de classificação

```text
Toda regra deve ter uma categoria definida.
Nenhuma regra fica sem classificação.
Regras sem categoria não são canônicas.
```

### 2.3 Hierarquia de aplicação

```text
BR-KERNEL
  ↓
BR-CORE
  ↓
BR-SECURITY
  ↓
BR-RUNTIME
  ↓
BR-DATA
  ↓
BR-INTEGRATION
  ↓
BR-AUDIT
  ↓
BR-PRODUCT
```

Regras de camada superior prevalecem sobre regras de camada inferior.

---

## 3. Regras Canônicas

### 3.1 BR-KERNEL — Regras do Kernel

| ID | Nome | Conceito | Origem | Consumidores | Impacto | Estado |
|----|------|----------|--------|--------------|---------|--------|
| BR-KERNEL-001 | Identidade Única | Toda identidade da plataforma deve derivar de Pessoa | MD-KERNEL-001 | Todos os produtos | ALTO | CANONICAL |
| BR-KERNEL-002 | Tenant como primeira dimensão | Todo dado carrega id_tenant | MD-KERNEL-002 | Todos os produtos | ALTO | CANONICAL |
| BR-KERNEL-003 | Sessão autoriza operação | Nenhuma operação sem sessão válida | MD-KERNEL-003 | Todos os produtos | ALTO | CANONICAL |
| BR-KERNEL-004 | Contexto variável | Contexto pode ser alterado sem recriar identidade | MD-KERNEL-004 | Todos os produtos | MÉDIO | CANONICAL |
| BR-KERNEL-005 | Authorization decide | Acesso é decisão, não cargo | MD-KERNEL-005 | Todos os produtos | ALTO | CANONICAL |
| BR-KERNEL-006 | Discovery filtra por contexto | Discovery não cria disponibilidade, apenas resolve | MD-KERNEL-006 | Todos os produtos | MÉDIO | CANONICAL |
| BR-KERNEL-007 | Registry é fonte estrutural | Registry não depende de Discovery | MD-KERNEL-007 | Todos os produtos | ALTO | CANONICAL |
| BR-KERNEL-008 | Capability é unidade funcional | Capability não é tela, menu ou permissão | MD-KERNEL-008 | Todos os produtos | ALTO | CANONICAL |
| BR-KERNEL-009 | Runtime coordena execução | Runtime não contém regra de negócio | MD-KERNEL-009 | Todos os produtos | ALTO | CANONICAL |
| BR-KERNEL-010 | Navigation projeta realidade | Navigation não define realidade | MD-KERNEL-010 | Todos os produtos | MÉDIO | CANONICAL |
| BR-KERNEL-011 | Workflow coordena estados | Workflow não define regra de negócio | MD-KERNEL-011 | Todos os produtos | MÉDIO | CANONICAL |
| BR-KERNEL-012 | Event comunica fato | Event não é log, não é auditoria | MD-KERNEL-012 | Todos os produtos | ALTO | CANONICAL |
| BR-KERNEL-013 | Ledger preserva evidência | Ledger é prova histórica imutável | MD-KERNEL-013 | Todos os produtos | ALTO | CANONICAL |
| BR-KERNEL-014 | Integration conecta externo | Integration não expõe sem governança | MD-KERNEL-014 | Todos os produtos | ALTO | CANONICAL |

### 3.2 BR-CORE — Regras do Core Platform

| ID | Nome | Conceito | Origem | Consumidores | Impacto | Estado |
|----|------|----------|--------|--------------|---------|--------|
| BR-CORE-001 | Auth Runtime é único | Nenhum produto cria próprio login | MAP-CORE-PLATFORM | Todos os produtos | ALTO | CANONICAL |
| BR-CORE-002 | Context Runtime é único | Nenhum produto cria próprio contexto | MAP-CORE-PLATFORM | Todos os produtos | ALTO | CANONICAL |
| BR-CORE-003 | Portal Runtime é único | Nenhum produto cria próprio launcher | MAP-CORE-PLATFORM | Todos os produtos | ALTO | CANONICAL |
| BR-CORE-004 | Navigation Runtime é único | Nenhum produto cria própria navegação | MAP-CORE-PLATFORM | Todos os produtos | ALTO | CANONICAL |
| BR-CORE-005 | Integration Runtime é único | Nenhum produto cria própria integração | MAP-CORE-PLATFORM | Todos os produtos | ALTO | CANONICAL |
| BR-CORE-006 | Workflow Runtime é único | Nenhum produto cria próprio workflow | MAP-CORE-PLATFORM | Todos os produtos | ALTO | CANONICAL |
| BR-CORE-007 | Event Runtime é único | Nenhum produto cria próprio evento | MAP-CORE-PLATFORM | Todos os produtos | ALTO | CANONICAL |
| BR-CORE-008 | Ledger Runtime é único | Nenhum produto cria próprio ledger | MAP-CORE-PLATFORM | Todos os produtos | ALTO | CANONICAL |
| BR-CORE-009 | Runtime Core é único | Nenhum produto cria próprio runtime | MAP-CORE-PLATFORM | Todos os produtos | ALTO | CANONICAL |

### 3.3 BR-SECURITY — Regras de Segurança

| ID | Nome | Conceito | Origem | Consumidores | Impacto | Estado |
|----|------|----------|--------|--------------|---------|--------|
| BR-SECURITY-001 | JWT HttpOnly | Token nunca em localStorage | MD-110 | Todos os produtos | ALTO | CANONICAL |
| BR-SECURITY-002 | Multi-tenant obrigatório | Toda query filtra por tenant | MD-KERNEL-002 | Todos os produtos | ALTO | CANONICAL |
| BR-SECURITY-003 | Sem deleção física | Cancelamento é evento | MD-110 | Todos os produtos | ALTO | CANONICAL |
| BR-SECURITY-004 | SP é porta de escrita | Nenhuma escrita direta em tabela | MD-110 | Todos os produtos | ALTO | CANONICAL |
| BR-SECURITY-005 | Trigger proibida para lógica | Trigger apenas para auditoria técnica | MD-110 | Todos os produtos | MÉDIO | CANONICAL |
| BR-SECURITY-006 | Sem regra de negócio no frontend | Frontend apenas exibe | MD-110 | Todos os produtos | ALTO | CANONICAL |
| BR-SECURITY-007 | Sem regra de negócio em IA | IA sugere, não decide | MD-110 | Todos os produtos | ALTO | CANONICAL |
| BR-SECURITY-008 | Credenciais no Vault | Nenhuma credencial no código | MD-110 | Todos os produtos | ALTO | CANONICAL |

### 3.4 BR-RUNTIME — Regras de Runtime

| ID | Nome | Conceito | Origem | Consumidores | Impacto | Estado |
|----|------|----------|--------|--------------|---------|--------|
| BR-RUNTIME-001 | Execução via Runtime | Toda execução passa pelo Runtime Kernel | MAP-CORE-PLATFORM | Todos os produtos | ALTO | CANONICAL |
| BR-RUNTIME-002 | Offline-first | Runtime suporta execução offline e sync | MD-KERNEL-009 | Todos os produtos | ALTO | CANONICAL |
| BR-RUNTIME-003 | Idempotência | Operações são idempotentes | MD-KERNEL-009 | Todos os produtos | ALTO | CANONICAL |
| BR-RUNTIME-004 | Resiliência | Runtime suporta retry, timeout, circuit breaker | MD-KERNEL-009 | Todos os produtos | ALTO | CANONICAL |
| BR-RUNTIME-005 | Single Writer | Apenas uma camada escreve no banco | MD-110 | Todos os produtos | ALTO | CANONICAL |
| BR-RUNTIME-006 | Cache invalidado por evento | Cache não é fonte da verdade | MD-110 | Todos os produtos | MÉDIO | CANONICAL |

### 3.5 BR-DATA — Regras de Dados

| ID | Nome | Conceito | Origem | Consumidores | Impacto | Estado |
|----|------|----------|--------|--------------|---------|--------|
| BR-DATA-001 | Banco é fonte da verdade | Nenhuma camada acima é fonte | MD-110 | Todos os produtos | ALTO | CANONICAL |
| BR-DATA-002 | Pessoa é raiz | Identity pertence à Pessoa, não ao Tenant | MD-110 | Todos os produtos | ALTO | CANONICAL |
| BR-DATA-003 | Identidade é permanente, contexto é variável | Usuário não muda, contexto muda | MD-110 | Todos os produtos | ALTO | CANONICAL |
| BR-DATA-004 | Nenhum dado isolado | Dado conectado é poder | MD-110 | Todos os produtos | MÉDIO | CANONICAL |
| BR-DATA-005 | Evento é imutável | Evento é append-only | MD-110 | Todos os produtos | ALTO | CANONICAL |
| BR-DATA-006 | Correção via evento | Correção, não apagar | MD-110 | Todos os produtos | ALTO | CANONICAL |
| BR-DATA-007 | História não morre | Nenhuma deleção física | MD-110 | Todos os produtos | ALTO | CANONICAL |

### 3.6 BR-INTEGRATION — Regras de Integração

| ID | Nome | Conceito | Origem | Consumidores | Impacto | Estado |
|----|------|----------|--------|--------------|---------|--------|
| BR-INTEGRATION-001 | Nenhuma integração sem IAM | Toda integração exige identidade e permissão | MD-110 | Todos os produtos | ALTO | CANONICAL |
| BR-INTEGRATION-002 | Contrato de eventos | Eventos representam fatos consumados | MD-110 | Todos os produtos | ALTO | CANONICAL |
| BR-INTEGRATION-003 | Nenhuma app sem Registry | Toda capacidade é registrada | MD-110 | Todos os produtos | ALTO | CANONICAL |
| BR-INTEGRATION-004 | Multi-tenant em toda integração | Nenhuma integração cruza tenant sem autorização | MD-KERNEL-002 | Todos os produtos | ALTO | CANONICAL |

### 3.7 BR-AUDIT — Regras de Auditoria

| ID | Nome | Conceito | Origem | Consumidores | Impacto | Estado |
|----|------|----------|--------|--------------|---------|--------|
| BR-AUDIT-001 | Todo evento relevante é registrado | Event Store é a memória da plataforma | MD-110 | Todos os produtos | ALTO | CANONICAL |
| BR-AUDIT-002 | Toda decisão de Authorization é registrada | Decisão de acesso é auditável | MD-KERNEL-005 | Todos os produtos | ALTO | CANONICAL |
| BR-AUDIT-003 | Toda transição de estado é registrada | Workflow gera evidência | MD-KERNEL-011 | Todos os produtos | ALTO | CANONICAL |
| BR-AUDIT-004 | Toda execução é registrada | Runtime gera evidência | MD-KERNEL-009 | Todos os produtos | ALTO | CANONICAL |
| BR-AUDIT-005 | Nenhuma evidência é alterada | Ledger é imutável | MD-KERNEL-013 | Todos os produtos | ALTO | CANONICAL |

### 3.8 BR-PRODUCT — Regras de Produto

| ID | Nome | Conceito | Origem | Consumidores | Impacto | Estado |
|----|------|----------|--------|--------------|---------|--------|
| BR-PRODUCT-001 | Portal é a porta | Todo acesso começa no Portal | MD-110 | Portal, HIS, ERP, CRM | ALTO | CANONICAL |
| BR-PRODUCT-002 | Apps executam negócio | Portal orquestra, apps executam | MD-110 | Todos os produtos | ALTO | CANONICAL |
| BR-PRODUCT-003 | Design System único | Toda app respeita Design System | MD-110 | Todos os produtos | MÉDIO | CANONICAL |
| BR-PRODUCT-004 | Multi-brand, single platform | White label muda marca, não experiência | MD-110 | Todos os produtos | MÉDIO | CANONICAL |
| BR-PRODUCT-005 | Nenhuma app roda sem Registry | App sem Registry não existe | MD-110 | Todos os produtos | ALTO | CANONICAL |

---

## 4. Matriz de Consumo

### 4.1 Matriz completa

| Regra | HIS | Portal | ERP | CRM | BI | Mobile | Display | API | Marketplace |
|-------|-----|--------|-----|-----|----|-------|---------|-----|-------------|
| BR-KERNEL-001 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-KERNEL-002 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-KERNEL-003 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-KERNEL-004 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-KERNEL-005 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-KERNEL-006 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-KERNEL-007 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-KERNEL-008 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-KERNEL-009 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-KERNEL-010 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-KERNEL-011 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-KERNEL-012 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-KERNEL-013 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-KERNEL-014 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-CORE-001 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-CORE-002 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-CORE-003 | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ | ✅ |
| BR-CORE-004 | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ | ❌ | ✅ |
| BR-CORE-005 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ |
| BR-CORE-006 | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ | ✅ | ✅ |
| BR-CORE-007 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ |
| BR-CORE-008 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ |
| BR-CORE-009 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ |
| BR-SECURITY-001 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-SECURITY-002 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-SECURITY-003 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-SECURITY-004 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-SECURITY-005 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-SECURITY-006 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-SECURITY-007 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-SECURITY-008 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-RUNTIME-001 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-RUNTIME-002 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-RUNTIME-003 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-RUNTIME-004 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-RUNTIME-005 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-RUNTIME-006 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-DATA-001 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-DATA-002 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-DATA-003 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-DATA-004 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-DATA-005 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-DATA-006 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-DATA-007 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-INTEGRATION-001 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-INTEGRATION-002 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-INTEGRATION-003 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-INTEGRATION-004 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-AUDIT-001 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-AUDIT-002 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-AUDIT-003 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-AUDIT-004 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-AUDIT-005 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| BR-PRODUCT-001 | ❌ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ | ❌ | ✅ |
| BR-PRODUCT-002 | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ | ❌ | ✅ |
| BR-PRODUCT-003 | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ | ❌ | ✅ |
| BR-PRODUCT-004 | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ | ❌ | ✅ |
| BR-PRODUCT-005 | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ | ❌ | ✅ |

---

## 5. Dependências

### 5.1 Depende de

| Documento | Como depende |
|------------|--------------|
| MD-KERNEL-000 | Arquitetura conceitual do Kernel |
| MD-KERNEL-001 até MD-KERNEL-014 | Domínios do Kernel |
| MAP-CORE-PLATFORM | Core Platform executável |
| MD-110 — Canonical Laws | Leis supremas |
| 000-CONSTITUICAO-IA.md | Guia operacional das IAs |

### 5.2 É dependido por

| Documento | Como depende |
|------------|--------------|
| Modelo Lógico | Aplica regras de modelagem |
| Modelo Físico | Aplica regras de física |
| SQL | Implementa regras em constraints, triggers, índices |
| SP Catalog | Implementa regras em procedures |
| Backend | Aplica regras em código |
| Frontend | Aplica regras em interface |
| Auditoria | Verifica conformidade com regras |

---

## 6. Estado

### 6.1 Estados de regra

| Estado | Descrição |
|--------|-----------|
| CANONICAL | Regra aprovada e imutável |
| DRAFT | Regra em discussão |
| PROPOSED | Regra proposta para aprovação |
| HISTORICAL | Regra antiga, mantida para referência |
| OBSOLETE | Regra substituída |

### 6.2 Regras de transição

```text
PROPOSED → CANONICAL (aprovada)
PROPOSED → DRAFT (em discussão)
DRAFT → PROPOSED (proposta formal)
DRAFT → OBSOLETE (descartada)
CANONICAL → HISTORICAL (versão anterior)
CANONICAL → OBSOLETE (substituída)
```

### 6.3 Regras de governança

- Nenhuma regra CANONICAL pode ser alterada sem GATE aprovado.
- Nenhuma regra PROPOSED é implementada.
- Nenhuma regra OBSOLETE é removida; apenas marcada.
- Toda regra CANONICAL tem origem em documento canônico.
- Toda regra CANONICAL tem consumidores declarados.
- Toda regra CANONICAL tem impacto declarado.

---

## 7. Próximos Artefatos

| Prioridade | Artefato | Descrição |
|------------|----------|-----------|
| Alta | FRONT-CATALOG.md | Catálogo de frontends |
| Alta | MAP-RUNTIME-FLOW.md | Mapa de fluxo de runtime |
| Alta | MAP-DATA-CANONICAL.md | Mapa de dados canônicos |
| Média | REVIEW-KERNEL-TRANSVERSAL.md | Revisão transversal |
| Média | MODEL-LOGICAL-KERNEL.md | Modelo lógico |
| Média | MODEL-PHYSICAL-KERNEL.md | Modelo físico |
| Média | SP-KERNEL-CATALOG.md | Catálogo de procedures |
| Baixa | FRONT-KERNEL-MAP.md | Mapa front-kernel |

---

## 8. Referências

- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
- MD-KERNEL-001 até MD-KERNEL-014
- MAP-CORE-PLATFORM
- MAPA DO KERNEL ENTERPRISE
- MD-KERNEL-DEPENDENCY-MAP
- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica
- 000-CONSTITUICAO-IA.md

---

## 9. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação do catálogo de Business Rules |

---

Documento Canônico — BR-CATALOG

**Este é o catálogo oficial de Business Rules da plataforma New Wave Enterprise.**
