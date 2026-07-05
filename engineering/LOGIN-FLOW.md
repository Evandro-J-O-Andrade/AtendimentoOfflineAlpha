# LOGIN FLOW - NEW WAVE Enterprise Platform

## Fluxo
```
LoginForm.tsx
    ↓
auth.service.ts
    ↓
MD-usuario → sp_usuario_login
    ↓
sessao.store.ts → armazena JWT
    ↓
ContextSelector.tsx (next)
```

## Componentes Necessários

### 1. LoginForm.tsx
- email/cpf
- senha
- botão submit
- validação client-side

### 2. auth.service.ts  
```ts
login(usuario, senha) → /api/login
validateSession() → /api/session
logout() → /api/logout
```

### 3. sessao.store.ts
```ts
{
  token: string,
  id_usuario: number,
  contexto_selecionado: null,
  isAuthenticated: boolean
}
```

## Próximo Passo
Implementar LoginForm com mock e conectar a ContextSelector