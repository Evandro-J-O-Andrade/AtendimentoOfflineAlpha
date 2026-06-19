# MD-003 — OperationalContext

## Status

Documento Canônico Fundacional.

Este documento define onde o usuário está operando.

---

## Objetivo

Definir o contexto operacional obrigatório para toda ação da plataforma.

---

## Composição

O contexto operacional é composto por:

```text
Tenant
Unidade
Local
Perfil
Sala
Painel
```

---

## Representação Canônica

```json
{
  "id_sessao_usuario": 0,
  "id_tenant": 0,
  "id_unidade": 0,
  "id_local": 0,
  "id_perfil": 0
}
```

---

## Regras

1. Nenhuma ação operacional pode ocorrer sem contexto ativo.
2. O contexto deve estar vinculado à sessão.
3. O contexto deve ser validado antes da execução.
4. O contexto deve ser auditado quando alterado.
5. O contexto não é identidade.
6. O contexto não substitui permissão.
7. O contexto não substitui tenant.
8. O contexto não substitui sessão.

---

## Fluxo

```text
Sessão
  ↓
Contextos disponíveis
  ↓
Seleção de contexto
  ↓
Contexto ativo
  ↓
Operação permitida
```

---

## Proibições

São proibidos:

```text
Operação sem contexto
Contexto hardcoded
Contexto armazenado apenas no frontend
Contexto paralelo por app
Contexto paralelo por domínio
```

---

## Lei

```text
Nenhuma ação operacional pode ocorrer sem contexto ativo.
```
