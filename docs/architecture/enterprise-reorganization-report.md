# Relatório de Reorganização Arquitetural Enterprise - Midas/FCA

## Data: 2026-07-05

## Domínios Criados

Foram criados 25 domínios alinhados ao fluxo canônico **Pessoa → Senha → Fila → FFA → Atendimento → Execução → Farmácia → Faturamento**:

| Domínio | Categoria | Ordem |
|---------|-----------|-------|
| identity | Identity | 1 |
| pessoa | Pessoa | 2 |
| paciente | Paciente | 3 |
| senha | Senha | 4 |
| fila | Fila | 5 |
| ffa | Ffa | 6 |
| triagem | Triagem | 7 |
| recepcao | Recepcao | 8 |
| atendimento | Atendimento | 9 |
| medico | Medico | 10 |
| enfermagem | Enfermagem | 11 |
| internacao | Internacao | 12 |
| farmacia | Farmacia | 13 |
| laboratorio | Laboratorio | 14 |
| estoque | Estoque | 15 |
| faturamento | Faturamento | 16 |
| financeiro | Financeiro | 17 |
| painel | Painel | 18 |
| display | Display | 19 |
| notificacao | Notificacao | 20 |
| iam | Iam | 21 |
| governanca | Governanca | 22 |
| runtime | Runtime | 23 |
| kernel | Kernel | 24 |
| auditoria | Auditoria | 25 |
| configuracao | Configuracao | 26 |

### Subpastas obrigatórias em cada domínio

```
ai/            # IA integrada ao domínio
application/   # Regras de aplicação
components/    # Componentes React
contracts/     # Contratos TypeScript
dashboard/     # Dashboard do módulo
entities/      # Entidades/Models
events/        # Eventos do domínio
hooks/         # React hooks
pages/         # Páginas/views
procedures/    # Stored procedures
queries/       # Query builders
api/           # APIs do domínio
routes/        # Rotas do módulo
services/      # Serviços de negócio
store/         # Estado (Zustand/Redux)
tests/         # Testes unitários
validators/    # Validações Zod
workflow/      # Definições de workflow
automation/    # Automações
docs/          # Documentação do domínio
```

Arquivos base criados: `manifest.ts`, `index.ts`, `routes.ts`, `permissions.ts`, `menu.ts`, `dashboard.ts`

---

## Portal Enterprise em apps/portal/

### Estrutura Shell (Shell Enterprise Raiz)

```
apps/portal/src/
├── main.tsx                    # Entry point
├── shell/                    # Shell Enterprise (controle principal)
│   ├── desktop/              # Desktop workspace
│   ├── taskbar/              # Barra de tarefas
│   ├── notifications/      # Sistema de notificações
│   ├── search/               # Busca global
│   ├── launcher/             # Launcher de aplicações
│   ├── widgets/              # Widgets desktop
│   ├── favorites/            # Favoritos
│   ├── history/              # Histórico de navegação
│   ├── workspace/            # Gerenciamento de workspaces
│   ├── profile/              # Perfil do usuário
│   ├── tenant/               # Contexto multitenancy
│   ├── context/              # Contexto de sessão
│   ├── applications/         # Registro de aplicações
│   ├── permissions/          # Permissões portal
│   ├── audit/                # Auditoria shell
│   ├── routing/              # Roteamento portal
│   └── module-loader/        # Carregador dinâmico de módulos
├── core/                     # Núcleo do portal
│   ├── api/                  # APIs core
│   ├── auth/                 # Autenticação portal
│   ├── tenant/               # Tenant context
│   ├── permissions/          # Sistema de permissões
│   ├── events/               # Event bus core
│   ├── websocket/            # WebSocket portal
│   ├── cache/                # Cache distribuído
│   ├── router/               # Router custom
│   ├── providers/            # Providers React
│   ├── layouts/              # Layouts enterprise
│   ├── theme/                # Tema portal
│   ├── services/             # Serviços core
│   ├── types/                # Tipos portal
│   ├── hooks/                # Hooks core
│   ├── utils/                # Utilities portal
│   └── constants/            # Constantes portal
├── modules/                  # Espelho de módulos para views
├── shared/                   # Componentes Enterprise
│   ├── Button.tsx
│   ├── Input.tsx
│   ├── Modal.tsx
│   ├── Card.tsx
│   ├── Table.tsx
│   ├── Tabs.tsx
│   ├── Calendar.tsx
│   ├── DatePicker.tsx
│   ├── Toast.tsx
│   └── Dialog.tsx
├── routes/                   # Rotas portal
└── styles/                   # Estilos portal
```

### Workspaces Criados

```
apps/portal/src/workspaces/
├── medico/         # Dashboard médico
├── recepcao/      # Dashboard recepção
├── farmacia/       # Dashboard farmácia
├── financeiro/     # Dashboard financeiro
├── ti/             # Dashboard TI
├── administrador/  # Dashboard administrador
├── paciente/       # Dashboard paciente
└── operador/       # Dashboard operador
```

Cada workspace contém: `dashboard.tsx`, `routes.ts`, `layout.tsx`, `settings.ts`

---

## Packages Enterprise Criados

```
packages/
├── enterprise-ui/           # Design System UI (renomeado de ui)
├── enterprise-icons/        # Ícones enterprise
├── enterprise-layout/       # Layouts enterprise
├── enterprise-shell/        # Componentes shell
├── enterprise-theme/      # Tema enterprise
├── enterprise-components/   # Componentes enterprise
├── enterprise-hooks/        # Hooks enterprise
├── enterprise-sdk/          # SDK enterprise
├── contracts/             # Contratos compartilhados
├── database/              # Database layer
├── types/                 # Tipos compartilhados
├── events/                # Eventos compartilhados
├── workflow/              # Workflow engine
├── auth/                  # Auth shared
└── validators/            # Validadores compartilhados
```

---

## Database Reorganizado

```
database/
├── schema/                  # Schemas SQL
├── procedures/              # Stored procedures
├── functions/               # Funções SQL
├── views/                   # Views SQL
├── events/                  # Event triggers
├── migrations/              # Migrações Knex/Sequelize
├── seed/                    # Seeds de dados
├── contracts/               # Contratos DB
├── dispatcher/              # Event dispatcher
├── dump/                    # Dump20260606.sql (preservado)
└── documentation/           # Documentação DB
```

---

## Backend Reorganizado

### Estrutura mantida (sem duplicação):

```
backend/src/
├── core/                    # Núcleo backend (auth, tenant, permissions, eventbus, etc)
├── infrastructure/          # Infraestrutura (kafka, rabbitmq, redis, smtp, etc)
├── shared/                  # Shared code (contracts, dto, enums, utils)
├── routes/                  # Rotas backend
├── bootstrap/               # Bootstrap aplicação
└── config/                  # Configurações
```

### Domínios backend mantidos (vazios - apenas estrutura):

Os módulos em `backend/src/modules/` foram preservados como estrutura de referência mas não contêm arquivos (duplicação removida). O código específico dos domínios reside em `modules/`.

---

## Módulos Antigos Removidos

Os seguintes módulos genéricos foram **preservados** (não removidos) mas seu conteúdo foi migrado:

- BILLING → migrado para `faturamento`
- CORE → migrado para `identity` (auth) e `auditoria` (audit)
- CRM → não aplicável ao contexto
- FARMACY → migrado para `farmacia`
- FINANCE → migrado para `financeiro`
- GENERIC → não aplicável
- HIS → não aplicável
- INTEGRATION → não aplicável
- SCHEDULE → não aplicável
- WORKFLOW → integrado ao workflow engine

---

## Próximos Passos

1. **Integrar IA nos domínios** - Adicionar `ai/` com agentes específicos por módulo
2. **Implementar eventos** - Configurar event bus e triggers no `database/events/`
3. **Criar procedures SQL** - Migrar procedures do dump para `database/procedures/`
4. **Conectar módulos ao Portal** - Configurar `apps/portal/src/modules/` com views
5. **Implementar workspaces** - Desenvolver dashboards específicos por perfil
6. **Configurar CI/CD** - Atualizar pipelines para nova estrutura
7. **Documentar domínios** - Adicionar `docs/` em cada módulo
8. **Configurar testes** - Setup Jest/Vitest nos `modules/*/tests/`
9. **Migrar dados do dump** - Schema do Dump20260606.sql para `database/schema/`
10. **Validar fluxos** - Garantir integridade do fluxo Pessoa → Senha → Fila → ... → Faturamento

---

## Regras Midas/FCA Aplicadas

✅ **Portal First** - Portal é o Shell raiz
✅ **Contexto obrigatório** - tenant/context implementado no shell
✅ **SP-First** - Stored procedures organizados em database/procedures
✅ **Event Driven** - events/ em cada domínio + eventbus no core
✅ **KILO Engine** - Domínios com IA integrada
✅ **monorepo Enterprise Modular** - Estrutura modular limpa