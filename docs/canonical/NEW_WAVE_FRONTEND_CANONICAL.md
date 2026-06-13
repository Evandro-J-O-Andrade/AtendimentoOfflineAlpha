# FRONTEND CANÔNICO

Status: OFICIAL

---

# STACK

Obrigatório:

- React
- TypeScript
- TSX
- TailwindCSS

Proibido para novos arquivos:

- JSX

---

# ESTRUTURA

src/

core/
apps/
shared/

---

# CORE

core/

auth/
tenant/
portal/
applications/
context/
runtime/
permissions/
analytics/
ai/
navigation/
design-system/

---

# APPS

apps/

corporativo/
operacional/
analytics/

---

# APLICAÇÃO CORPORATIVA

Exemplo:

apps/corporativo/wiki/

dashboard/
pages/
components/
hooks/
services/
types/
routes/

---

# APLICAÇÃO OPERACIONAL

Exemplo:

apps/operacional/farmacia/

dashboard/
pages/
components/
hooks/
services/
context/
types/
routes/
widgets/

---

# DASHBOARDS

Toda aplicação deve possuir:

- Sidebar
- Header
- Widgets
- Indicadores
- Atalhos
- Filtros

Inspirado em:

- Microsoft 365
- ClickUp
- Atlassian
- Monday

---

# NAVEGAÇÃO

Sempre permitir:

- Voltar ao Portal
- Trocar Contexto
- Perfil
- Alterar Senha
- Ajuda
- Sair

---

# CONTEXTO

Contexto nunca é solicitado no login.

Contexto somente após entrar em aplicação operacional.

O frontend não deve assumir entidades fixas.

O backend define:

- unidade
- sala
- guichê
- local
- filial
- departamento

ou qualquer outra estrutura.