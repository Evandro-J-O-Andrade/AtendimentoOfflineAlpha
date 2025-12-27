# React + Vite

This template provides a minimal setup to get React working in Vite with HMR and some ESLint rules.

Currently, two official plugins are available:

- [@vitejs/plugin-react](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react) uses [Babel](https://babeljs.io/) (or [oxc](https://oxc.rs) when used in [rolldown-vite](https://vite.dev/guide/rolldown)) for Fast Refresh
- [@vitejs/plugin-react-swc](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react-swc) uses [SWC](https://swc.rs/) for Fast Refresh

## React Compiler

The React Compiler is not enabled on this template because of its impact on dev & build performances. To add it, see [this documentation](https://react.dev/learn/react-compiler/installation).

## Expanding the ESLint configuration

If you are developing a production application, we recommend using TypeScript with type-aware lint rules enabled. Check out the [TS template](https://github.com/vitejs/vite/tree/main/packages/create-vite/template-react-ts) for information on how to integrate TypeScript and [`typescript-eslint`](https://typescript-eslint.io) in your project.

---

## Seeds / Test Users

There is a seed script to create profiles and test users locally (only run in dev/test environments):

- `php scripts/seed_users.php`

Default test credentials created by the seed:

- admin / Senha123! (ADMIN_MASTER, SUPORTE_MASTER)
- suporte_master / Senha123! (SUPORTE_MASTER)
- suporte / Senha123! (SUPORTE)
- adm_recepcao / Senha123! (ADM_RECEPCAO)
- totem01 / Senha123! (TOTEM_CALLER)
- recepcao1 / Senha123! (RECEPCAO)
- medico_clinico / Senha123! (MEDICO)
- medico_pediatria / Senha123! (MEDICO)
- enfermagem1 / Senha123! (ENFERMAGEM)

Important: change passwords in production and remove the seed script or restrict access.  
