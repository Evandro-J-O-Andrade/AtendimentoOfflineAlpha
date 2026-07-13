# REGISTRY CANÔNICO — Auditoria e Classificação (Ciclo 2.1, Fase 1+2)

## Status
```text
CANÔNICO (ENGENHARIA)
Fase 1 — Auditoria: CONCLUÍDA
Fase 2 — Classificação: CONCLUÍDA
Fase 3 — Materialização: PENDENTE (somente itens PROPOSE)
Banco Vivo auditado: database/dump/Dump20260618.sql
```

---

## Método (GATE-PLATFORM-001 + Constituição Art. 74/75/76)

```text
GATE → Banco Vivo → Knowledge Graph
   → REUSE → ADAPT → EXTEND → MERGE → somente então PROPOSE
```

Não se cria tabela por imaginação. Cada Registry é classificado
contra o que já existe no Banco Vivo.

---

## Fase 1 — Auditoria: candidatos encontrados

| Registry alvo | Candidato(s) no Banco Vivo | Linha (dump) |
|---------------|----------------------------|--------------|
| Domain / Tenant | `tenant_registry`, `saas_entidade` | 15299 / 14339 |
| Permission | `permissao`, `perfil_permissao`, `auth_grupo_permissao` | 11733 / 11701 / 2511 |
| Capability (núcleo) | `permissao` (já liga SP e frontend) | 11733 |
| Contract | `contrato`, `saas_contrato` | 3716 / 14309 |
| Portal / Module Catalog | `portal_categoria` | 12283 |
| Event Store | `kernel_ledger`, `kernel_runtime_evento` | 8938 / 8977 |
| Runtime (infra) | `runtime_*` (execução/offline) | 13794+ |
| Tool | — (ausente) | — |
| SP Catalog | `permissao.nome_procedure` (link fraco) | 11739 |
| API Catalog | — (ausente) | — |
| Event Type Catalog | — (ausente como tipos) | — |

Destaque: `permissao` já possui os campos que caracterizam uma
capacidade canônica:

```text
codigo, nome, descricao, dominio,
nome_procedure  → liga à SP (LEI 05/26)
acao_frontend   → liga à UI
metadata (json) → extensível
grupo_menu, icone, ordem_menu, visivel_menu → catálogo de UI
```

Ou seja, o **Permission/Capability Registry já existe em estado
embrionário** e é o ponto de partida, não uma tabela nova.

---

## Fase 2 — Classificação (REUSE / ADAPT / EXTEND / MERGE / PROPOSE)

| Registry | Classificação | Decisão |
|----------|--------------|---------|
| Domain Registry | REUSE | `tenant_registry` já registra tenants/entidades. Usar como Domain Registry. |
| Event Store | REUSE | `kernel_ledger` é o Event Store canônico (Art. 22). Instâncias já registradas. |
| Permission Registry | ADAPT | `permissao` + `perfil_permissao` + `auth_grupo_permissao` cobrem permissão/perfil/grupo. |
| Contract Registry | ADAPT | `contrato` / `saas_contrato` modelam contratos. Adaptar para Contract Registry. |
| Portal Catalog | ADAPT | `portal_categoria` agrupa categorias do Portal. |
| Capability Registry | EXTEND/MERGE | NÃO criar `capability_registry`. Estender `permissao` com `id_runtime`, `id_contrato`, `id_tool`, `payload_contrato` para virar o núcleo de capacidade. Evita duplicar o que já existe. |
| SP Registry | EXTEND/MERGE | Estender `permissao.nome_procedure` para um catálogo real (SP → master/executor/domínio). Preferir EXTEND a nova tabela. |
| Runtime Registry (lógico) | PROPOSE | Runtimes existem como infra (`runtime_*`), mas NÃO há registry que os enumere para descoberta (Portal/Auth/Farmácia/Estoque/...). Criar `runtime_registry`. |
| Tool Registry | PROPOSE | Nenhum catálogo de ferramentas (tool_get_patient, etc.). Criar `tool_registry`. |
| API Registry | PROPOSE | Nenhum catálogo API→capability. Criar `api_registry`. |
| Event Type Catalog | PROPOSE/EXTEND | `kernel_ledger` guarda instâncias; catálogo de TIPOS de evento ausente. Avaliar EXTEND de `kernel_runtime_evento` ou PROPOSE `event_registry`. |

---

## Fase 3 — Materialização (PENDENTE, somente PROPOSE)

Itens que realmente exigem nova estrutura (após GATE + MD + MAP + BR):

1. `runtime_registry` — runtimes lógicos descobertos dinamicamente.
2. `tool_registry` — ferramentas com metadados completos (nome, descrição, domínio, runtime, procedure, contrato, permissão, tenant, versão, status, timeout, auditoria).
3. `api_registry` — APIs → capability.
4. `event_registry` (ou EXTEND de `kernel_runtime_evento`) — catálogo de tipos de evento.

Itens EXTEND/MERGE (não novas tabelas):
- `permissao`: + `id_runtime`, `id_contrato`, `id_tool`, `payload_contrato`.
- `permissao.nome_procedure`: promovido a SP Registry real.

---

## Próximo passo

Submeter os itens PROPOSE ao GATE-PLATFORM-001 e, na sequência
obrigatória (Art. 74), produzir MD → MAP → BR → Contratos →
SQL → Runtime → Master → Dispatcher → Executor → Procedures.

Sem esta auditoria, criar `capability_registry` do zero seria
violação da disciplina do Ciclo 2 (a própria governança passa
pelo GATE).

### Reordenação Tool ↔ API (EM VALIDAÇÃO)
Proposta: trocar a sequência original
`Capability → Runtime → Tool → API → Event`
por `Capability → Runtime → API → Tool → Event`
(motivo: Tool consome API; API existe independente de Tool).
Decisão **PENDENTE de nova auditoria do Banco Vivo**
(REUSE→ADAPT→EXTEND→MERGE→PROPOSE). Não altera a Etapa 2 em curso.
