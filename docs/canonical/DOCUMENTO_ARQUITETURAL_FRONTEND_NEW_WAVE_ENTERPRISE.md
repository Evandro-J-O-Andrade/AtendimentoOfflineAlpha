# NEW WAVE ENTERPRISE
## Arquitetura Frontend React + TypeScript

Versão: Canônica
Status: Arquitetura Base
Frontend: React + TypeScript + Vite
Backend: API Gateway + Stored Procedures
Banco: MySQL (Fonte da Verdade)

---

# PRINCÍPIO FUNDAMENTAL

A Identidade é persistente; o Contexto é mutável.

### Ontologia de Acesso

1. **PESSOA**: O ente real no mundo.
2. **USUARIO**: A credencial digital da Pessoa.
3. **SESSAO_USUARIO**: O período de atividade (Único por Login).
4. **CONTEXTO_OPERACIONAL**: O estado atual da operação (Sistema + Unidade + Local).

### Fluxo de Navegação (Single Session / Multi-Context)

* **Login**: Cria `SESSAO_USUARIO` 500.
* **Portal**: `SESSAO` 500 + `SISTEMA` Portal.
* **Abrir HIS**: `SESSAO` 500 + `SISTEMA` HIS + `UNIDADE` Centro.
* **Trocar para CRM**: `SESSAO` 500 + `SISTEMA` CRM.

### Vantagem de Auditoria
Toda ação no banco deve registrar o `id_sessao_usuario` e o contexto ativo, permitindo saber exatamente quem era a pessoa, qual usuário usou, em qual sessão global e em qual aplicação/unidade o evento ocorreu.

---

# FLUXO GERAL

┌─────────────┐
│ LOGIN       │
└──────┬──────┘
       │
       ▼
┌────────────────────┐
│ PORTAL CORPORATIVO │
└──────┬─────────────┘
       │
       ├─ Assistencial
       │
       ├─ Farmácia
       │
       ├─ Financeiro
       │
       ├─ RH
       │
       ├─ Comercial
       │
       ├─ Estoque
       │
       ├─ Analytics
       │
       └─ Administração
       │
       ▼
┌────────────────────┐
│ APLICAÇÃO          │
└──────┬─────────────┘
       │
       ▼
┌────────────────────┐
│ MODAL CONTEXTO     │
└──────┬─────────────┘
       │
       ▼
┌────────────────────┐
│ DASHBOARD APP      │
└────────────────────┘

---

# ETAPA 1 - LOGIN

Tela única.

Campos:

- Login
- Senha

Ação:

POST /api/auth/login

Retorno:

{
  token,
  usuario,
  tenant,
  sistemas
}

Após autenticação:

navigate('/portal')

---

# ETAPA 2 - PORTAL CORPORATIVO

Objetivo:

Ser a Home Global da plataforma.

Não possui contexto operacional.

Mostra apenas sistemas autorizados.

Exemplo:

┌──────────────────────────┐
│ Bem-vindo João           │
├──────────────────────────┤
│ Assistencial             │
│ Farmácia                 │
│ Financeiro               │
│ RH                       │
│ Comercial                │
│ Analytics                │
│ Administração            │
└──────────────────────────┘

Dados:

sp_auth_menu_get

ou

sp_master_routes

---

# ETAPA 3 - ENTRADA NA APLICAÇÃO

Ao clicar em um sistema:

Exemplo:

Assistencial

navigate('/app/assistencial')

Sistema verifica:

Possui contexto?

SIM:
→ abre dashboard

NÃO:
→ abre modal contexto

---

# ETAPA 4 - MODAL DE CONTEXTO

Primeira entrada na aplicação.

Selecionar:

- Unidade
- Local Operacional
- Sala

Exemplo:

Unidade:
[ UPA Centro ▼ ]

Local:
[ Triagem ▼ ]

Sala:
[ Consultório 01 ▼ ]

Botão:

[ Entrar ]

Chamada:

sp_auth_contexto_set

Retorno:

{
  sucesso: true
}

Salvar:

RuntimeContext

---

# ETAPA 5 - DASHBOARD OPERACIONAL

Agora sim existe contexto.

Exibir:

Usuário
Tenant
Unidade
Local
Sala

Exemplo:

João Silva
UPA Centro
Triagem
Consultório 01

---

# ARQUITETURA REACT

src/

├── app/
│
├── core/
│   ├── auth/
│   ├── runtime/
│   ├── api/
│   ├── hooks/
│   └── providers/
│
├── portal/
│   ├── pages/
│   ├── components/
│   └── services/
│
├── modules/
│
│   ├── assistencial/
│   │
│   ├── farmacia/
│   │
│   ├── financeiro/
│   │
│   ├── estoque/
│   │
│   ├── rh/
│   │
│   ├── comercial/
│   │
│   └── analytics/
│
├── shared/
│   ├── components/
│   ├── layouts/
│   ├── tables/
│   ├── forms/
│   └── modals/
│
├── routes/
│
├── assets/
│
└── main.tsx

---

# CORE AUTH

Responsável por:

- Login
- Logout
- Token
- Refresh
- Perfil

AuthContext

interface AuthContext {
  usuario
  tenant
  token
  sistemas
}

---

# CORE RUNTIME

Responsável por:

- Unidade
- Local
- Sala

RuntimeContext

interface RuntimeContext {
  unidade
  local
  sala
}

Não existe durante login.

Só existe dentro da aplicação.

---

# ROUTES

/

Login

/portal

Portal Corporativo

/app/:sistema

Entrada da aplicação

/app/:sistema/dashboard

Dashboard

---

# LAYOUT PADRÃO

┌─────────────────────────────┐
│ HEADER                      │
├────────────┬────────────────┤
│ SIDEBAR    │                │
│            │   CONTEÚDO     │
│            │                │
└────────────┴────────────────┘

Header:

- Usuário
- Tenant
- Contexto

Sidebar:

- Menus do sistema

---

# CONSUMO DE APIs

Frontend nunca acessa tabela.

Frontend chama:

API Gateway

Exemplo:

POST /api/dispatcher

{
  acao: "ATENDIMENTO_INICIAR",
  payload: {}
}

Backend chama:

sp_master_dispatcher

---

# REGRA CANÔNICA

Frontend não conhece banco.

Frontend não chama SP diretamente.

Frontend não monta SQL.

Frontend fala apenas com:

API Gateway

API Gateway fala com:

Stored Procedures

Stored Procedures falam com:

MySQL

MySQL é a Fonte da Verdade.

---

# OBJETIVO FINAL

Login
→ Portal Corporativo
→ Aplicação
→ Contexto Operacional
→ Dashboard

Separando completamente:

AuthContext
de
RuntimeContext

e permitindo que a mesma plataforma opere:

- Saúde
- Farmácia
- RH
- Financeiro
- Comercial
- Logística
- Analytics
- Qualquer outro segmento
Essa estrutura já fica alinhada com o que você definiu para o AtendimentoOfflineAlpha/New Wave: Portal Corporativo como ponto central, identidade separada do contexto operacional e comunicação exclusivamente via API Gateway → SPs → MySQL