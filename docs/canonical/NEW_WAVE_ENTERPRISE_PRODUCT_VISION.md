# NEW WAVE ENTERPRISE

# LEI CANÔNICA 3

# VISÃO OFICIAL DO PRODUTO

Status: OFICIAL
Autoridade: New Wave Sistemas Digitais
Fundador e CEO: Evandro Andrade

---

# OBJETIVO

Transformar a plataforma em um SaaS Enterprise Multiempresa,
Multiaplicação,
Multiunidade,
White Label,
capaz de atender qualquer segmento de mercado através de um único núcleo tecnológico.

---

# POSICIONAMENTO COMERCIAL

O produto não deve ser apresentado como:

- HIS
- ERP
- CRM
- Sistema Hospitalar

O produto deve ser apresentado como:

New Wave Enterprise

Enterprise Management & Analytics Platform

Plataforma Corporativa de Gestão e Inteligência Analítica.

---

# IDENTIDADE DA PLATAFORMA

Nome Oficial:

New Wave Enterprise

Subtítulo Oficial:

Enterprise Management & Analytics Platform

ou

Plataforma Corporativa de Gestão e Inteligência Analítica

---

# FLUXO OFICIAL

Login
↓
Portal Corporativo
↓
Aplicação
↓
Contexto Operacional
↓
Dashboard da Aplicação
↓
Operação

---

# REGRA FUNDAMENTAL

Identidade ≠ Operação

Nunca misturar:

AuthContext

com

ContextContext

---

# LOGIN

O login é GLOBAL.

O login pertence à plataforma.

O login NÃO pertence ao cliente.

O login NÃO pertence à unidade.

O login NÃO pertence ao contexto operacional.

---

# TELA DE LOGIN

A tela de login deve exibir:

New Wave Enterprise

Enterprise Management & Analytics Platform

Usuário
Senha

Entrar

---

# LOGIN WHITE LABEL

PROIBIDO:

Trocar a identidade visual do login por cliente.

O login deve manter a identidade da plataforma.

---

# BRANDING APÓS LOGIN

Após autenticar:

TenantProvider assume o controle.

Carregar:

- Nome da empresa
- Logo
- Favicon
- Tema
- Paleta
- Permissões
- Aplicações

---

# PORTAL CORPORATIVO

O Portal é a Home oficial.

Todo usuário autenticado deve passar pelo Portal.

Nunca redirecionar diretamente para:

- Recepção
- Triagem
- Médico
- Farmácia
- Estoque
- Dashboard Operacional

---

# PORTAL

Exibir apenas aplicações permitidas ao usuário.

Cada card deve conter:

- Ícone
- Nome
- Descrição
- Favorito
- Último acesso
- Status

---

# REGRA DE CONTEXTO OPERACIONAL

Contexto não deve ser solicitado no login.

Contexto deve ser solicitado após o usuário entrar na aplicação.

Fluxo oficial:

Portal
↓
Aplicação
↓
Seleção de Contexto
↓
Dashboard

---

# EXEMPLO

Portal
↓
Recepção
↓
Selecionar Unidade
↓
Selecionar Local
↓
Dashboard Recepção

---

# DASHBOARDS

Toda aplicação possui dashboard própria.

As dashboards seguem o padrão:

Sidebar
Header
Widgets
Indicadores
Atalhos
Filtros

---

# PADRÃO VISUAL DAS DASHBOARDS

Inspirado em:

- Microsoft 365
- Atlassian
- ClickUp
- Monday
- Notion

Características:

- moderna
- limpa
- corporativa
- responsiva
- dark mode
- white label

---

# SIDEBAR

Cada aplicação possui sidebar própria.

Exemplo:

Recepção

- Dashboard
- Pacientes
- Atendimentos
- Fila
- Relatórios

Farmácia

- Dashboard
- PDV
- Estoque
- Compras
- Inventário
- Relatórios

RH

- Dashboard
- Funcionários
- Treinamentos
- Avaliações

---

# WHITE LABEL

Permitido ao cliente:

- Nome
- Logo
- Favicon
- Cores
- Tema
- Módulos

---

# NEW WAVE

A marca New Wave deve aparecer:

Login
Rodapé
Tela Sobre

Formato:

Powered by New Wave Enterprise

© New Wave Sistemas Digitais

Fundador e CEO
Evandro Andrade

---

# FRONTEND

Obrigatório:

React
TypeScript
Tailwind

Novos componentes:

TSX

Proibido:

Novos JSX

---

# DESIGN SYSTEM

Preferir:

SVG
Gradientes
Blur
Glassmorphism
Microinterações
Motion suave

Evitar:

Imagens pesadas
Layouts legados
Visual hospitalar fixo

---

# TELA DE LOGIN

A tela de login deve ser construída utilizando:

React
TypeScript
TailwindCSS
SVG

Sem dependência de imagens externas.

A ilustração lateral deve ser gerada por:

- SVG
- Curvas vetoriais
- Glow
- Shapes abstratos
- Partículas
- Gradientes

Objetivo:

Visual premium equivalente a produtos SaaS Enterprise modernos.

---

# INSTRUÇÃO PARA IA

Antes de gerar qualquer código:

Ler obrigatoriamente:

AI_RULES.md
NEW_WAVE_ARCHITECTURE_CANONICAL.md
NEW_WAVE_ENTERPRISE_CANONICAL.md
ROADMAP.md
DECISIONS.md

Aplicações Universais

São aplicações que não exigem contexto operacional.

Exemplos:

- Intranet
- AVA
- Rede Social Corporativa
- Chamados
- Ramal
- Chat
- Documentos
- Agenda
- Ouvidoria
- Wiki

Aplicações Operacionais

São aplicações que exigem contexto operacional.

Exemplos:

- Recepção
- Triagem
- Consultório
- Farmácia
- Estoque
- Manutenção
- Transporte
- Faturamento

O contexto operacional somente é solicitado quando a aplicação necessita de contexto para execução.