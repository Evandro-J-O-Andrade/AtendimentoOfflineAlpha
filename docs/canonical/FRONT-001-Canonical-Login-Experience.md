# FRONT-001 — Canonical Login Experience

## Status

Documento Canônico de Frontend.
Define a experiência de autenticação única da plataforma.

---

## Objetivo

Garantir que o login seja seguro, rápido e a porta de entrada canônica para todo o ecossistema.

---

## Princípio Fundamental

```text
Login não é uma tela.
Login é a primeira impressão da plataforma.
Login é identidade, não contexto.
Após login, o usuário ancora no Portal.
```

---

## Fluxo Canônico

```
Usuário acessa plataforma
  ↓
Login (este documento)
  ↓
Validação de credenciais (IAM)
  ↓
Sessão criada (JWT HttpOnly + Refresh Token)
  ↓
Redirecionamento para Context Selection (FRONT-002)
  ↓
Contexto selecionado
  ↓
Portal Corporativo (FRONT-003)
```

---

## Componentes

### LoginForm

```text
Campo de usuário (login/email)
Campo de senha
Botão de login
Checkbox "Lembrar dispositivo"
Link "Esqueceu a senha?"
Indicador de carregamento
Tratamento de erro canônico
```

### SocialLogin (opcional por tenant)

```text
Google
Microsoft
GitHub (para desenvolvedores)
SSO corporativo
```

### ForgotPassword

```text
Solicitação de recuperação
Envio por email/SMS
Validação de token
Reintegração de sessão
```

### SecurityBanner

```text
Indicador de conexão segura (HTTPS)
Informação de SSO ativo
Aviso de ambiente (producao/staging)
Último acesso (se dispositivo confiável)
```

### DeviceTrust

```text
Dispositivo confiável = login sem MFA
Dispositivo novo = MFA obrigatório
Opção "Confiar neste dispositivo por 30 dias"
Revogação de dispositivo por usuário
```

---

## Regras de Segurança

### Obrigatório

```text
JWT armazenado em HttpOnly Cookie
Refresh Token em HttpOnly Cookie separado
CSRF Token em header/cookie
CSP (Content Security Policy) rigorosa
XSS Protection (sanitização de input)
HTTPS obrigatório (TLS 1.2+)
CORS restrito a domínios confiáveis
Tax limit na rota de login (anti-brute-force)
Auditoria de todo login (sucesso e falha)
Log de dispositivo (fingerprint, IP, user-agent)
```

### Proibido

```text
Token em localStorage
Token em sessionStorage
Token em variável global JavaScript
Senha armazenada em cache
Senha no autocomplete sem consentimento
Dados sensíveis no console
Dados sensíveis no URL
Dados sensíveis no estado global exposto
Hardcoded credenciais
Fallback inseguro (HTTP em produção)
```

### Google Security Layer

```text
Validação de reCAPTCHA quando suspeito
Login por geolocalização incomum = bloqueio temporário
Login por dispositivo novo = MFA obrigatório
Notificação por email/SMS para novo dispositivo
Bloqueio automático após N tentativas falhas
Allow-list de IPs para tenants Enterprise (opcional)
```

---

## Estados da Tela

| Estado | Comportamento |
|--------|---------------|
| Idle | Formulário visível, campos habilitados |
| Loading | Botão desabilitado, spinner, sem requisição duplicada |
| Success | Redirecionamento imediato para Context Selection |
| Error | Mensagem genérica ("Credenciais inválidas"), log detalhado no backend |
| Blocked | "Conta bloqueada. Contate o administrador." |
| MFARequired | Tela de MFA (token SMS/email/app) antes de prosseguir |
| PasswordExpired | Redirecionamento para troca de senha obrigatória |

---

## Integrações

| MD | Finalidade |
|----|-----------|
| MD-034 — Identity Access Management | Auth, permissão, contexto |
| MD-035 — Security Trust Architecture | Segurança, criptografia, audit |
| MD-036 — Mobile PWA Architecture | Responsividade, PWA |
| MD-101 — Canonical Data Architecture | Fonte da verdade: sessão no banco |
| MD-102 — SP First Architecture | SP de autenticação |
| MD-103 — Dispatcher Execution Model | Fluxo de execução canônico |
| MD-107 — Tenant Architecture | Tenant ativo, branding |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-002 — Context Selection Experience | Próxima tela após login |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | Exibir formulário, capturar input, chamar API, tratar estados |
| Backend | Validar credenciais, criar sessão, emitir JWT, registrar evento |
| Dispatcher | Roteamento para SP de auth |
| SP | Validar senha (hash bcrypt), criar sessão, registrar auditoria |
| Event Store | Registrar LOGIN_SUCESSO ou LOGIN_FALHA |

---

## Métricas

```text
Taxa de sucesso de login
Tempo médio de login (P95)
Taxa de MFA solicitado
Taxa de bloqueio por brute-force
Taxa de recuperação de senha
Dispositivos confiáveis vs. não confiáveis
Logins por tenant, por dia
Erros de autenticação por motivo
```

---

## Lei

```text
Autenticação é identidade.
Autenticação não define contexto.
Após login, o usuário ancora no Portal.
A sessão é o contrato entre usuário e plataforma.
```

---

## Próximo

```text
FRONT-001 completo
  ↓
FRONT-002 — Context Selection Experience
```
