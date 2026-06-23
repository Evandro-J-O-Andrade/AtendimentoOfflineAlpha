# MD-106 — Multi-Domain Architecture

## Status

Documento Canônico de Arquitetura de Domínios.
Define a separação entre Plataforma e Domínios de Negócio.

---

## Objetivo

Separar claramente a Plataforma (core, infraestrutura, governança) dos Domínios de Negócio (HIS, CRM, SAC, PDV, etc.).

---

## Princípio Fundamental

```text
Plataforma é o sistema operacional.
Domínios são as aplicações que rodam nele.
Plataforma não faz regra de negócio de domínio.
Domínio não涉足 infraestrutura da plataforma.
```

---

## Camada 0 — Plataforma (Core)

**Responsabilidades transversais a todos os domínios.**

```text
Identidade (IAM)
Segurança (Zero Trust)
Multi-Tenant (isolamento)
Contexto Operacional (engine)
Event Store (rastro)
Dispatcher (roteamento)
App Registry (catálogo)
Design System (UI)
Portal Core (navegação)
Runtime (execução offline)
Workflow Fabric (automação)
Analytics (métricas)
IA (copilots, agentes)
```

**Características:**
- Não contém regra de negócio de domínio
- Não conhece "Farmácia", "CRM", "HIS"
- Conhece apenas: tenant, usuário, permissão, contexto, app, evento
- É agnóstica a domínios

---

## Camada 1 — Domínios de Negócio

**Cada domínio é uma App registrada com suas próprias regras.**

### Saúde (HIS)

```text
Senha
Fila
FFA
Atendimento
Triagem
Execução Clínica
Farmácia
Laboratório
Internação
CAT
```

### Comercial

```text
CRM (Leads, Contas, Contratos, Pipeline)
SAC (Tickets, Fila, SLA, Base de Conhecimento)
PDV (Venda, Caixa, Sangria, Fechamento)
Financeiro (Contas, Lançamentos, Repasse)
Faturamento (Guias, Notas, Conciliação)
```

### RH

```text
Funcionário
Escala
Avaliação
Treinamento
Ponto
```

### Logística

```text
Estoque
Movimentação
Almoxarifado
Patrimônio
```

### Educação

```text
AVA
Cursos
Treinamentos
Certificados
Gamificação
```

### Social & Workplace

```text
Feed
Chat
Comunidades
Calendário
Eventos
```

### Analytics

```text
BI
Dashboards
Relatórios
KPIs
```

### IA & Automação

```text
Copilots
Agentes
Prompts
Workflows N8N
Knowledge Graph
```

---

## Domínios Mapeados no Dump

| Domínio | Tabelas | SPs | Status |
|---------|---------|-----|--------|
| AUTH | usuario, perfil, permissao, sessao | sp_auth_* | CANONICO |
| PLATAFORMA | sistema, tenant_registry, config | sp_admin_* | CANONICO |
| PORTAL | portal_*, documento_* | - | CANONICO |
| OPERACIONAL / HIS | senha_*, fila_*, ffa_*, atendimento_* | sp_atendimento_*, sp_senha_*, sp_fila_*, sp_ffa_* | CANONICO |
| FARMACIA | farm_*, farmacia_*, dispensacao_medicacao, gpat_* | sp_farmacia_* | CANONICO |
| ESTOQUE | estoque_*, produto_*, lote_*, saldo_* | sp_estoque_* | CANONICO |
| FATURAMENTO | faturamento_*, gpat_* | sp_conciliador_*, sp_faturamento_* | CANONICO |
| FINANCEIRO | financeiro_*, repasse_*, forma_pagamento | - | CANONICO |
| PDV | pdv_*, venda_*, caixa_* | - | CANONICO |
| CRM | cliente, fornecedor, contrato | - | CANONICO |
| SAC | chamado_*, alerta_* | - | CANONICO |
| LABORATORIO | lab_*, exame_* | - | CANONICO |
| INTERNACAO | internacao_*, leito_* | - | CANONICO |
| CAT | cat_*, sinan_* | sp_cat_* | CANONICO |
| ESOCIAL / RH | rh_*, funcionario_*, escala_* | - | CANONICO |
| WORKFLOW | fluxo_*, workflow_*, eventos_fluxo | - | CANONICO |
| RUNTIME | runtime_*, sync_* | - | CANONICO |
| AUDITORIA | auditoria_*, log_*, kernel_ledger | sp_auditar_* | CANONICO |
| MASTERDATA | md_*, codigo_*, cid10_*, cnes_*, sigtap_* | - | CANONICO |
| SEGURANCA | hardening_*, guardiao_* | sp_guardiao_* | CANONICO |
| BI | painel_*, tv_rotativo_* | sp_painel_* | CANONICO |

---

## Domínios Planejados (não presentes no dump)

| Domínio | Justificativa | MD Fonte |
|---------|---------------|----------|
| SOCIAL | MD-028 Enterprise Social Network | PLANEJADO |
| WORKPLACE | MD-029 Digital Workplace | PLANEJADO |
| CHAT | MD-029 Digital Workplace | PLANEJADO |
| DOCUMENTOS | MD-006 Portal | PLANEJADO |
| MARKETPLACE | MD-031, MD-075 | PLANEJADO |
| IA_COPILOT | MD-081 | PLANEJADO |
| AGENT_MARKETPLACE | MD-082 | PLANEJADO |
| N8N | MD-089 | PLANEJADO |
| NOTIFICACOES | MD-088 | PLANEJADO |
| SEARCH | MD-053, MD-087 | PLANEJADO |

---

## Regras de Isolamento

### Dados

```text
Cada domínio possui suas tabelas com prefixo específico.
Nenhuma tabela de domínio é acessada diretamente por outro domínio.
Compartilhamento é via App Registry + API + Event Store.
```

### Lógica

```text
Cada domínio possui suas SPs com prefixo específico.
Nenhuma SP de domínio é chamada diretamente por outro domínio.
Compartilhamento é via Dispatcher canônico.
```

### UI

```text
Cada domínio possui suas telas dentro do Shell.
Nenhuma tela de domínio carrega código de outro domínio.
Compartilhamento é via Design System + componentes compartilhados.
```

### Eventos

```text
Cada domínio emite seus eventos.
Eventos são consumidos por quem tem permissão.
Nenhum domínio altera evento de outro domínio.
```

---

## Comunicação Entre Domínios

### Eventos (Assíncrono — Preferencial)

```text
Domínio A emite evento.
Event Store registra.
Domínio B consome (se autorizado).
Exemplo: Farmácia emite DISPENSACAO → Faturamento consome para gerar guia.
```

### APIs (Síncrono — Quando Necessário)

```text
Domínio A expõe API via Enterprise API Platform.
Domínio B consome via API oficial.
Autenticação e autorização via IAM.
Exemplo: CRM consulta dados do SAC para score de cliente.
```

### Workflows (N8N)

```text
Domínio A inicia workflow.
N8N orquestra passos entre domínios.
Exemplo: SAC abre chamado → Workflow notifica → CRM atualiza score.
```

### Proibido

```text
Domínio A acessa tabela de Domínio B diretamente.
Domínio A chama SP de Domínio B diretamente.
Domínio A modifica estado de Domínio B sem evento.
Domínio A acopla lógica de Domínio B em sua UI.
```

---

## Evolução de Domínio

```text
Novo domínio nasce no App Registry.
Novo domínio define suas tabelas, SPs, eventos e APIs.
Novo domínio integra com Plataforma (IAM, Context, Event Store).
Novo domínio pode ser white-labeled (MD-094).
Novo domínio pode ser vendido no Marketplace (MD-075).
```

---

## Integrações

```text
MD-017 — Multi-Tenant
MD-019 — App Registry Canônico
MD-020 — Portal Core Architecture
MD-034 — Identity Access Management
MD-038 — Integration Hub
MD-042A — Portal Experience
MD-075 — Marketplace Seller Hub
MD-080 — Ecosystem Expansion Framework
```

---

## Lei

```text
Plataforma une.
Domínios executam.
Nenhum domínio é a plataforma.
Nenhuma plataforma é domínio.
Isolamento sem silos.
Integração sem acoplamento.
```

---

## Responsabilidades

Plataforma é responsável por:

```text
Core transversal (IAM, Event Store, Dispatcher, Registry)
Shell, Design System, Portal
Runtime, Offline-First, Sync
Analytics, IA, Workflow Fabric
Segurança, Compliance, Auditoria
```

Domínios são responsáveis por:

```text
Suas regras de negócio (SPs)
Suas telas (dentro do Shell)
Seus dados (tabelas próprias)
Seus eventos (para Event Store)
Suas métricas (para Analytics)
```

---

## Métricas

```text
Domínios registrados
Apps por domínio
Telas por domínio
SPs por domínio
Eventos por domínio
Integrações entre domínios
Acoplamentos detectados (anti-pattern)
Tempo de onboarding de novo domínio
```
