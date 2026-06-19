# ESTRUTURA_ENTERPRISE_CANONICA_NEW_WAVE_SAAS

## STATUS

Documento Canônico.

Substitui qualquer estrutura anterior de pastas, frontend, backend, portal, módulos ou organização física do projeto.

---

# VISÃO ESTRATÉGICA

A Plataforma New Wave não é um HIS.

A Plataforma New Wave não é um ERP.

A Plataforma New Wave não é um CRM.

A Plataforma New Wave é uma Plataforma Operacional Corporativa SaaS, Multiempresa, Multiunidade, Multiaplicação, Offline-First, Orientada a Eventos, preparada para B2B, B2C e Governo.

---

# ARQUITETURA MACRO

Pessoa
→ Usuário
→ Sessão
→ Portal
→ Aplicação
→ Contexto Operacional
→ Workflow
→ Evento
→ Auditoria

Domínio Assistencial:

Pessoa
→ Senha
→ FFA
→ GPAT
→ Evento

---

# ESTRUTURA FÍSICA

AtendimentoOfflineAlpha/

├── docs/
├── apps/
├── dispositivos/
├── packages/
├── backend/
├── database/
├── dashboards/
├── workflow/
├── automacoes/
├── ia/
├── runtime/
├── integracoes/
├── infra/
├── tests/
├── assets/
└── legacy/

---

# DOCS

docs/

├── canonico/
├── arquitetura/
├── frontend/
├── backend/
├── banco/
├── eventos/
├── workflow/
├── integracoes/
├── ia/
├── portal/
├── assistencial/
├── farmacia/
├── financeiro/
├── rh/
├── ti/
├── logistica/
├── bi/
└── legacy/

---

# PORTAL CORPORATIVO

apps/portal

├── login
├── onboarding
├── home
├── marketplace
├── favoritos
├── notificacoes
├── tarefas
├── agenda
├── documentos
├── pesquisa_global
├── perfil
├── configuracoes
├── auditoria
├── central_ajuda
├── sac
├── cat
└── dashboard_portal

---

# MODULOS DE NEGOCIO

apps/

├── saude
├── farmacia
├── financeiro
├── faturamento
├── suprimentos
├── logistica
├── rh
├── ti
├── crm
├── compliance
├── bi
├── administracao
├── comercial
├── contratos
├── convenios
├── atendimento
├── ouvidoria
├── juridico
├── patrimonio
└── projetos

---

# SAUDE

apps/saude

├── recepcao
├── senha
├── ffa
├── gpat
├── acolhimento
├── triagem
├── classificacao_risco
├── consultorio
├── enfermagem
├── observacao
├── medicacao
├── procedimentos
├── exames
├── regulacao
├── internacao
├── alta
├── prontuario
├── telemedicina
├── homecare
├── epidemiologia
└── dashboards

---

# FARMACIA

apps/farmacia

├── farmacia_assistencial
├── farmacia_ambulatorial
├── farmacia_rua
├── pdv
├── caixa
├── vendas
├── clientes
├── convenios
├── estoque
├── compras
├── fornecedores
├── lotes
├── validade
├── inventario
├── rastreabilidade
├── perdas
└── dashboards

---

# FINANCEIRO

apps/financeiro

├── contas_pagar
├── contas_receber
├── tesouraria
├── conciliacao
├── fluxo_caixa
├── bancos
├── centro_custo
├── orcamento
├── fiscal
└── dashboards

---

# FATURAMENTO

apps/faturamento

├── sus
├── convenios
├── particular
├── glosas
├── auditoria_contas
├── producao
├── exportacoes
└── dashboards

---

# SUPRIMENTOS

apps/suprimentos

├── almoxarifado
├── estoque
├── compras
├── cotacoes
├── licitacoes
├── distribuicao
├── inventario
└── fornecedores

---

# LOGISTICA

apps/logistica

├── ambulancias
├── remocoes
├── transporte_sanitario
├── frota
├── manutencao
├── abastecimento
├── rastreamento
└── dashboards

---

# RH

apps/rh

├── funcionarios
├── escalas
├── ponto
├── treinamentos
├── recrutamento
├── desempenho
├── medicina_ocupacional
└── dashboards

---

# TI

apps/ti

├── chamados
├── cat
├── ativos
├── inventario
├── monitoramento
├── redes
├── servidores
├── backup
├── observabilidade
└── dashboards

---

# CRM

apps/crm

├── leads
├── clientes
├── oportunidades
├── contratos
├── campanhas
├── relacionamento
└── dashboards

---

# DISPOSITIVOS

dispositivos/

├── painel
├── totem
├── kiosk
├── mobile
├── tablet
└── tv_corporativa

---

# PAINEIS

dispositivos/painel

├── painel_recepcao
├── painel_triagem
├── painel_clinico
├── painel_medicacao
├── painel_exames
├── painel_farmacia
├── painel_publico
└── painel_gestao

---

# TOTENS

dispositivos/totem

├── totem_senha
├── totem_cadastro
├── totem_checkin
├── totem_satisfacao
└── totem_orientacao

---

# PACKAGES

packages/

├── auth
├── identidade
├── sessao
├── contexto
├── workflow
├── eventos
├── auditoria
├── notificacoes
├── dashboard
├── sdk
├── api_client
├── webhooks
├── n8n
├── ai_sdk
├── documentos
├── anexos
├── formularios
├── tabelas
├── ui
├── themes
├── hooks
└── runtime

---

# FRONTEND GLOBAL

apps/shared

├── layouts
├── componentes
├── formularios
├── modais
├── tabelas
├── dashboards
├── notificacoes
├── filtros
├── tema
└── acessibilidade

---

# CSS

assets/styles

├── reset.css
├── variables.css
├── theme.css
├── typography.css
├── layout.css
├── animations.css
├── portal.css
├── dashboard.css
├── forms.css
├── tables.css
├── login.css
└── globals.css

Cada módulo poderá possuir:

module.css

local ao módulo.

---

# BACKEND

backend/

├── auth
├── portal
├── identidade
├── sessao
├── contexto
├── workflow
├── eventos
├── auditoria
├── notificacoes
├── documentos
├── anexos
├── integracoes
├── webhooks
├── automacoes
├── ai
├── api_publica
├── api_privada
├── api_mobile
├── api_dispositivos
├── sync
└── runtime

---

# APIS

api_publica

Integrações externas.

api_privada

Portal e aplicações internas.

api_mobile

Aplicativos móveis.

api_dispositivos

Painéis, totens e dispositivos.

---

# WEBHOOKS

backend/webhooks

├── entrada
├── saida
├── assinaturas
├── fila
├── retry
├── auditoria
└── monitoramento

---

# N8N

automacoes/n8n

├── workflows
├── templates
├── credenciais
├── monitoramento
├── webhooks
└── integracoes

---

# IA

ia/

├── assistentes
├── copilots
├── classificadores
├── triagem_ia
├── atendimento_ia
├── sac_ia
├── cat_ia
├── analytics_ia
├── recomendacoes
├── automacoes
└── modelos

---

# BANCO

database/

├── schema
├── migrations
├── procedures
├── functions
├── views
├── triggers
├── eventos
├── auditoria
├── seeds
├── exportacoes
└── dicionario_dados

---

# WORKFLOW

workflow/

├── portal
├── saude
├── farmacia
├── financeiro
├── faturamento
├── suprimentos
├── logistica
├── rh
├── ti
├── crm
├── compliance
└── corporativo

---

# DASHBOARDS

dashboards/

├── executivo
├── gestor
├── assistencial
├── farmacia
├── financeiro
├── faturamento
├── logistica
├── suprimentos
├── rh
├── ti
├── crm
├── compliance
├── auditoria
├── sac
├── cat
└── bi

---

# OFFLINE FIRST

runtime/

├── edge
├── offline
├── cache
├── fila_local
├── reconciliacao
├── sincronizacao
├── eventos
└── auditoria_local

---

# LEI IMUTAVEL

Pessoa é a entidade raiz.

Sessão é a identidade operacional.

Portal é o ponto de entrada.

Evento é o motor do sistema.

Workflow é executado por eventos.

No domínio assistencial:

Pessoa
→ Senha
→ FFA
→ GPAT
→ Evento

Toda expansão futura deve respeitar esta estrutura.
