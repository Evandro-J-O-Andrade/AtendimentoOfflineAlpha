# REGRAS OBRIGATÓRIAS

## Arquitetura

- Não criar aplicações paralelas.
- Não criar novos pontos de entrada React.
- Não criar main.tsx dentro dos módulos.
- Existe apenas UM main.jsx global.

## CSS

- Todo módulo deve herdar src/index.css.
- Não criar CSS isolado para módulos.
- Não usar Bootstrap.
- Não usar Material UI.

## TypeScript

- Todo código novo deve ser TSX.
- Não criar novos arquivos JSX.
- Arquivos legados podem permanecer JSX até migração.

## Segurança

- JWT apenas via Cookie HttpOnly.
- Nunca utilizar localStorage para token.
- localStorage apenas para preferências de usuário.

## Portal

- Portal é a tela inicial após login.
- Portal não exige contexto operacional.
- Contexto operacional somente ao entrar em módulos operacionais.

## White Label

- Nunca utilizar nomes fixos:
  - Hospital
  - Clínica
  - UPA
  - Alpha

- Utilizar:
  - Tenant
  - Organização
  - Empresa

## Banco

- Backend e banco não devem ser alterados sem autorização.
