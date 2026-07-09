# CATÁLOGO-DA-PLATAFORMA

## Propósito

Inventário oficial de todos os artefatos canônicos da plataforma.

## Formato

Cada artefato possui identificador único:

```
CAT-001  Tabela    usuario
CAT-002  Procedure  sp_auth_login
CAT-003  View       vw_usuario
CAT-004  API        /auth/login
CAT-005  Contract   PermissionContract
```

## Regras

- Nenhum artefato novo entra no ecossistema sem CAT-
- Nenhum CAT- é removido sem registro de obsoleto
- Cada CAT- deve possuir: nome, tipo, camada, status, dependências, documentação

## Atualização

Atualizada pelo arquiteto após inclusão/remoção/alteração de artefato.
