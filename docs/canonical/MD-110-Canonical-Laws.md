# MD-110 — Canonical Laws

## Status

Documento Canônico Supremo.
Consolida todas as leis canônicas da Plataforma New Wave Enterprise.

```text
FREEZE (Ciclo Arquitetural 1)
Fundação Runtime/Integração (LEI 23–26) congelada.
Alteração exige ADR + aprovação do Arquiteto Chefe (Art. 63/65).
Ver 000-CONSTITUICAO-PLATAFORMA.md — Título XV.
```

---

## Objetivo

Ser a fonte única de verdade para todas as regras, princípios e leis que governam a plataforma.

---

## Princípio Fundamental

```text
Este documento é a lei máxima.
Nenhuma implementação pode contradizer o MD-110.
Qualquer divergência exige atualização deste documento.
Nenhuma alteração em MD-110 é feita sem discussão arquitetônica.
```

---

## Leis Supremas

### LEI 01 — Portal é a Porta

```text
Todo acesso começa no Portal.
Nenhuma app abre diretamente.
Nenhum módulo operacional é acessado por URL direta.
Fluxo obrigatório:
  Login → Portal → App Registry → App → Contexto → Dashboard → Operação
```

---

### LEI 02 — Apps Executam Negócio

```text
Portal orquestra.
Apps executam.
Portal não faz regra de negócio.
Apps são registradas, não hardcoded.
Toda app respeita Design System.
```

---

### LEI 03 — IA Auxilia, Não Decide

```text
IA sugere.
IA analisa.
IA resume.
IA não altera dados sem autorização humana explícita.
Decisão final é sempre humana.
Todo output de IA é auditável.
```

---

### LEI 04 — Nenhum Dado Fica Isolado

```text
Dado isolado é risco.
Dado conectado é poder.
Customer 360 unifica toda visão de cliente.
Knowledge Graph conecta entidades.
Event Store registra tudo.
Data Lakehouse centraliza inteligência.
```

---

### LEI 05 — Regra de Negócio Pertence à SP

```text
Nenhuma regra de negócio no frontend.
Nenhuma regra de negócio no backend Node.
Nenhum CRUD direto.
Toda escrita passa por Stored Procedure.
SP é a única porta de escrita no banco.
Frontend exibe. Backend roteia. SP executa.
```

---

### LEI 06 — Nenhuma App Roda Sem Registry

```text
Toda capacidade da plataforma é uma App registrada.
App sem Registry não existe.
App sem IAM não abre.
App opera dentro do Shell.
App respeita Design System.
```

---

### LEI 07 — Nenhuma Integração Sem IAM

```text
Toda integração exige identidade.
Toda integração exige permissão.
Toda integração exige token válido.
OAuth2, JWT, mTLS são obrigatórios conforme o caso.
Sem IAM, sem acesso.
```

---

### LEI 08 — Automação Sem Governança é Risco

```text
N8N é infraestrutura, não ferramenta isolada.
Todo workflow é versionado.
Todo workflow é auditado.
Workflow sem aprovação não vai para produção.
Credenciais no Vault, nunca no código.
```

---

### LEI 09 — Expansão Sem Ilhas

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

### LEI 10 — A Experiência é Única

```text
Multi-tenant, mas experiência unificada.
Multi-app, mas Shell único.
Multi-dispositivo, mas contexto fluido.
Design System canônico.
White label muda marca, não experiência.
Multi-brand muda posicionamento, não core.
```

---

### LEI 11 — Authorization is Decision

```text
Acesso não é cargo.
Acesso é decisão.
Decisão é:
  identidade + tenant + app + escopo + permissão + contexto.
IAM decide. Nenhuma app decide.
Decisão é centralizada, auditável e multi-tenant.
```

---

### LEI 12 — Identidade é Permanente, Contexto é Variável

```text
Usuário não muda.
Contexto muda.
Um usuário pode operar em múltiplos tenants, unidades, locais e perfis.
Sem criar nova conta.
Sem perder histórico.
Sem perder permissões.
```

---

### LEI 13 — Senha é a Entrada Operacional do HIS

```text
Paciente existe no cadastro mestre.
Operacionalmente, quem entra no fluxo é a Senha.
Fluxo canônico:
  Senha → Fila → FFA → Atendimento → Triagem → Execução → Farmácia → Faturamento
Nenhuma operação clínica começa sem senha.
Nenhum atendimento é criado sem senha.
```

---

### LEI 14 — Multi-Tenant é Transversal

```text
Tenant é a primeira dimensão de tudo.
Todo dado carrega id_tenant.
Toda query filtra por tenant.
Todo evento registra tenant.
Todo usuário pertence a tenant.
Nenhuma operação cruza tenants sem autorização explícita.
```

---

### LEI 15 — Evento é Rastro Oficial

```text
Sem evento não existe operação.
Evento é imutável.
Evento é append-only.
Evento é consultável.
Evento é a memória da plataforma.
Todo evento relevante é registrado no Event Store canônico (kernel_ledger).
```

---

### LEI 16 — Cache é Atalho, Não Verdade

```text
Cache nunca é fonte da verdade.
Cache é derivado do banco ou do Event Store.
Cache é invalidado por evento.
Cache é invalidado por mudança de contexto.
Cache não serve para decisão de negócio.
Cache serve para performance.
```

---

### LEI 17 — Frontend é Janela, Não Cérebro

```text
Frontend exibe.
Frontend captura input.
Frontend chama API.
Frontend não decide regra de negócio.
Frontend não valida permissão.
Frontend não acessa banco.
Frontend é a projeção do motor.
```

---

### LEI 18 — Backend é Porteiro, Não Juiz

```text
Backend valida sessão.
Backend valida contexto.
Backend roteia para Dispatcher.
Backend não decide regra de negócio.
Backend não altera dados diretamente.
Backend é a camada de transporte confiável.
```

---

### LEI 19 — Dispatcher Orquestra, Não Executa

```text
Dispatcher valida contrato.
Dispatcher valida permissão.
Dispatcher chama SP.
Dispatcher registra evento.
Dispatcher não executa regra de negócio.
Dispatcher é o maestro. SP é o músico.
```

---

### LEI 20 — N8N é Patrimônio, Não Brinquedo

```text
Automação é estratégica.
Workflow é código.
Workflow é governado.
Workflow é testado.
Workflow é auditado.
Automação sem governança é risco.
Automação com governança é poder.
```

---

### LEI 21 — Banco é a Fonte da Verdade

```text
MySQL é a fonte da verdade.
Nenhuma camada acima do banco é fonte de verdade.
Frontend nunca é fonte da verdade.
IA nunca é fonte da verdade.
N8N nunca é fonte da verdade.
Node/Backend nunca é fonte da verdade.
Cache nunca é fonte da verdade.
```

---

### LEI 22 — APIs são Stateless

```text
APIs não guardam estado em memória.
Estado compartilhado reside no Banco.
Load Balancer distribui requisições entre instâncias.
Qualquer instância pode atender qualquer requisição.
Escala horizontal não requer sync de estado.
Redis é cache, nunca fonte da verdade.
```

---

### LEI 23 — Portal é Runtime, Não Interface

```text
Portal não é apenas frontend. Portal é Runtime.
Todo domínio materializado na plataforma deve ser consumível por:

  Interfaces humanas:
    Web (React), Mobile, Kiosk, TV Display

  Interfaces computacionais:
    APIs externas, MCPs (Model Context Protocol),
    Agentes de IA, Automações, Integrações futuras

Todas consomem o mesmo Runtime, o mesmo Kernel,
as mesmas regras de negócio e as mesmas Stored Procedures.

É proibido criar lógica exclusiva para IA que contorne
o Kernel, os contratos ou as Stored Procedures canônicas.

Fluxo obrigatório de qualquer interface (humana ou computacional):

  Interface
    ↓
  MCP / API
    ↓
  AI Runtime (se IA) / Runtime de domínio (se humano)
    ↓
  Capability Resolver → Runtime Resolver
    ↓
  Runtime alvo (Portal / Farmácia / Estoque / ...)
    ↓
  Master
    ↓
  Dispatcher
    ↓
  Executors
    ↓
  Stored Procedures
    ↓
  Banco Canônico

Portal Runtime não é obrigatório para toda operação.
É apenas mais um Runtime da plataforma (LEI 25).

Nenhuma IA acessa o banco diretamente.
Nenhuma IA contorna o Runtime.
Nenhuma IA decide regra de negócio fora da SP.
```

---

### LEI 24 — Lei da Integração Universal da Plataforma

```text
Toda a plataforma segue uma única espinha dorsal.
Usuários, aplicações, automações e agentes de IA
nunca criam caminhos paralelos nem regras duplicadas.

1. Todo serviço da plataforma deve ser consumível por
   interfaces humanas e computacionais.

2. Nenhuma IA pode acessar diretamente o banco de dados.

3. Toda IA deve operar através do AI Runtime e do Runtime
   correspondente ao domínio.

4. Toda operação deve passar pelo fluxo
   Master → Dispatcher → Executor → Stored Procedure.

5. O banco canônico permanece a única fonte de verdade.

6. As capacidades disponíveis para uma IA devem ser
   descobertas pelo Runtime, nunca codificadas no agente.

7. Toda execução de IA deve possuir sessão, contexto,
   permissões e auditoria.
```

---

### LEI 25 — Lei da Descoberta Canônica de Capacidades

```text
A plataforma é desacoplada por descoberta, não por
conhecimento interno da arquitetura.

1. Nenhum cliente (Frontend, API, MCP ou IA) pode conhecer
   diretamente Stored Procedures.

2. Toda capacidade deve ser descoberta pelo Runtime.

3. Toda ferramenta deve estar registrada no Tool Registry.

4. Toda integração deve utilizar contratos canônicos.

5. O Runtime é o único responsável por resolver qual Master,
   Dispatcher e Executor serão utilizados.

6. O banco canônico continua sendo a fonte oficial da verdade.
```

---

### LEI 26 — Lei da Execução Canônica

```text
Toda capacidade descoberta deve ser executada pelo mesmo
pipeline. Nenhum cliente pode pular etapas.

Capability
   ↓
Action
   ↓
Contract
   ↓
Runtime
   ↓
Master
   ↓
Guardião (Permission + Context + Tenant + Feature)
   ↓
Dispatcher
   ↓
Executor
   ↓
Stored Procedure
   ↓
Banco Canônico
   ↓
Eventos
   ↓
Auditoria
   ↓
Resposta

Capability NÃO executa. Ela apenas informa:
  existe / quem pode usar / qual contrato utiliza.
Quem executa é o Runtime, que resolve internamente
qual Master, Executor e SP serão usados.

A capacidade é a unidade de engenharia.
Novo módulo começa por Capability, não por tabela.

Futuro: banco vivo como Grafo de Capacidades
(Graph Runtime) — relações navegáveis entre
Capability, Runtime, Contrato, SP, Tabelas,
Eventos, BRs, MDs, MAPs e Testes.
```

---

## Matriz de Responsabilidade

| Camada | Decidir | Validar | Executar | Escrever | Exibir |
|--------|---------|---------|----------|----------|--------|
| Frontend | ❌ | ❌ | ❌ | ❌ | ✅ |
| Backend | ❌ | ✅ | ❌ | ❌ | ❌ |
| Dispatcher | ❌ | ✅ | ✅ (roteia) | ❌ | ❌ |
| SP | ✅ | ✅ | ✅ | ✅ | ❌ |
| Event Store | ❌ | ✅ | ✅ (registra) | ✅ (append) | ❌ |
| IA | ❌ | ❌ | ✅ (sugere) | ❌ | ✅ (sugere) |
| N8N | ❌ | ❌ | ✅ (automa) | ✅ (via SP) | ❌ |

---

## Hierarquia de Verdade

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

## Anti-Patterns Proibidos

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
❌ Token em localStorage (proibido por SEGURANCA_CANONICA)
❌ Prompt sem auditoria
❌ Workflow sem aprovação
❌ Evento sem tenant
❌ Deleção física de dado (sempre soft delete com auditoria)
```

---

## Integrações

```text
Todos os MDs canônicos (MD-001 até MD-110) são complementares.
Em caso de conflito, MD-110 prevalece.
Qualquer alteração em MD-110 impacta toda a plataforma.
Mudança em MD-110 exige revalidação de todos os MAPs e BRs dependentes.
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

E a lei é uma só:
   Nada existe fora do Banco.
   Nada existe fora do Contexto.
   Nada existe fora do Evento.
   Nada existe fora da Lei Canônica.
   Nada existe fora da Pessoa Raiz.
```

---

## Leis Canônicas Party Identity

### LC-PER-001 — Pessoa é Raiz
```text
Pessoa é a entidade raiz da plataforma Midas.
```

### LC-PER-002 — Papéis são Projeções
```text
Identidade pertence à Pessoa, não ao Tenant.
```

### LC-PER-003 — Multi-Tenant Party
```text
Uma Pessoa pode existir em múltiplos Tenants simultaneamente.
```

### LC-PER-004 — Dados Pertencem ao Tenant
```text
Dados assistenciais pertencem ao Tenant onde ocorreram.
```

### LC-PER-005 — Contexto Define Visibilidade
```text
Contexto é o filtro de isolamento de dados.
```

---

## Leis Canônicas Patient Experience

### LC-PX-010 — Portal Único
```text
Pacientes entram pelo Portal Enterprise.
Nunca diretamente no HIS.
```

### LC-PX-011 — Acesso Direto
```text
1 contexto = dashboard direto.

N contextos = seleção.
```

---

## Leis Canônicas Platform Resilience

### LC-RES-001 — Operação Contínua
```text
Nenhuma falha técnica interrompe o fluxo assistencial.
```

### LC-RES-002 — APIs Stateless
```text
APIs não mantêm estado em memória.
Load Balancer distribui requisições entre instâncias.
Qualquer instância pode atender qualquer requisição.
Escala horizontal não requer replicação de estado.
```

### LC-RES-003 — Tolerância a Falhas
```text
Se uma instância API cair, outra assume imediatamente.
Se um Worker morrer, job permanece na fila.
Se o Load Balancer falhar, standby assume.
Recovery automático via health checks.
```

---

## Leis Canônicas AI Core

### LC-AI-001 — Sugerir, Não Decidir
```text
IA sugere. Usuário decide.
```

### LC-AI-002 — IA Acessa Pelo Mesmo Runtime
```text
IA não acessa banco diretamente.
IA acessa via MCP / API → Portal Runtime → Master
  → Dispatcher → Executors → Stored Procedures.
Nenhuma IA cria lógica paralela ao Kernel, contratos ou SPs.
IA consome as mesmas regras de negócio dos humanos.
```

### LC-AI-003 — IA é Governada, Não Solta
```text
Agente de IA é registrado, autenticado e autorizado.
Contexto, permissão, ferramentas e auditoria são controlados
pelo domínio ai_agent (registry, session, permission, context,
audit, execution, tool, memory).
Toda chamada de IA é rastreável.
```

---

## Leis Canônicas Database Architecture

### LC-DB-001 — SP como Porta Oficial de Escrita
```text
Nenhuma escrita direta em tabelas de negócio.
Toda operação relevante passa por Stored Procedure.
```

### LC-DB-002 — Triggers Proibidas para Lógica
```text
Triggers são proibidas para lógica de negócio.
Triggers podem existir somente para:
- Auditoria técnica
- Integração database-level
- Performance (índices, particionamento)
```

### LC-DB-003 — Eventos vs Triggers
```text
Triggers ocultam lógica.
SPs + Eventos tornam todo fluxo explícito.
```

### LC-DB-004 — Functions são para Cálculo
```text
Functions servem para cálculos.
Exemplo: idade(), tempo_espera(), score()
```

### LC-DB-005 — Views são para Leitura
```text
Views servem para leitura.
Exemplo: vw_painel_fila, vw_dashboard_urgencia
```

### LC-DB-006 — História Não Morre
```text
Nenhuma deleção física.
Cancelamento = novo evento.
Remoção = status inativo.
Histórico = fonte da verdade.
```

### LC-DB-007 — Correção via Evento
```text
Correção, não apagar.
Retificação, não sobrescrever.
Cancelamento, não DELETE.
Substituição, não UPDATE.
```

---

## Leis Canônicas Portal Experience

### LC-PORTAL-001 — Portal como Launcher
```text
Portal é launcher de aplicações, não aplicação de negócio.
```

### LC-PORTAL-002 — Windows-8 Style Layout
```text
Portal usa tiles/containers como Windows-8.
Cada container representa um domínio ou capability.
```

### LC-PORTAL-003 — Display como Container
```text
Dispositivos (TV, Totem, Kiosk, Monitor) são containers gerenciáveis no Portal.
```

### LC-PORTAL-004 — Live Tiles
```text
Containers mostram dados dinâmicos.
Exemplo: Senhas aguardando, Displays online, KPIs.
```

### LC-PORTAL-005 — Portal vs App Separation
```text
Portal ≠ App. App possui sua própria experiência.
Portal é entry point. App é operação.
```

### LC-PORTAL-006 — Portal Foca em Domínios
```text
Portal mostra domínios (Assistencial, Estoque, Displays).
Não mostra funções técnicas (botões).
```

---

Documento Canônico Supremo — MD-110

**Esta é a lei final do projeto AtendimentoOfflineAlpha.**
