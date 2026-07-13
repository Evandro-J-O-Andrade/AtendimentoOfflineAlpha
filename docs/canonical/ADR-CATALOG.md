# ADR-CATALOG

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Catálogo de Architecture Decision Records.
```

---

## 1. Propósito

Este documento é o **catálogo oficial de Architecture Decision Records (ADRs)** da plataforma New Wave Enterprise.

Ele serve para:
- Registrar decisões arquiteturais importantes
- Manter rastreabilidade de decisões
- Evitar retrabalho
- Servir como referência para implementação

ADR não é documento de projeto.
ADR é **registro de decisão arquitetural**.

---

## 2. Princípio Fundamental

```text
Toda decisão arquitetural importante é registrada.
ADR é imutável uma vez aprovado.
Nenhuma implementação sem ADR aprovado.
```

---

## 3. ADRs do Kernel

### 3.1 ADR-KERNEL-001

| Campo | Valor |
|-------|-------|
| Título | Kernel Enterprise como espinha dorsal da plataforma |
| Status | ACEITO |
| Data | 2026-07-13 |
| Autores | Kilo |
| Contexto | Plataforma HIS crescendo, risco de fragmentação |
| Decisão | Criar Kernel Enterprise como núcleo canônico |
| Consequências | Todos os produtos consomem Kernel; nenhum produto cria núcleo paralelo |
| Referências | MD-KERNEL-000, MD-110, 000-CONSTITUICAO-PLATAFORMA |

### 3.2 ADR-KERNEL-002

| Campo | Valor |
|-------|-------|
| Título | Foundation Layer: Identity, Tenant, Session, Context |
| Status | ACEITO |
| Data | 2026-07-13 |
| Autores | Kilo |
| Contexto | Necessidade de conceitos fundamentais antes de execução |
| Decisão | Criar Foundation Layer com Identity, Tenant, Session, Context |
| Consequências | Todos os domínios dependem de Foundation Layer |
| Referências | MD-KERNEL-001, MD-KERNEL-002, MD-KERNEL-003, MD-KERNEL-004 |

### 3.3 ADR-KERNEL-003

| Campo | Valor |
|-------|-------|
| Título | Governance Layer: Authorization, Event, Ledger |
| Status | ACEITO |
| Data | 2026-07-13 |
| Autores | Kilo |
| Contexto | Necessidade de governança centralizada |
| Decisão | Criar Governance Layer com Authorization, Event, Ledger |
| Consequências | Toda decisão de acesso é centralizada; todo evento é comunicado; toda evidência é preservada |
| Referências | MD-KERNEL-005, MD-KERNEL-012, MD-KERNEL-013 |

### 3.4 ADR-KERNEL-004

| Campo | Valor |
|-------|-------|
| Título | Runtime Layer: Registry, Discovery, Capability, Runtime, Navigation |
| Status | ACEITO |
| Data | 2026-07-13 |
| Autores | Kilo |
| Contexto | Necessidade de execução controlada e descoberta dinâmica |
| Decisão | Criar Runtime Layer com Registry, Discovery, Capability, Runtime, Navigation |
| Consequências | Execução é centralizada; descoberta é dinâmica; navegação é projetada |
| Referências | MD-KERNEL-006, MD-KERNEL-007, MD-KERNEL-008, MD-KERNEL-009, MD-KERNEL-010 |

### 3.5 ADR-KERNEL-005

| Campo | Valor |
|-------|-------|
| Título | Integration Layer: Workflow, Integration |
| Status | ACEITO |
| Data | 2026-07-13 |
| Autores | Kilo |
| Contexto | Necessidade de coordenação de processos e integração externa |
| Decisão | Criar Integration Layer com Workflow, Integration |
| Consequências | Processos são orquestrados; integrações são governadas |
| Referências | MD-KERNEL-011, MD-KERNEL-014 |

### 3.6 ADR-KERNEL-006

| Campo | Valor |
|-------|-------|
| Título | Event é comunicação, não log |
| Status | ACEITO |
| Data | 2026-07-13 |
| Autores | Kilo |
| Contexto | Risco de confundir Event com log técnico ou auditoria |
| Decisão | Event é comunicação de fato consumado; Ledger é prova histórica |
| Consequências | Event não é log; Ledger não é Event; separação clara |
| Referências | MD-KERNEL-012, MD-KERNEL-013, MD-017 |

### 3.7 ADR-KERNEL-007

| Campo | Valor |
|-------|-------|
| Título | Navigation é projeção, não fonte |
| Status | ACEITO |
| Data | 2026-07-13 |
| Autores | Kilo |
| Contexto | Risco de menu hardcoded e navegação acoplada |
| Decisão | Navigation projeta estado resolvido pelo Kernel; nunca define realidade |
| Consequências | Menu é dinâmico; navegação é contextual; produtos não montam menu próprio |
| Referências | MD-KERNEL-010, FRONT-KERNEL-MAP |

### 3.8 ADR-KERNEL-008

| Campo | Valor |
|-------|-------|
| Título | Registry é fonte estrutural, não dependente de Discovery |
| Status | ACEITO |
| Data | 2026-07-13 |
| Autores | Kilo |
| Contexto | Risco de inversão de dependência Registry → Discovery |
| Decisão | Registry é fonte estrutural; Discovery consulta Registry |
| Consequências | Catálogo é independente de contexto; Discovery filtra por contexto |
| Referências | MD-KERNEL-007, MD-KERNEL-006, MD-KERNEL-DEPENDENCY-MAP |

### 3.9 ADR-KERNEL-009

| Campo | Valor |
|-------|-------|
| Título | Capability é unidade funcional, não tela |
| Status | ACEITO |
| Data | 2026-07-13 |
| Autores | Kilo |
| Contexto | Risco de transformar telas, botões e menus em capabilities |
| Decisão | Capability é capacidade funcional reutilizável; não é interface |
| Consequências | Capability é transversal; produtos projetam interface via Navigation |
| Referências | MD-KERNEL-008, FRONT-CATALOG |

### 3.10 ADR-KERNEL-010

| Campo | Valor |
|-------|-------|
| Título | Runtime executa, não decide regra de negócio |
| Status | ACEITO |
| Data | 2026-07-13 |
| Autores | Kilo |
| Contexto | Risco de Runtime virar camada que faz tudo |
| Decisão | Runtime coordena execução; regra de negócio mora no domínio consumidor |
| Consequências | Runtime é pura coordenação; SPs executam regras; produtos definem fluxos |
| Referências | MD-KERNEL-009, SP-KERNEL-CATALOG |

---

## 4. ADRs do Core Platform

### 4.1 ADR-CORE-001

| Campo | Valor |
|-------|-------|
| Título | Core Platform como camada executável entre Kernel e Produtos |
| Status | ACEITO |
| Data | 2026-07-13 |
| Autores | Kilo |
| Contexto | Necessidade de camada executável compartilhada |
| Decisão | Core Platform é a camada executável entre Kernel e Produtos |
| Consequências | Produtos não acessam Kernel diretamente; consomem Core |
| Referências | MAP-CORE-PLATFORM, MD-KERNEL-000 |

### 4.2 ADR-CORE-002

| Campo | Valor |
|-------|-------|
| Título | Auth Runtime como único ponto de autenticação |
| Status | ACEITO |
| Data | 2026-07-13 |
| Autores | Kilo |
| Contexto | Risco de múltiplos logins por produto |
| Decisão | Auth Runtime é o único ponto de autenticação |
| Consequências | Nenhum produto cria próprio login; todos consomem Auth Runtime |
| Referências | MAP-CORE-PLATFORM, BR-CORE-001 |

### 4.3 ADR-CORE-003

| Campo | Valor |
|-------|-------|
| Título | Frontend como consumidor do Core, não como sistema independente |
| Status | ACEITO |
| Data | 2026-07-13 |
| Autores | Kilo |
| Contexto | Risco de frontend virar sistema paralelo com regras próprias |
| Decisão | Frontend consome Core via contratos; não contém regra de negócio |
| Consequências | Frontend é projeção; Core é executável; Kernel é conceitual |
| Referências | FRONT-CATALOG, FRONTEND-ARCHITECTURE, FRONT-KERNEL-MAP |

---

## 5. ADRs de Frontend

### 5.1 ADR-FRONT-001

| Campo | Valor |
|-------|-------|
| Título | Design System como contrato visual da plataforma |
| Status | ACEITO |
| Data | 2026-07-13 |
| Autores | Kilo |
| Contexto | Necessidade de consistência visual entre produtos |
| Decisão | Design System é transversal; serve a todos os produtos |
| Consequências | Todo componente respeita tokens; multi-brand via tema |
| Referências | FRONT-DESIGN-SYSTEM, FRONT-CATALOG |

### 5.2 ADR-FRONT-002

| Campo | Valor |
|-------|-------|
| Título | Workspaces descobertos via Discovery, não hardcoded |
| Status | ACEITO |
| Data | 2026-07-13 |
| Autores | Kilo |
| Contexto | Workspaces atuais são perfis hardcoded no código |
| Decisão | Workspaces são descobertos via Discovery/Navigation |
| Consequências | Menu é dinâmico; produtos não montam menu próprio |
| Referências | FRONTEND-AUDIT, MD-KERNEL-006, MD-KERNEL-010 |

### 5.3 ADR-FRONT-003

| Campo | Valor |
|-------|-------|
| Título | Assets inventariados e organizados por domínio |
| Status | ACEITO |
| Data | 2026-07-13 |
| Autores | Kilo |
| Contexto | Assets espalhados em Captures/ sem estrutura |
| Decisão | Criar estrutura canônica de assets com inventário |
| Consequências | Assets são reutilizáveis; sem hardcoding em componentes |
| Referências | ASSET-INVENTORY, FRONT-CATALOG |

---

## 6. ADRs de Database

### 6.1 ADR-DB-001

| Campo | Valor |
|-------|-------|
| Título | MySQL como fonte da verdade |
| Status | ACEITO |
| Data | 2026-07-13 |
| Autores | Kilo |
| Contexto | Necessidade de fonte única de verdade |
| Decisão | MySQL é a fonte da verdade; SPs são a única porta de escrita |
| Consequências | Nenhuma escrita direta em tabela; toda operação via SP |
| Referências | MD-110, SP-KERNEL-CATALOG |

### 6.2 ADR-DB-002

| Campo | Valor |
|-------|-------|
| Título | Nenhuma deleção física |
| Status | ACEITO |
| Data | 2026-07-13 |
| Autores | Kilo |
| Contexto | Necessidade de histórico completo |
| Decisão | Nenhuma deleção física; soft delete + evento |
| Consequências | Histórico é preservado; correção via evento |
| Referências | MD-110, MODEL-PHYSICAL-KERNEL |

### 6.3 ADR-DB-003

| Campo | Valor |
|-------|-------|
| Título | Multi-tenant como primeira dimensão |
| Status | ACEITO |
| Data | 2026-07-13 |
| Autores | Kilo |
| Contexto | Necessidade de isolamento entre organizações |
| Decisão | Todo dado carrega id_tenant; toda query filtra por tenant |
| Consequências | Isolamento natural; escalabilidade multi-tenant |
| Referências | MD-KERNEL-002, MD-110, MODEL-PHYSICAL-KERNEL |

---

## 7. Regras de Governança

### 7.1 Criação de ADR

```text
Novo ADR:
1. Verificar se já existe ADR equivalente
2. Se existir: atualizar
3. Se não existir: criar com template padrão
4. Documentar decisão, contexto, consequências
5. Aprovar
6. Registrar no ADR-CATALOG
```

### 7.2 Alteração de ADR

```text
Alterar ADR:
1. Avaliar impacto
2. Criar novo ADR se decisão mudou
3. Marcar ADR anterior como substituído
4. Aprovar
```

### 7.3 Exclusão de ADR

```text
Excluir ADR:
1. Verificar dependências
2. Marcar como deprecated
3. Não remover (histórico)
```

---

## 8. Estrutura de ADR

### 8.1 Template

```text
# ADR-{NUMERO} — {TÍTULO}

## Status
ACEITO | REJEITADO | DEPRECATED | SUBSTITUÍDO

## Propósito
{Por que esta decisão é necessária}

## Contexto
{Qual problema estamos resolvendo}

## Decisão
{O que foi decidido}

## Consequências
{Quais impactos positivos e negativos}

## Alternativas consideradas
{Quais outras opções foram avaliadas}

## Referências
{Documentos relacionados}
```

---

## 9. Próximos ADRs

| Prioridade | ADR | Descrição |
|------------|-----|-----------|
| Alta | ADR-DB-004 | Revisão cruzada: banco existente vs modelo físico |
| Alta | ADR-API-001 | API Gateway como ponto de entrada único |
| Média | ADR-SYNC-001 | Sync engine para offline-first |
| Média | ADR-CACHE-001 | Estratégia de cache |
| Baixa | ADR-MONITOR-001 | Observabilidade |

---

## 10. Referências

- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
- MD-KERNEL-001 até MD-KERNEL-014
- MAP-CORE-PLATFORM
- BR-CATALOG
- FRONT-CATALOG
- MODEL-LOGICAL-KERNEL
- MODEL-PHYSICAL-KERNEL
- SP-KERNEL-CATALOG
- MAPA DO KERNEL ENTERPRISE
- MD-KERNEL-DEPENDENCY-MAP
- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica
- 000-CONSTITUICAO-IA.md

---

## 11. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação do catálogo de ADRs |

---

Documento Canônico — ADR-CATALOG

**Este é o catálogo oficial de Architecture Decision Records da plataforma New Wave Enterprise.**
