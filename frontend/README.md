# Pronto Atendimento - Frontend

Frontend React para o sistema de gestão integrado Pronto Atendimento.

## 🚀 Tecnologias

- **React 18** - Framework UI
- **Vite 4** - Build tool moderno e rápido
- **React Router v6** - Roteamento
- **Axios** - Requisições HTTP
- **TailwindCSS** - Estilização
- **Lucide React** - Ícones
- **Context API** - Gerenciamento de estado

## 📋 Pré-requisitos

- Node.js 18+
- npm ou yarn
- Backend rodando em `http://localhost:3000`

## ⚙️ Configuração

### 1. Instalar Dependências

```bash
npm install
```

### 2. Configurar Variáveis de Ambiente

```bash
cp .env.example .env.local
```

Edite `.env.local` conforme necessário:

```env
VITE_API_URL=http://localhost:3000/api
VITE_APP_NAME=Pronto Atendimento
VITE_ENABLE_OFFLINE_MODE=false
```

### 3. Iniciar Servidor de Desenvolvimento

```bash
npm run dev
```

A aplicação estará disponível em `http://localhost:5173`

## 📁 Estrutura de Pasta

```
frontend/
├── src/
│   ├── components/           # Componentes React reutilizáveis
│   │   ├── Header/          # Header da aplicação
│   │   ├── Sidebar/         # Barra lateral de navegação
│   │   ├── Layout/          # Layouts principais
│   │   └── ...
│   ├── pages/               # Páginas da aplicação
│   │   ├── LoginPage.jsx
│   │   ├── DashboardPage.jsx
│   │   ├── FarmaciaPage.jsx
│   │   ├── EstoquePage.jsx
│   │   ├── admin/
│   │   └── ...
│   ├── hooks/               # Hooks customizados
│   │   └── useAuth.js
│   ├── context/             # Contextos (state management)
│   │   └── AuthContext.jsx
│   ├── services/            # Serviços API
│   │   └── api.js           # Axios instance com interceptors
│   ├── App.jsx              # Componente raiz com rotas
│   ├── main.jsx             # Entry point React
│   └── index.css            # Estilos globais
├── index.html               # HTML root
├── vite.config.js          # Configuração Vite
├── tailwind.config.js      # Configuração TailwindCSS
├── postcss.config.js       # Configuração PostCSS
├── .env.example            # Template de variáveis ambiente
└── package.json            # Dependências do projeto
```

## 🔐 Autenticação

### Fluxo de Login

1. Usuário acessa `/login`
2. Preenche email e senha
3. Frontend envia POST `/api/auth/login`
4. Backend retorna `accessToken` e `refreshToken`
5. Tokens são salvos no `localStorage`
6. Usuário é redirecionado para `/dashboard`

### JWT Interceptor

Todos os requests subsequentes incluem o token JWT:

```javascript
Authorization: Bearer <accessToken>
```

Se o token expirar, o interceptor:
1. Tenta renovar usando `refreshToken`
2. Se sucesso, retenta o request original
3. Se falha, faz logout automático

## 📡 API Integration

### Services Disponíveis

- `api.js` - Axios instance com interceptors JWT
- `authService.js` - Login, logout, refresh (via AuthContext)
- `farmaciaService.js` - Dispensações e reservas
- `estoqueService.js` - Lotes e movimentos

### Exemplo de Requisição

```javascript
import api from '../services/api';

// GET
const response = await api.get('/farmacia/dispensacoes');

// POST
const response = await api.post('/farmacia/dispensacao', {
  id_receita: 1,
  id_produto: 5,
  id_lote: 10,
  qtd: 2
});
```

## 🎨 Componentes

### Layout Principal

```jsx
import MainLayout from '../components/Layout/MainLayout';

<MainLayout>
  <YourPage />
</MainLayout>
```

### Header

Exibe informações do usuário e botão de logout (automático no MainLayout)

### Sidebar

Navegação por módulos conforme perfil do usuário (automático no MainLayout)

## 🧪 Desenvolvimento

### Build para Produção

```bash
npm run build
```

Arquivos compilados em `dist/`

### Preview de Build

```bash
npm run preview
```

## 🔄 Rotas da Aplicação

| Rota | Componente | Proteção |
|------|-----------|----------|
| `/login` | LoginPage | Público |
| `/dashboard` | DashboardPage | Protegido |
| `/farmacia` | FarmaciaPage | Protegido |
| `/estoque` | EstoquePage | Protegido |
| `/atendimento` | AtendimentoPage | Protegido |
| `/faturamento` | FaturamentoPage | Protegido |
| `/relatorios` | RelatoriosPage | Protegido |
| `/perfil` | PerfilPage | Protegido |
| `/admin/usuarios` | UsuariosPage | Admin only |
| `/admin/auditoria` | AuditoriaPage | Admin only |
| `/admin/manutencao` | ManutencaoPage | Admin only |
| `/admin/configuracoes` | ConfiguracoesPage | Admin only |

## 🚨 Troubleshooting

### Erro de Conexão com Backend

1. Verifique se backend está rodando em `http://localhost:3000`
2. Verifique `VITE_API_URL` em `.env.local`
3. Verifique CORS no backend

### Token Expirado

O sistema tenta renovar automaticamente. Se falhar, usuário é redirecionado para login.

### Login não funciona

1. Verifique credenciais no banco de dados
2. Verifique se backend está respondendo em `/api/auth/login`
3. Verifique logs do backend

## 📚 Documentação

Veja também:
- [Backend README](../backend/README.md)
- [Documentação da Arquitetura](../docs/ARQUITETURA_FRONTEND.md)
- [Guia de Desenvolvimento](../docs/DESENVOLVIMENTO_QUICK_START.md)

## 📝 Licença

MIT

## 🤝 Suporte

Para dúvidas ou issues, entre em contato com o time de desenvolvimento.
