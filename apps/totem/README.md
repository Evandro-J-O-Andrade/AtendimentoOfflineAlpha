# Totem — Senha Eletrônica

Aplicativo de totem de autoatendimento para emissão de senhas.

## Estrutura

```
apps/totem/
  public/
    assets/
      img/
      icons/
  src/
    App.tsx
    main.tsx
    app/
      config.ts
      routes.ts
      providers.tsx
    pages/
      TotemSenha/
        TotemSenha.tsx
      TotemSatisfacao/
        TotemSatisfacao.tsx
    core/
      hooks/
        useTotemSenha.ts
      utils/
        printTicket.ts
      types/
        totem.types.ts
    styles/
      totem.css
```

## Capacidades

- **TotemSenha**: emite senha e mostra plantão médico.
- **TotemSatisfacao**: coleta feedback do paciente.

## Arquitetura

```text
Tela (TotemSenha)
    ↓
Contract (TotemContracts)
    ↓
API (TotemApi)
    ↓
Backend (/totem/*)
    ↓
SP (sp_totem_gerar_senha)
    ↓
Banco (totem, totem_senha_opcao)
```

## Execução

```bash
pnpm install
pnpm dev
```
