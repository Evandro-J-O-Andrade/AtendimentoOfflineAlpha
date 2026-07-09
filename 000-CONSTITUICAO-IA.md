# 000 — Guia Operacional das IAs

## Status
SYSTEM PROMPT PERMANENTE PARA TODAS AS IAs DO PROJETO ATENDIMENTOOFFLINEALPHA

---

## Objetivo

Este documento define o **comportamento operacional obrigatório** de todas as IAs (KiloCode, ChatGPT, Claude, Gemini, Copilot, AVA, etc.) durante a construção, evolução e operação da Plataforma Midas Enterprise.

Ele **não é** a constituição arquitetural da plataforma.
Para isso, consulte:

```
000-CONSTITUICAO-PLATAFORMA.md
```

---

## Regra 0 — Ordem de Leitura Obrigatória

Antes de executar **qualquer tarefa**, a IA deve ler **nesta ordem**:

1. `000-CONSTITUICAO-PLATAFORMA.md` (Constituição da Plataforma — documento supremo)
2. `000-CONSTITUICAO-IA.md` (este documento — guia operacional das IAs)
3. `docs/canonical/MD-CANONICO-IA-001-Lei-Evolucao-Documental.md` (Lei de Evolução Documental)
4. `docs/canonical/MD-CANONICO-IA-002-Lei-Governanca-Arquitetural.md` (Lei de Governança Arquitetural)
5. `docs/canonical/MD-CANONICO-IA-003-Lei-Evolucao-Core.md` (Lei da Evolução do Core)
6. `docs/canonical/MD-CANONICO-IA-004-Matriz-Evolucao-Projeto.md` (Matriz de Evolução)
7. `docs/canonical/MD-110-Canonical-Laws.md` (Leis Supremas)
8. `docs/canonical/MD-100-Unified-Enterprise-Operating-System.md` (Arquitetura)
9. `docs/canonical/MAP-001-Enterprise-Domain-Architecture.md` (Domínios)
10. Documentos MD canônicos relevantes ao escopo da tarefa
11. Documentos MAP específicos do domínio
12. Documentos BR do domínio (Business Rules)
13. Documentos ADR relevantes (Architecture Decision Records)
14. `docs/canonical/RADAR-ARQUITURA.md` (Radar de Arquitetura)

Somente depois iniciar qualquer alteração.

> **Nota:** Os `LIVRO-*` definidos na `000-CONSTITUICAO-PLATAFORMA.md` entram na categoria de documentos MD canônicos. Se existirem, são lidos junto ao passo 10.

---

## Regra 1 — Nunca Assumir

Se uma informação não existir:

- procure nos documentos canônicos (MD-*)
- procure nos documentos de arquitetura (MAP-*)
- procure nos documentos de regras de negócio (BR-*)
- procure no dump SQL (analisar esquemas, não copiar)
- procure no código fonte existente
- somente depois faça inferência e **documente**

Nunca invente arquitetura. Nunca invente regra.

---

## Regra 2 — Nunca Renomear Arquivos

```
Proibido:
- renomear arquivos
- mover arquivos
- reorganizar pastas
- alterar a estrutura do projeto

Exceção: apenas com autorização explícita do usuário.
```

---

## Regra 3 — Nunca Apagar

```
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

## Regra 4 — Nunca Gerar V2

```
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

Existe apenas uma versão canônica.
Extensões devem usar o Registry oficial.
```

---

## Regra 5 — Sempre Procurar Primeiro

Antes de criar qualquer coisa:

1. Procurar — verificar se já existe
2. Validar — confirmar se atende ao requisito
3. Atualizar — modificar existente se necessário
4. Criar somente se não existir

---

## Regra 6 — Classificação Obrigatória de Novos Componentes

Toda descoberta deve responder:

```text
Pertence ao CORE:      Componentes fundamentais (IAM, Portal, Dispatcher, Event Store, Runtime)
Pertence ao IAM:       Identidade, autenticação, autorização, contexto, permissões
Pertence ao PORTAL:    Launcher, dashboard, navegação, widgets, experience layer
Pertence ao WORKFLOW:  Orquestração, automação, N8N, processos long-running
Pertence ao KERNEL:    Runtime, sync, edge, offline-first, sync-engine
Pertence ao SOCIAL:    Comunicação, chat, redes, colaboração
Pertence ao CHAT:      Mensagens, canais, notificações em tempo real
Pertence ao WIKI:      Documentação, conhecimento, artigos
Pertence ao ANALYTICS: Dados, métricas, KPIs, dashboards, BI
Pertence ao RUNTIME:   Execução, filas, jobs, processamento assíncrono
Pertence ao APP:       Aplicação específica do tenant (não subir para CORE)
```

Se for APP: Nunca subir para o CORE. Use extensão via SDK/AppRegistry.

---

## Regra 7 — Dump SQL Representa Conhecimento, Não Arquitetura

```
O Dump SQL serve para extrair:
- regras de negócio implícitas
- fluxos de processo
- responsabilidades de tabelas
- dependências entre entidades

NÃO serve para:
- copiar tabelas literalmente
- reproduzir estrutura acidental
- criar novos V2 do schema
```

---

## Regra 8 — Procedures Devem ser Reconstruídas

```
Nenhuma procedure do legado deve ser reproduzida literalmente.

Classificar e reconstruir no padrão Enterprise:

Dispatcher     — Orquestrador que valida contrato, permissão e chama SP
Orquestrador   — Coordena múltiplas SPs, gerencia transação
Executor       — Executa operação específica (uma única SP)
Validator      — Valida entrada antes da operação
Ledger         — Persiste eventos no Event Store
Runtime        — Processa filas, jobs, sync
IAM            — Procedures de identidade, contexto, permissão
Workflow       — Procedures que suportam automação
```

---

## Regra 9 — React Não Tem Regra de Negócio

```
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

## Regra 10 — Responsabilidades são Sagradas

```
Banco = Cérebro operacional (MySQL, regras, eventos)
Node  = Gateway (roteamento, transporte confiável)
React = Interface (projeção, experiência)

Nunca inverter responsabilidades.
```

---

## Regra 11 — Eventos Seguem o Padrão Canônico

```
Todo novo domínio deve seguir o fluxo:

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

## Regra 12 — Atualização Obrigatória

Quando uma IA descobre algo novo:

```text
Já existe documentação?
  SIM → Atualizar documento existente
  NÃO → Criar novo documento (se for canônico) ou documentar inline

Nunca duplicar. Nunca deixar sem documentação.
```

---

## Regra 13 — Pensar como Arquiteto Enterprise

```
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

## Regra 14 — Lei da Plataforma Única

```
Multi-tenant, mas experiência unificada.
Multi-app, mas Shell único.
Multi-dispositivo, mas contexto fluido.
White label muda marca, não experiência.
Multi-brand muda posicionamento, não core.
```

---

## Regra 15 — Classificação de Camadas

| Camada | Decidir | Validar | Executar | Escrever | Exibir | Auditar |
|--------|---------|---------|----------|----------|--------|---------|
| Frontend | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ |
| Backend | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Dispatcher | ❌ | ✅ | ✅ (roteia) | ❌ | ❌ | ✅ |
| SP | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ |
| Event Store | ❌ | ✅ | ✅ (registra) | ✅ (append) | ❌ | ✅ |
| IA | ❌ | ❌ | ✅ (sugere) | ❌ | ✅ (sugere) | ❌ |

---

## Regra 16 — Stored Procedures são Sagradas

```
Nenhuma escrita direta em tabelas de negócio.
Toda operação relevante passa por Stored Procedure.
SP é a única porta de escrita no banco.
Frontend exibe. Backend roteia. SP executa.
```

---

## Regra 17 — Event Store é a Memória da Plataforma

```
Sem evento não existe operação.
Evento é imutável.
Evento é append-only.
Evento é consultável.
Evento é a memória da plataforma.
Todo evento relevante é registrado no Event Store canônico (kernel_ledger).
```

---

## Regra 18 — Cache é Atalho, Não Verdade

```
Cache nunca é fonte da verdade.
Cache é derivado do banco ou do Event Store.
Cache é invalidado por evento.
Cache é invalidado por mudança de contexto.
Cache não serve para decisão de negócio.
Cache serve para performance.
```

---

## Regra 19 — Triggers São Proibidas para Lógica

```
Triggers são proibidas para lógica de negócio.

Triggers podem existir SOMENTE para:
- Auditoria técnica
- Integração database-level
- Performance (índices, particionamento)
```

---

## Regra 20 — Functions São Para Cálculo

```
Functions servem para cálculos.
Exemplo: idade(), tempo_espera(), score()

Functions não devem conter lógica de negócio complexa.
```

---

## Regra 21 — Views São Para Leitura

```
Views servem para leitura.
Exemplo: vw_painel_fila, vw_dashboard_urgencia

Views não devem conter lógica de escrita.
```

---

## Regra 22 — História Não Morre

```
Nenhuma deleção física.
Cancelamento = novo evento.
Remoção = status inativo.
Histórico = fonte da verdade.
```

---

## Regra 23 — Correção via Evento

```
Correção, não apagar.
Retificação, não sobrescrever.
Cancelamento, não DELETE.
Substituição, não UPDATE.
```

---

## Regra 24 — Portal é a Porta

```
Todo acesso começa no Portal.
Nenhuma app abre diretamente.
Nenhum módulo operacional é acessado por URL direta.

Fluxo obrigatório:
    Login → Portal → IAM → Selecionar Contexto → Workspace → App Registry → App → Dashboard → Operação

Nunca:
    localhost:5173/atendimento
    localhost:3000/api/...
    URL direta para módulo operacional
```

---

## Regra 25 — Apps Executam Negócio

```
Portal orquestra.
Apps executam.
Portal não faz regra de negócio.
Apps são registradas, não hardcoded.
Toda app respeita Design System.
```

---

## Regra 26 — IA Sugere, Não Decide

```
IA sugere.
IA analisa.
IA resume.
IA não altera dados sem autorização humana explícita.

Decisão final é sempre humana.
Todo output de IA é auditável.
```

---

## Regra 27 — Nenhum Dado Fica Isolado

```
Dado isolado é risco.
Dado conectado é poder.

Customer 360 unifica toda visão de cliente.
Knowledge Graph conecta entidades.
Event Store registra tudo.
Data Lakehouse centraliza inteligência.
```

---

## Regra 28 — Nenhuma App Roda Sem Registry

```
Toda capacidade da plataforma é uma App registrada.
App sem Registry não existe.
App sem IAM não abre.
App opera dentro do Shell.
App respeita Design System.
```

---

## Regra 29 — Nenhuma Integração Sem IAM

```
Toda integração exige identidade.
Toda integração exige permissão.
Toda integração exige token válido.

OAuth2, JWT, mTLS são obrigatórios conforme o caso.
Sem IAM, sem acesso.
```

---

## Regra 30 — Automação é Estratégica

```
N8N é infraestrutura, não ferramenta isolada.
Todo workflow é versionado.
Todo workflow é auditado.

Workflow sem aprovação não vai para produção.
Credenciais no Vault, nunca no código.

Automação sem governança é risco.
Automação com governança é poder.
```

---

## Regra 31 — Expansão Sem Ilhas

```
Toda nova app entra pelo Registry.
Toda nova app usa IAM canônico.
Toda nova app usa Dispatcher canônico.
Toda nova app emite eventos.
Toda nova app usa Design System.

Nenhuma app cria próprio banco, próprio login, própria auditoria.

Ecossistema forte não tem ilhas.
```

---

## Regra 32 — Multi-Tenant é Transversal

```
Tenant é a primeira dimensão de tudo.
Todo dado carrega id_tenant.
Toda query filtra por tenant.
Todo evento registra tenant.
Todo usuário pertence a tenant.

Nenhuma operação cruza tenants sem autorização explícita.
```

---

## Regra 33 — Authorization is Decision

```
Acesso não é cargo.
Acesso é decisão.

Decisão é:
    identidade + tenant + app + escopo + permissão + contexto.

IAM decide. Nenhuma app decide.
Decisão é centralizada, auditável e multi-tenant.
```

---

## Regra 34 — Identidade é Permanente, Contexto é Variável

```
Usuário não muda.
Contexto muda.

Um usuário pode operar em múltiplos tenants, unidades, locais e perfis.
Sem criar nova conta.
Sem perder histórico.
Sem perder permissões.
```

---

## Regra 35 — Pessoa é Raiz

```
Pessoa é a entidade raiz da plataforma Midas.
Identidade pertence à Pessoa, não ao Tenant.

Uma Pessoa pode existir em múltiplos Tenants simultaneamente.
Dados assistenciais pertencem ao Tenant onde ocorreram.
Contexto é o filtro de isolamento de dados.
```

---

## Regra 36 — Contrato de Eventos Corporativos

```
Eventos devem representar fatos consumados (passado):

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

## Regra 37 — Anti-Patterns Proibidos

```
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
❌ App standalone em localhost
❌ Frontend acessando banco
❌ Backend alterando tabela diretamente
❌ Trigger com lógica de negócio
❌ Redis como fonte da verdade
```

---

## Regra 38 — Documentos Canônicos São Lei

```
MDs são lei — divergência exige MD de alteração.
MAPs são arquitetura — seguir rigorosamente.
BRs são regras — implementar fielmente.

Este documento é o guia operacional para IAs.
000-CONSTITUICAO-PLATAFORMA.md é a constituição suprema.
```

---

## Regra 39 — Evolução Contínua

```
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

## Regra 40 — Critérios de Sucesso

```
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

## Regra 41 — Estrutura do Projeto Enterprise

```
Estrutura obrigatória (ver detalhes em 000-CONSTITUICAO-PLATAFORMA.md):

apps/           # Aplicações canônicas (somente uma por domínio)
dispositivos/   # painel, totem, kiosk, mobile, tv
packages/       # auth, contexto, eventos, workflow, sdk, ui
backend/        # auth, portal, eventos, audit, integrations
database/       # schema, procedures, migrations, views, ledger
dashboards/     # dashboards canônicos
workflow/       # workflows por domínio
runtime/        # offline-first, sync
legacy/         # código congelado (somente leitura)

Proibido:
- apps/ legado
- backend/ legado
- src/ alternativo
- estrutura paralela
```

---

## Regra 42 — Organização dos Documentos

```
docs/canonical/
├── LIVRO-*.md      # Constituição completa da plataforma (volumes)
├── MD-*.md         # Documentos Canônicos (leis)
├── MAP-*.md        # Mapas de Arquitetura
├── BR-*.md         # Business Rules
├── FRONT-*.md      # Experiência Frontend
└── ADR-*.md        # Architecture Decision Records

Cada documento deve declarar:
- Status (RASCUNHO, EM EVOLUÇÃO, CANÔNICO, FREEZE)
- Relacionamentos (Depende de, Relacionado com, Usado por)
```

---

## Regra 43 — Banco de Dados Enterprise

```
MySQL é a Fonte da Verdade.
Stored Procedures são a única porta de escrita.
Views são para leitura.
Functions são para cálculo.
Triggers são proibidas para lógica de negócio.
Nenhuma deleção física — sempre soft delete com evento.
```

---

## Regra 44 — Procedures Enterprise

```
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

Nunca copiar procedure literalmente do legado.
```

---

## Regra 45 — React Enterprise

```
React é apenas camada de apresentação.
React não contém regra de negócio.
React não valida permissões.
React não acessa banco diretamente.
React consome APIs via Backend.
React respeita Design System canônico.
```

---

## Regra 46 — Node.js Enterprise

```
Node é gateway de transporte.
Node valida sessão.
Node valida contexto.
Node roteia para Dispatcher.

Node não decide regra de negócio.
Node não acessa tabelas diretamente.
```

---

## Regra 47 — Runtime Enterprise

```
Runtime é camada de execução offline-first.
Responsabilidades: Sync Engine, Heartbeat, Reconciliação, Workers, Fila, Single Writer, Idempotência, Cache (invalidado por evento), Snapshot, Locks.
```

---

## Regra 48 — Ledger Enterprise

```
Ledger é a memória imutável da plataforma.
Evento é append-only, consultável, imutável.
Todo evento relevante é registrado.
Ledger = kernel_ledger (Event Store canônico).
```

---

## Regra 49 — Workflow Enterprise

```
N8N é infraestrutura canônica.
Workflow é código versionado.
Workflow é auditado.

Workflow segue fluxo:
  Dispatcher → Orquestrador → Executor → Evento

Workflow nunca acessa banco diretamente.
```

---

## Regra 50 — Portal Enterprise

```
Portal é o launcher oficial.
Portal ≠ App.
Portal é entry point.
App é operação.

Fluxo obrigatório:
  Login → Portal → IAM → Contexto → App Registry → App → Dashboard → Operação

Nunca acesso direto por URL.
```

---

## Regra 51 — IAM Enterprise

```
IAM é a camada de identidade e permissão.
IAM decide acesso (não App).

Decisão = identidade + tenant + app + escopo + permissão + contexto.

JWT HttpOnly, Secure Cookie, SameSite=Strict.
Token nunca em localStorage.
```

---

## Regra 52 — Multi-Tenant Enterprise

```
Tenant é a primeira dimensão.
Todo dado carrega id_tenant.
Toda query filtra por tenant.
Todo evento registra tenant.
Todo usuário pertence a tenant.

Nenhuma operação cruza tenants sem autorização explícita.
```

---

## Regra 53 — Engenharia Reversa Enterprise

```
Fluxo obrigatório para qualquer objeto legado:

1. Descobrir — identificar propósito
2. Classificar — CORE / INFRA / PLATFORM / APP / LEGACY
3. Generalizar — extrair papel arquitetural
4. Implementar — reconstruir no padrão Enterprise

Nunca copiar estrutura legada.
```

---

## Regra 54 — Criação de Documentos

```
Criar novo documento apenas quando:
- assunto não existir
- não houver documento equivalente
- representar domínio/app nova

Caso contrário: atualizar documento existente.
Nunca duplicar conteúdo.
```

---

## Regra 55 — Atualização de Documentos

```
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

## Regra 56 — Exclusão de Documentos

```
Exclusão praticamente proibida.

Exceções apenas com:
- autorização explícita do usuário
- documento com status RASCUNHO
- duplicata identificada

Processo formal obrigatório para documentos canônicos.
```

---

## Regra 57 — Regra do Gap

```
Antes de qualquer ação:

Existe?
  SIM → Atualizar
  NÃO → Criar novo

Fluxo:
O que existe? → O que falta? → O que atualizar? → O que criar?

Nunca pular direto para implementação.
```

---

## Regra 58 — Documento Vivo

```
Fluxo obrigatório antes de criar:

Existe?
  SIM → Atualiza
  NÃO → Cria
  Fraco? → Fortalece
  Completo? → Apenas consulta

Isso evita inflação desnecessária de documentos.
```

---

## Regra 59 — Knowledge Graph

```
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

## Regra 60 — Maturidade Documental

```
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

## Regra 61 — Proibido Acesso Direto a URL em Desenvolvimento

```
Em desenvolvimento, NUNCA acessar:
- localhost:5173/atendimento
- localhost:3000/api/...
- Qualquer URL direta de módulo

Sempre acessar pelo Portal:
- http://localhost:PORT/portal
- Selecionar contexto
- Abrir App via Registry
```

---

## Regra 62 — Somente Um Frontend, Somente Um Backend

```
Apps/ é a estrutura única de frontend.
Backend/ é a estrutura única de backend.

Proibido:
- apps/ paralelos (apps2, apps-new, etc.)
- backend/ paralelos (backend2, api2, etc.)
- src/ alternativos (src-legacy, src-new, etc.)
```

---

## Regra 63 — Apps São Domínios Isolados

```
Cada domínio é uma App completa em apps/:

apps/
  ├── saude/
  ├── financeiro/
  ├── rh/
  ├── crm/
  └── ...

Cada App contém:
- Frontend isolado (pages, components, widgets, hooks, services, types)
- Rotas canônicas
- Manifest (metadados da App)
- Dashboard próprio (ou herda do Portal)
- Tipos compartilhados via packages/

Nenhuma App acessa código de outra App diretamente.
Comunicação exclusiva via API/SDK.
```

---

## Regra 64 — Estrutura de Página Enterprise

```
Cada página de uma App é um módulo isolado:

apps/saude/pages/senha/
  ├── Dashboard/        # Dashboard da página
  ├── NovaSenha/        # Criação
  ├── Painel/           # Operação principal
  ├── Impressao/        # Impressão de tickets
  ├── Relatorios/       # Relatórios da página
  ├── Widgets/          # Widgets específicos
  ├── Components/       # Componentes da página
  ├── Hooks/            # Hooks específicos
  ├── Services/         # Serviços da página
  ├── Types/            # Tipos da página
  └── Routes/           # Rotas da página
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

**Constituição das IAs — Projeto AtendimentoOfflineAlpha — Plataforma SaaS Enterprise**
