# FRONT-000 - Frontend Platform Architecture Constitution

> **Status:** Canônico
> **Domínio:** FRONT
> **Tipo:** Constituição de Plataforma Frontend

---

## 1. Mudança de Mentalidade

De aplicação React para **plataforma SaaS Enterprise**.

---

## 2. Lei Principal

> Apps entregam produtos.
> Packages entregam capacidades da plataforma.

---

## 3. Separação Obrigatória

| Diretório       | Responsabilidade                                   |
|-----------------|----------------------------------------------------|
| `apps/`         | Produtos independentes (resultados entregues).      |
| `packages/`     | Núcleo reutilizável da plataforma (capacidades).    |

Essa separação é **não negociável**. Qualquer violação deve ser rejeitada na revisão arquitetural.

---

## 4. Portal First (Mantido)

```text
Login
 ↓
Identity
 ↓
Context Selection
 ↓
Portal Enterprise
 ↓
Applications
```

O Portal Enterprise continua sendo a porta de entrada canônica do ecossistema.

---

## 5. Management Center como Produto Independente

O Management Center deixa de ser uma página interna do Portal e passa a ser considerado um **produto/app independente** dentro do ecossistema.

---

## 6. Arquitetura Frontend Orientada por Metadados

O backend — através de SPs, contratos e APIs — define:

- aplicações;
- menus;
- permissões;
- widgets;
- dashboards;
- contexto;
- branding.

O frontend **apenas interpreta e renderiza** esses metadados.

Princípios:

- Nenhuma estrutura de navegação ou dashboard deve ser hardcoded no frontend sem correspondência explícita em metadados.
- Alterações de layout, menus ou permissões devem ser refletidas via configuração, não por deploy de código.

---

## 7. Engines como Elementos Compartilhados

A infraestrutura comum é organizada em engines compartilhados no `packages/`:

- **Layout Engine** — estrutura base de páginas e containers.
- **Navigation Engine** — roteamento, breadcrumbs, menus dinâmicos.
- **Runtime Engine** — ciclo de vida de módulos e inicialização.
- **Dashboard Framework** — orquestração de dashboards via metadados.
- **Widget Framework** — registro, descoberta e execução de widgets.
- **Module SDK** — contratos e APIs para desenvolvimento de módulos plugáveis.

---

## 8. Regra Contra Acoplamento

- **Não compartilhar telas prontas** entre apps.
- **Não compartilhar componentes específicos** como Header, Sidebar ou Dashboard concretos.
- **Compartilhar apenas infraestrutura e motores** (seções 6 e 7).

Essa regra preserve a autonomia de cada produto/app.

---

## 9. Modelo de Módulos Plugáveis

Módulos são domínios funcionais plugáveis no ecossistema:

- HIS
- Workforce
- Displays
- AVA
- Chat
- Financeiro
- demais domínios

Cada módulo:

- é empacotado como package;
- registra suas capacidades no Module SDK;
- é carregado dinamicamente pelo Runtime Engine.

---

## 10. Ordem de Construção

```text
Platform Core
        ↓
Portal Enterprise
        ↓
Management Center
        ↓
Domain Modules
```

Essa ordem é a sequência canônica de entrega. Desvios devem ser justificados e documentados.

---

## 11. Validação Arquitetural

Esta constituição é associada ao **KILO ENGINE** como regra de validação arquitetural.

Qualquer proposta que viole as seções acima deve ser bloqueada ou escalada para revisão.

---

*Última atualização: 2026-07-07*
