# 🏥 Pronto Atendimento - Sistema de Gestão Integrado
## Full Stack (Frontend + Backend)

---

## 📋 Visão Geral

Sistema web completo de gestão integrada para clínicas/hospitais com funcionalidades de:

- ✅ **Autenticação** - Login com JWT + refresh token
- ✅ **Farmácia** - Dispensações e reservas de medicamentos
- ✅ **Estoque** - Movimentos append-only e saldo de lotes
- ✅ **Atendimento** - Ficha de atendimento (FFA)
- ✅ **Auditoria** - Rastreamento de todas as operações
- ✅ **Admin** - Gestão de usuários, relatórios e manutenção

---

## 🏗️ Arquitetura

```
┌─────────────────────────────────────────────────────┐
│                Frontend (React/Vite)                │
│  http://localhost:5173                              │
│  ├── LoginPage (email + senha)                      │
│  ├── DashboardPage (visão geral)                    │
│  ├── FarmaciaPage (dispensações)                    │
│  ├── EstoquePage (lotes + movimentos)               │
│  ├── AtendimentoPage (FFAs)                         │
│  └── AdminPages (usuários, auditoria, etc)          │
└────────────────────┬────────────────────────────────┘
                     │ Axios + JWT
                     ▼
┌─────────────────────────────────────────────────────┐
│             Backend (Node/Express)                  │
│  http://localhost:3000                              │
│  ├── /api/auth (login, logout, refresh)             │
│  ├── /api/farmacia (dispensações, reservas)         │
│  ├── /api/estoque (saldo, movimentos, lotes)        │
│  ├── /api/atendimento (FFAs)                        │
│  └── /api/admin (usuários, relatórios)              │
└────────────────────┬────────────────────────────────┘
                     │ MySQL2/Promise
                     ▼
┌─────────────────────────────────────────────────────┐
│         MySQL 8.0 (pronto_atendimento)              │
│  ├── 122 tabelas                                    │
│  ├── 80+ procedures canônicas                       │
│  ├── Append-only para auditoria                     │
│  └── Dupla-baixa para controle                      │
└─────────────────────────────────────────────────────┘
```

---

## ⚡ Quick Start

### 1. **Clone e Configure**

```bash
# Windows (PowerShell)
.\setup.ps1

# Linux/Mac
chmod +x setup.sh
./setup.sh
```

Isso instala dependências e cria arquivos `.env`.

### 2. **Configure Banco de Dados**

Editar `backend/.env`:
```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=seu_usuario
DB_PASSWORD=sua_senha
DB_DATABASE=pronto_atendimento
JWT_SECRET=sua_chave_secreta_aqui
```

**Certifique-se de:**
- ✅ MySQL está rodando
- ✅ Banco `pronto_atendimento` existe
- ✅ Dump SQL foi importado

### 3. **Inicie o Sistema**

**Terminal 1 - Backend:**
```bash
cd backend
npm start
# Resposta esperada: "Express running on port 3000"
```

**Terminal 2 - Frontend:**
```bash
cd frontend  
npm run dev
# Resposta esperada: "http://localhost:5173"
```

### 4. **Acesse a Aplicação**

- **URL:** http://localhost:5173
- **Login:** Use credenciais do banco (tabela `usuario`)
- **Senha:** Armazenada como hash bcrypt (salt 10)

---

## 📁 Estrutura do Projeto

```
atendimentoofflineAlpha/
├── backend/                          # Node.js + Express
│   ├── src/
│   │   ├── config/                  # MySQL pool, JWT config
│   │   ├── middleware/              # Auth, error handling
│   │   ├── controllers/             # auth, farmacia, estoque
│   │   ├── routes/                  # /api/auth, /api/farmacia, etc
│   │   └── index.js                 # Entry point (port 3000)
│   ├── .env.example                 # Template variáveis
│   ├── package.json                 # Dependências
│   └── README.md
│
├── frontend/                         # React + Vite
│   ├── src/
│   │   ├── components/              # Header, Sidebar, Layout
│   │   ├── pages/                   # Login, Dashboard, Farmacia, etc
│   │   ├── context/                 # AuthContext (estado global)
│   │   ├── hooks/                   # useAuth, useFarmacia, etc
│   │   ├── services/                # api.js (axios + interceptors)
│   │   ├── App.jsx                  # React Router setup
│   │   ├── main.jsx                 # Entry point
│   │   └── index.css                # TailwindCSS + estilos globais
│   ├── index.html                   # HTML root
│   ├── vite.config.js               # Vite config
│   ├── tailwind.config.js           # TailwindCSS config
│   ├── .env.example                 # Template variáveis
│   ├── package.json                 # Dependências
│   └── README.md
│
├── docs/                             # Documentação
│   ├── ARQUITETURA_FRONTEND.md
│   ├── MAPA_BANCO_DADOS_COMPLETO.md # 122 tabelas documentadas
│   ├── REFERENCIA_TECNICA_PROCEDURES.md # 80+ procedures
│   └── ...
│
├── scripts/                          # SQL scripts
│   ├── Dump20260*.sql               # Backups
│   ├── functions.sql                # Funções MySQL
│   ├── procedures.sql               # Procedures iniciais
│   └── ...
│
├── setup.ps1                         # Setup script (Windows)
├── setup.sh                          # Setup script (Linux/Mac)
└── README.md                         # Este arquivo
```

---

## 🔐 Autenticação

### Fluxo de Login

1. Usuário entra email + senha em `/login`
2. Frontend envia `POST /api/auth/login`
3. Backend:
   - Busca usuário por email
   - Compara senha com `bcrypt.compare()`
   - Gera `accessToken` (15 min) e `refreshToken` (7 dias)
   - Retorna tokens + dados do usuário
4. Frontend:
   - Salva tokens em `localStorage`
   - Define `Authorization: Bearer <accessToken>`
   - Redireciona para `/dashboard`

### Proteção de Rotas

- `/login` - Público
- `/dashboard`, `/farmacia`, `/estoque`, etc - **Protegido** (requer JWT)
- `/admin/*` - **Admin only** (requer JWT + role admin)

Se não autenticado, redireciona para `/login`.

### Refresh Token Automático

Interceptor Axios automático:
1. Se requisição retorna status 401 + "TOKEN_EXPIRED"
2. Tenta renovar com `POST /api/auth/refresh`
3. Se sucesso, retenta requisição original
4. Se falha, redireciona para login

---

## 📡 API Endpoints

### PUBLIC
```
POST   /api/auth/login              # { email, senha } → { accessToken, refreshToken, usuario }
POST   /api/auth/logout             # Fecha sessão
POST   /api/auth/refresh            # { refreshToken } → { accessToken }
GET    /api/auth/me                 # Retorna usuário logado (requer JWT)
```

### PROTECTED (Requer JWT Header: Authorization: Bearer <token>)
```
GET    /api/farmacia/dispensacoes   # Lista dispensações
POST   /api/farmacia/dispensacao    # { id_receita, id_produto, id_lote, qtd }
GET    /api/farmacia/reservas       # Lista reservas ativas
POST   /api/farmacia/confirmar-reserva # { id_reserva, id_usuario_confirmador }

GET    /api/estoque/saldo           # Lista lotes com quantidades
GET    /api/estoque/movimentos      # Lista movimentos (append-only)
POST   /api/estoque/movimento       # { tipo, id_produto, id_lote, qtd }
GET    /api/estoque/lotes/:id       # Lista lotes de um produto
```

Todos retornam `{ success, data, error }` em JSON.

---

## 🗄️ Database

### Tabelas Principais

| Tabela | Descrição |
|--------|-----------|
| `usuario` | Usuários do sistema (email, senha_hash, id_perfil) |
| `farm_dispensacao` | Dispensações registradas |
| `estoque_lote` | Lotes de produtos (snapshot saldo) |
| `estoque_movimento` | Registros de entrada/saída (append-only) |
| `estoque_movimento_item` | Itens dos movimentos |
| `estoque_reserva` | Reservas de produtos |
| `ffa` | Ficha de atendimento |
| `auditoria` | Log de todas as operações |

### Procedures Implementadas

**Autenticação:**
- `sp_sessao_abrir()` - Abre sessão ao login
- `sp_sessao_fechar()` - Fecha sessão ao logout

**Farmácia:**
- `sp_farm_dispensacao_registrar()` - Registra dispensação
- `sp_farm_reserva_confirmar()` - Confirma reserva

**Estoque:**
- `sp_estoque_movimento_registrar()` - Movimento append-only
- `sp_estoque_saldo_atualizar()` - Atualiza snapshot quantidade

Ver documentação completa em `docs/REFERENCIA_TECNICA_PROCEDURES.md`.

---

## 🛠️ Stack Tecnológico

### Backend
- **Runtime:** Node.js 18+
- **Framework:** Express 4.x
- **Database:** MySQL 8.0 + mysql2/promise
- **Autenticação:** JWT (jsonwebtoken) + bcryptjs
- **Dependências:** cors, dotenv, uuid
- **Port:** 3000

### Frontend
- **Framework:** React 18+
- **Build:** Vite 4
- **Routing:** React Router v6
- **HTTP Client:** Axios
- **CSS:** TailwindCSS
- **Icons:** Lucide React
- **State:** Context API + useReducer
- **Port:** 5173

---

## 🚀 Deployment

### Backend (Node.js)

```bash
# Build
npm install --production

# Run
npm start
# Ou com PM2:
pm2 start src/index.js --name pronto-backend
```

**Variáveis de ambiente recomendadas:**
```env
NODE_ENV=production
DB_HOST=seu-rds-endpoint
DB_USER=seu-usuario
DB_PASSWORD=sua-senha
DB_DATABASE=pronto_atendimento
JWT_SECRET=sua_chave_longa_segura_aqui
BCRYPT_ROUNDS=10
CORS_ORIGIN=seu-frontend.com
PORT=3000
```

### Frontend (React/Vite)

```bash
# Build
npm run build
# Output em dist/

# Deploy
# Copiar dist/* para seu servidor web (Nginx, Apache, etc)
# Ou hospedar em Vercel, Netlify, etc
```

**Variáveis de ambiente recomendadas:**
```env
VITE_API_URL=https://api.seu-dominio.com
VITE_APP_NAME=Pronto Atendimento
VITE_ENABLE_OFFLINE_MODE=true
```

---

## 📊 Monitoramento & Logs

### Backend

Logs em console com timestamp:
```javascript
[2025-02-14 14:23:45] POST /api/auth/login 200 OK
[2025-02-14 14:23:46] GET /api/farmacia/dispensacoes 200 3 items
[2025-02-14 14:23:47] POST /api/estoque/movimento 201 Created
```

Erros aparecem como:
```javascript
[ERROR] SQLSTATE: 45000 - Custom error message
```

### Frontend

Console do browser (F12):
- Requisições Axios (com timestamps)
- Erros de parsing de token
- Warnings de React (development mode)

---

## ✅ Checklist de Primeira Execução

- [ ] Node.js 18+ instalado
- [ ] MySQL rodando
- [ ] Banco `pronto_atendimento` criado
- [ ] Dump SQL importado
- [ ] `backend/.env` configurado com credenciais MySQL
- [ ] `backend` dependencies instaladas (`npm install`)
- [ ] `frontend` dependencies instaladas (`npm install`)
- [ ] Backend inicia sem erros (`npm start`)
- [ ] Frontend inicia sem erros (`npm run dev`)
- [ ] Acesso http://localhost:5173 funciona
- [ ] Login funciona com credenciais do banco
- [ ] Dashboard carrega sem erros
- [ ] Farmácia consegue listar dispensações
- [ ] Estoque consegue listar lotes

---

## 🐛 Troubleshooting

### Erro: "Cannot connect to database"
- Verifique se MySQL está rodando
- Verifique credenciais em `backend/.env`
- Verifique se banco `pronto_atendimento` existe

### Erro: "CORS error"
- Verifique CORS_ORIGIN em `backend/.env`
- Para desenvolvimento: `CORS_ORIGIN=http://localhost:5173`

### Erro: "Invalid token"
- Limpe localStorage no browser (F12 → Application → Clear Site Data)
- Faça login novamente

### Frontend mostra tela branca
- Abra console do browser (F12)
- Procure por erros de React
- Verifique se backend está respondendo
- Verifice network tab para requisições falhadas

### Senha pré-existente do banco não funciona
- Senhas estão salvas como hash bcrypt
- Não é possível fazer login diretamente
- Você precisa resetar a senha no banco com hash novo:
```sql
UPDATE usuario SET senha_hash = '$2a$10$...' WHERE id = 1;
```
Ou criar novo usuário com senha hash válida.

---

## 📚 Documentação Adicional

- [Frontend README](./frontend/README.md) - Como usar frontend
- [Backend setup](./backend/README.md) - Como usar backend
- [Mapa do Banco de Dados](./docs/MAPA_BANCO_DADOS_COMPLETO.md) - 122 tabelas explicadas
- [Referência de Procedures](./docs/REFERENCIA_TECNICA_PROCEDURES.md) - 80+ procedures
- [Arquitetura Frontend](./docs/ARQUITETURA_FRONTEND.md) - Estrutura React
- [Stack de Desenvolvimento](./docs/STACK_FRONTEND_BACKEND.md) - Visão técnica completa

---

## 🤝 Contribuindo

Ao adicionar novas features:

1. **Backend:**
   - Criar route em `backend/src/routes/`
   - Criar controller em `backend/src/controllers/`
   - Adicionar procedure no banco se necessário
   - Testar com Postman/Insomnia

2. **Frontend:**
   - Criar page em `frontend/src/pages/`
   - Criar componente em `frontend/src/components/`
   - Criar service em `frontend/src/services/`
   - Consumir com hooks customizados

3. **Documentação:**
   - Atualizar README
   - Documentar novos endpoints
   - Documentar novas tabelas/procedures

---

## 📞 Suporte

Para dúvidas ou problemas:
1. Verifique a seção Troubleshooting
2. Consulte documentação nos `/docs`
3. Verifique logs no backend e frontend
4. Entre em contato com o time de desenvolvimento

---

## 📄 Licença

MIT

---

**Última atualização:** 2025-02-14  
**Versão:** 1.0.0  
**Status:** Em desenvolvimento
