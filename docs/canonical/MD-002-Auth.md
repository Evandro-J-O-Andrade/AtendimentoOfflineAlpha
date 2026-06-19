# MD-002 — Auth

## Status

Documento Canônico Fundacional.

Este documento define a separação entre Identidade e Operação.

---

## Objetivo

Separar identidade de operação e garantir que autenticação, sessão, perfil, permissão e tenant pertençam exclusivamente ao núcleo canônico.

---

## Fluxo Obrigatório

```text
Login
  ↓
Sessão
  ↓
Contextos disponíveis
  ↓
Seleção de contexto
  ↓
Portal
```

---

## Responsabilidades do Auth

Auth é responsável por:

```text
Identidade
Sessão
Permissões
Perfis
Tenant
```

---

## Não Responsabilidades do Auth

Auth não é responsável por:

```text
Fila
Paciente
Farmácia
Triagem
Atendimento
Estoque
Faturamento
Auditoria operacional
Workflow assistencial
```

---

## Regras

1. Login cria ou valida sessão.
2. Sessão representa identidade operacional.
3. Tenant representa propriedade dos dados.
4. Contexto operacional deve ser selecionado antes de operações.
5. Perfil e permissão devem ser validados antes da execução.
6. Auth não executa regra de negócio assistencial.
7. Auth não possui dispatcher próprio.
8. Auth não possui auditoria própria fora do Event Store canônico.

---

## Proibições

São proibidos:

```text
Login direto para módulo assistencial
Auth próprio por domínio
Sessão própria por app
Perfil próprio por app
Permissão própria por app
Tenant próprio por app
```

---

## Lei

```text
Identidade não é contexto operacional.
```
