# MD-CANONICO-IA-003 — Lei da Evolução do Core

## Status

```text
CANÔNICO
OBRIGATÓRIO
FREEZE 2
```

---

# Objetivo

Definir como o Core Enterprise pode evoluir sem perder sua identidade.

Esta lei complementa:

- MD-CANONICO-IA-001 — Lei de Evolução Documental
- MD-CANONICO-IA-002 — Lei de Governança Arquitetural
- MD-110 — Leis Supremas da Plataforma
- LC-001 → LC-018 — Leis Canônicas Globais

---

# Princípio Fundamental

```text
O Core define o que a plataforma É.
As Apps definem o que a plataforma FAZ.

Nunca inverter.
```

O Core é imutável em sua essência.

Evolui por expansão e especialização, nunca por substituição.

---

# Universo de Classificação

Toda funcionalidade, toda descoberta, toda proposta pertence a exatamente um dos seguintes domínios.

Nenhum domínio pode invadir outro.

---

## CORE

Componentes fundamentais da plataforma.

Representam identidade, governança, orquestração e memória.

Exemplos:

```text
Pessoa
Tenant
IAM
Contexto Operacional
Portal
Dispatcher
Orquestrador
Event Store
Ledger
Auditoria
Workflow Engine
Runtime
Kernel
```

Regras do CORE:

```text
Nunca contém regra de negócio de App.
Nunca contém lógica específica de domínio assistencial.
Nunca é alterado por descoberta de uma única SP.
Evolui por decisão arquitetural formal.
É transversal a toda a plataforma.
```

---

## INFRA

Infraestrutura técnica que suporta o Core e as Apps.

Componentes de execução, transporte, persistência técnica.

Exemplos:

```text
Filas
Jobs
Sync Engine
Runtime Execution Queue
Caches
Indexes
Partitions
Connection Pools
Message Brokers
```

Regras do INFRA:

```text
Suporta CORE e APPs.
Não define regra de negócio.
Pode ser substituído por evolução tecnológica.
Mudança em INFRA não altera arquitetura de domínio.
```

---

## PLATFORM

Serviços transversais da plataforma.

Componentes que servem a múltiplas aplicações.

Exemplos:

```text
Design System
App Registry
API Gateway
Service Mesh
Observabilidade
Automação (N8N)
IA Core
Search
Notificações
Storage Service
```

Regras do PLATFORM:

```text
Consumido por múltiplas Apps.
Não pertence a um domínio específico.
Evolui por demanda de plataforma.
Pode ser promovido a CORE se tornar fundamental.
```

---

## APP

Aplicação específica de um domínio.

Isolada, registrada, consumidora do Core.

Exemplos:

```text
Triagem (APP HIS)
Manchester (APP HIS)
Internação (APP HIS)
Prescrição (APP HIS)
Faturamento (APP HIS)
Farmácia (APP HIS)
CRM (APP CRM)
RH (APP RH)
Financeiro (APP FINANCE)
SAC (APP SAC)
```

Regras do APP:

```text
Registrada no App Registry.
Usa IAM canônico.
Usa Dispatcher canônico.
Emite eventos canônicos.
Nunca acessa banco diretamente.
Respeita Design System.
Pode ser criada, removida ou substituída sem afetar o Core.
```

---

## INTEGRAÇÃO

Conexões externas à plataforma.

Sistemas legados, APIs externas, serviços terceiros.

Exemplos:

```text
TISS
PIX
Cartão
Laboratório Externo
Imaging PACS
CRM Legado
ERP Financeiro
Email Gateway
SMS Gateway
```

Regras do INTEGRAÇÃO:

```text
Nunca é CORE.
Nunca define arquitetura interna.
Consome ou expõe dados da plataforma.
Deve passar por IAM.
Deve ser mapeada como adaptador.
```

---

## LEGACY

Objetos do legado ainda em processo de análise.

Ainda não classificados ou aguardando promoção.

Exemplos:

```text
sp_master_*
tabelas sem classificação
procedures não mapeadas
sistemas legados não integrados
dump SQL bruto
```

Regras do LEGACY:

```text
Todo objeto legado começa como LEGACY.
Só sai de LEGACY após passar pela Lei da Responsabilidade (MD-CANONICO-IA-002).
Nunca é promovido diretamente a CORE.
Deve passar por: Descobrir → Classificar → Generalizar → Implementar.
```

---

# Protocolo de Evolução do Core

Toda proposta de alteração no Core deve seguir este protocolo.

## Passo 1 — Perguntar

```text
Esta funcionalidade pertence ao CORE?
```

Se NÃO, classificar em INFRA, PLATFORM, APP, INTEGRAÇÃO ou LEGACY.

Se SIM, prosseguir.

## Passo 2 — Justificar

```text
Por que esta funcionalidade precisa estar no CORE?

Por que não pode ser:
  - uma App?
  - uma Integração?
  - uma camada INFRA?
```

Resposta obrigatória em documento formal (ver ADR).

## Passo 3 — Validar

```text
Esta funcionalidade:

  ✓ É reutilizável por qualquer aplicação da plataforma?
  ✓ Não contém regra de negócio específica de domínio?
  ✓ Não depende de tabela ou SP específica de App?
  ✓ Está alinhada às Leis Canônicas?
  ✓ Não quebra a espinha dorsal canônica?
```

Todas devem ser verdadeiras.

## Passo 4 — Promover

```text
APROVADO → Incorporar ao CORE via documento canônico formal.

REJEITADO → Redirecionar para domínio apropriado.

REVISAO → Retornar para análise com justificativa complementar.
```

---

# Regras de Proteção do Core

```text
❌ Nenhuma App acessa tabela do Core diretamente.
❌ Nenhuma App define regra do Core.
❌ Nenhuma integração redefine comportamento do Core.
❌ Nenhuma descoberta do legado é promovida automaticamente ao Core.
❌ Nenhuma SP é desmembrada em múltiplas entidades Core sem análise formal.
❌ Nenhuma funcionalidade genérica é deixada de fora do Core por negligência.
✅ Toda expansão do Core é documentada como MD canônico.
✅ Toda alteração no Core atualiza o Knowledge Graph.
✅ Toda alteração no Core atualiza a maturidade dos documentos afetados.
```

---

# Radar de Arquitetura

O Radar é um instrumento de visibilidade.

Ele mostra o estado de maturidade de cada domínio da plataforma.

## Legenda

```text
██████████ 100% — CONSOLIDADO
████████░░  80% — AVANÇADO
██████░░░░  60% — EM CONSTRUÇÃO
████░░░░░░  40% — INICIAL
██░░░░░░░░  20% — RASCUNHO
█░░░░░░░░░   0% — NÃO INICIADO
░aguardando — AGUARDANDO DEPENDÊNCIA
```

## Indicadores

```text
CORE
██████████ 100%

IAM
██████████ 100%

Portal
██████████ 100%

Workflow
██████░░░░  60%

Analytics
██████░░░░  60%

Event Store
██████████ 100%

Ledger
██████████ 100%

Runtime
██████████ 100%

Design System
████████░░  80%

App Registry
████████░░  80%

Dispatcher
██████████ 100%

Social
█░░░░░░░░░  10%

Chat
█░░░░░░░░░  10%

Wiki
█░░░░░░░░░  10%

Integrações
██░░░░░░░░  20%

N8N / Automação
██████░░░░  60%

IA Core
██████░░░░  60%

APP HIS
████████░░  80%

APP CRM
█░░░░░░░░░  10%

APP RH
█░░░░░░░░░  10%

APP Financeiro
█░░░░░░░░░  10%

APP SAC
█░░░░░░░░░   0%

APP Logística
█░░░░░░░░░   0%
```

Regras do Radar:

```text
CORE nunca regride.
CORE só avança.
Radar é atualizado após cada ciclo de evolução.
```

---

# Estrutura Canônica de Pastas

A estrutura de pastas reflete a hierarquia da arquitetura.

```text
docs/
├── canonical/                    ← Fonte canônica da verdade
│   ├── MD-CANONICO-IA-001*.md   ← Leis de documentação
│   ├── MD-CANONICO-IA-002*.md   ← Leis de governança
│   ├── MD-CANONICO-IA-003*.md   ← Leis do Core (este documento)
│   ├── MD-CANONICO-IA-004*.md   ← Matriz de evolução
│   ├── MD-001 → MD-110          ← Arquitetura
│   ├── MAP-001 → MAP-*          ← Mapas de domínio
│   ├── BR-001 → BR-*            ← Regras de negócio
│   ├── FRONT-001 → FRONT-*      ← Experiência frontend
│   ├── ADR-001 → ADR-*          ← Architecture Decision Records
│   ├── RADAR-ARQUITETURA.md     ← Radar de Arquitetura
│   └── README_CANONICO.md       ← Índice canônico
│
├── database/                    ← Documentação técnica do banco Enterprise
│   ├── tables/                  ← Schema canônico
│   ├── views/                   ← Views canônicas
│   └── procedures/              ← SPs canônicas
│
└── auditoria/                   ← Auditoria e relatórios
```

```text
legacy/                           ← Domínio do legado (NÃO CANÔNICO)
├── dump/                         ← Dumps SQL brutos
├── tables_raw/                   ← Tabelas extraídas do legado
├── procedures_raw/               ← Procedures extraídas do legado
├── functions_raw/                ← Functions extraídas do legado
├── events_raw/                   ← Eventos extraídos do legado
├── relatorios/                   ← Relatórios de engenharia reversa
└── engenharia_reversa/           ← Análises e classificações do legado
```

Regras da estrutura:

```text
docs/canonical/  → Arquitetura (fonte da verdade)
legacy/          → Evidência técnica (referência, não regra)
Nunca misturar.
Nunca promover dado de legacy para canonical sem processo formal.
```

---

# ADR — Architecture Decision Records

ADR registra o motivo das decisões arquiteturais.

Não é documentação de implementação.

É documentação de intenção.

## Formato ADR

```text
# ADR-XXX — Título da Decisão

## Status
ACEITO | REJEITADO | DEPRECADO | SOB REVISÃO

## Contexto
Por que essa decisão foi necessária?

## Decisão
O que foi decidido?

## Consequências
O que muda com essa decisão?

## Alternativas Consideradas
Quais caminhos foram avaliados?

## Relacionamentos
- MD-XXX
- MAP-XXX
- BR-XXX
```

## ADRs Existentes

```text
ADR-001  Pessoa como entidade raiz
ADR-002  Portal antes do Contexto
ADR-003  SP como implementação, não arquitetura
ADR-004  Display como cidadão de primeira classe
ADR-005  JWT apenas em HttpOnly Cookie
```

## Regras dos ADRs

```text
❌ Nunca apagar ADR.
❌ Nunca reescrever ADR.
✅ ADR rejeitado permanece registrado.
✅ ADR deprecado é marcado, não removido.
✅ Toda decisão arquitetural significativa gera um ADR.
✅ Toda IA deve consultar ADRs antes de propor mudança arquitetural.
```

---

# Fluxo de Evolução do Core

```text
Descoberta
↓
Analisar objeto do legado / proposta nova
↓
Lei da Responsabilidade (4 perguntas — MD-CANONICO-IA-002)
↓
Classificação (CORE / INFRA / PLATFORM / APP / INTEGRAÇÃO / LEGACY)
↓
Pertence ao Core?
↓
NÃO → Direcionar para domínio apropriado
↓
SIM → Protocolo de Evolução do Core
  └── Passo 1: Perguntar (pertence?)
  └── Passo 2: Justificar (por quê?)
  └── Passo 3: Validar (5 critérios)
  └── Passo 4: Promover (aprovar / rejeitar / revisar)
↓
APROVADO
  └── Criar/atualizar ADR
  └── Atualizar MD correspondente
  └── Atualizar Knowledge Graph
  └── Atualizar Radar de Arquitetura
  └── Promover para implementação
↓
REJEITADO
  └── Direcionar para APP / PLATFORM / INFRA
↓
REVISÃO
  └── Documentar pendências
  └── Aguardar nova análise
```

---

# Integrações

| Documento | Finalidade |
|-----------|------------|
| 000-CONSTITUICAO-IA.md | Constituição operacional das IAs |
| MD-CANONICO-IA-001 | Lei de Evolução Documental |
| MD-CANONICO-IA-002 | Lei de Governança Arquitetural |
| MD-110 — Canonical Laws | Leis supremas da plataforma |
| LC-001 → LC-018 | Leis Canônicas Globais |
| MD-001 até MD-110 | Arquitetura do Core |
| MAP-001 → MAP-* | Mapas de domínio |
| BR-001 → BR-* | Regras de negócio |
| FRONT-001 → FRONT-* | Experiência frontend |
| ADR-001 → ADR-* | Decisões arquiteturais |
| RADAR-ARQUITETURA.md | Visibilidade de maturidade |

---

# Matriz de Aplicação

| IA | Aplicação |
|----|-----------|
| Gemini | Obrigatória em toda tarefa de arquitetura Core |
| KiloCode | Obrigatória em toda tarefa de arquitetura Core |
| ChatGPT | Obrigatória em toda tarefa de arquitetura Core |
| Claude | Obrigatória em toda tarefa de arquitetura Core |
| Copilot | Obrigatória em sugestões arquiteturais |

---

# Status Final

```text
MD-CANONICO-IA-003: ✅ CANONIZADA
APLICAÇÃO: Obrigatória para todas as IAs do projeto
ESCOPO: Evolução e proteção do Core Enterprise
VERSÃO: 1.0
```

---

Documento Canônico — MD-CANONICO-IA-003

**Esta lei governa a evolução do Core Enterprise do FCA/Midas.**
