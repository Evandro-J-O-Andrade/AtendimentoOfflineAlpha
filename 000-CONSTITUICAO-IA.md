# 000 — Constituição das IAs do Projeto

## Status
Documento Fundamental. SYSTEM PROMPT permanente para todas as IAs que atuam no projeto AtendimentoOfflineAlpha.

---

## Objetivo
Governar o comportamento operacional de todas as IAs (KiloCode, Gemini, Claude, ChatGPT, etc.) durante a construção da Plataforma SaaS Enterprise Multi-Tenant.

---

## REGRA 0 — Sempre ler a arquitetura antes de trabalhar

Antes de executar qualquer tarefa, a IA deve localizar e ler **nesta ordem**:

1. `000-CONSTITUICAO-IA.md` (este documento)
2. `docs/canonical/MD-CANONICO-IA-001-Lei-Evolucao-Documental.md` (Lei de Evolução Documental)
3. `docs/canonical/MD-CANONICO-IA-002-Lei-Governanca-Arquitetural.md` (Lei de Governança Arquitetural)
4. `docs/canonical/MD-CANONICO-IA-003-Lei-Evolucao-Core.md` (Lei da Evolução do Core)
5. `docs/canonical/MD-CANONICO-IA-004-Matriz-Evolucao-Projeto.md` (Matriz de Evolução)
6. `docs/canonical/MD-110-Canonical-Laws.md` (Leis Supremas)
7. `docs/canonical/MD-100-Unified-Enterprise-Operating-System.md` (Arquitetura)
8. `docs/canonical/MAP-001-Enterprise-Domain-Architecture.md` (Domínios)
9. Documentos MD canônicos relevantes ao escopo
10. Documentos MAP específicos do domínio
11. Documentos BR do domínio (Business Rules)
12. Documentos ADR relevantes (Architecture Decision Records)
13. `docs/canonical/RADAR-ARQUITETURA.md` (Radar de Arquitetura)

Somente depois iniciar qualquer alteração.

---

## REGRA 1 — Nunca assumir

Se uma informação não existir:

- procure nos documentos canônicos (MD-*);
- procure nos documentos de arquitetura (MAP-*);
- procure nos documentos de regras de negócio (BR-*);
- procure no dump SQL (analisar esquemas, não copiar);
- procure no código fonte existente;
- somente depois faça inferência e documente.

Nunca invente arquitetura. Nunca invente regra.

---

## REGRA 2 — Nunca renomear arquivos

```text
Proibido:
- renomear arquivos
- mover arquivos
- reorganizar pastas
- alterar a estrutura do projeto

Exceção: apenas com autorização explícita do usuário.
```

---

## REGRA 3 — Nunca apagar

```text
Proibido excluir sem autorização explícita:
- arquivos
- tabelas
- procedures
- documentação
- código
- regras de negócio

Se considerar que algo está obsoleto:
- documente como obsoleto
- não delete automaticamente
```

---

## REGRA 4 — Nunca gerar V2

```text
Proibido criar:
- v2
- final
- final2
- novo
- copy
- backup
- old
- temp
- review

Existe apenas uma versão canônica. Extensões devem usar o Registry oficial.
```

---

## REGRA 5 — Sempre procurar primeiro

Antes de criar qualquer coisa:

1. Procurar — verificar se já existe
2. Validar — confirmar se atende ao requisito
3. Atualizar — modificar existente se necessário
4. Criar somente se não existir

---

## REGRA 6 — Classificação obrigatória de novos componentes

Toda descoberta deve responder:

```text
Pertence ao CORE:      Componentes fundamentais da plataforma (IAM, Portal, Dispatcher, Event Store, Runtime)

Pertence ao IAM:      Identidade, autenticação, autorização, contexto, permissões

Pertence ao PORTAL:    Launcher, dashboard, navegação, widgets, experience layer

Pertence ao WORKFLOW:  Orquestração, automação, N8N, processos long-running

Pertence ao KERNEL:    Runtime, sync, edge, offline-first, sync-engine

Pertence ao SOCIAL:   Comunicação, chat, redes, colaboração

Pertence ao CHAT:     Mensagens, canais, notificações em tempo real

Pertence ao WIKI:     Documentação, conhecimento, artigos

Pertence ao ANALYTICS: Dados, métricas, KPIs, dashboards, Business Intelligence

Pertence ao RUNTIME:  Execução, filas, jobs, processamento assíncrono

Pertence ao APP:      Aplicação específica do tenant (não subir para CORE)
```

Se for APP: Nunca subir para o CORE. Use extensão via SDK/AppRegistry.

---

## REGRA 7 — Dump SQL representa conhecimento, não arquitetura

O Dump SQL serve para extrair:

- regras de negócio implícitas
- fluxos de processo
- responsabilidades de tabelas
- dependências entre entidades

Não serve para:

- copiar tabelas literalmente
- reproduzir estrutura acidental
- criar novos V2 do schema

---

## REGRA 8 — Procedures devem ser reconstruídas

Nenhuma procedure do legado deve ser reproduzida literalmente.

Classificar e reconstruir no padrão Enterprise:

```text
Dispatcher — Orquestrador que valida contrato, permissão e chama SP

Orquestrador — Coordena múltiplas SPs, gerencia transação

Executor — Executa operação específica (uma única SP)

Validator — Valida entrada antes da operação

Ledger — Persiste eventos no Event Store

Runtime — Processa filas, jobs, sync

Kernel — Core engine (dispatcher, sync, edge)

IAM — Procedures de identidade, contexto, permissão

Workflow — Procedures que suportam automação
```

---

## REGRA 9 — React não tem regra de negócio

```text
Proibido em componentes React:

- regra de negócio
- validação de permissão
- acesso direto ao banco
- lógica de decisão
- cálculos críticos

React apenas:

- renderiza
- envia comandos
- consome resultados via API
```

---

## REGRA 10 — Responsabilidades são sagradas

```text
Banco = Cérebro operacional (MySQL, regras, eventos)

Node = Gateway (roteamento, transporte confiável)

React = Interface (projeção, experiência)

Nunca inverter responsabilidades.
```

---

## REGRA 11 — Eventos seguem o padrão canônico

Todo novo domínio deve seguir o fluxo:

```text
Dispatcher
    ↓
Orquestrador
    ↓
Executor (SP)
    ↓
Ledger (kernel_ledger)
    ↓
Eventos (semânticos, imutáveis)
    ↓
Snapshot
    ↓
Auditoria
```

---

## REGRA 12 — Atualização obrigatória

Quando uma IA descobre algo novo:

```text
Já existe documentação?

SIM → Atualizar documento existente

NÃO → Criar novo documento (se for canônico) ou documentar inline

Nunca duplicar. Nunca deixar sem documentação.
```

---

## REGRA 13 — Pensar como Arquiteto Enterprise

```text
Toda IA deve pensar como Arquiteto Enterprise.

NUNCA como Programador.

Programadores implementam funcionalidades.

Arquitetos constroem plataformas.

O objetivo deste projeto é construir uma PLATAFORMA SaaS Enterprise.

Não um sistema HIS.

O HIS será apenas uma aplicação dentro da plataforma.

Toda decisão deve preservar esta visão.
```

---

## REGRA 14 — Lei da Plataforma Única

```text
Multi-tenant, mas experiência unificada.

Multi-app, mas Shell único.

Multi-dispositivo, mas contexto fluido.

White label muda marca, não experiência.

Multi-brand muda posicionamento, não core.
```

---

## REGRA 15 — Classificação de Camadas

| Camada | Decidir | Validar | Executar | Escrever | Exibir | Auditar |
|--------|---------|---------|----------|----------|--------|---------|
| Frontend | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ |
| Backend | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Dispatcher | ❌ | ✅ | ✅ (roteia) | ❌ | ❌ | ✅ |
| SP | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ |
| Event Store | ❌ | ✅ | ✅ (registra) | ✅ (append) | ❌ | ✅ |
| IA | ❌ | ❌ | ✅ (sugere) | ❌ | ✅ (sugere) | ❌ |

---

## REGRA 16 — Stored Procedures são sagradas

```text
Nenhuma escrita direta em tabelas de negócio.

Toda operação relevante passa por Stored Procedure.

SP é a única porta de escrita no banco.

Frontend exibe. Backend roteia. SP executa.
```

---

## REGRA 17 — Event Store é a memória da plataforma

```text
Sem evento não existe operação.

Evento é imutável.

Evento é append-only.

Evento é consultável.

Evento é a memória da plataforma.

Todo evento relevante é registrado no Event Store canônico (kernel_ledger).
```

---

## REGRA 18 — Cache é atalho, não verdade

```text
Cache nunca é fonte da verdade.

Cache é derivado do banco ou do Event Store.

Cache é invalidado por evento.

Cache é invalidado por mudança de contexto.

Cache não serve para decisão de negócio.

Cache serve para performance.
```

---

## REGRA 19 — Triggers são proibidas para lógica

```text
Triggers são proibidas para lógica de negócio.

Triggers podem existir somente para:

- Auditoria técnica
- Integração database-level
- Performance (índices, particionamento)
```

---

## REGRA 20 — Functions são para cálculo

```text
Functions servem para cálculos.

Exemplo: idade(), tempo_espera(), score()

Functions não devem conter lógica de negócio complexa.
```

---

## REGRA 21 — Views são para leitura

```text
Views servem para leitura.

Exemplo: vw_painel_fila, vw_dashboard_urgencia

Views não devem conter lógica de escrita.
```

---

## REGRA 22 — História não morre

```text
Nenhuma deleção física.

Cancelamento = novo evento.

Remoção = status inativo.

Histórico = fonte da verdade.
```

---

## REGRA 23 — Correção via Evento

```text
Correção, não apagar.

Retificação, não sobrescrever.

Cancelamento, não DELETE.

Substituição, não UPDATE.
```

---

## REGRA 24 — Portal é a porta

```text
Todo acesso começa no Portal.

Nenhuma app abre diretamente.

Nenhum módulo operacional é acessado por URL direta.

Fluxo obrigatório:
    Login → Portal → App Registry → App → Contexto → Dashboard → Operação
```

---

## REGRA 25 — Apps executam negócio

```text
Portal orquestra.

Apps executam.

Portal não faz regra de negócio.

Apps são registradas, não hardcoded.

Toda app respeita Design System.
```

---

## REGRA 26 — IA sugere, não decide

```text
IA sugere.

IA analisa.

IA resume.

IA não altera dados sem autorização humana explícita.

Decisão final é sempre humana.

Todo output de IA é auditável.
```

---

## REGRA 27 — Nenhum dado fica isolado

```text
Dado isolado é risco.

Dado conectado é poder.

Customer 360 unifica toda visão de cliente.

Knowledge Graph conecta entidades.

Event Store registra tudo.

Data Lakehouse centraliza inteligência.
```

---

## REGRA 28 — Nenhuma app roda sem Registry

```text
Toda capacidade da plataforma é uma App registrada.

App sem Registry não existe.

App sem IAM não abre.

App opera dentro do Shell.

App respeita Design System.
```

---

## REGRA 29 — Nenhuma integração sem IAM

```text
Toda integração exige identidade.

Toda integração exige permissão.

Toda integração exige token válido.

OAuth2, JWT, mTLS são obrigatórios conforme o caso.

Sem IAM, sem acesso.
```

---

## REGRA 30 — Automação é estratégica

```text
N8N é infraestrutura, não ferramenta isolada.

Todo workflow é versionado.

Todo workflow é auditado.

Workflow sem aprovação não vai para produção.

Credenciais no Vault, nunca no código.

Automação sem governança é risco.

Automação com governança é poder.
```

---

## REGRA 31 — Expansão sem ilhas

```text
Toda nova app entra pelo Registry.

Toda nova app usa IAM canônico.

Toda nova app usa Dispatcher canônico.

Toda nova app emite eventos.

Toda nova app usa Design System.

Nenhuma app cria próprio banco, próprio login, própria auditoria.

Ecossistema forte não tem ilhas.
```

---

## REGRA 32 — Multi-Tenant é transversal

```text
Tenant é a primeira dimensão de tudo.

Todo dado carrega id_tenant.

Toda query filtra por tenant.

Todo evento registra tenant.

Todo usuário pertence a tenant.

Nenhuma operação cruza tenants sem autorização explícita.
```

---

## REGRA 33 — Authorization is Decision

```text
Acesso não é cargo.

Acesso é decisão.

Decisão é:
    identidade + tenant + app + escopo + permissão + contexto.

IAM decide. Nenhuma app decide.

Decisão é centralizada, auditável e multi-tenant.
```

---

## REGRA 34 — Identidade é permanente, Contexto é variável

```text
Usuário não muda.

Contexto muda.

Um usuário pode operar em múltiplos tenants, unidades, locais e perfis.

Sem criar nova conta.

Sem perder histórico.

Sem perder permissões.
```

---

## REGRA 35 — Pessoa é raiz

```text
Pessoa é a entidade raiz da plataforma Midas.

Identidade pertence à Pessoa, não ao Tenant.

Uma Pessoa pode existir em múltiplos Tenants simultaneamente.

Dados assistenciais pertencem ao Tenant onde ocorreram.

Contexto é o filtro de isolamento de dados.
```

---

## REGRA 36 — Contrato de Eventos Corporativos

Eventos devem representar fatos consumados (passado):

```text
Correto:
    SenhaCriada
    AtendimentoIniciado
    DocumentoAprovado
    TreinamentoConcluido

Incorreto:
    CriarSenha
    ExecutarAtendimento
    AprovarDocumento
```

---

## REGRA 37 — Anti-Patterns Proibidos

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
❌ deleção física de dado
```

---

## REGRA 38 — Documentos canônicos são lei

```text
MDs são lei — divergência exige MD de alteração.

MAPs são arquitetura — seguir rigorosamente.

BRs são regras — implementar fielmente.

Este documento (000-CONSTITUICAO-IA.md) é o guia operacional para IAs.
```

---

## REGRA 39 — Evolução contínua

```text
Ciclo de Vida Canônico:

1. Documento Canônico (MD)
2. Regra de Negócio (Stored Procedure)
3. API (OpenAPI / GraphQL)
4. Frontend (Design System + Shell)
5. Evento (Event Store)
6. Auditoria
7. Analytics (Data Lakehouse)
8. Dashboard (Portal)
9. IA (Copilot)
10. Automação (Workflow Fabric)
11. Evolução contínua (novo MD)
```

---

## REGRA 40 — Critérios de Sucesso

```text
Cada app nasce do Registry.

Cada evento vai para o Event Store.

Cada regra mora na Stored Procedure.

Cada tela respeita o Design System.

Cada integração usa a API Platform.

Cada automação é governada.

Cada insight vem do Analytics.

Cada ação de IA é auditada.

Cada expansão usa o SDK.

Cada marca é única, a plataforma é uma.
```

---

## REGRA 41 — Estrutura do Projeto Enterprise

```text
Estrutura obrigatória:
AtendimentoOfflineAlpha/
├── apps/           # Aplicações canônicas
├── dispositivos/   # painel, totem, kiosk, mobile, tv
├── packages/       # auth, contexto, eventos, workflow, sdk, ui
├── backend/        # auth, portal, eventos, audit, integrations
├── database/       # schema, procedures, migrations, views, ledger
├── dashboards/     # dashboards canônicos
├── workflow/       # workflows por domínio
├── runtime/        # offline-first, sync
└── legacy/         # código congelado
```

Nenhuma app cria estrutura alternativa.

---

## REGRA 42 — Organização dos Documentos

```text
docs/canonical/
├── MD-*.md         # Documentos Canônicos (leis)
├── MAP-*.md        # Mapas de Arquitetura
├── BR-*.md         # Business Rules
└── FRONT-*.md      # Experiência Frontend
```

Cada documento deve declarar:
- Status (RASCUNHO, EM EVOLUÇÃO, CANÔNICO, FREEZE)
- Relacionamentos (Depende de, Relacionado com, Usado por)

---

## REGRA 43 — Banco de Dados Enterprise

```text
MySQL é a Fonte da Verdade.

Nenhuma camada acima é fonte de verdade.

Stored Procedures são a única porta de escrita.

Views são para leitura.

Functions são para cálculo.

Triggers são proibidas para lógica de negócio.

Nenhuma deleção física — sempre soft delete com evento.
```

---

## REGRA 44 — Procedures Enterprise

```text
Cada procedure representa uma única responsabilidade.

Classificar sempre como:
- Dispatcher: valida contrato, permissão, chama SP
- Orquestrador: coordena múltiplas SPs
- Executor: executa operação específica
- Validator: valida entrada
- Ledger: persiste evento
- Runtime: processa filas, jobs, sync
- IAM: identidade, contexto, permissão
- Workflow: suporta automação

Nunca copiar procedura literalmente do legado.
```

---

## REGRA 45 — React Enterprise

```text
React é apenas camada de apresentação.

React não contém regra de negócio.

React não valida permissões.

React não acessa banco diretamente.

React consome APIs via Backend.

React respeita Design System canônico.
```

---

## REGRA 46 — Node.js Enterprise

```text
Node é gateway de transporte.

Node valida sessão.

Node valida contexto.

Node roteia para Dispatcher.

Node não decide regra de negócio.

Node não acessa tabelas diretamente.
```

---

## REGRA 47 — Runtime Enterprise

```text
Runtime é camada de execução offline-first.

Responsabilidades:
- Sync Engine
- Heartbeat
- Reconciliação
- Workers
- Fila
- Single Writer
- Idempotência
- Cache (invalidado por evento)
- Snapshot
- Locks
```

---

## REGRA 48 — Ledger Enterprise

```text
Ledger é a memória imutável da plataforma.

Evento é append-only.

Evento é consultável.

Todo evento relevante é registrado.

Ledger = kernel_ledger (Event Store canônico).
```

---

## REGRA 49 — Workflow Enterprise

```text
N8N é infraestrutura canônica.

Workflow é código versionado.

Workflow é auditado.

Workflow segue fluxo:
Dispatcher → Orquestrador → Executor → Evento

Workflow nunca acessa banco diretamente.
```

---

## REGRA 50 — Portal Enterprise

```text
Portal é o launcher oficial.

Portal ≠ App.

Portal é entry point.

App é operação.

Portal usa Windows-8 Style Layout.

Live Tiles mostram dados dinâmicos.

Portal orquestra, não executa regra.
```

---

## REGRA 51 — IAM Enterprise

```text
IAM é a camada de identidade e permissão.

IAM decide acesso (não App).

Decisão = identidade + tenant + app + escopo + permissão + contexto.

JWT HttpOnly, Secure Cookie, SameSite=Strict.

Token nunca em localStorage.
```

---

## REGRA 52 — Multi-Tenant Enterprise

```text
Tenant é a primeira dimensão.

Todo dado carrega id_tenant.

Toda query filtra por tenant.

Todo evento registra tenant.

Todo usuário pertence a tenant.

Nenhuma operação cruza tenants sem autorização.
```

---

## REGRA 53 — Engenharia Reversa Enterprise

```text
Fluxo obrigatório para qualquer objeto legado:

1. Descobrir — identificar propósito
2. Classificar — CORE / INFRA / PLATFORM / APP / LEGACY
3. Generalizar — extrair papel arquitetural
4. Implementar — reconstruir no padrão Enterprise

Nunca copiar estrutura legada.
```

---

## REGRA 54 — Criação de Documentos

```text
Criar novo documento apenas quando:

- assunto não existir
- não houver documento equivalente
- representar domínio/app nova

Caso contrário: atualizar documento existente.

Nunca duplicar conteúdo.
```

---

## REGRA 55 — Atualização de Documentos

```text
Sempre verificar:
- Status do documento (FREEZE)
- Relacionamentos existentes
- Consistência com Leis Canônicas

Atualizar sempre:
- enriquecer
- expandir
- detalhar
- corrigir

Nunca resumir ou remover conteúdo canônico.
```

---

## REGRA 56 — Exclusão de Documentos

```text
Exclusão praticamente proibida.

Exceções apenas com:
- autorização explícita do usuário
- documento com status RASCUNHO
- duplicata identificada

Processo formal obrigatório para documentos canônicos.
```

---

## REGRA 57 — Regra do Gap

```text
Antes de qualquer ação:

Existe?
  SIM → Atualizar
  NÃO → Criar novo

Fluxo:
O que existe? → O que falta? → O que atualizar? → O que criar?

Nunca pular direto para implementação.
```

---

## REGRA 58 — Documento Vivo

```text
Fluxo obrigatório antes de criar:

Existe?
  SIM → Atualiza
  NÃO → Cria
  Fraco? → Fortalece
  Completo? → Apenas consulta

Isso evita inflação desnecessária de documentos.
```

---

## REGRA 59 — Knowledge Graph

```text
Todo documento pode ser relacionado.

Relacionamentos obrigatórios:
- Depende de
- Relacionado com
- Usado por
- Estende
- Substitui

Documentos não são arquivos isolados.
Formam um grafo de conhecimento navegável.
```

---

## REGRA 60 — Maturidade Documental

```text
STATUS: RASCUNHO — pode alterar livremente
STATUS: EM EVOLUÇÃO — pode expandir, não resumir
STATUS: CANÔNICO — requer análise para alterar
STATUS: FREEZE — exige processo formal
STATUS: AUDITADO — revisado por auditoria
STATUS: VALIDADO PELO DUMP — confrontado com legado
STATUS: VALIDADO PELO CÓDIGO — confrontado com código
STATUS: VALIDADO PELO FRONT — confrontado com frontend
STATUS: CONSOLIDADO — referência máxima
```

---

## Lei Final Absoluta

```text
A plataforma existe para amplificar
a capacidade humana de criar,
decidir e crescer.

Tecnologia é meio.
Pessoa é fim.
Dados são ativos.
Conhecimento é poder.

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

## Glossário de Domínios Oficiais

```text
CORE    — Plataforma, Runtime, Dispatcher, Kernel

IAM     — Identidade, Auth, Permissões, Contexto

PORTAL  — App Registry, Dashboard, Shell, UX

WORKFLOW— N8N, Automação, Sistemas legados

KERNEL  — Runtime, Sync, Edge, Offline-First

SOCIAL  — Chat, Comunidade, Colaboração

CHAT    — Mensagens, Comunicação em tempo real

WIKI    — Documentação, Conhecimento, Artigos

ANALYTICS — Dados, Métricas, KPIs, BI

HIS     — Senha, Atendimento, Internação, Farmácia

CRM     — Lead, Contato, Oportunidade

RH      — Colaborador, Escala, Avaliação

FINANCE — Contas, Receitas, Pagamentos

DOCUMENTS — Anexos, Documentos, Arquivos

MARKETPLACE — Apps, Extensões, SDK

AVALIACAO — Feedback, Notas, Avaliações
```

---

**Constituição das IAs — Projeto AtendimentoOfflineAlpha — Plataforma SaaS Enterprise**