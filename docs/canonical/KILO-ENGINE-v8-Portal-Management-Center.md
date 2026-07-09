# KILO ENGINE v8 — Portal Enterprise & Management Center Evolution

## Status

Atualização oficial do KILO Engine.
Congela as decisões de arquitetura do Portal Enterprise e do Management Center.
Base para os MDs e FRONTs do Portal Enterprise.

---

## Objetivo

Consolidar as decisões arquitetônicas sobre o Portal Enterprise, separando definitivamente o ambiente operacional do ambiente administrativo da plataforma.

---

## LEI CANÔNICA 001 — O Portal é o núcleo da plataforma

```text
Login → Portal Enterprise → Portal Runtime → Aplicações
```

Nenhum módulo (HIS, AVA, Workforce, CRM etc.) é acessado diretamente.

---

## LEI CANÔNICA 002 — Existe apenas um Portal

Não existem Portal Root, Portal Gestor, Portal Funcionário ou Portal Médico.
Existe apenas o **Portal Enterprise**. O conteúdo é montado dinamicamente pelo Runtime.

---

## LEI CANÔNICA 003 — O Portal é orientado por metadados

Após autenticação, o backend monta o Portal. O frontend apenas renderiza.
Nunca existe lógica de autorização no frontend.

```text
Portal Runtime → Aplicações → Menus → Widgets → Cards →
Dashboards → Containers → Management → Branding → Feature Flags
```

---

## LEI CANÔNICA 004 — O Portal possui dois mundos

```text
Portal Enterprise
├── Mundo Operacional
└── Management Center
```

O usuário continua dentro do Portal; apenas muda o ambiente.

---

## LEI CANÔNICA 005 — O Management Center é modular

Ele não possui configurações fixas; possui containers. Cada container representa um módulo instalado.

---

## LEI CANÔNICA 006 — Cada container abre um Subportal Administrativo

```text
Management Center → <Módulo> → Dashboard Administrativo do Módulo
```

O Management Center apenas orquestra; cada módulo administra a si próprio.

---

## LEI CANÔNICA 007 — O Portal não conhece módulos específicos

Para o Portal tudo é Aplicação. Ele apenas apresenta a lista recebida do Runtime.

---

## LEI CANÔNICA 008 — O Management Center é orientado por módulos

Ele nunca possui telas codificadas. Pergunta "quais módulos possuem administração?" e monta os containers automaticamente.

---

## LEI CANÔNICA 009 — Cada módulo publica sua Administração

Cada produto expõe dois contratos: **Operação** e **Administração**.

---

## LEI CANÔNICA 010 — O Portal nunca é alterado para adicionar novos produtos

Novo produto = novo registro no catálogo. Zero alteração estrutural no Portal ou no Management Center.

---

## Portal Runtime

Cérebro do Portal. Monta Dashboard, Cards, Widgets, Containers, Aplicações, Favoritos, Menus, Notificações, Branding, Personalização, Management, Marketplace e Feature Flags em uma única chamada (SP-First).

---

## Evolução do Management Center

```text
Portal Enterprise → Dashboard → Card Gestão → Management Center →
Container → Subportal Administrativo → Configuração do Produto
```

---

## Subportal Administrativo

Todo módulo pode possuir um Subportal Administrativo seguindo o mesmo padrão arquitetural.

---

## Decisão de Estrutura (Monorepo) — Engines sobre Components

- `apps/` contém apenas aplicações; nunca bibliotecas. `management/` é app separado do `portal/`.
- `packages/` concentra tudo reutilizável: `ui`, `design-system`, `layout`, `navigation`, `runtime`, `widgets`, `dashboard`, `module-sdk`, `contracts`, `api`, `auth`, `events`, `database`, `sdk`, `assets`.
- Não se compartilha componente pronto; compartilha-se **engine**.
  - Sidebar → `SidebarEngine`
  - Dashboard → `Dashboard Framework`
  - Header/Footer/Layout → `Layout Engine` (PortalLayout, ManagementLayout, ModuleLayout, DisplayLayout, AuthLayout)
- Compartilhado (packages): design system, componentes base, engines de layout/navegação/runtime, dashboard/widget framework, cliente de API, SDK, eventos, auth, contratos, i18n, assets.
- Não compartilhado (apps): páginas, regras de negócio, dashboards, headers/footers específicos, menus, rotas, features, configurações de produto.

---

## Benefícios

- Um único Portal Enterprise.
- Separação clara entre operação e administração.
- Crescimento ilimitado da plataforma.
- Novos produtos entram sem alterar o Portal.
- Management Center como orquestrador.
- Cada módulo administra seu próprio domínio.
- Frontend orientado por metadados; backend como única fonte de verdade (SP-First).

---

## Integrações

| MD / FRONT | Finalidade |
|------------|-----------|
| MD-020 — Portal Core | Núcleo do Portal |
| MD-123 — Portal Canonical Experience | Experiência do Portal |
| MD-143 — Management Center Architecture | Arquitetura interna do MC |
| FRONT-003 — Portal Enterprise Experience | Entry point |
| FRONT-049 — Admin Center | Centro de administração |
| MAP-006 — Application Registry | Registro de apps |
