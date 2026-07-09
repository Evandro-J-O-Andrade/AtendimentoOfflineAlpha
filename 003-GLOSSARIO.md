# 003 — GLOSSÁRIO
## Linguagem Oficial da Plataforma Midas Enterprise

## Status
CANÔNICO
EM EVOLUÇÃO

---

## Regra de Uso

```text
1. Use SEMPRE os termos definidos aqui.
2. Nunca use sinônimos improvisados.
3. Se um termo não existir aqui, ele não existe na plataforma.
4. Se precisar de um novo termo, crie a entrada no glossário primeiro.
```

---

## Termos

### A

**App** — Aplicação canônica registrada no AppRegistry. Executa dentro do Shell do Portal. Nunca é standalone.

**AppRegistry** — Registro central de todas as Apps da plataforma. Nenhuma App existe sem Registry.

**Anti-Pattern** — Padrão de implementação proibido pela arquitetura. Lista em LIVRO-20-ANTI-PATTERNS.md.

**Arquiteto Enterprise** — Modo de pensar obrigatório para toda IA ou humano. Ver Regra 13 da Constituição das IAs.

**Auditoria** — Registro imutável de toda operação relevante. Implementada via Event Store.

**AVA** — Assistente Virtual de Atendimento. IA do domínio Saúde. Governado pela Constituição das IAs.

---

### B

**Backend** — Camada de gateway de transporte. Node.js canônico. Nunca decide regra de negócio.

**Banco (MySQL)** — Fonte única da verdade. Nenhuma camada acima é fonte da verdade.

**Bootstrap** — Processo obrigatório que toda IA deve executar antes de qualquer tarefa.Ver `000-BOOTSTRAP-IA.md`.

**BR** — Business Rule. Documento de regras de negócio por domínio. Diretório: `docs/canonical/BR/`.

---

### C

**Cache** — Atalho de performance. Nunca fonte da verdade. Invalidado por evento.

**Canônico** — Documento, componente ou padrão que representa a versão oficial e imutável (até alteração formal).

**ChatGPT** — Uma das IAs permitidas. Segue a mesma constituição que todas as outras.

**Claude** — Uma das IAs permitidas. Segue a mesma constituição que todas as outras.

**Constituição da Plataforma** — `000-CONSTITUICAO-PLATAFORMA.md`. Documento supremo. 66 artigos. Substitui todas as decisões anteriores.

**Constituição das IAs** — `001-CONSTITUICAO-IA.md`. Guia operacional das IAs. 64 regras.

**Contexto** — Filtro de isolamento de dados. Variável. Define onde o usuário opera. Inclui tenant, unidade, local, perfil, data.

**Contratos** — Acordos explícitos entre camadas. OpenAPI, SDK, DTOs. Todo contrato tem documento correspondente.

**Copilot** — IA incorporada à plataforma. Auxilia usuários humanos. Governada pela Constituição das IAs.

**CRM** — Domínio de relacionamento com cliente. App canônica em `apps/crm/`.

**Customer 360** — Visão unificada do cliente. Estrutura que conecta todas as entidades relacionadas a uma Pessoa.

---

### D

**Dados** — Ativos da plataforma. Nunca hardcoded. Nunca isolados. Sempre contextualizados.

**Database** — Diretório oficial do banco: `database/`. Contém schema, procedures, views, migrations, seeds, ledger.

**Design System** — Pacote canônico de componentes: `packages/ui`. Toda App usa este pacote. Nenhuma App cria biblioteca própria.

**Device** — Dispositivo gerenciado pelo Portal: TV, Painel, Totem, Kiosk, Mobile. Diretório: `dispositivos/`.

**Dispatcher** — Camada que valida contrato, valida permissão, chama SP e registra evento. Orquestrador, não executor.

**Display** — Sinônimo oficial para Device. Usado em contexto de visualização pública.

**Dump SQL** — `database/schema/Dump20260606.sql`. Banco congelado. Fonte de conhecimento, não arquitetura.

**DX** — Developer Experience. Conjunto de ferramentas, templates e processos que facilitam o desenvolvimento dentro da plataforma.

---

### E

**Engineering** — Diretório oficial de engenharia: `engineering/`. Contém bootstrap, kilo, templates.

**Enterprise** — Modo de pensar. Plataforma projetada para escala, multi-tenant, multi-brand, white-label, SaaS.

**Event Store** — `kernel_ledger`. Memória imutável da plataforma. Todo evento relevante é registrado aqui.

**Evento** — Fato consumado (passado). Semântico, imutável, append-only. Ex: `SenhaCriada`, `AtendimentoIniciado`.

---

### F

**Feature Flag** — Mecanismo de ativação/desativação de funcionalidades. Governado, versionado, auditado.

**Fila** — Camada de mensageria confiável. Implementada no Runtime. Garante entrega, retry, idempotência.

**Fluxo Canônico** — Sequência obrigatória de uma operação:
  `Route → Controller → Dispatcher → Validator → Orchestrator → Executor → SP → Ledger → Response`

**FRONT** — Documento de experiência Frontend por domínio. Diretório: `docs/canonical/FRONT/`.

**Function (MySQL)** — Função de cálculo no banco. Ex: `idade()`, `tempo_espera()`. Não contém lógica de negócio complexa.

---

### G

**GAP** — Diferença entre documentação/código/dump. Deve ser identificado e documentado antes de implementar.

**Gemini** — Uma das IAs permitidas. Segue a mesma constituição que todas as outras.

**Glossário** — `003-GLOSSARIO.md`. Linguagem oficial. Todos os termos oficiais da plataforma.

---

### H

**HIS** — Sistema de Informação Hospitalar. Na plataforma Midas, é apenas uma App no domínio Saúde. Não é a plataforma.

---

### I

**IAM** — Identity and Access Management. Camada de identidade, autenticação, autorização, contexto, permissões.

**IA** — Inteligência Artificial. Na plataforma: sugere, não decide.它包括 ChatGPT, Claude, Gemini, KiloCode, Copilot, AVA, Agentes N8N, RAG.

**Idempotência** — Propriedade de operações que podem ser repetidas sem efeito colateral. Obrigatória no Runtime.

**Imutabilidade** — Princípio de que dados e eventos não são alterados. Apenas novos eventos são adicionados.

**Índice** — `002-INDICE-GERAL.md`. Mapa navegável de todos os documentos da plataforma.

**Integração** — Conexão com sistema externo. Requer IAM, contrato, permissão, token válido.

---

### K

**KILO** — Motor de engenharia da plataforma. Executa auditoria, engenharia reversa, codegen, comparação dump×código×documento.

**Kernel** — Núcleo operacional da plataforma. Inclui Dispatcher, Runtime Core, Ledger, Sync Engine.

**Knowledge Graph** — Grafo de conhecimento que conecta entidades da plataforma. Implementado via IAs e Event Store.

---

### L

**Launcher** — Sinônimo de Portal. Entry point da plataforma. Nenhuma App abre diretamente.

**Ledger** — `kernel_ledger`. Event Store canônico. Memória imutável.

**Legacy** — Código anterior à reconstrução. Diretório: `legacy/`. Somente leitura. Conhecimento, não implementação.

**Lei Final Absoluta** — Princípio máximo que rege toda a plataforma. Declarado na Constituição.

**Livros** — Documentos volumosos que compõem a base de conhecimento. Diretório: `docs/canonical/livros/`. 26 livros.

**Localhost** — Proibido como acesso direto. Toda navegação passa pelo Portal.

**Locks** — Mecanismo de controle de concorrência. Implementado no Runtime.

---

### M

**MAP** — Mapa de Arquitetura. Documento que descreve estrutura, fluxos, relacionamentos. Diretório: `docs/canonical/MAP/`.

**MD** — Documento Canônico. Lei, regra, definição técnica. Diretório: `docs/canonical/MD/`.

**MFA** — Multi-Factor Authentication. Obrigatório para todos os usuários.

**Microserviço** — Padrão arquitetural suportado, mas preferência por Modular Monolith dentro de domínios isolados.

**Mobile** — App/Device em `dispositivos/mobile/`. Cidadão de primeira classe.

**Monorepo** — Estrutura oficial do projeto. Um único repositório com workspaces.

**Multi-Tenant** — Isolamento lógico de dados por tenant. Primeira dimensão de toda operação.

---

### N

**N8N** — Infraestrutura canônica de workflow/automação. Versionado, auditado, governado.

**Node (Backend)** — Gateway de transporte. Node.js canônico. Nunca decide regra de negócio.

---

### O

**Offline-First** — Princípio obrigatório. Plataforma funciona sem conectividade. Runtime garante operação e sync.

**OpenAPI** — Especificação de contrato de API. Toda API tem contrato explícito.

**Operação** — Ação final do usuário dentro de uma App. Sempre contextualizada.

---

### P

**Paciente** — Entidade do domínio Saúde. Subordinada a Senha no fluxo operacional.

**Pacote** — Módulo compartilhado. Diretório: `packages/`. Contém UI, SDK, Auth, Contexto, Eventos, Runtime, Shared.

**Página** — Módulo isolado dentro de uma App. Estrutura enterprise com Dashboard, Nova, Painel, Impressão, Relatórios, Widgets, Components, Hooks, Services, Types, Routes.

**Painel** — Display corporativo. Device em `dispositivos/`. Cidadão de primeira classe.

**Pessoa** — Entidade raiz da plataforma. Identidade permanente. Pode existir em múltiplos tenants.

**Platform** — Sinônimo de Plataforma Midas Enterprise. Sistema Operacional Unificado.

**Portal** — Entry point oficial. Launcher de Apps. Shell unificado. Windows-8 / Microsoft 365 style.

**Procedure (SP)** — Stored Procedure. Única porta de escrita no banco. Classificada: Dispatcher, Orquestrador, Executor, Validator, Ledger, Runtime, IAM, Workflow.

**Prompt** — Comando dado a uma IA. Todo prompt é auditável. Nenhum prompt executa sem validação de documentação.

---

### Q

**Queue** — Fila de mensagens. Implementada no Runtime. Garante entrega, ordem, retry, idempotência.

---

### R

**React** — Camada de apresentação. Apenas UI, layout, navegação, dashboard. Nunca regra, nunca banco.

**Registry** — AppRegistry. Registro central de Apps.

**Request** — Requisição que entra no sistema. Fluxo: Route → Controller → Dispatcher → ... → Response.

**Response** — Resposta que sai do sistema. Sempre imutável. Sempre auditável.

**Reversa, Engenharia** — Processo de extrair conhecimento do legado para reconstruir no padrão Enterprise. Fluxo: Descobrir → Classificar → Generalizar → Implementar.

**Roadmap** — Plano de fases, prioridades, entregas. `LIVRO-19-ROADMAP.md`.

**Runtime** — Camada de execução offline-first. Sync Engine, Heartbeat, Workers, Fila, Cache, Snapshot, Locks.

**RBAC** — Role-Based Access Control. Modelo de permissão baseado em papéis.

**RAG** — Retrieval-Augmented Generation. Técnica de IA que usa documentos para responder.

---

### S

**SaaS** — Software as a Service. Modelo de entrega da plataforma. Multi-tenant, multi-brand, white-label.

**SDK** — Kit de desenvolvimento. Pacote canônico: `packages/sdk`. Toda App usa SDK para comunicar com Backend.

**Security** — Segurança zero-trust. JWT HttpOnly, Secure, SameSite=Strict. MFA obrigatório.

**Senha** — Entrada operacional do domínio Saúde. Fluxo: Senha → Fila → FFA → Atendimento → Triagem → Farmácia → Faturamento.

**Shell** — Interface unificada do Portal. Windows-8 / Microsoft 365 style. Live Tiles, containers, contexto fluido.

**Snapshot** — Ponto de verificação do estado. Usado para reconciliação, backup, auditoria.

**SP** — Stored Procedure. Ver Procedure.

**SQL** — Linguagem de consulta. No contexto da plataforma, usada para ler views e functions. Escrita somente via SP.

**Stateless** — APIs não mantêm estado em memória. Estado reside no banco.

**Sync Engine** — Motor de sincronização offline-first. Delta, snapshot, reconciliação. Implementado no Runtime.

---

### T

**Tenant** — Isolamento lógico principal. Primeira dimensão de todo dado. Um tenant = uma instituição/cliente.

**Tile** — Container visual no Portal. Live Tile mostra dados dinâmicos.

**Token** — Credencial de acesso. Sempre em Cookie HttpOnly, Secure, SameSite=Strict. Nunca em localStorage.

**Trigger** — Mecanismo de banco PROIBIDO para lógica de negócio. Permitido apenas para auditoria técnica, integração database-level, performance.

**TV Corporativa** — Display em `dispositivos/tv/`. Cidadão de primeira classe. Mostra KPIs, filas, alertas.

---

### U

**UI** — User Interface. Camada de apresentação. Design System canônico em `packages/ui`.

**User** — Sinônimo de Usuário. Pessoa com identidade e contexto.

**UUID** — Identificador único universal. Usado como PK em tabelas transacionais.

---

### V

**Validação** — Processo de verificação de entrada. Realizado por Validator (SP) antes da execução.

**View** — Consulta otimizada para leitura. Ex: `vw_painel_fila`, `vw_dashboard_urgencia`. Não contém lógica de escrita.

**V2** — PROIBIDO. Nunca criar v2, final, backup, old, temp. Ver Anti-Patterns.

---

### W

**White Label** — Capacidade de customizar marca sem alterar experiência. Plataforma suporta múltiplas marcas.

**Widget** — Componente visual reutilizável. Usado em Dashboards, Tiles, Páginas.

**Workflow** — Automação versionada e auditada. Implementada em N8N. Nunca acessa banco diretamente.

**Worker** — Processo assíncrono. Implementado no Runtime. Processa filas, jobs, eventos.

---

## Siglas e Acrônimos

| Sigla | Significado |
|-------|-------------|
| ADR | Architecture Decision Record |
| API | Application Programming Interface |
| BI | Business Intelligence |
| BR | Business Rule |
| CRUD | Create, Read, Update, Delete |
| CQRS | Command Query Responsibility Segregation |
| DTO | Data Transfer Object |
| E2E | End-to-End |
| ES | Event Store |
| FK | Foreign Key |
| HIS | Health Information System |
| IAM | Identity and Access Management |
| IA | Inteligência Artificial |
| IAAS | Infrastructure as a Service |
| JSON | JavaScript Object Notation |
| JWT | JSON Web Token |
| K8S | Kubernetes |
| KPIs | Key Performance Indicators |
| MD | Documento Canônico |
| MFA | Multi-Factor Authentication |
| MAP | Mapa de Arquitetura |
| MVVM | Model-View-ViewModel |
| OAuth | Open Authorization |
| PK | Primary Key |
| RBAC | Role-Based Access Control |
| RAG | Retrieval-Augmented Generation |
| REST | Representational State Transfer |
| SPA | Single Page Application |
| SP | Stored Procedure |
| SQL | Structured Query Language |
| SRE | Site Reliability Engineering |
| TDD | Test-Driven Development |
| UI | User Interface |
| UX | User Experience |
| UUID | Unique Universal Identifier |
| YAML | YAML Ain't Markup Language |

---

## Convenções de Nomenclatura

### Arquivos e Diretórios

```
Pastas:       kebab-case (minúsculas separadas por hífen)
Arquivos:    PascalCase ou kebab-case conforme tipo
MDs/MAPs/BRs: MAIUSCULAS-SEPARADAS-POR-HIFEN
Variáveis:   camelCase
Constantes:  UPPER_SNAKE_CASE
Tipos:       PascalCase
Componentes: PascalCase
Hooks:       camelCase com prefixo use (ex: useAuth)
Services:    camelCase
```

### Banco de Dados

```
Tabelas:     snake_case (minúsculas separadas por underscore)
Views:       vw_ + snake_case (ex: vw_painel_fila)
Functions:   snake_case (ex: idade(), tempo_espera())
Procedures:  snake_case (ex: sp_dispatch_senha)
Triggers:    tr_ + snake_case
Índices:     idx_ + snake_case
PK:          id (UUID)
FK:          id_{tabela_referencia}
Tenant:      id_tenant
Timestamps:  created_at, updated_at, deleted_at
```

---

## Valores por Padrão

| Conceito | Valor Padrão |
|----------|--------------|
| Geração de ID | UUIDv4 |
| Timezone | América/São_Paulo (UTC-3) |
| Encoding | UTF-8 |
| Linguagem | Português (Brasil) |
| Chave estrangeira | id_{tabela} |
| Coluna tenant | id_tenant |
| Coluna timestamp | criado_em / atualizado_em |
| Soft delete | excluido_em (DATETIME NULL) |
| Formato de data | ISO 8601 |
| Moeda | BRL (R$) |
| Precisão decimal | 2 casas para valores monetários |

---

**Glossário — Projeto AtendimentoOfflineAlpha — Plataforma Midas Enterprise**
**Versão 1.0 — Status: EM EVOLUÇÃO**
**Este documento é a linguagem oficial. Use-o sempre.**
