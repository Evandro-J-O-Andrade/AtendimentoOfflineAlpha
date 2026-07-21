# FRONT-085 — Developer Toolkit Standard

> **Status:** Canônico  
> **Domínio:** FRONT  
> **Tipo:** Padrão de Engenharia e Ferramentas  
> **Companheiro:** FRONT-000 (Constituição), FRONT-001 (Login), FRONT-003 (Portal Enterprise), FRONT-017 (Theme Experience), MD-020 (Portal Core), MAP-001 (Enterprise Domain Architecture)

---

## 1. Objetivo

Definir o **Developer Toolkit Oficial** da New Wave Enterprise Platform, alinhado ao stack arquitetural do ecossistema.

Este documento estabelece quais ferramentas são obrigatórias, recomendadas ou proibidas durante o desenvolvimento, garantindo consistência entre equipes e máxima produtividade no ecossistema React + Vite + TypeScript.

---

## 2. Princípio Arquitetural

A New Wave Enterprise Platform é construída sobre:

- **React** (Frontend UI)
- **Vite** (Bundler / Dev Server)
- **TypeScript** (Linguagem base)
- **CSS Modules** (Estilização)
- **Context API** (Estado global)
- **Express + MySQL** (Backend)

Toda ferramenta de desenvolvimento deve ser escolhida com base nesse stack.

Ferramentas alinhadas a outras tecnologias **não são suportadas oficialmente**.

---

## 3. Stack Oficial do Portal Enterprise

| Camada | Tecnologia | Versão Mínima |
|--------|-----------|---------------|
| Frontend | React | 18+ |
| Build | Vite | 7+ |
| Linguagem | TypeScript | 5+ |
| Estilos | CSS Modules | — |
| Estado | Context API | — |
| Backend | Express | 4+ |
| Banco | MySQL | 8+ |
| ORM/Driver | mysql2 | 3+ |
| Validação | Zod | 3+ |

---

## 4. Ferramentas de Frontend

### 4.1 Obrigatórias

| Ferramenta | Finalidade | Prioridade |
|------------|-----------|-----------|
| **React DevTools** | Inspeção de componentes, props, state, contexto | ⭐⭐⭐⭐⭐ |
| **React Profiler** | Análise de re-renderizações e performance | ⭐⭐⭐⭐⭐ |
| **Vite Inspector** | Navegação rápida entre código fonte e DOM | ⭐⭐⭐⭐ |
| **Lighthouse** | Auditoria de Performance, CLS, LCP, SEO, Acessibilidade | ⭐⭐⭐⭐⭐ |
| **Playwright** | Testes E2E e regressivos | ⭐⭐⭐⭐⭐ |
| **Vitest** | Testes unitários e de integração | ⭐⭐⭐⭐⭐ |
| **Storybook** | Design System e documentação de componentes | ⭐⭐⭐⭐⭐ |

### 4.2 Condicionalmente Obrigatórias

| Ferramenta | Condição | Finalidade |
|------------|----------|-----------|
| **TanStack Query DevTools** | Se utilizar React Query | Cache e estado assíncrono |
| **Redux DevTools** | Se utilizar Redux | Estado global imutável |

### 4.3 Proibidas / Não Suportadas

| Ferramenta | Motivo |
|------------|--------|
| ❌ **Vue DevTools** | Projeto não utiliza Vue.js. Não consegue inspecionar componentes React. |
| ❌ **Angular DevTools** | Projeto não utiliza Angular. |

---

## 5. Ferramentas de Backend

| Ferramenta | Finalidade | Prioridade |
|------------|-----------|-----------|
| **MySQL Workbench** | Modelagem e administração do banco | ⭐⭐⭐⭐⭐ |
| **DBeaver** | Query e exploração de dados | ⭐⭐⭐⭐⭐ |
| **Postman** | Testes de API REST | ⭐⭐⭐⭐⭐ |
| **Bruno** | Testes de API REST (alternativa open-source) | ⭐⭐⭐⭐ |
| **OpenAPI/Swagger** | Documentação de contratos de API | ⭐⭐⭐⭐⭐ |

---

## 6. Ferramentas de Infraestrutura

| Ferramenta | Finalidade | Prioridade |
|------------|-----------|-----------|
| **Docker Desktop** | Containerização local | ⭐⭐⭐⭐⭐ |
| **Portainer** | Gerenciamento visual de containers | ⭐⭐⭐⭐ |
| **Grafana** | Dashboards de métricas | ⭐⭐⭐⭐⭐ |
| **Prometheus** | Coleta de métricas e alertas | ⭐⭐⭐⭐⭐ |

---

## 7. Ferramentas de Observabilidade

| Ferramenta | Finalidade | Prioridade |
|------------|-----------|-----------|
| **Sentry** | Rastreamento de erros em produção | ⭐⭐⭐⭐⭐ |
| **OpenTelemetry** | Tracing distribuído e métricas | ⭐⭐⭐⭐⭐ |
| **Chrome Performance** | Análise de runtime e memory leaks | ⭐⭐⭐⭐⭐ |

---

## 8. Ferramentas de Engenharia (Monorepo)

| Ferramenta | Finalidade | Prioridade |
|------------|-----------|-----------|
| **pnpm** | Gerenciador de pacotes e workspaces | ⭐⭐⭐⭐⭐ |
| **Turbo** | Orquestração de tasks do monorepo | ⭐⭐⭐⭐⭐ |
| **ESLint** | Linting e regras de código | ⭐⭐⭐⭐⭐ |
| **Prettier** | Formatação de código | ⭐⭐⭐⭐⭐ |

---

## 9. Uso Obrigatório do React DevTools

Toda equipe deve habilitar o **React DevTools** durante o desenvolvimento do Portal Enterprise.

Ele permite inspecionar:

```
LoginPage
 ├── LoginHero
 ├── LoginCard
 ├── LoginFooter
```

e verificar em tempo real:

- Árvore de componentes;
- Props;
- Hooks;
- Estado local;
- Context values;
- Renderizações.

---

## 10. Uso Obrigatório do React Profiler

O **React Profiler** é obrigatório para debugging de performance.

Ele identifica:

```
Quem renderizou?
Por quê renderizou?
Quanto tempo demorou?
Quem causou a renderização?
```

Exemplo prático no Portal Enterprise:

```
ThemeProvider
    ↓
LoginPage
    ↓
LoginHero
    ↓
re-render
```

Isso permite descobrir rapidamente por que a imagem do Hero sofre layout shift durante troca de tema.

---

## 11. Uso Obrigatório do Lighthouse

O **Lighthouse** deve ser executado sempre que houver alteração visual no Login ou Portal.

Métricas críticas monitoradas:

| Métrica | Limite Aceitável |
|---------|-----------------|
| CLS (Cumulative Layout Shift) | < 0.1 |
| LCP (Largest Contentful Paint) | < 2.5s |
| FID (First Input Delay) | < 100ms |
| TTI (Time to Interactive) | < 3.8s |

No Login, o Lighthouse identifica automaticamente se o Hero Background está causando deslocamento.

---

## 12. Developer Toolkit Completo

```text
NEW WAVE ENTERPRISE
Developer Toolkit

Frontend
-----------
✓ React DevTools
✓ React Profiler
✓ Vite Inspector
✓ Lighthouse
✓ Storybook
✓ Playwright
✓ Vitest

Backend
----------
✓ MySQL Workbench
✓ DBeaver
✓ Postman
✓ Bruno
✓ OpenAPI

Infra
---------
✓ Docker Desktop
✓ Portainer
✓ Grafana
✓ Prometheus

Observabilidade
-------------------
✓ Sentry
✓ OpenTelemetry
✓ Chrome Performance
```

---

## 13. Exclusividade de Stack

É **terminantemente proibido** introduzir ferramentas de debug ou desenvolvimento de outras stacks no Portal Enterprise.

Exemplos de ferramentas **não suportadas**:

- Vue DevTools
- Angular DevTools
- Svelte DevTools
- Nuxt DevTools

Qualquer solicitação de inclusão de ferramenta externa ao stack deve ser avaliada pela governança arquitetural (MD-CANONICO-IA-002).

---

## 14. Compatibilidade

Este padrão é compatível com:

- React 18+
- Vite 5+
- TypeScript 5+
- CSS Modules
- Tailwind CSS
- Node.js 20+
- pnpm 8+
- Turbo 2+

---

## Estado

**Aprovado para utilização como padrão oficial da New Wave Enterprise Platform.**
