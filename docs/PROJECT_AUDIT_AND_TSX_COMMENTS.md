# Documentação do Projeto - AtendimentoOfflineAlpha
**Plataforma Midas Enterprise - Sistema Operacional Unificado**

## 1. Visão Geral

O **AtendimentoOfflineAlpha** é uma plataforma **SaaS corporativa multi-tenant, cognitiva e offline-first**, projetada como um **Sistema Operacional Unificado Enterprise**. Diferente de um ERP/CRM/HIS tradicional, a plataforma torna esses sistemas extensões naturais do core, unificando gestão, inteligência analítica e operações de saúde.

### Stack Tecnológico Principal
- **Frontend:** React 18 + TypeScript + Vite 7
- **Backend:** Express 4 + TypeScript (`tsx`) + Zod
- **Banco de Dados:** MySQL (única fonte da verdade)
- **Autenticação:** JWT + bcrypt
- **Build/Orquestração:** pnpm Workspaces + Turborepo
- **Arquitetura:** Monorepo com módulos de domínio desacoplados

## 2. Estrutura de Pastas

```
D:\AtendimentoOfflineAlpha/
├── apps/
│   ├── portal/          # App principal (SPA React) - 58 arquivos TSX
│   ├── admin/           # Scaffold
│   ├── displays/        # Scaffold
│   ├── intranet/        # Scaffold
│   └── mobile/          # Scaffold
├── backend/             # API Express (gateway stateless)
├── packages/            # Pacotes compartilhados
│   ├── contracts/       # Contratos TypeScript
│   ├── runtime/         # Runtime do portal
│   ├── auth/            # AuthProvider, AuthGuard (2 arquivos TSX)
│   ├── api/             # Cliente API
│   └── enterprise-icons/ # Ícones SVG
├── modules/             # 27 domínios de negócio (40 arquivos TSX)
├── database/            # MySQL (SP-first, migrations, seeds)
├── docs/                # Documentação canônica, database, engineering
├── engineering/         # Metadados, inventários, templates
└── tools/               # sp-analyzer, sp-client-generator
```

## 3. Apps

### `apps/portal` (IMPLEMENTADO)
Aplicação principal SPA React com Vite. Estrutura:
- **Shell Enterprise:** Navegação e contexto global
- **Login:** Tela de autenticação com seleção de contexto
- **Guards:** Proteção de rotas por perfil
- **Workspaces:** Dashboards por perfil (admin, médico, farmácia, financeiro, etc.)
- **Shared:** Componentes reutilizáveis (Button, Card, Table, Dialog, etc.)

### `apps/admin`, `apps/displays`, `apps/intranet`, `apps/mobile`
Apenas estrutura scaffold criada, sem implementação.

## 4. Backend

API Express standalone em `backend/`:
- **Rotas:** `auth.ts`, `portal.ts`
- **Serviços:** AuthService, PermissionService, PortalService
- **Conexão:** MySQL via `mysql2`
- **Arquitetura:** Route → Controller → Dispatcher → Orquestrador → Executor → SP → Ledger → Response

## 5. Packages

### Implementados
| Package | Descrição | Arquivos TSX |
|---------|-----------|--------------|
| `@atendimentooffline/contracts` | Contratos TypeScript compartilhados | - |
| `@atendimentooffline/runtime` | Runtime do portal | - |
| `@atendimentooffline/auth` | Autenticação e guards | 2 |
| `@atendimentooffline/api` | Cliente HTTP para API | - |

### Scaffold (estrutura criada)
| Package | Descrição |
|---------|-----------|
| `enterprise-components` | Componentes UI |
| `enterprise-hooks` | Hooks customizados |
| `enterprise-theme` | Temas visuais |
| `enterprise-shell` | Shell enterprise |
| `enterprise-sdk` | SDK da plataforma |
| `enterprise-layout` | Layouts |

## 6. Módulos de Domínio (27 módulos)

Cada módulo representa um domínio de negócio da plataforma:

| Módulo | Domínio | Status |
|--------|---------|--------|
| `atendimento` | Atendimento/Pacientes | Scaffold |
| `auditoria` | Auditoria | Scaffold |
| `configuracao` | Configurações | Scaffold |
| `display` | Displays/Totens | Scaffold |
| `enfermagem` | Enfermagem | Scaffold |
| `estoque` | Estoque/Logística | Scaffold |
| `farmacia` | Farmácia | Scaffold (tem Dashboard.tsx) |
| `faturamento` | Faturamento | Scaffold |
| `ffa` | FFA (Força/Função/Atividade) | Scaffold |
| `fila` | Fila de espera | Scaffold |
| `financeiro` | Financeiro | Scaffold (tem Dashboard.tsx) |
| `governanca` | Governança | Scaffold |
| `iam` | IAM (Identity & Access Management) | Scaffold |
| `identity` | Identidade digital | Scaffold (tem Dashboard.tsx) |
| `internacao` | Internação hospitalar | Scaffold |
| `kernel` | Kernel/Core | Scaffold |
| `laboratorio` | Laboratório | Scaffold |
| `medico` | Médico/Prontuário | Scaffold |
| `notificacao` | Notificações | Scaffold |
| `paciente` | Paciente | Scaffold |
| `painel` | Painel geral | Scaffold |
| `pessoa` | Pessoa (entidade raiz) | Scaffold |
| `recepcao` | Recepção | Scaffold |
| `runtime` | Runtime | Scaffold |
| `senha` | Senha/Reset | Scaffold |
| `triagem` | Triagem | Scaffold |

## 7. Arquitetura

### Fluxo Canônico
```
Login → Portal → IAM → Contexto → Workspace → App Registry → Dashboard → Operação
Route → Controller → Dispatcher → Orquestrador → Executor → SP → Ledger → Response
```

### Regras de Ouro
1. **MySQL é única fonte da verdade**
2. **Nenhuma escrita direta em tabelas** - apenas via Stored Procedures
3. **Event Store (`kernel_ledger`)** é a memória operacional
4. **Documentos Canônicos** regem toda evolução (MD-*.md, MAP-*.md, BR-*.md)
5. **Lei de Evolução Documental:** todo código nasce de documento canônico, todo código gera documento canônico

### Portas
- Frontend (Portal): `localhost:3000` (Vite)
- Backend API: `localhost:3001` (proxy no Vite)

## 8. Documentação Oficial

### Documentos Supremos (leitura obrigatória)
- `000-CONSTITUICAO-PLATAFORMA.md` - Constituição suprema (1295 linhas)
- `000-CONSTITUICAO-IA.md` - Guia operacional das IAs
- `AGENTS.md` - Guia para IAs colaboradoras
- `AI_CONTEXT.md` - Memória permanente

### Documentos Canônicos
- `docs/canonical/` - 49+ documentos consolidados
- `docs/DATABASE_BRAIN.md` - Modelo mental do banco
- `docs/API_BRAIN.md` - Modelo mental da API
- `docs/PROJECT_BRAIN.md` - Cérebro do projeto
- `docs/IMPLEMENTATION_STATUS.md` - Status de implementação

### Inventários Técnicos
- `frontend-inventory.md` - Inventário estruturado do frontend
- `frontend-runtime-discovery.md` - Descoberta do runtime
- `docs/database/` - Catálogos de tabelas, views, procedures, events

## 9. Status Geral

### Implementado
- ✅ App Portal com login e seleção de contexto
- ✅ Shell Enterprise com workspaces por perfil
- ✅ Backend API com autenticação JWT
- ✅ Pacotes compartilhados (contracts, runtime, auth)
- ✅ Módulos com estrutura de dashboard/pages

### Em Desenvolvimento
- 🔄 Módulos de domínio (27 módulos, maior parte scaffold)
- 🔄 Apps adicionais (admin, displays, intranet, mobile)
- 🔄 Pacotes UI (enterprise-components, enterprise-theme, etc.)

### Planejado
- ⏳ Integração completa dos módulos com backend
- ⏳ App Registry dinâmico
- ⏳ Offline-first completo (Service Workers, IndexedDB)
- ⏳ IA cognitiva (insights, predições, automação)
