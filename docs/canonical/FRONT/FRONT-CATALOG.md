# FRONT-CATALOG

## Objetivo

Catalogar e descrever os artefatos de frontend canônicos (FRONT-000 → FRONT-xxx), rotas, páginas e contratos consumidos para evitar implementar telas sem contrato.

## Instruções rápidas

1. Não mover nem alterar arquivos durante a catalogação.
2. Preencher o catálogo com base na estrutura existente em `apps/*`, `packages/*` e `docs/*`.
3. Validar com o dono do produto antes de marcar `CANON`.

## Seções

- Overview: propósito do front
- FRONT ID: FRONT-000 até FRONT-005 (ex.: FRONT-000 Constituição, FRONT-001 Login)
- Páginas: lista de rotas / páginas (path, arquivo, módulos relacionados)
- Componentes: componentes reutilizáveis (path, props/contratos)
- Contratos consumidos: packages/contracts usados (nome, endpoints, eventos)
- Runtime: providers, auth, context, discovery
- Owners: time/responsável
- Status: DRAFT / REVIEW / CANON

## Template de entrada (exemplo)

- `frontId`: FRONT-001
- `title`: Login Experience
- `paths`: apps/portal/src/pages/Login
- `routes`: `/login`
- `components`: `LoginForm`, `BrandingHeader`
- `contracts`: `@atendimentooffline/contracts: LoginRequestContract, AuthenticationState`
- `runtime-providers`: `AuthProvider`, `SessionProvider`, `DiscoveryService`
- `owner`: time-frontend
- `status`: DRAFT

## Próximos passos

- Rodar varredura automática para preencher entradas iniciais (scripts sugeridos abaixo).
- Revisão humana para marcar `CANON`.
