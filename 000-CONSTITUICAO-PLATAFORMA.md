# 000 — CONSTITUIÇÃO DA PLATAFORMA MIDAS ENTERPRISE

## Status
DOCUMENTO SUPREMO DA PLATAFORMA
Versão 1.0
CANÔNICO
CONSOLIDADO

---

## Herança e Substituição

Este documento substitui e absorve:

1. `000-CONSTITUICAO-IA.md` (guia operacional das IAs — agora reduzido ao seu papel operacional)
2. Dispersão de regras arquiteturais existentes em dezenas de documentos não indexados
3. Decisões informais tomadas durante a fase de transição do legado para o SaaS Enterprise

Nenhuma decisão anterior de arquitetura, engenharia ou governança pode contradizer este documento.
Em caso de conflito, este documento prevalece.

---

## Título I — Princípios Fundamentais

### Artigo 1 — Finalidade da Plataforma

```text
A plataforma Midas Enterprise existe para amplificar
a capacidade humana de criar, decidir e crescer.

Tecnologia é meio.
Pessoa é fim.
Dados são ativos.
Conhecimento é poder.
```

### Artigo 2 — Natureza da Plataforma

```text
A plataforma não é um ERP.
A plataforma não é um CRM.
A plataforma não é um HIS.
A plataforma não é uma coleção de apps.

A plataforma é o Sistema Operacional Unificado
que torna qualquer ERP, CRM, HIS ou aplicação
uma extensão natural.
```

### Artigo 3 — Modo de Pensamento Obrigatório

```text
Toda pessoa que atua na plataforma (humana ou IA)
deve pensar como Arquiteto Enterprise.

NUNCA como Programador.

Programadores implementam funcionalidades.
Arquitetos constroem plataformas.
```

### Artigo 4 — Imutabilidade dos Princípios

```text
Os princípios fundamentais não são alterados
por conveniência operacional, pressa de entrega
ou pressão comercial.

Eles são alterados apenas por processo formal
de governança arquitetônica.
```

### Artigo 5 — Fonte Única da Verdade

```text
Banco (MySQL) é a única fonte operacional da verdade.

Nenhuma camada acima do banco pode ser
considerada fonte da verdade.
```

---

## Título II — Filosofia da Plataforma

### Artigo 6 — Visão

Plataforma SaaS Enterprise Multi-Tenant, cognitiva e auto-evolutiva, onde:

- O **HIS** é apenas um App;
- Qualquer sistema legado ou moderno pode ser integrado como App;
- A experiência do usuário é unificada pelo **Portal Enterprise**;
- Os dados são unificados pelo **Customer 360**;
- O conhecimento é conectado pelo **Knowledge Graph**;
- A memória operacional é garantida pelo **Event Store**;
- A inteligência é ampliada pela **IA Colaborativa** governada.

### Artigo 7 — Missão

Fornecer infraestrutura operacional, tecnológica e cognitiva para organizações de saúde e outros segmentos enterprise, eliminando ilhas de sistema, garantindo continuidade operacional e amplificando a capacidade de decisão humana.

### Artigo 8 — Valores Arquiteturais

| Valor | Significado |
|-------|-------------|
| **Pessoa é Raiz** | Toda identidade pertence à Pessoa, não ao Tenant. |
| **Contexto é Chave** | Um usuário pode operar em múltiplos contextos sem perder histórico. |
| **Evento é Memória** | Toda operação relevante é registrada e imutável. |
| **Portal é Porta** | Nenhuma App abre diretamente. |
| **App Executa** | Portal orquestra; Apps executam. |
| **IA Auxilia** | IA sugere, analisa e resume. Decide o ser humano. |
| **Multi-Tenant é Transversal** | Tenant é a primeira dimensão de tudo. |
| **Design System é Lei** | Nenhuma App cria biblioteca visual própria. |
| **Offline-First é Obrigatório** | A plataforma funciona sem conectividade. |
| **Reconstrução, Não Herança** | Legado é conhecimento, não referência de implementação. |

### Artigo 9 — Princípios de Isolamento

```text
Cada domínio é uma unidade autônoma.

Frontend isolado.
Backend isolado.
Contratos isolados.
Testes isolados.
Documentação isolada.

Nada vaza entre domínios sem contrato explícito.
```

### Artigo 10 — Princípio da Reconstrução

```text
O legado React/Node/API é CONHECIMENTO.
NÃO É REFERÊNCIA DE IMPLEMENTAÇÃO.

Novas implementações são reconstruídas do zero
a partir do banco congelado e dos documentos canônicos.
```

---

## Título III — Estrutura Oficial do Monorepo

### Artigo 11 — Árvore Definitiva de Diretórios

```text
AtendimentoOfflineAlpha/
├── apps/                     # Aplicações canônicas (domínios isolados)
│   ├── portal/               # Portal Enterprise (launcher oficial)
│   ├── saude/                # Domínio Saúde (HIS)
│   ├── financeiro/           # Domínio Financeiro
│   ├── rh/                   # Domínio RH
│   ├── crm/                  # Domínio CRM
│   ├── analytic/             # Domínio Analytics
│   ├── social/               # Domínio Social
│   ├── chat/                 # Domínio Chat
│   ├── wiki/                 # Domínio Wiki
│   └── [novas apps]/         # Novos domínios via AppRegistry
│
├── backend/                  # Backend canônico único
│   ├── modules/              # Módulos por domínio (isolados)
│   │   ├── iam/
│   │   ├── portal/
│   │   ├── saude/
│   │   ├── financeiro/
│   │   ├── rh/
│   │   ├── crm/
│   │   └── ...
│   ├── gateway/              # API Gateway canônico
│   ├── dispatcher/           # Dispatcher canônico
│   ├── sdk/                  # SDK do Backend
│   └── contracts/            # Contratos do Backend
│
├── packages/                 # Pacotes compartilhados
│   ├── ui/                   # Design System canônico
│   ├── auth/                 # Biblioteca de Autenticação
│   ├── contexto/             # Biblioteca de Contexto
│   ├── eventos/              # Biblioteca de Eventos
│   ├── sdk/                  # SDK Cliente
│   ├── runtime/              # Runtime Engine
│   └── shared/               # Tipos, utilitários, constantes
│
├── database/                 # Banco de dados
│   ├── schema/               # Dump canônico (Dump20260606.sql — FREEZE)
│   ├── procedures/           # Procedures classificadas
│   ├── views/                # Views canônicas
│   ├── migrations/           # Migrações versionadas
│   ├── seeds/                # Dados seed
│   └── ledger/               # Event Store (kernel_ledger)
│
├── workflow/                 # Workflows por domínio
│   ├── saude/
│   ├── financeiro/
│   └── ...
│
├── runtime/                  # Camada Runtime (offline-first)
│   ├── sync-engine/
│   ├── cache/
│   ├── workers/
│   └── queue/
│
├── dashboards/               # Dashboards canônicos
│
├── dispositivos/             # Dispositivos (TV, Totem, Kiosk, Mobile)
│   ├── tv/
│   ├── totem/
│   ├── kiosk/
│   └── mobile/
│
├── integracoes/              # Integrações com sistemas externos
│
├── ia/                       # Módulos de IA (Copilots, Agents, RAG)
│
├── workflow/                 # N8N, automações, workflows
│
├── packages/                 # Pacotes compartilhados (Design System, SDK)
│
├── docs/                     # Documentação canônica
│   └── canonical/
│       ├── LIVRO-*-*.md      # Constituição completa da plataforma
│       ├── MD-*.md           # Documentos canônicos técnicos
│       ├── MAP-*.md          # Mapas de arquitetura
│       ├── BR-*.md           # Regras de negócio
│       ├── FRONT-*.md        # Experiência Frontend
│       └── ADR-*.md          # Architecture Decision Records
│
├── assets/                   # Recursos estáticos
├── Captures/                 # Capturas de tela (evidências)
└── legacy/                   # Código legado CONGELADO (somente leitura)
    ├── frontend/
    ├── backend/
    ├── api/
    ├── services/
    └── ...
```

### Artigo 12 — Regras da Árvore

```text
Proibido:
- Criar estrutura alternativa em qualquer App
- Colocar código legado em diretórios canônicos
- Misturar src/ antigo com apps/ novo
- Criar pastas v2, final, backup, old, temp, copy
```

### Artigo 13 — Somente Um Frontend Canônico

```text
apps/portal é o único frontend oficial da plataforma.
Nenhum outro diretório React é canônico.

Qualquer App executa DENTRO do Shell do Portal.
Nunca como aplicação standalone em localhost:5173.
```

### Artigo 14 — Somente Um Backend Canônico

```text
backend/ é o único backend oficial da plataforma.
Nenhum outro diretório Node/API é canônico.
```

### Artigo 15 — O Legacy é Histórico

```text
legacy/ contém código congelado.
É somente leitura.
Serve como referência de conhecimento, não de implementação.
Nenhuma alteração é permitida em legacy/.
```

---

## Título IV — Banco de Dados

### Artigo 16 — MySQL é a Fonte da Verdade

```text
MySQL é a única fonte operacional da verdade.

Nenhuma camada acima do banco pode ser considerada fonte da verdade.

Frontend, Backend, IA, N8N, Redis — todos são derivados.
```

### Artigo 17 — Dump Congelado

```text
Dump20260606.sql é o banco congelado.

Ele é a referência de conhecimento para engenharia reversa.
Ele não é a arquitetura final.

Toda reconstrução de SP, View e Function
parte do dump, mas é reescrita no padrão Enterprise.
```

### Artigo 18 — Stored Procedures são a Porta de Escrita

```text
Nenhuma escrita direta em tabelas de negócio.

Toda operação relevante passa por Stored Procedure.
SP é a única porta de escrita no banco.

Frontend exibe.
Backend roteia.
SP executa.
```

### Artigo 19 — Classificação de Procedures

```text
Dispatcher     — Valida contrato, permissão, chama SP
Orquestrador   — Coordena múltiplas SPs, gerencia transação
Executor       — Executa operação específica (uma única SP)
Validator      — Valida entrada antes da operação
Ledger         — Persiste eventos no Event Store
Runtime        — Processa filas, jobs, sync
IAM            — Identidade, contexto, permissão
Kernel         — Core engine (dispatcher, sync, edge)
Workflow       — Suporta automação
```

### Artigo 20 — Views e Functions

```text
Views servem para leitura.
Functions servem para cálculo.

Exemplos:
Views: vw_painel_fila, vw_dashboard_urgencia
Functions: idade(), tempo_espera(), score()
```

### Artigo 21 — Triggers Proibidas para Lógica

```text
Triggers são proibidas para lógica de negócio.

Triggers podem existir SOMENTE para:
- Auditoria técnica
- Integração database-level
- Performance (índices, particionamento)
```

### Artigo 22 — Event Store

```text
Event Store (kernel_ledger) é a memória imutável da plataforma.

Evento é append-only.
Evento é consultável.
Evento é imutável.

Todo evento relevante é registrado.
Sem evento, não existe operação.
```

### Artigo 23 — História Não Morre

```text
Nenhuma deleção física.

Cancelamento = novo evento.
Remoção = status inativo.
Histórico = fonte da verdade.
```

### Artigo 24 — Correção via Evento

```text
Correção, não apagar.
Retificação, não sobrescrever.
Cancelamento, não DELETE.
Substituição, não UPDATE.
```

### Artigo 25 — Multi-Tenant no Banco

```text
Tenant é a primeira dimensão de tudo.

Todo dado carrega id_tenant.
Toda query filtra por tenant.
Todo evento registra tenant.

Nenhuma operação cruza tenants sem autorização explícita.
```

---

## Título V — Portal Enterprise

### Artigo 26 — Portal é a Porta

```text
Todo acesso começa no Portal.
Nenhuma App abre diretamente.
Nenhum módulo operacional é acessado por URL direta.

Fluxo obrigatório:
  Login → Portal → IAM → Selecionar Contexto → Workspace → App Registry → App → Dashboard → Operação
```

### Artigo 27 — Portal Não Decide

```text
Portal orquestra.
Apps executam.

Portal não contém regra de negócio.
Portal não valida permissões.
Portal não acessa banco.
```

### Artigo 28 — Windows-8 Style Layout

```text
Portal usa layout estilo Windows-8 / Microsoft 365.

Live Tiles mostram dados dinâmicos.
Containers representam domínios ou capabilities.
```

### Artigo 29 — App Registry

```text
Toda capacidade da plataforma é uma App registrada.

App sem Registry não existe.
App sem IAM não abre.
App opera dentro do Shell.
App respeita Design System.
```

### Artigo 30 — Displays como Cidadãos de Primeira Classe

```text
TV, Painel, Totem, Kiosk, Mobile são containers gerenciáveis no Portal.
Eles recebem contexto, permissão e dashboard da mesma forma que Apps.
```

### Artigo 31 — Contexto é Fluido

```text
1 contexto = dashboard direto.
N contextos = seleção de contexto.

Troca de contexto é imediata, sem novo login.
```

---

## Título VI — Apps Enterprise

### Artigo 32 — Domínio como App

```text
Cada domínio é uma App completa e isolada:

apps/
  ├── [dominio]/
  │   ├── app.tsx
  │   ├── routes.ts
  │   ├── manifest.ts
  │   ├── dashboard.tsx
  │   ├── pages/
  │   ├── widgets/
  │   ├── services/
  │   ├── hooks/
  │   ├── providers/
  │   ├── components/
  │   ├── layouts/
  │   ├── types/
  │   └── api/
```

### Artigo 33 — Página como Módulo

```text
Cada página de uma App é um módulo isolado:

pages/
  ├── [pagina]/
  │   ├── Dashboard/
  │   ├── Nova[Pagina]/
  │   ├── Painel/
  │   ├── Impressao/
  │   ├── Relatorios/
  │   ├── Widgets/
  │   ├── Components/
  │   ├── Hooks/
  │   ├── Services/
  │   ├── Types/
  │   └── Routes/
```

### Artigo 34 — App Não Decide Acesso

```text
IAM decide acesso.

Decisão = identidade + tenant + app + escopo + permissão + contexto.

Nenhuma App decide permissão.
Nenhuma App decide acesso.
```

### Artigo 35 — App Respeita Design System

```text
Toda App usa o Design System canônico (packages/ui).

Nenhuma App cria biblioteca visual própria.
Nenhuma App define tema próprio.
Nenhuma App define componentes próprios.
```

### Artigo 36 — App Usa SDK Canônico

```text
Toda comunicação com Backend usa o SDK canônico (packages/sdk).

Nenhuma App cria cliente HTTP próprio.
Nenhuma App acessa banco diretamente.
```

### Artigo 37 — App Emite Eventos

```text
Toda ação relevante emite evento no Event Store.

Evento é semântico, imutável, passado.
Ex: SenhaCriada, AtendimentoIniciado, DocumentoAprovado
```

---

## Título VII — Backend Enterprise

### Artigo 38 — Node é Gateway de Transporte

```text
Node valida sessão.
Node valida contexto.
Node roteia para Dispatcher.

Node não decide regra de negócio.
Node não acessa tabelas diretamente.
```

### Artigo 39 — Fluxo Canônico do Backend

```text
Route → Controller → Dispatcher → Orquestrador → Executor → SP → Ledger → Response
```

### Artigo 40 — Dispatcher Orquestra, Não Executa

```text
Dispatcher valida contrato.
Dispatcher valida permissão.
Dispatcher chama SP.
Dispatcher registra evento.

Dispatcher não executa regra de negócio.
SP executa.
```

### Artigo 41 — Contratos são Obrigatórios

```text
Toda API tem contrato explícito (OpenAPI / SDK).

Nenhuma endpoint existe sem contrato.
Nenhuma App consome API sem contrato.
```

### Artigo 42 — APIs são Stateless

```text
APIs não guardam estado em memória.
Estado compartilhado reside no Banco.

Load Balancer distribui requisições.
Qualquer instância pode atender qualquer requisição.
Escala horizontal não requer sync de estado.
```

### Artigo 43 — Backend Não Decide Regra

```text
Regra de negócio reside exclusivamente na SP.

Backend pode validar formato, mas nunca decisão de negócio.
Middleware não decide permissão (IAM decide).
Controller não decide fluxo (Dispatcher decide).
```

---

## Título VIII — Runtime Enterprise

### Artigo 44 — Offline-First é Obrigatório

```text
Plataforma funciona sem conectividade.

Runtime garante operação offline.
Sync Engine reconcilia quando online.
```

### Artigo 45 — Runtime é Camada de Execução

```text
Responsabilidades do Runtime:

- Sync Engine (delta, snapshot, reconciliação)
- Heartbeat (health check contínuo)
- Workers (processamento assíncrono)
- Fila (mensageria confiável)
- Single Writer (evita conflitos)
- Idempotência (operações repetidas são seguras)
- Cache (invalidado por evento)
- Locks (concorrência controlada)
```

### Artigo 46 — Cache é Atalho, Não Verdade

```text
Cache nunca é fonte da verdade.
Cache é derivado do banco ou do Event Store.
Cache é invalidado por evento ou mudança de contexto.
Cache não serve para decisão de negócio.
Cache serve para performance.
```

---

## Título IX — IAM (Identidade e Acesso)

### Artigo 47 — IAM Decide Acesso

```text
Acesso não é cargo.
Acesso é decisão.

Decisão = identidade + tenant + app + escopo + permissão + contexto.

IAM decide.
Nenhuma App decide.
Nenhuma camada decide.

Decisão é centralizada, auditável e multi-tenant.
```

### Artigo 48 — Identidade é Permanente

```text
Usuário não muda.
Contexto muda.

Um usuário pode operar em múltiplos tenants, unidades, locais e perfis.
Sem criar nova conta.
Sem perder histórico.
Sem perder permissões.
```

### Artigo 49 — Pessoa é Raiz

```text
Pessoa é a entidade raiz da plataforma.
Identidade pertence à Pessoa, não ao Tenant.

Uma Pessoa pode existir em múltiplos Tenants simultaneamente.
Dados assistenciais pertencem ao Tenant onde ocorreram.
Contexto é o filtro de isolamento de dados.
```

### Artigo 50 — Cookies HttpOnly, Secure, SameSite=Strict

```text
JWT é armazenado em Cookie HttpOnly, Secure, SameSite=Strict.

Token nunca em localStorage.
Token nunca em sessionStorage.
Token nunca em URL.
```

### Artigo 51 — MFA é Obrigatório

```text
Multi-Factor Authentication é obrigatório para todos os usuários.

MFA não é opcional para administradores.
MFA não é opcional para usuários internos.
```

---

## Título X — IA Colaborativa

### Artigo 52 — IA Sugere, Não Decide

```text
IA sugere.
IA analisa.
IA resume.
IA não altera dados sem autorização humana explícita.

Decisão final é sempre humana.
Todo output de IA é auditável.
```

### Artigo 53 — Fluxo Obrigatório Antes de Implementar

```text
Antes de escrever qualquer código:

1. Ler a Constituição da Plataforma (este documento)
2. Ler a Constituição das IAs (000-CONSTITUICAO-IA.md)
3. Ler Arquitetura (MD-100, MDs relacionados)
4. Ler Engenharia (LIVRO-08, padrões de código)
5. Ler MD do domínio
6. Ler MAP do domínio
7. Ler BR do domínio
8. Ler FRONT do domínio
9. Ler ADR relevante
10. Ler Dump (somente conhecimento, não implementação)
11. Procurar implementação existente
12. Identificar GAP
13. Propor solução
14. Atualizar documentação (se necessário)
15. Só então gerar código
```

### Artigo 54 — Todas as IAs São Iguais

```text
KiloCode, ChatGPT, Claude, Gemini, Copilot, AVA e qualquer outra IA
seguem EXATAMENTE a mesma constituição.

Nenhuma IA tem privilégio arquitetural.
Nenhuma IA pode divergir da lei canônica.
```

### Artigo 55 — Prompts são Ativos

```text
Todo prompt que gera código, documento ou decisão é registrado.
Todo prompt é auditável.
Nenhum prompt é executado sem validação de documentação.
```

---

## Título XI — Workflow e Automação

### Artigo 56 — N8N é Infraestrutura

```text
N8N não é ferramenta isolada.
N8N é infraestrutura canônica.

Todo workflow é versionado.
Todo workflow é auditado.

Workflow sem aprovação não vai para produção.
Credenciais no Vault, nunca no código.
```

### Artigo 57 — Workflow Não Acede Banco Direto

```text
Workflow segue fluxo:
  Dispatcher → Orquestrador → Executor → Evento

Workflow nunca acessa banco diretamente.
Workflow nunca decide regra de negócio.
```

### Artigo 58 — Automação com Governança

```text
Automação sem governança é risco.
Automação com governança é poder.

Todo fluxo automatizado tem:
- Dono responsável
- Aprovação formal
- Testes de sanidade
- Rollback planejado
- Auditoria obrigatória
```

---

## Título XII — Anti-Patterns Proibidos

### Artigo 59 — Lista de Proibições Absolutas

```text
❌ Regra de negócio em controller
❌ Regra de negócio em service
❌ Regra de negócio em middleware
❌ Regra de negócio em frontend
❌ Regra de negócio em N8N
❌ Regra de negócio em IA
❌ CRUD direto em tabela
❌ SELECT sem filtro de tenant
❌ INSERT/UPDATE/DELETE sem SP
❌ SELECT em tabela de outro tenant
❌ Frontend decide permissão
❌ App decide acesso
❌ Dados hardcoded no frontend
❌ Token em localStorage
❌ Prompt sem auditoria
❌ Workflow sem aprovação
❌ Evento sem tenant
❌ Deleção física de dado
❌ Criar v2, final, backup, old, temp
❌ Usar código legado como referência de implementação
❌ App fora do Registry
❌ Frontend acessando banco
❌ Backend alterando tabela diretamente
❌ Trigger com lógica de negócio
❌ Redis como fonte da verdade
❌ App standalone em localhost
❌ Queue sem idempotência
❌ Workflow sem retry/compensação
❌ Contrato sem documentação
❌ API sem versionamento
❌ Documento duplicado
❌ Documento sem status declarado
❌ IA alterando dados sem aprovação humana
❌ Push direto para main
❌ Commit com segredo ou chave
❌ Log com dado sensível
```

---

## Título XIII — Qualidade e CI/CD

### Artigo 60 — Qualidade é Não-Negociável

```text
Nenhum código vai para produção sem:

- Testes unitários
- Testes de integração
- Lint aprovado
- Typecheck aprovado
- Documentação atualizada
- Auditoria de segurança
- Validação de contrato
```

### Artigo 61 — Pipeline Obrigatória

```text
Todo repositório possui CI/CD canônico:

1. Lint
2. Testes
3. Build
4. Validação de contrato
5. Auditoria de segurança
6. Deploy para homologação
7. Validação humana
8. Deploy para produção
```

### Artigo 62 — Versionamento Semântico

```text
MAJOR.MINOR.PATCH

- MAJOR: mudança incompatível
- MINOR: nova feature compatível
- PATCH: correção de bug

Todo release tem changelog.
Todo release tem nota de versão.
```

---

## Título XIV — Governança da Plataforma

### Artigo 63 — Processo de Alteração Arquitetural

```text
Toda alteração arquitetural requer:

1.ADR (Architecture Decision Record)
2. Discussão com arquitetos
3. Atualização dos MDs e MAPs afetados
4. Aprovação formal
5. Planejamento de migração
6. Execução em fases
7. Validação pós-implementação
```

### Artigo 64 — Hierarquia Documental

```text
Em caso de conflito, prevalece:

1. Esta Constituição da Plataforma (000)
2. MD-110 — Leis Canônicas Supremas
3. MD-100 — Unified Enterprise Operating System
4. MD canônicos específicos do domínio
5. MAPs de arquitetura
6. BRs de regra de negócio
7. FRONTs de experiência
8. ADRs
9. Constituição das IAs (000-CONSTITUICAO-IA.md)
10. Documentos operacionais
```

### Artigo 65 — Estrutura de Governança

```text
Arquiteto Chefe: aprova todas as alterações arquiteturais.
Líderes de Domínio: responsáveis por MD/MAP/BR do domínio.
Engenharia: responsável por implementação e qualidade.
IA: executa dentro dos limites desta constituição.
Auditoria: valida conformidade contínua.
Toda decisão é registrada em ADR.
```

### Artigo 66 — Evolução Contínua

```text
Esta constituição é um documento vivo.

Ela é atualizada conforme a plataforma evolui.
Ela é versionada.
Ela é auditada periodicamente.

Nenhuma alteração é feita sem registro formal.
```

---

## Título XV — Arquitetura de Plataforma e Congelamento do Ciclo 1

### Artigo 67 — Camadas da Constituição da Plataforma

A plataforma organiza-se em quatro camadas. Nenhuma camada
superior é contornada por camada inferior.

```text
CAMADA CONSTITUCIONAL
  Leis Canônicas (LEI 01...26)
  ADRs
  Princípios de Engenharia
  Banco Vivo
  Knowledge Graph

CAMADA DE ENGENHARIA
  MDs  MAPs  BRs  FRONTs  Dossiês  Gates

CAMADA DE EXECUÇÃO
  Runtime → Master → Guardião → Dispatcher
          → Executor → Stored Procedures

CAMADA DE CONSUMO
  React · Mobile · Kiosk · TV Display
  APIs · MCP · Agentes de IA
```

A capacidade (Capability) é a unidade de engenharia.
Novo domínio começa por Capability, não por tabela.

### Artigo 68 — Congelamento do Ciclo Arquitetural 1

O primeiro ciclo de definição da arquitetura de plataforma
está encerrado e CONGELADO. O congelamento preserva a fundação
enquanto os domínios são materializados.

```text
✅ LEI 23 — Portal é Runtime, Não Interface
✅ LEI 24 — Lei da Integração Universal da Plataforma
✅ LEI 25 — Lei da Descoberta Canônica de Capacidades
✅ LEI 26 — Lei da Execução Canônica
✅ MAP-019 — AI Domain Architecture
✅ MD-110  — Canonical Laws (fundação Runtime/Integração)
✅ Arquitetura Runtime (AI/Portal/Farmácia/Estoque/...)
```

Regras do congelamento (Art. 63 e Art. 65):

```text
- Congelamento NÃO impede evolução, apenas estabiliza a fundação.
- Alteração exige ADR + aprovação do Arquiteto Chefe.
- Evolução ocorre por NOVOS DOMÍNIOS (Portal, Farmácia,
  Estoque, Financeiro, ...), seguindo as leis, não alterando-as.
- Validação sempre contra banco vivo, Knowledge Graph e MDs.
```

### Artigo 69 — Próximo Grande Passo: Materialização

Após o congelamento, a prioridade migra de "definir arquitetura"
para "materializar a plataforma":

```text
1. Capability Registry (real) — catálogo, ações, contratos,
   runtimes, permissões no banco vivo.
2. Runtime Registry (real)    — cada Runtime registrado e
   descoberto dinamicamente.
3. Tool Registry (real)       — Portal, Mobile, MCP, CLI,
   Jobs, Automação (não só IA).
4. Capability Resolver        — responde "quem executa esta
   capacidade?" sem expor SP/tabela/Runtime/Executor.
5. Graph Runtime (futuro)     — Knowledge Graph dirigindo a
   engenharia: análise de impacto, consistência, suporte a IAs.
```

### Artigo 70 — GATE-PLATFORM-001: Fundação Congelada

Todo novo domínio (Portal, Farmácia, Financeiro, RH, Estoque, ...)
deve passar obrigatoriamente pelo `GATE-PLATFORM-001` antes de
iniciar. O gate impede reintrodução de arquitetura paralela e
qualquer alteração da fundação congelada (LEI 23–26, Runtime,
Kernel, MAP-019, MD-110).

```text
Checklist (resumo):
  Arquitetura : respeita Constituição, não viola LEI 23–26,
                não altera Runtime/Kernel, não cria fluxo paralelo
  Banco Vivo  : dump analisado, KG consultado,
                REUSE→ADAPT→EXTEND→MERGE→somente então PROPOSE
  Engenharia  : MD, MAP, BR, FRONT, Contratos, APIs, Runtime
  Materializ. : Master, Dispatcher, Executors, Procedures,
                Auditoria, Eventos
  IA          : Capability/Tool/Runtime Registry, AI Runtime,
                MCP compatíveis
```

Falha em Arquitetura → domínio bloqueado (retorna a ADR +
Arquiteto Chefe). Documento completo: `docs/canonical/GATE-PLATFORM-001.md`.

### Artigo 71 — Precedência de Leitura das IAs

A Constituição é o documento de MÁXIMA precedência para toda IA
de engenharia. Toda IA segue ordem de leitura explícita antes
de produzir código, documento ou decisão.

```text
Constituição
   ↓
Leis
   ↓
ADRs
   ↓
Banco Vivo
   ↓
Knowledge Graph
   ↓
MDs
   ↓
MAPs
   ↓
BRs
   ↓
FRONTs
   ↓
Código
```

Variação coerente (Banco Vivo como fonte primária de dados):

```text
Constituição → Leis → ADRs → Banco Vivo → Knowledge Graph
   → MDs → MAPs → BRs → FRONTs → Código
```

Complementa o Art. 53 (Fluxo Obrigatório Antes de Implementar).
Nenhuma IA tem privilégio arquitetural (Art. 54).

### Artigo 72 — O Banco é Quádrupla Fonte

O banco não é apenas persistência. Ele desempenha quatro papéis
simultâneos, o que justifica decisões que começam no dump, nas
SPs e no grafo antes do código.

```text
1. Fonte da verdade dos dados      (estado operacional)
2. Fonte da verdade da engenharia  (Banco Vivo)
3. Base de descoberta de capacidades (Runtime + Registry)
4. Base de conhecimento navegável  (Knowledge Graph)
```

Essa convergência mantém a plataforma consistente e reduz
retrabalho conforme ela cresce.

---

## Título XVI — Ciclo 2: Materialização

O Ciclo Arquitetural 1 está encerrado e congelado (Art. 68).
O risco deixa de ser arquitetura e passa a ser **execução
disciplinada**. Nenhuma nova lei é aberta; a fundação não é
revisada exceto por ADR formal (Art. 63/65).

### Artigo 73 — Objetivo do Ciclo 2

```text
Antes: construir a arquitetura.
Agora:  construir domínios USANDO a arquitetura.
```

Esforço direcionado para:
1. Materializar os domínios (Portal, Farmácia, Estoque, Financeiro...).
2. Aumentar a cobertura de capacidades.
3. Consolidar Banco Vivo e Knowledge Graph como fontes de verdade.
4. Automatizar os GATEs sempre que possível.

### Artigo 74 — Ordem Obrigatória de Materialização de Domínio

Nenhum domínio pula etapas. Sequência canônica:

```text
GATE-PLATFORM-001
   ↓
Banco Vivo
   ↓
Knowledge Graph
   ↓
MD
   ↓
MAP
   ↓
BR
   ↓
Contratos
   ↓
APIs
   ↓
Runtime
   ↓
Master
   ↓
Dispatcher
   ↓
Executor
   ↓
SQL
   ↓
Backend
   ↓
Frontend
   ↓
Testes
   ↓
Dossiê
   ↓
GATE (validação final)
```

### Artigo 75 — Indicador: Cobertura por Capability

Volume de artefatos (tabelas, SPs, MDs) é insuficiente.
O indicador central do Ciclo 2 é maturidade funcional:

```text
Portal
  ✅ Dashboard   ✅ Widgets
  ⬜ Favoritos   ⬜ Notificações
  ⬜ Layout      ⬜ Busca   ⬜ Home

Farmácia
  ✅ Consulta
  ⬜ Dispensação ⬜ Prescrição ⬜ Lotes
  ⬜ Inventário  ⬜ Transferência ⬜ Devolução
```

### Artigo 76 — Indicador: Rastreabilidade de Capability

Cada Capability deve ser totalmente rastreável. Elo ausente
gera STATUS INCOMPLETO e falha no GATE.

```text
Capability → MD → MAP → BR → Contrato → API
   → Runtime → Master → Executor → SP → Tabela
```

```text
Se algum elo estiver ausente → STATUS: INCOMPLETO
Pode virar validação automática do GATE-PLATFORM-001.
```

### Artigo 77 — Capacidade é a Unidade, Não o Módulo

Parar de pensar em "telas/módulos". Pensar em capacidades.

```text
Portal não é um módulo. É um conjunto de capacidades.
Farmácia não é um módulo. É um conjunto de capacidades.
Financeiro não é um módulo. É um conjunto de capacidades.
```

A plataforma responde:
  "Quais capacidades existem?"
e não:
  "Quais telas existem?"

Isso é coerente com LEI 25 (descoberta) e LEI 26 (execução).

---

## Anexo A — Glossário de Domínios Oficiais

```text
CORE     — Plataforma, Runtime, Dispatcher, Kernel
IAM      — Identidade, Auth, Permissões, Contexto
PORTAL   — App Registry, Dashboard, Shell, UX
WORKFLOW — N8N, Automação, Sistemas legados
KERNEL   — Runtime, Sync, Edge, Offline-First
SOCIAL   — Chat, Comunidade, Colaboração
CHAT     — Mensagens, Comunicação em tempo real
WIKI     — Documentação, Conhecimento, Artigos
ANALYTICS— Dados, Métricas, KPIs, BI
HIS      — Senha, Atendimento, Internação, Farmácia
CRM      — Lead, Contato, Oportunidade
RH       — Colaborador, Escala, Avaliação
FINANCE  — Contas, Receitas, Pagamentos
DOCUMENTS— Anexos, Documentos, Arquivos
MARKETPLACE — Apps, Extensões, SDK
AVALIACAO— Feedback, Notas, Avaliações
```

---

## Anexo B — Hierarquia de Verdade

```
BANCO (MySQL)
  └── Fonte da Verdade
      └── Stored Procedures
          └── Regra de Negócio Canônica
              └── Event Store (kernel_ledger)
                  └── Rastro Oficial
                      └── Analytics (derivado)
                          └── BI / Dashboards (derivado)
                              └── Frontend (leitura/projeção)
                                  └── Cache (atalho)
```

---

## Anexo C — Matriz de Responsabilidade de Camadas

| Camada | Decidir | Validar | Executar | Escrever | Exibir | Auditar |
|--------|---------|---------|----------|----------|--------|---------|
| Frontend | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ |
| Backend | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Dispatcher | ❌ | ✅ | ✅ (roteia) | ❌ | ❌ | ✅ |
| SP | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ |
| Event Store | ❌ | ✅ | ✅ (registra) | ✅ (append) | ❌ | ✅ |
| IA | ❌ | ❌ | ✅ (sugere) | ❌ | ✅ (sugere) | ❌ |
| N8N | ❌ | ❌ | ✅ (automa) | ✅ (via SP) | ❌ | ✅ |

---

## Lei Final Absoluta

```text
Banco é a Fonte da Verdade.
SP é a porta de entrada.
Evento é a memória.
Portal é a porta.
Apps executam.
IA auxilia.
Contexto é chave.
Tenant é ilha.
Plataforma é oceano.

Nada existe fora do Banco.
Nada existe fora do Contexto.
Nada existe fora do Evento.
Nada existe fora da Lei Canônica.
Nada existe fora da Pessoa Raiz.
```

---

**Constituição da Plataforma Midas Enterprise — Projeto AtendimentoOfflineAlpha**
**Versão 1.0 — Status: CANÔNICO CONSOLIDADO**
