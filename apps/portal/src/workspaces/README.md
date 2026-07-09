# LEGACY PLACEHOLDER

## Status

Esta estrutura **não representa a arquitetura canônica** do projeto.

Ela existe apenas como scaffolding temporário e será substituída.

## Motivo

Os diretórios abaixo representam **perfis de acesso** (roles), não **produtos/apps**:

```text
administrador/
farmacia/
financeiro/
medico/
operador/
paciente/
recepcao/
ti/
```

Na arquitetura Enterprise SaaS, o fluxo correto é:

```text
Portal
    ↓
Contexto
    ↓
Aplicações
    ↓
Permissões
```

e **não**:

```text
Portal
    ↓
Workspace por cargo
```

## Futura substituição

Esta estrutura será eliminada e substituída por:

- **Application Registry** — registro dinâmico de aplicações via metadata
- **Permission Resolver** — resolução de permissões por contexto/pessoa
- **Metadata Driven Layout** — layouts específicos por perfil definidos em metadata, não em diretórios físicos

## Regra

Nenhum código novo deve ser adicionado nestes diretórios.

Qualquer alteração deve ser proposta via ADR e aprovada antes da implementação.

## ADR de referência

`docs/canonical/FRONT/FRONT-000.md` — Seção 3, Separação Obrigatória  
`docs/canonical/FRONT/FRONT-001.md` — Seção 12, Dependências
