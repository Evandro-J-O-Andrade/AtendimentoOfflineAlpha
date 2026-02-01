# 🏥 LoginPage - Página de Autenticação Premium

## 📋 Overview

A página de login foi redesenhada com design moderno, profissional e responsivo, seguindo a identidade visual do sistema **ALPHA Atendimento Offline**.

### Características Principais

✅ **Design Premium**
- Layout em 2 colunas (desktop) / 1 coluna (mobile)
- Gradiente roxo/rosa com animações suaves
- Logo ALPHA integrado com branding corporativo
- Fundo animado com shapes flutuantes

✅ **Interface Intuitiva**
- Ícones representativos em labels
- Campo de senha com toggle de visibilidade
- Checkbox "Lembrar-me"
- Mensagens de erro claras e visuais

✅ **Responsividade Completa**
- Desktop (1200px+): 2 colunas lado a lado
- Tablet (1024px - 768px): Ajustes de padding
- Mobile (480px - 768px): 1 coluna full-width
- Ultra-mobile (<480px): Layout otimizado

✅ **Animações e Feedback**
- Entrada suave do container (slideIn)
- Logo com efeito bounceIn
- Features com delay sequencial
- Loading spinner no botão de envio
- Estados desabilitados durante carregamento

---

## 📁 Estrutura de Arquivos

```
src/
├── pages/
│   └── login/
│       ├── LoginPage.jsx       ← Componente principal
│       └── LoginPage.css       ← Estilos (850+ linhas)
└── routes/
    └── Routes.jsx              ← Configuração de rotas
```

---

## 🎨 Design System

### Cores

| Uso | Cor | Valor | Notas |
|-----|-----|-------|-------|
| Gradiente Principal | Roxo → Rosa | `#667eea → #f093fb` | Primário para login |
| Background Right | Cinza Claro | `#f8f9fa` | Lado do formulário |
| Texto Principal | Azul Escuro | `#2c3e50` | Labels e headings |
| Texto Secundário | Cinza | `#7f8c8d` | Subtextos |
| Accent/Focus | Roxo | `#667eea` | Inputs em foco |
| Erro | Vermelho | `#c0392b` | Alert de erro |

### Tipografia

- **Font**: Segoe UI, Tahoma, Geneva, Verdana (sans-serif)
- **Headings**: 700 weight (bold)
- **Body**: 400 weight (regular)
- **Sizes**: 12px → 36px (fluído por viewport)

### Espaçamento

- **Padding Padrão**: 24px (mobile) → 60px (desktop)
- **Gaps**: 8px (labels) → 24px (formulário)
- **Border Radius**: 8px (inputs) → 20px (container)

---

## 🧩 Componentes

### Seção Esquerda (login-left)
Contém branding, informações e features

```jsx
<div className="login-left">
  {/* Logo ALPHA */}
  <div className="alpha-logo">
    <div className="logo-icon">🏥</div>
    <div className="logo-text">
      <h1>ALPHA</h1>
      <p>Atendimento Offline</p>
    </div>
  </div>

  {/* Informações */}
  <div className="login-info">
    <h2>Bem-vindo ao Sistema</h2>
    <p>Descrição...</p>
    <div className="info-features">
      {/* 3 Features com ícones */}
    </div>
  </div>

  {/* Footer */}
  <div className="login-footer">© 2026</div>
</div>
```

### Seção Direita (login-right)
Contém o formulário de login

```jsx
<div className="login-right">
  <div className="login-form-container">
    <h2>Faça Login</h2>
    <form className="login-form">
      {/* Usuário */}
      <div className="form-group">
        <label>👤 Usuário</label>
        <input type="text" />
      </div>

      {/* Senha */}
      <div className="form-group">
        <label>🔐 Senha</label>
        <div className="input-group">
          <input type="password" />
          <button className="btn-toggle-senha">👁️</button>
        </div>
      </div>

      {/* Checkbox */}
      <div className="form-checkbox">
        <input type="checkbox" />
        <label>Lembrar-me</label>
      </div>

      {/* Botão */}
      <button className="btn-login">🔓 Entrar</button>

      {/* Links */}
      <div className="login-links">
        <a href="#">Esqueci a senha</a>
        <span>•</span>
        <a href="#">Suporte</a>
      </div>
    </form>

    {/* Credenciais Teste */}
    <div className="login-test-info">
      <strong>🧪 Teste:</strong>
      <code>admin / admin</code>
    </div>
  </div>
</div>
```

---

## 💻 Funcionalidades JavaScript

### Estados

```javascript
const [credenciais, setCredenciais] = useState({
  usuario: '',
  senha: '',
});
const [carregando, setCarregando] = useState(false);
const [erro, setErro] = useState('');
const [mostrarSenha, setMostrarSenha] = useState(false);
```

### Handlers

**handleChange**: Atualiza estado e limpa erro ao digitar

```javascript
const handleChange = (e) => {
  const { name, value } = e.target;
  setCredenciais({ ...credenciais, [name]: value });
  if (erro) setErro('');
};
```

**handleSubmit**: Valida e faz login

```javascript
const handleSubmit = async (e) => {
  e.preventDefault();
  setCarregando(true);
  setErro('');

  if (!credenciais.usuario || !credenciais.senha) {
    setErro('Preencha usuário e senha');
    setCarregando(false);
    return;
  }

  await new Promise(resolve => setTimeout(resolve, 1500));

  if (credenciais.usuario === 'admin' && credenciais.senha === 'admin') {
    localStorage.setItem('usuario_logado', credenciais.usuario);
    navigate('/recepcao');
  } else {
    setErro('Usuário ou senha inválidos');
  }
};
```

---

## 🎬 Animações

### slideIn
Container entra suavemente de cima

```css
@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
```

### bounceIn
Logo entra com efeito de bounce

```css
@keyframes bounceIn {
  0% {
    opacity: 0;
    transform: scale(0.8);
  }
  100% {
    opacity: 1;
    transform: scale(1);
  }
}
```

### float
Shapes de fundo flutuam continuamente

```css
@keyframes float {
  0%, 100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(30px);
  }
}
```

### slideInLeft/slideInRight
Features e formulário entram de seus lados

```css
@keyframes slideInLeft {
  from {
    opacity: 0;
    transform: translateX(-20px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

@keyframes slideInRight {
  from {
    opacity: 0;
    transform: translateX(20px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}
```

### spin
Spinner do botão loading

```css
@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}
```

---

## 📱 Responsividade

### Desktop (1200px+)
- Grid 2 colunas (1fr 1fr)
- Padding: 60px
- Layout lado a lado

### Tablet (1024px - 768px)
- Grid 2 colunas (ajustes)
- Padding: 40px
- Reduz margin-bottom

### Mobile (768px - 480px)
- Grid 1 coluna
- Padding: 30px
- Full-width com scroll

### Ultra-Mobile (<480px)
- 1 coluna
- Padding: 24px
- Font sizes reduzidas
- Buttons menores

---

## 🔗 Integração

### 1. Importar LoginPage em App.jsx

```jsx
import LoginPage from './pages/login/LoginPage';
```

### 2. Configurar Rota

```jsx
<Route 
  path="/login" 
  element={usuario ? <Navigate to="/recepcao" /> : <LoginPage />}
/>
```

### 3. PrivateRoute redireciona para login

```jsx
// Se não autenticado, redireciona para /login
<PrivateRoute>
  <RecepcaoLayout />
</PrivateRoute>
```

---

## 🧪 Credenciais de Teste

```
Usuário: admin
Senha: admin
```

Exibidas na seção "🧪 Credenciais de Teste" no formulário para facilitar testes.

---

## 🔐 Segurança (Implementar em Produção)

### Atualmente (MVP)
- Login simulado com timeout de 1.5s
- Credenciais hardcoded no frontend (apenas para teste)
- Token fake em localStorage

### Para Produção
1. **Backend de Autenticação**
   - Endpoint: `POST /api/auth/login`
   - Request: `{ usuario, senha }`
   - Response: `{ ok: true, data: { token, usuario, perfis } }`
   - Hash bcrypt de senhas no BD

2. **JWT Token Management**
   - Armazenar token seguro (HttpOnly cookie)
   - Refresh token para renovação
   - Logout limpa token

3. **API Interceptor**
   - Adiciona header: `Authorization: Bearer {token}`
   - Redireciona para login se token inválido

4. **2FA (Optional)**
   - SMS/Email
   - Authenticator app

---

## 📋 Checklist de Customização

- [ ] Trocar logo emoji (🏥) por imagem SVG/PNG
- [ ] Adicionar cores da marca corporativa
- [ ] Trocar textos genéricos
- [ ] Implementar backend de auth real
- [ ] Adicionar validações de senha forte
- [ ] Setup de "Esqueci a senha"
- [ ] Setup de suporte/contato
- [ ] Teste em dispositivos reais
- [ ] Verificar acessibilidade (WCAG)
- [ ] Otimizar images se necessário

---

## 🚀 Próximos Passos

1. **Routing Completo**
   - Criar arquivo `routes/Routes.jsx`
   - Integrar com App.jsx
   - Testar navegação

2. **Autenticação Real**
   - Conectar com backend PHP
   - Implementar JWT
   - Logout functionality

3. **Additional Pages**
   - Triagem (TriagemLayout.jsx)
   - Farmácia, SAMU, etc.

4. **WebSocket Real-time**
   - Atualização de filas
   - Notificações de urgência

---

## 📞 Suporte

Para dúvidas sobre a implementação, consulte:
- `docs/ARQUITETURA_E_PROGRESSO.md`
- `docs/SISTEMA_PRONTO.md`
- Code comments no próprio componente

---

**Desenvolvido com ❤️ para ALPHA Atendimento Offline**
