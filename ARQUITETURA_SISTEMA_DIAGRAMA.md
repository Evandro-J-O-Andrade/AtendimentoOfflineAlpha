# 🏗️ DIAGRAMA DE ARQUITETURA DO SISTEMA

## Visão Geral da Arquitetura

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           FRONTEND (React + Vite)                          │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                         apps/                                        │    │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐            │    │
│  │  │ operacional│ │  painel  │ │  totem   │ │  admin   │            │    │
│  │  │   (SPA)   │ │  (TV)    │ │ (Kiosk)  │ │  (Web)   │            │    │
│  │  └────┬─────┘ └────┬─────┘ └────┬─────┘ └────┬─────┘            │    │
│  │       │            │            │            │                   │    │
│  │  ┌────┴────────────┴────────────┴────────────┴────┐               │    │
│  │  │              api/spApi.js                      │               │    │
│  │  │         (callRoute / spCall / call)            │               │    │
│  │  └─────────────────────┬──────────────────────────┘               │    │
│  └────────────────────────┼────────────────────────────────────────────┘    │
└───────────────────────────┼────────────────────────────────────────────────┘
                            │ HTTP/REST
                            ▼
┌───────────────────────────────────────────────────────────────────────────────┐
│                         BACKEND (Node.js + Express)                          │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                         routes/                                       │    │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐  │    │
│  │  │spRoutes  │ │authRoutes│ │filaRoutes│ │painelRoutes│ │totemRoutes│ │    │
│  │  └────┬─────┘ └────┬─────┘ └────┬─────┘ └────┬─────┘ └────┬─────┘  │    │
│  │       │            │            │            │            │         │    │
│  │  ┌────┴────────────┴────────────┴────────────┴────────────┴────┐  │    │
│  │  │              kernel/dispatcher_gateway.js                     │  │    │
│  │  │                    (sp_master_dispatcher)                    │  │    │
│  │  └─────────────────────┬───────────────────────────────────────┘  │    │
│  └────────────────────────┼─────────────────────────────────────────────┘    │
└───────────────────────────┼─────────────────────────────────────────────────┘
                            │ SQL/Oracle
                            ▼
┌───────────────────────────────────────────────────────────────────────────────┐
│                         BANCO DE DADOS (MySQL 8.0)                          │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                    478 Tabelas + 20 Views                           │    │
│  │  ┌─────────────────────────────────────────────────────────────┐   │    │
│  │  │  AUTH    │ ATENDIMENTO │ ESTOQUE │ FATURAMENTO │ FLUXO     │   │    │
│  │  └─────────────────────────────────────────────────────────────┘   │    │
│  │                                                                   │    │
│  │  ┌─────────────────────────────────────────────────────────────┐   │    │
│  │  │              224 Stored Procedures + 3 Functions            │   │    │
│  │  │  sp_master_dispatcher, sp_auth_menu_get, sp_chamar_senha    │   │    │
│  │  └─────────────────────────────────────────────────────────────┘   │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
└───────────────────────────────────────────────────────────────────────────────┘
```

---

# 📁 ESTRUTURA DE ARQUIVOS

## ROOT (Raiz)

```
AtendimentoOfflineAlpha/
├── backend/                 # Servidor Node.js
├── frontend/                # Aplicação React
├── docs/                   # Documentação
├── Captures/               # Screenshots
├── MAPA_BANCO_DADOS_COMPLETO.md    # Mapa do banco
├── ARQUITETURA_SISTEMA_ANALISE.md  # Análise arquitetura
└── package.json            # Scripts globais
```

---

## 🟦 BACKEND

```
backend/
├── .env                    # Variáveis de ambiente
├── server.js               # Entry point
├── package.json            # Dependências
│
├── src/
│   ├── app.js             # Config Express
│   │
│   ├── auth/              # 🔐 Módulo de autenticação
│   │   ├── authController.js      # Controlador principal
│   │   ├── authService.js         # Lógica de auth
│   │   ├── authRoutes.js          # Rotas /api/auth/*
│   │   ├── authMiddleware.js      # Middleware JWT
│   │   ├── permissionMiddleware.js# Permissões
│   │   ├── permissionService.js  # Lógica permissões
│   │   ├── loginContextService.js # Contexto login
│   │   └── runtimeContextMiddleware.js
│   │
│   ├── routes/            # 🌐 Rotas da API
│   │   ├── spRoutes.js           # ✅ sp_master_dispatcher
│   │   ├── authRoutes.js         # Auth
│   │   ├── filaRoutes.js         # Fila/Senha
│   │   ├── painelRoutes.js       # Painel
│   │   ├── totemRoutes.js        # Totem
│   │   ├── triagemRoutes.js      # Triagem
│   │   ├── contextoRoutes.js     # Contexto
│   │   ├── farmaciaRoutes.js     # Farmácia
│   │   ├── operacionalRoutes.js # Operacional
│   │   ├── sessionRoutes.js      # Sessão
│   │   └── permissaoRoutes.js    # Permissão
│   │
│   ├── kernel/            # ⚙️ Motor do sistema
│   │   ├── dispatcher_gateway.js  # Gateway dispatcher
│   │   ├── authz_client.js        # Cliente ACL
│   │   ├── ledger_client.js       # Ledger events
│   │   ├── worker_runner.js       # Worker background
│   │   ├── auth/                 # Auth kernel
│   │   │   ├── auth_guardian_assert.js
│   │   │   ├── auth_login_service.js
│   │   │   ├── auth_password_hash.js
│   │   │   ├── auth_runtime_dispatcher.js
│   │   │   └── auth_session_validator.js
│   │   └── worker/
│   │       └── runtime_worker_processor.js
│   │
│   ├── services/         # 🔧 Serviços de negócio
│   │   ├── spService.js          # Executor SP
│   │   ├── atendimento_service.js
│   │   ├── triagem_service.js
│   │   ├── farmacia_service.js
│   │   ├── senha_service.js
│   │   └── auditoria_service.js
│   │
│   ├── controllers/      # 🎮 Controladores
│   │   └── auth/
│   │       └── loginController.js
│   │
│   ├── middleware/       # 🔒 Middlewares
│   ├── runtime/         # ⚡ Runtime guards
│   │   ├── runtimeGuard.js
│   │   ├── sessionGuard.js
│   │   └── syncQueueManager.js
│   │
│   ├── context/         # 🎯 Gerenciamento contexto
│   │   └── contextService.js
│   │
│   ├── config/          # ⚙️ Configurações
│   │   ├── database.js
│   │   └── jwt.js
│   │
│   └── ledger/          # 📊 Sistema de ledger
│       ├── ledgerRoutes.js
│       └── ledgerService.js
│
├── sql/
│   └── Dump20260322 (2).sql    # Dump banco completo
│
├── scripts/             # 🛠️ Utilitários
│   ├── patch.js
│   ├── seed_*.js
│   └── check-procedures.js
│
└── docs/
    └── FLUXO_SENHAS_SEQUENCIA.md
```

---

## 🟩 FRONTEND

```
frontend/
├── index.html
├── package.json          # React + Vite
├── vite.config.js
├── eslint.config.js
│
├── src/
│   ├── main.jsx          # Entry point React
│   ├── App.jsx          # Root component
│   │
│   ├── api/             # 🌐 Camada de API
│   │   ├── api.js       # Axios instance
│   │   └── spApi.js     # ✅ callRoute / spCall
│   │
│   ├── router/          # 🚦 Roteamento
│   │   ├── index.jsx    # React Router
│   │   └── operacionalRoutes.js
│   │
│   ├── context/         # 🎯 Contextos React
│   │   ├── AuthContext.jsx
│   │   ├── AppContext.jsx
│   │   └── AuthProvider.jsx (re-export)
│   │
│   ├── hooks/           # ⚓ Custom Hooks
│   │   ├── useAuth.js
│   │   ├── useMenu.js
│   │   ├── useApp.js
│   │   ├── useFilaRealtime.js
│   │   └── ...
│   │
│   ├── services/       # 🔧 Serviços de negócio
│   │   ├── loginService.js
│   │   ├── sessionService.js
│   │   ├── FilaService.js
│   │   ├── PacienteService.js
│   │   ├── AssistencialService.js
│   │   ├── PermissionService.js
│   │   └── syncService.js
│   │
│   ├── components/     # 🧩 Componentes reutilizáveis
│   │   ├── MenuDinamico.jsx
│   │   ├── Sidebar.jsx
│   │   └── ...
│   │
│   ├── pages/          # 📄 Páginas avulsas
│   │   ├── LoginPage.jsx
│   │   └── Dashboard.jsx
│   │
│   ├── runtime/        # ⚡ Runtime frontend
│   │   └── RuntimeActionRouter.jsx
│   │
│   └── apps/           # 🚀 Módulos da aplicação
│       ├── operacional/        # 🏥 Main SPA
│       │   ├── auth/
│       │   │   ├── AuthProvider.jsx    # ✅ Auth Provider
│       │   │   └── RuntimeAuthContext.jsx
│       │   ├── layout/
│       │   │   ├── Layout.jsx
│       │   │   ├── Layout.css
│       │   │   └── sidebar.css
│       │   ├── security/
│       │   │   └── SecurityGuard.jsx
│       │   ├── components/
│       │   │   └── PatientQueue.jsx
│       │   ├── hooks/
│       │   ├── pages/                 # 📄 Páginas operacionais
│       │   │   ├── Login.jsx          # Login/setor
│       │   │   ├── Dashboard.jsx      # Dashboard
│       │   │   ├── contexto/
│       │   │   │   └── SelecionarContexto.jsx
│       │   │   ├── recepcao/
│       │   │   │   └── Recepcao.jsx
│       │   │   ├── triagem/
│       │   │   │   └── Triagem.jsx
│       │   │   ├── medico/
│       │   │   │   └── Medico.jsx
│       │   │   ├── enfermagem/
│       │   │   │   └── Enfermagem.jsx
│       │   │   ├── farmacia/
│       │   │   │   └── Farmacia.jsx
│       │   │   ├── laboratorio/
│       │   │   │   └── Laboratorio.jsx
│       │   │   ├── internacao/
│       │   │   │   └── Internacao.jsx
│       │   │   ├── estoque/
│       │   │   │   └── Estoque.jsx
│       │   │   ├── ambulancia/
│       │   │   │   └── Ambulancia.jsx
│       │   │   ├── remocao/
│       │   │   │   └── Remocao.jsx
│       │   │   ├── manutencao/
│       │   │   │   └── Manutencao.jsx
│       │   │   └── ...
│       │   └── runtime/
│       │
│       ├── painel/             # 📺 TV/Painel
│       │   └── pages/
│       │       ├── Painel.jsx
│       │       └── PainelUsuario.jsx
│       │
│       ├── totem/              # 📟 Toten/Kiosk
│       │   └── pages/
│       │       └── Totem.jsx
│       │
│       ├── admin/              # ⚙️ Admin
│       │   ├── pages/
│       │   │   ├── Admin.jsx
│       │   │   └── AdminModulePage.jsx
│       │   └── security/
│       │       └── AdminGuard.jsx
│       │
│       ├── auth/               # Auth standalone
│       │   └── pages/
│       │       └── Login.jsx
│       │
│       └── governaca/          # Governança
│
└── public/
```

---

# 🔄 FLUXO DE DADOS

## 1. Login do Usuário

```
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│  Usuário │────▶│ Login.jsx│────▶│ spApi.js │────▶│  Backend │
│          │     │          │     │ callRoute │     │ /api/sp  │
└──────────┘     └──────────┘     └──────────┘     └────┬─────┘
                                                         │
                                                         ▼
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│  Sessão  │◀────│ Provider │◀────│ resposta │◀────│  sp_auth │
│  Context │     │  Atualiza│     │  JWT     │     │  _login  │
└──────────┘     └──────────┘     └──────────┘     └──────────┘
```

## 2. Carregar Menu

```
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│ Auth     │────▶│  Backend │────▶│  sp_auth │────▶│   MySQL  │
│ Provider │     │ /menu    │     │ _menu_get│     │ auth_menu│
│          │     │          │     │          │     │  224 SPs │
└──────────┘     └────┬─────┘     └──────────┘     └──────────┘
                     │
                     ▼
              ┌──────────┐
              │  Menu    │
              │ Dinâmico │
              └──────────┘
```

## 3. Executar Ação (Dispatcher)

```
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│ Página   │────▶│ spApi.js │────▶│  Backend │────▶│ sp_master│
│ Operac.  │     │ callRoute│     │ /api/sp  │     │_dispatch │
│          │     │          │     │          │     │   er     │
└──────────┘     └──────────┘     └────┬─────┘     └────┬─────┘
                                        │                │
                                        ▼                ▼
                                 ┌──────────┐     ┌──────────┐
                                 │ resposta │     │  224 SPs │
                                 │  JSON    │     │  MySQL   │
                                 └──────────┘     └──────────┘
```

---

# 🎯 ARQUITETURA DE CHAMADAS

## API Layer (Frontend)

```javascript
// frontend/src/api/spApi.js
import api from './api';

export default {
  // ✅ NOVO: callRoute (canônico)
  async callRoute({ metodo, rota, id_sessao, payload }) {
    const response = await api.post('/sp', {
      p_id_sessao: id_sessao,
      p_dominio: rota.split('/')[0],
      p_acao: rota.split('/')[1],
      p_payload: JSON.stringify(payload)
    });
    return response.data;
  },

  // ✅ NOVO: spCall (atalho)
  async spCall(spName, params) {
    return this.callRoute({
      rota: spName,
      ...params
    });
  },

  // Legado (deprecated)
  async call(procedure, params) { ... }
}
```

## Dispatcher (Backend)

```javascript
// backend/src/kernel/dispatcher_gateway.js
async function sp_master_dispatcher(req, res) {
  const { p_id_sessao, p_dominio, p_acao, p_payload } = req.body;

  // Mapeia para SP correta
  const spMap = {
    'auth/login': 'sp_master_login',
    'auth/menu': 'sp_auth_menu_get',
    'fila/chamar': 'sp_chamar_senha',
    'atendimento/iniciar': 'sp_master_atendimento_iniciar',
    // ... 224 SPs
  };

  const spName = spMap[`${p_dominio}/${p_acao}`];

  // Executa no MySQL
  const result = await executeSP(spName, { p_id_sessao, p_payload });

  res.json({ sucesso: true, resultado: result });
}
```

---

# 📊 BANCO DE DADOS

## Visão Geral

| Componente | Quantidade |
|------------|------------|
| Tabelas | 478 |
| Views | 20 |
| Stored Procedures | 224 |
| Functions | 3 |

## Principais Tabelas

### Auth
- `auth_sessao` - Sessões ativas
- `usuario` - Usuários
- `perfil` - Perfis
- `permissao` - Permissões
- `auth_token` - Tokens

### Atendimento
- `atendimento` - Atendimentos
- `atendimento_evento` - Eventos
- `atendimento_triagem` - Triagem
- `atendimento_evolucao` - Evolução

### Estrutura
- `unidade` - Unidades
- `local` - Locais
- `setor` - Setores
- `leito` - Leitos

## Principais SPs

| Categoria | SP Principal |
|-----------|---------------|
| **Dispatcher** | `sp_master_dispatcher` |
| **Auth** | `sp_master_login`, `sp_auth_menu_get`, `sp_sessao_abrir` |
| **Fila** | `sp_chamar_senha`, `sp_criar_senha`, `sp_senha_emitir` |
| **Atendimento** | `sp_master_atendimento_iniciar`, `sp_atendimento_transicionar` |
| **Triagem** | `sp_triagem_classificar_senha`, `sp_executor_assistencial_triagem_*` |
| **Farmácia** | `sp_farm_dispensacao_criar`, `sp_medicacao_*` |
| **Estoque** | `sp_estoque_movimentar`, `sp_estoque_movimento_criar` |

---

# 🔐 FLUXO DE AUTENTICAÇÃO

```
┌─────────────────────────────────────────────────────────────────────────┐
│                           FLUXO COMPLETO                               │
└─────────────────────────────────────────────────────────────────────────┘

  1. USUÁRIO ABRE APP
         │
         ▼
  2. LoginPage.jsx
     ┌─────────────────────┐
     │ 输入: usuário      │
     │ 输入: senha        │
     └──────────┬──────────┘
                │
                ▼
  3. spApi.callRoute({
       metodo: 'POST',
       rota: 'auth/login',
       id_sessao: null,
       payload: { usuario, senha }
     })
                │
                ▼
  4. backend/routes/spRoutes.js
     → sp_master_dispatcher()
                │
                ▼
  5. sp_master_login(p_login, p_senha)
     ┌─────────────────────────────────────┐
     │ • Valida usuário/senha             │
     │ • Cria sessão (auth_sessao)         │
     │ • Gera token JWT                    │
     │ • Retorna: { sessao, token, menu } │
     └─────────────────────────────────────┘
                │
                ▼
  6. AuthProvider.jsx
     ┌─────────────────────────────────────┐
     │ • setSession(sessao)               │
     │ • setToken(token)                   │
     │ • Carrega menu (sp_auth_menu_get)  │
     │ • Redireciona para Dashboard        │
     └─────────────────────────────────────┘
                │
                ▼
  7. Dashboard.jsx
     ┌─────────────────────────────────────┐
     │ • Renderiza MenuDinamico            │
     │ • Permite acesso às páginas         │
     │   conforme permissões               │
     └─────────────────────────────────────┘
```

---

# 📱 MÓDULOS DO SISTEMA

| Módulo | Arquivo | Descrição |
|--------|---------|-----------|
| **Recepção** | [`Recepcao.jsx`](frontend/src/apps/operacional/pages/recepcao/Recepcao.jsx:1) | Abertura de atendimento |
| **Triagem** | [`Triagem.jsx`](frontend/src/apps/operacional/pages/triagem/Triagem.jsx:1) | Classificação de risco |
| **Médico** | [`Medico.jsx`](frontend/src/apps/operacional/pages/medico/Medico.jsx:1) | Atendimento médico |
| **Enfermagem** | [`Enfermagem.jsx`](frontend/src/apps/operacional/pages/enfermagem/Enfermagem.jsx:1) | Cuidados enfermagem |
| **Farmácia** | [`Farmacia.jsx`](frontend/src/apps/operacional/pages/farmacia/Farmacia.jsx:1) | Dispensação medicamentos |
| **Laboratório** | [`Laboratorio.jsx`](frontend/src/apps/operacional/pages/laboratorio/Laboratorio.jsx:1) | Exames laboratoriais |
| **Internação** | [`Internacao.jsx`](frontend/src/apps/operacional/pages/internacao/Internacao.jsx:1) | Internados |
| **Estoque** | [`Estoque.jsx`](frontend/src/apps/operacional/pages/estoque/Estoque.jsx:1) | Gestão estoque |
| **Ambulância** | [`Ambulancia.jsx`](frontend/src/apps/operacional/pages/ambulancia/Ambulancia.jsx:1) | Remoções |
| **Remoção** | [`Remocao.jsx`](frontend/src/apps/operacional/pages/remocao/Remocao.jsx:1) | Transporte |
| **Manutenção** | [`Manutencao.jsx`](frontend/src/apps/operacional/pages/manutencao/Manutencao.jsx:1) | Chamados |
| **Painel** | [`Painel.jsx`](frontend/src/apps/painel/pages/Painel.jsx:1) | TV/Painel |
| **Totem** | [`Totem.jsx`](frontend/src/apps/totem/pages/Totem.jsx:1) | Kiosk |

---

# 🗂️ RESUMO ARQUITETURA

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         ARQUITETURA 3 CAMADAS                         │
└─────────────────────────────────────────────────────────────────────────┘

  ┌─────────────────────────────────────────────────────────────────────┐
  │                      FRONTEND (React + Vite)                        │
  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐              │
  │  │Operacio-│  │ Painel  │  │ Totem   │  │ Admin   │              │
  │  │nal SPA  │  │   TV    │  │ Kiosk   │  │   Web   │              │
  │  └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘              │
  │       └────────────┴────────────┴────────────┘                    │
  │                           │                                         │
  │                    ┌──────┴──────┐                                  │
  │                    │  spApi.js   │                                  │
  │                    │ (callRoute) │                                  │
  │                    └──────┬──────┘                                  │
  └───────────────────────────┼─────────────────────────────────────────┘
                               │ HTTP
  ┌───────────────────────────┼─────────────────────────────────────────┐
  │                    BACKEND (Node.js)                               │
  │                    ┌──────┴──────┐                                  │
  │                    │ sp_master_ │                                  │
  │                    │ dispatcher │                                  │
  │                    └──────┬──────┘                                  │
  │       ┌───────────────────┴───────────────────┐                    │
  │  ┌────┴────┐  ┌────┴────┐  ┌────┴────┐  ┌────┴────┐             │
  │  │  Auth   │  │  Fila   │  │ Atend.  │  │ Estoque │             │
  │  │ Routes  │  │ Routes  │  │ Routes  │  │ Routes  │             │
  │  └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘             │
  └───────┼────────────┼────────────┼────────────┼────────────────────┘
          │            │            │            │
          ▼            ▼            ▼            ▼
  ┌─────────────────────────────────────────────────────────────────────┐
  │                    BANCO (MySQL 8.0)                               │
  │  ┌───────────────────────────────────────────────────────────────┐ │
  │  │                    224 Stored Procedures                      │ │
  │  │  auth_sessao │ atendimento │ fila_senha │ prescricao │ ...   │ │
  │  └───────────────────────────────────────────────────────────────┘ │
  │  ┌───────────────────────────────────────────────────────────────┐ │
  │  │                       478 Tabelas                             │ │
  │  │  usuario │ perfil │ permissao │ atendimento │ estoque │ ...   │ │
  │  └───────────────────────────────────────────────────────────────┘ │
  └─────────────────────────────────────────────────────────────────────┘
```

---

*Diagrama gerado automaticamente - Backend: 47 arquivos | Frontend: 80+ arquivos*
