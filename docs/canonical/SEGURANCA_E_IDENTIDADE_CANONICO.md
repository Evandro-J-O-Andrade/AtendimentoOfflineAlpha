# SEGURANCA_E_IDENTIDADE_CANONICO.md

## Fluxo de Identidade

```
Login
↓
Portal
↓
Aplicações
↓
Contexto
↓
Dashboard
```

## Entidades de Segurança

| Entidade | Propósito |
|----------|-----------|
| **Pessoa** | Raiz - Identidade humana |
| **Usuario** | Credenciais de acesso |
| **Sessao** | Identidade operacional válida |
| **Perfil** | Papéis e permissões (RBAC) |
| **Contexto** | Escopo operacional (unidade, local) |

## Permissões (RBAC)

```sql
perfil (
    id_perfil PK,
    nome,
    codigo,
    descricao
)

permissao (
    id_permissao PK,
    id_perfil FK,
    recurso,
    acao
)
```

## Regras de Segurança

### Autenticação
- JWT com access (15min) e refresh (7d)
- bcrypt hash com salt 10
- Logout com invalidação de sessão

### Autorização
- Middleware verifica permissões por recurso
- Contexto obrigatório para operações
- Validação em cada requisição

### Auditoria
- Todo evento registrado
- IP de origem
- Timestamp preciso
- Dados antes/depois