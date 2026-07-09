# Development

Comandos oficiais do monorepo.

## Pré-requisito

```bash
pnpm install
```

## Comandos

```bash
# Portal
pnpm --filter @atendimentooffline/portal dev

# Build do Portal
pnpm --filter @atendimentooffline/portal build

# Preview
pnpm --filter @atendimentooffline/portal preview

# Typecheck do workspace
pnpm -r typecheck
```

## Workspace completo (futuro)

```bash
pnpm dev
pnpm build
pnpm typecheck
pnpm lint
pnpm test
```

## Estrutura

```text
apps/
    portal/
packages/
    contracts/
    api/
    auth/
    runtime/
```

## Observação

Os comandos devem ser executados na raiz do monorepo.
