# MD-KERNEL-013 — Ledger

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Governance Layer
Pré-requisito: MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
Pré-requisito: MD-KERNEL-005 — Authorization
Pré-requisito: MD-KERNEL-012 — Event
Consumido por: MD-KERNEL-014 — Integration
Consumido por: Governança, Auditoria, Compliance, BI, Integrações, Suporte operacional
```

---

## 1. Objetivo

Definir o conceito canônico de **Ledger** no Kernel Enterprise.

Ledger é a camada responsável por responder:

> **"Qual é a prova histórica das mudanças ocorridas na plataforma?"**

Ele não é um log técnico.
Ele não é um banco operacional.
Ele é a **memória histórica e imutável** da plataforma, preservando evidências de todos os fatos relevantes ocorridos no Kernel.

Sem Ledger, não há auditoria confiável.
Sem Event, Ledger não tem fatos para registrar.

---

## 2. Definição Canônica

```text
Ledger representa o registro histórico imutável
de todos os fatos relevantes ocorridos
na plataforma New Wave Enterprise.

Ledger é:
  - a memória da plataforma
  - um registro imutável
  - uma fonte de verdade histórica
  - um suporte para auditoria
  - um habilitador de compliance
  - uma base para reconstrução histórica
  - independente de produto

Ledger não responde:
  "o que aconteceu em tempo real?"
  "qual processo está em qual etapa?"
  "quem pode executar?"

Ledger responde:
  "qual é a prova histórica
   das mudanças ocorridas
   na plataforma?"
```

### 2.1 Princípio fundamental

```text
Ledger é a prova histórica.
Event é a comunicação do fato.
Log é o diagnóstico técnico.

Sem Event não há fato.
Sem Ledger não há prova.
Sem log não há diagnóstico.
```

### 2.2 Características obrigatórias

| Característica | Descrição |
|----------------|-----------|
| Imutável | Registros não são alterados ou deletados |
| Temporal | Todo registro carrega timestamp exato |
| Contextualizado | Todo registro carrega identity, tenant, session e contexto |
| Auditável | Todo registro é rastreável e verificável |
| Completo | Todo registro carrega evidência mínima necessária |
| Recuperável | Todo registro pode ser consultado e reconstruído |
| Versionado | Mudanças de contrato são gerenciadas |
| Isolado | Dados de um tenant não são visíveis por outro tenant |

### 2.3 Tipos de evidência

| Tipo | Natureza | Observação |
|------|----------|------------|
| Decisão | Registro de decisão de Authorization | Ex: AcessoPermitido, AcessoNegado |
| Execução | Registro de execução de Runtime | Ex: CapacidadeExecutada, OperacaoConcluida |
| Transição | Registro de mudança de estado de Workflow | Ex: AtendimentoAprovado, ProcessoFinalizado |
| Integração | Registro de integração externa | Ex: TASYAtualizado, CartorioRecebido |
| Sistema | Registro de evento sistêmico | Ex: SessaoExpirada, SyncConcluido |
| Administrativo | Registro de ação administrativa | Ex: UsuarioCriado, TenantConfigurado |

---

## 3. Boundaries

### 3.1 Ledger É

- A memória histórica imutável da plataforma.
- O registro de evidências de todos os fatos relevantes.
- A fonte de verdade para auditoria e compliance.
- A base para reconstrução histórica de operações.
- O habilitador de rastreabilidade completa.
- O repositório consultável de evidências.

### 3.2 Ledger NÃO é

- ❌ **Log técnico**: não armazena diagnóstico de servidor ou aplicação.
- ❌ **Evento em tempo real**: não é o canal de comunicação de fatos.
- ❌ **Banco operacional**: não é a fonte de dados transacionais.
- ❌ **Auditoria isolada**: não é uma ferramenta de auditoria; é a fonte para auditoria.
- ❌ **Workflow**: não coordena transições.
- ❌ **Authorization**: não decide acesso.
- ❌ **Runtime**: não executa operações.
- ❌ **Interface**: não exibe nada.
- ❌ **Cache**: não é derivado; é a fonte.

### 3.3 Limites claros

```text
LEDGER
  │
  ├── É responsável por: evidência histórica, imutabilidade, auditoria, compliance
  │
  └── NÃO é responsável por:
        ├── identidade (Identity)
        ├── organização (Tenant)
        ├── autenticação (Session)
        ├── escopo operacional (Context)
        ├── decisão de acesso (Authorization)
        ├── catálogo estrutural (Registry)
        ├── descoberta contextual (Discovery)
        ├── capacidade funcional (Capability)
        ├── execução técnica (Runtime)
        ├── projeção de interface (Navigation)
        ├── coordenação de processos (Workflow)
        ├── comunicação de fatos (Event)
        ├── integração externa (Integration)
        └── regra de negócio (Domínio consumidor)
```

---

## 4. Responsabilidades

4.1 Preservar evidências imutáveis de todos os fatos relevantes.
4.2 Registrar contexto completo de cada evidência.
4.3 Suportar auditoria e compliance.
4.4 Permitir reconstrução histórica de operações.
4.5 Garantir rastreabilidade completa.
4.6 Manter isolamento multi-tenant.
4.7 Suportar consulta e análise histórica.
4.8 Garantir integridade e não repúdio.
4.9 Suportar retenção e arquivamento conforme política.
4.10 Servir como base para BI e analytics.

---

## 5. Produtores

| Papel | Responsabilidade |
|-------|------------------|
| Event | Gera entrada no Ledger para fatos relevantes |
| Workflow | Gera entrada no Ledger para mudanças de estado |
| Runtime | Gera entrada no Ledger para execuções |
| Authorization | Gera entrada no Ledger para decisões de acesso |
| Integration | Gera entrada no Ledger para integrações externas |
| Administração | Gera entrada no Ledger para ações administrativas |
| IA | Gera entrada no Ledger para sugestões (não decisões) |
| Auditoria | Consulta Ledger para verificação |

---

## 6. Consumidores

| Consumidor | Como usa |
|------------|----------|
| Auditoria | Consulta Ledger para verificação de conformidade |
| Compliance | Consulta Ledger para validação regulatória |
| BI / Analytics | Consulta Ledger para métricas e dashboards |
| Integrações | Consulta Ledger para sincronização externa |
| Suporte operacional | Consulta Ledger para reconstrução de operações |
| Navegação | Consulta Ledger para histórico de contexto |
| IA | Consulta Ledger para aprendizado e sugestão |
| Workflow | Consulta Ledger para reconstrução de estado |
| Runtime | Consulta Ledger para resiliência e compensação |

---

## 7. Relacionamentos

### 7.1 Visão geral

```text
Ledger
  │
  ├── Event (fonte de entrada)
  │
  ├── Identity (quem estava envolvido)
  │
  ├── Tenant (onde aconteceu)
  │
  ├── Session (qual sessão)
  │
  ├── Context (qual contexto)
  │
  ├── 1:N → Evidence (evidências registradas)
  │
  ├── 1:N → Audit (registros de auditoria)
  │
  └── 1:N → Consumer (interessados)
```

### 7.2 Modelo conceitual

```text
Event ocorre
  │
  ├── Ex: AtendimentoIniciado
  ├── Ex: PrescricaoDispensada
  ├── Ex: AcessoPermitido
  │
  ▼
Event é consumido por Ledger
  │
  ├── Metadados:
  │     ├── id_ledger (único)
  │     ├── timestamp
  │     ├── id_evento (referência)
  │     ├── identity
  │     ├── tenant
  │     ├── session
  │     ├── contexto
  │     └── correlation_id
  │
  ├── Evidência:
  │     └── payload completo + metadados de auditoria
  │
  └── Estado:
        └── REGISTRADO (imutável)
```

### 7.3 Ledger como prova histórica

```text
LEDGER
  │
  ├── É: "Prova histórica imutável"
  │     └── Fonte de verdade para auditoria
  │
  ├── NÃO É: "Comunicação em tempo real"
  │     └── Isso é Event
  │
  ├── NÃO É: "Diagnóstico técnico"
  │     └── Isso é log
  │
  ├── NÃO É: "Dados transacionais"
  │     └── Isso é banco operacional
  │
  └── NÃO É: "Ferramenta de auditoria"
        └── Isso é consumidor de Ledger
```

### 7.4 Diferença crítica

```text
LOG TÉCNICO
  │
  └── "API recebeu request X, servidor respondeu Y"
        └── Objetivo: diagnóstico técnico

EVENT
  │
  └── "Dispensação realizada"
        └── Objetivo: comunicação de fato

LEDGER
  │
  └── "Dispensação realizada
        Tenant: Hospital SP
        Contexto: UPA Centro
        Identidade: Dra. Ana Silva
        Momento: 2026-07-13 10:00:00
        Resultado: Concluído
        Evidência: {dados completos}"
          └── Objetivo: prova histórica
```

### 7.5 Ledger e reconstrução histórica

```text
Ledger permite reconstruir:

"O que aconteceu com o atendimento X?"
  ↓
Eventos relacionados no Ledger
  ↓
Timeline completa
  ↓
Decisões, execuções, transições
```

Isso é fundamental para:
- Auditoria
- Compliance
- Suporte operacional
- Investigação de incidentes

### 7.6 Separação de conceitos

```text
LEDGER
  │
  ├── NÃO é Log
  │     └── Log é técnico; Ledger é histórico
  │
  ├── NÃO é Event
  │     └── Event é comunicação; Ledger é evidência
  │
  ├── NÃO é Banco Operacional
  │     └── Banco é transacional; Ledger é histórico
  │
  ├── NÃO é Auditoria
  │     └── Auditoria consome Ledger; Ledger é a fonte
  │
  ├── NÃO é Cache
  │     └── Cache é derivado; Ledger é fonte
  │
  └── NÃO é BI
        └── BI consome Ledger; Ledger é a fonte
```

---

## 8. Dependências

### 8.1 Depende de

| Domínio | Como depende |
|---------|--------------|
| Identity | Ledger registra evidência associada a uma identidade |
| Tenant | Ledger registra evidência dentro de um tenant |
| Session | Ledger registra evidência associada a uma sessão |
| Context | Ledger registra evidência com contexto operacional |
| Event | Ledger consome Event para gerar evidências |

### 8.2 É dependido por

| Domínio | Como depende de Ledger |
|---------|-------------------------|
| Governance | Ledger é a fonte de verdade para governança |
| Auditoria | Auditoria consome Ledger para verificação |
| Compliance | Compliance consome Ledger para validação |
| BI / Analytics | Analytics consome Ledger para métricas |
| Integração | Integration consome Ledger para sincronização |
| Suporte operacional | Suporte consome Ledger para reconstrução |
| Workflow | Workflow consome Ledger para reconstrução de estado |
| Runtime | Runtime consome Ledger para resiliência |
| IA | IA consome Ledger para aprendizado |

### 8.3 Matriz de dependência

| Domínio      | Identity | Tenant | Session | Context | Authorization | Discovery | Registry | Capability | Runtime | Navigation | Workflow | Event | Ledger | Integration |
| ------------ | -------- | ------ | ------- | ------- | ------------- | --------- | -------- | ---------- | ------- | ---------- | -------- | ----- | ------ | ------------ |
| Identity     | —        |        |         |         |               |           |          |            |         |            |          |       |        |              |
| Tenant       |          | —      |         |         |               |           |          |            |         |            |          |       |        |              |
| Session      | ✔        | ✔      | —       |         |               |           |          |            |         |            |          |       |        |              |
| Context      | ✔        | ✔      | ✔       | —       |               |           |          |            |         |            |          |       |        |              |
| Authorization| ✔        | ✔      | ✔       | ✔       | —             |           |          |            |         |            |          |       |        |              |
| Discovery    | ✔        | ✔      | ✔       | ✔       | ✔             | —         |          |            |         |            |          |       |        |              |
| Registry     |          |        |         |         |               |           | —        |            |         |            |          |       |        |              |
| Capability   |          |        |         |         |               |           |          | —          |         |            |          |       |        |              |
| Runtime      |          |        |         |         |               |           |          |            | —       |            |          |       |        |              |
| Navigation   |          |        |         |         |               |           |          |            |         | —          |          |       |        |              |
| Workflow     |          |        |         |         |               |           |          |            |         |            | —        |       |        |              |
| Event        |          |        |         |         |               |           |          |            |         |            |          | ✔     |        |              |
| Ledger       |          |        |         |         |               |           |          |            |         |            |          | ✔     | —      |              |
| Integration  |          |        |         |         |               |           |          |            |         |            |          |       | ✔      |              |

---

## 9. Estados Canônicos

### 9.1 Estados de evidência no Ledger

| Estado | Descrição |
|--------|-----------|
| PENDING | Aguardando registro |
| REGISTERED | Registrada com sucesso |
| ARCHIVED | Arquivada após período de retenção |
| PURGED | Removida após retenção máxima (não é exclusão física; é marcação) |

### 9.2 Regras de transição

```text
PENDING → REGISTERED (registrada com sucesso)
REGISTERED → ARCHIVED (arquivada após retenção)
ARCHIVED → PURGED (marcada como purgada após retenção máxima)
```

### 9.3 Regras de negócio

- Evidência registrada é imutável; nunca alterada ou deletada.
- Todo Event relevante é registrado no Ledger.
- Evidência carrega contexto completo: identity, tenant, session, contexto, timestamp.
- Evidência é isolada por tenant; nenhuma consulta cruza tenant sem autorização.
- Retenção é configurável por tenant e por tipo de evidência.
- Purging é marcação; nunca exclusão física.
- Ledger é a única fonte de verdade para reconstrução histórica.
- Nenhuma camada acima do Ledger pode alterar ou remover evidências.

---

## 10. Integração com o Kernel

### 10.1 Papel no Kernel

Ledger é o domínio final da **Governance Layer**.

É a memória imutável que fecha o ciclo de governança do Kernel, garantindo que todo fato relevante tenha prova histórica.

```text
Cliente
  ↓
Identity (quem é?)
  ↓
Tenant (onde opera?)
  ↓
Session (está autorizado agora?)
  ↓
Context (em qual escopo operacional?)
  ↓
Authorization (pode?)
  ↓
Registry (o que existe?)
  ↓
Discovery (o que está disponível?)
  ↓
Capability (o que cada item representa?)
  ↓
Runtime (executa)
  ↓
Workflow (coordena processos)
  ↓
Event (comunica fatos)
  ↓
Ledger (preserva evidências)
  ↓
Integration (integra externamente)
```

### 10.2 Contratos

Ledger não é uma SP. Ledger é um conceito.

Sua materialização será:
- Tabelas: `kernel_ledger`, `ledger_evidence`, `ledger_archive`, etc.
- SPs: `sp_ledger_append`, `sp_ledger_query`, `sp_ledger_archive`, `sp_ledger_purge`, etc.
- Views: `vw_ledger_active`, `vw_ledger_by_tenant`, `vw_ledger_audit`, etc.

Mas esses detalhes pertencem ao **Modelo Lógico** e **Modelo Físico**.

Neste documento, Ledger é apenas um conceito.

### 10.3 Integração com outros domínios

| Domínio | Integração |
|---------|------------|
| Identity | Ledger registra evidências associadas a identidades |
| Tenant | Ledger registra evidências dentro de um tenant |
| Session | Ledger registra evidências associadas a sessões |
| Context | Ledger registra evidências com contexto operacional |
| Authorization | Ledger registra decisões de acesso |
| Discovery | Ledger registra descobertas relevantes |
| Registry | Ledger registra alterações no Registry |
| Capability | Ledger registra execuções de Capability |
| Runtime | Ledger registra execuções de Runtime |
| Navigation | Ledger registra projeções relevantes |
| Workflow | Ledger registra mudanças de estado de Workflow |
| Event | Ledger consome Event para gerar evidências |
| Integration | Integration consome Ledger para sincronização externa |

---

## 11. Impacto Arquitetural

### 11.1 Impactos positivos

- Torna a plataforma auditável e compliant.
- Cria fonte única de verdade histórica.
- Suporta reconstrução de operações.
- Habilita rastreabilidade completa.
- Cria base para BI e analytics históricos.
- Garante não repúdio de operações.
- Suporta investigação de incidentes.
- Separa evidência de execução e comunicação.

### 11.2 Impactos negativos / Riscos

- Volume: crescimento contínuo de evidências.
- Performance: consultas históricas podem ser custosas.
- Retenção: políticas de retenção precisam ser definidas.
- Custo: armazenamento de longo prazo.
- Privacidade: evidências podem conter dados sensíveis.
- Acesso: consultas precisam respeitar isolamento multi-tenant.

### 11.3 Mitigações

- Política de retenção por tipo de evidência.
- Particionamento por tenant e por tempo.
- Indexação otimizada para consultas frequentes.
- Criptografia de dados sensíveis no Ledger.
- Controle de acesso rigoroso para consultas.
- Arquivo e purga automatizados conforme política.
- Dashboard de health e crescimento do Ledger.

---

## 12. Critérios de Materialização

12.1 Nenhuma tabela de ledger será criada sem justificar REUSE/ADAPT/EXTEND/MERGE/PROPOSE.
12.2 Nenhuma SP de ledger será criada sem classificação de tipo (MASTER, DISPATCHER, ORCHESTRATOR, EXECUTOR, ASSERT, QUERY, COMMAND, LEDGER, EVENT).
12.3 Toda FK de ledger deve estar coerente com as SPs que a consomem.
12.4 Todo índice de ledger deve suportar as consultas mais frequentes (busca por tenant, identity, tipo, timestamp).
12.5 Nenhuma evidência registrada pode ser alterada ou deletada.
12.6 Toda evidência de Ledger deve gerar registro de auditoria.
12.7 Ledger é a única fonte de verdade histórica; nenhuma camada acima pode alterá-la.
12.8 Ledger respeita isolamento multi-tenant em todas as consultas.
12.9 A materialização depende da aprovação do MD-KERNEL-013 e do dossiê correspondente.

---

## 13. Referências

- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
- MD-KERNEL-001 — Identity
- MD-KERNEL-002 — Tenant
- MD-KERNEL-003 — Session
- MD-KERNEL-004 — Context
- MD-KERNEL-005 — Authorization
- MD-KERNEL-006 — Discovery
- MD-KERNEL-007 — Registry
- MD-KERNEL-008 — Capability
- MD-KERNEL-009 — Runtime
- MD-KERNEL-010 — Navigation
- MD-KERNEL-011 — Workflow
- MD-KERNEL-012 — Event
- MAPA DO KERNEL ENTERPRISE
- MD-KERNEL-DEPENDENCY-MAP
- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica
- MD-005 — Lei de Engenharia e Materialização
- MD-017 — Event Store é a Memória da Plataforma
- MD-036 — Contrato de Eventos Corporativos
- GATE-DISCOVERY-REGISTRY-RUNTIME-DECISION
- DOSSIER-DISCOVERY-REGISTRY-RUNTIME

---

## 14. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação do MD-KERNEL-013 — Ledger |

---

Documento Canônico — MD-KERNEL-013

**Este é o décimo terceiro domínio do Kernel Enterprise. Pertence à Governance Layer, depende de Event e Foundation Layer, e é pré-requisito para Integration e todos os domínios de governança e consumo.**
