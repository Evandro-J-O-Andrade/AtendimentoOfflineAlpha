# FRONTEND-AUDIT

## Objetivo

Auditar a estrutura frontend existente e identificar riscos, providers, auth, session, context e runtime antes de iniciar implementações.

## Checklist inicial

- [ ] Estrutura de pastas `apps/portal/src` correta e consistente
- [ ] Packages essenciais (`packages/contracts`, `packages/auth`, `packages/runtime`, `packages/api`) listados e certificados como REUSE/EXTEND
- [ ] Auth provider identificado e contrato verificado (`useAuth`, `LoginRequestContract`)
- [ ] Session e Context providers disponíveis (ex.: `SessionProvider`, `ContextResolver`)
- [ ] Discovery / Capability runtime hooks (ex.: `useDiscovery`)
- [ ] Roteamento dinâmico suportado (runtime-driven navigation)
- [ ] Workspaces/profile discovery não hardcoded
- [ ] Uso de assets via assets-catalog (não import direto de `Captures/`)
- [ ] Política de theming / branding (multi-tenant) definida
- [ ] Testes e mocks para auth (e2e / unit)

## Observações iniciais

- Foi detectado `apps/portal/src/pages/Login/LoginPage.tsx` que usa `useAuth` e `@atendimentooffline/contracts`.
- Existem assets em `Captures/dashboard` que devem ser catalogados e NÃO importados diretamente no código-fonte; devem entrar no catálogo de assets aprovado.
- Pacotes em `packages/` parecem conter contratos e infra; avaliar se estão vazios ou apenas com stubs — não removê-los.

## Recomendação

Parar novas alterações de UI até concluir `FRONT-CATALOG`, `ASSET-INVENTORY` e `FRONT-RUNTIME-MAP`.

## Próximos passos operacionais

1. Validar entradas do `FRONT-CATALOG` com times de produto.
2. Executar script para coletar tamanhos e tipos de assets e atualizar `ASSET-INVENTORY`.
3. Mapear runtime (o próximo documento `FRONT-RUNTIME-MAP`).
