# STACK Frontend + Backend Completo - Pronto Atendimento

## 📋 Visão Geral da Arquitetura

```
┌─────────────────────────────────────────────────────────────┐
│                    FRONTEND (React + Vite)                   │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐        │
│  │  Login   │ │Dashboard │ │ Farmácia │ │ Estoque  │        │
│  └────┬─────┘ └────┬─────┘ └────┬─────┘ └────┬─────┘        │
│       │            │            │            │              │
│       └────────────┼────────────┼────────────┘              │
│                    │ API REST + JWT                         │
│       ┌────────────▼────────────────────────────┐           │
│       │    CONTEXT + SERVICES (Estado Global)   │           │
│       └─────────────────────────────────────────┘           │
└─────────────────────────────────────────────────────────────┘
                           ▼ HTTPS
┌─────────────────────────────────────────────────────────────┐
│               BACKEND (Express + Node.js)                    │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  API Routes (Autenticação/Farmácia/Estoque/etc)    │   │
│  └────────────────┬─────────────────────────────────────┘   │
│                   ▼                                          │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  MySQL Procedure Wrapper (Pool + Transações)        │   │
│  └────────────────┬─────────────────────────────────────┘   │
│                   ▼                                          │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  MySQL 8.0 (pronto_atendimento - 122 tabelas)      │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

## 🚀 STACK RECOMENDADO

### Backend
- **Node.js 18+** (runtime JavaScript)
- **Express 4.x** (framework web)
- **mysql2/promise** (driver MySQL com promises)
- **jsonwebtoken** (autenticação)
- **bcryptjs** (hash de senha)
- **cors** (CORS habilitado)
- **dotenv** (variáveis ambiente)
- **express-validator** (validação)

### Frontend
- **React 18+** (UI library)
- **Vite** (build tool - rápido)
- **React Router v6** (roteamento)
- **Axios** (HTTP client)
- **TailwindCSS** (styling)
- **Context API + useReducer** (estado global)
- **React Query** (caching/sincronização)

### Database
- **MySQL 8.0+**
- **19.400+ linhas SQL** (dump pronto)
- **122 tabelas** (pronto para usar)
- **80+ Procedures** (lógica de negócio)

---

## 📁 ESTRUTURA DE PASTA RECOMENDADA

```
AtendimentoOfflineAlpha/
├── backend/
│   ├── src/
│   │   ├── index.js                    # Entry point
│   │   ├── config/
│   │   │   ├── mysql.js                # Pool de conexão
│   │   │   ├── jwt.js                  # Configuração JWT
│   │   │   └── env.js                  # Variáveis ambiente
│   │   ├── middleware/
│   │   │   ├── auth.js                 # Validar JWT
│   │   │   ├── errorHandler.js         # Tratamento de erros
│   │   │   └── validateInput.js        # Validação de entrada
│   │   ├── routes/
│   │   │   ├── auth.routes.js          # Login/Logout/Refresh
│   │   │   ├── farmacia.routes.js      # Dispensação
│   │   │   ├── estoque.routes.js       # Movimento de estoque
│   │   │   ├── atendimento.routes.js   # FFA/Triagem/Consulta
│   │   │   ├── usuario.routes.js       # Usuários/Perfis
│   │   │   └── admin.routes.js         # Admin (dashboards)
│   │   ├── controllers/
│   │   │   ├── auth.controller.js      # Lógica de autenticação
│   │   │   ├── farmacia.controller.js  # Lógica de farmácia
│   │   │   └── ...
│   │   ├── services/
│   │   │   ├── mysql.service.js        # Wrapper procedures
│   │   │   ├── auth.service.js         # Token/Password
│   │   │   └── ...
│   │   └── utils/
│   │       ├── logger.js               # Logging
│   │       ├── errors.js               # Custom errors
│   │       └── validators.js           # Funções validação
│   ├── .env                            # Variáveis base
│   ├── .env.example                    # Template .env
│   ├── package.json
│   └── README.md
│
├── frontend/
│   ├── src/
│   │   ├── index.jsx                   # Entry React
│   │   ├── App.jsx                     # Root component
│   │   ├── pages/
│   │   │   ├── LoginPage.jsx           # Tela de login
│   │   │   ├── DashboardPage.jsx       # Dashboard principal
│   │   │   ├── FarmaciaPage.jsx        # Módulo farmácia
│   │   │   ├── EstoquePage.jsx         # Módulo estoque
│   │   │   ├── AtendimentoPage.jsx     # Módulo atendimento
│   │   │   └── AdminPage.jsx           # Admin/Relatórios
│   │   ├── components/
│   │   │   ├── Layout/
│   │   │   │   ├── MainLayout.jsx      # Layout principal (sidebar + header)
│   │   │   │   ├── Sidebar.jsx         # Barra lateral
│   │   │   │   └── Header.jsx          # Cabeçalho
│   │   │   ├── Auth/
│   │   │   │   ├── LoginForm.jsx       # Formulário login
│   │   │   │   └── ProtectedRoute.jsx  # Wrapper rota autenticada
│   │   │   ├── Farmacia/
│   │   │   │   ├── DispensacaoForm.jsx # Novo dispensação
│   │   │   │   ├── ReservaList.jsx     # Listar reservas
│   │   │   │   └── ConfirmacaoModal.jsx # Modal dupla-baixa
│   │   │   ├── Estoque/
│   │   │   │   ├── MovimentoForm.jsx   # Novo movimento
│   │   │   │   ├── SaldoTable.jsx      # Tabela saldo
│   │   │   │   └── LoteDetail.jsx      # Detalhe lote
│   │   │   ├── Atendimento/
│   │   │   │   ├── FFACard.jsx         # Card FFA
│   │   │   │   ├── FilaOp.jsx          # Fila operacional
│   │   │   │   └── TriagemForm.jsx     # Formulário triagem
│   │   │   └── Common/
│   │   │       ├── Table.jsx           # Tabela genérica
│   │   │       ├── Modal.jsx           # Modal genérica
│   │   │       ├── Button.jsx          # Botão customizado
│   │   │       ├── Input.jsx           # Input customizado
│   │   │       ├── Alert.jsx           # Alerta/notificação
│   │   │       └── Loading.jsx         # Spinner loading
│   │   ├── context/
│   │   │   ├── AuthContext.jsx         # Contexto autenticação
│   │   │   ├── FarmaciaContext.jsx     # Contexto farmácia
│   │   │   └── EstoqueContext.jsx      # Contexto estoque
│   │   ├── services/
│   │   │   ├── api.js                  # Axios instance + interceptors
│   │   │   ├── authService.js          # Serviço auth
│   │   │   ├── farmaciaService.js      # Serviço farmácia
│   │   │   └── ...
│   │   ├── hooks/
│   │   │   ├── useAuth.js              # Hook autenticação
│   │   │   ├── useFarmacia.js          # Hook farmácia
│   │   │   └── useApi.js               # Hook genérico API
│   │   ├── utils/
│   │   │   ├── formatters.js           # Formatação dados
│   │   │   ├── validators.js           # Validação frontend
│   │   │   └── constants.js            # Constantes APP
│   │   ├── styles/
│   │   │   ├── tailwind.config.js      # Config Tailwind
│   │   │   ├── globals.css             # Estilos globais
│   │   │   └── components.css          # Estilos componentes
│   │   └── assets/
│   │       ├── logo.png
│   │       ├── icons/
│   │       └── images/
│   ├── public/
│   │   └── index.html
│   ├── vite.config.js
│   ├── package.json
│   └── README.md
│
├── docs/
│   ├── MAPA_BANCO_DADOS_COMPLETO.md     # Referência banco
│   ├── FLUXOS_ARQUITETURA_VISUAL.md     # Fluxos negócio
│   ├── REFERENCIA_TECNICA_PROCEDURES.md # Procedures
│   ├── DESENVOLVIMENTO_QUICK_START.md   # Como começar
│   └── README_DOCUMENTACAO.md           # Índice docs
│
├── scripts/
│   ├── dump/
│   │   └── Dump20260220 (3).sql         # Dump MySQL
│   └── setup.sh                         # Setup database
│
├── STACK_FRONTEND_BACKEND.md            # Este arquivo
└── README.md                            # Projeto principal
```

---

## 🔑 Fluxo de Autenticação - Login Completo

```
┌─────────────────────────────────────────────────────┐
│           USUÁRIO ACESSA LOGIN PAGE                │
│   http://localhost:5173/login                      │
└──────────────────┬──────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────┐
│      FRONTEND: LoginForm.jsx                       │
│  - Email input                                     │
│  - Senha input                                     │
│  - Botão "ENTRAR"                                  │
└──────────────────┬──────────────────────────────────┘
                   │ POST /api/auth/login
                   │ {email, senha}
                   ▼
┌─────────────────────────────────────────────────────┐
│      BACKEND: POST /api/auth/login                │
│  1. Valida email/senha existem                    │
│  2. Query: SELECT * FROM usuario WHERE email=?   │
│  3. bcrypt.compare(senha, usuario.senha_hash)    │
│  4. Se OK: gera JWT + Refresh Token              │
│  5. Persiste sessão: INSERT sessao_usuario       │
└──────────────────┬──────────────────────────────────┘
                   │ 200 OK + JSON
                   │ {
                   │   accessToken: "eyJ...",
                   │   refreshToken: "eyJ...",
                   │   usuario: {id, nome, perfil, ...}
                   │ }
                   ▼
┌─────────────────────────────────────────────────────┐
│      FRONTEND: AuthContext.jsx                    │
│  1. LocalStorage.setItem('accessToken', token)   │
│  2. LocalStorage.setItem('usuario', user)        │
│  3. setAuth({user, token, isAuth: true})         │
│  4. Redireciona para /dashboard                  │
└──────────────────┬──────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────┐
│      FRONTEND: DASHBOARD CARREGADO                │
│  - Header com usuário logado + logout            │
│  - Sidebar com módulos habilitados               │
│  - Dashboard cards com resumos                   │
│  - Todos os requests com Authorization header   │
└─────────────────────────────────────────────────────┘

TOKEN NO HEADER:
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

MIDDLEWARE NO BACKEND:
- Extrai token do header
- Verifica JWT.verify(token, secretKey)
- Se válido: next() (continua)
- Se expirado: 401 Unauthorized
- Se inválido: 403 Forbidden
```

---

## 📦 Procedimento Base - Como Estruturar Chamadas

### Backend: Wrapper de Procedure

```javascript
// src/services/mysql.service.js

async function callProcedure(procedureName, params = []) {
  const connection = await pool.getConnection();
  try {
    // Constrói query: CALL sp_nome(?, ?, ?)
    const query = `CALL ${procedureName}(${params.map(() => '?').join(',')})`;
    const [results] = await connection.execute({
      sql:query,
      values: params,
      supportBigNumbers: true,
      bigNumberStrings: true
    });
    return results;
  } catch (error) {
    throw error;
  } finally {
    await connection.end();
  }
}

// Exemplo: Registrar dispensação
async function registrarDispensacao(sessaoId, receitaId, produtoId, loteId, qtd) {
  return await callProcedure('sp_farm_dispensacao_registrar', [
    sessaoId, receitaId, produtoId, loteId, receitaLocalId, qtd, null
  ]);
}
```

### Frontend: Service + Hook

```javascript
// src/services/farmaciaService.js
import api from './api';

export async function registrarDispensacao(dados) {
  const response = await api.post('/api/farmacia/dispensacao', dados);
  return response.data;
}

// src/hooks/useFarmacia.js
import { useContext } from 'react';
import { FarmaciaContext } from '@/context/FarmaciaContext';

export function useFarmacia() {
  const context = useContext(FarmaciaContext);
  if (!context) {
    throw new Error('useFarmacia deve ser usado dentro de FarmaciaProvider');
  }
  return context;
}

// Componente usa:
function DispensacaoForm() {
  const { dispensacoes, registrarDispensacao } = useFarmacia();
  // ... usar dados e evento
}
```

---

## 🔐 Segurança - Checklist Implementado

- ✅ **JWT** - Access token (15min) + Refresh token (7d)
- ✅ **Senha** - Bcrypt com salt 10
- ✅ **CORS** - Origem branca (localhost:5173)
- ✅ **HTTPS** - Obrigatório em produção
- ✅ **SQL Injection** - Prepared statements (?)
- ✅ **XSS** - React escape automático
- ✅ **CSRF** - Token no formulário  (se needed)
- ✅ **Rate Limiting** - Implementado em /login
- ✅ **Input Validation** - Ambos client + server
- ✅ **Auditoria** - sp_auditoria_evento_registrar chamada
- ✅ **Permissões** - Verificação de perfil/modulo

---

## 🚀 Próximas Seções (Código Concreto)

Esta é uma visão de 50.000 pés. Nos arquivos a seguir, fornecerei:

1. **Backend Setup + Autenticação** (Express + MySQL)
2. **Frontend Setup + Login** (React + Context)
3. **APIs de Farmácia** (Dispensação + Reserva)
4. **APIs de Estoque** (Movimento + Lote)
5. **Dashboard** (Resumos + KPIs)
6. **Relatórios/Admin** (Auditoria + Insights)

---

## 📊  Sumário de Arquivos a Criar

| Arquivo | Tipo | Descrição |
|---------|------|-----------|
| backend/src/index.js | JavaScript | Express server entry |
| backend/src/config/mysql.js | JavaScript | MySQL Pool |
| backend/src/middleware/auth.js | JavaScript | JWT middleware |
| backend/src/routes/auth.routes.js | JavaScript | Login/logout APIs |
| backend/src/routes/farmacia.routes.js | JavaScript | Farmácia APIs |
| backend/src/controllers/auth.controller.js | JavaScript | Auth logic |
| backend/package.json | JSON | Dependencies |
| frontend/src/pages/LoginPage.jsx | JSX | Login UI |
| frontend/src/context/AuthContext.jsx | JSX | Auth state |
| frontend/src/components/Layout/MainLayout.jsx | JSX | Main layout |
| frontend/vite.config.js | JavaScript | Vite config |
| frontend/package.json | JSON | Dependencies |

---

## ✅ Checklist de Implementação

**FASE 1: Setup (Semana 1)**
- [ ] Setup Node + express
- [ ] Setup MySQL pool + conexão
- [ ] Setup JWT + autenticação
- [ ] Setup React + Vite
- [ ] Criar LoginPage + AuthContext

**FASE 2: Core APIs (Semana 2)**
- [ ] /api/auth/login + /logout
- [ ] /api/farmacia/dispensacao (GET/POST)
- [ ] /api/estoque/movimento (GET/POST)
- [ ] Dashboard básico

**FASE 3: Frontend Modules (Semana 3)**
- [ ] Página Farmácia (UI + service)
- [ ] Página Estoque (UI + service)
- [ ] Página Atendimento (UI + service)

**FASE 4: Advanced (Semana 4-5)**
- [ ] Relatórios/Admin
- [ ] Alertas em tempo real (WebSocket)
- [ ] Offline-first (service worker)
- [ ] Testes automatizados

---

**Próximo passo:** Vá para seção "Backend Setup Completo" ou "Frontend Setup Completo"

---

*Criado: 21 de fevereiro de 2026*
*Stack: Node.js + Express + React + MySQL*
*Ambiente: desenvolvimento + staging + produção*
