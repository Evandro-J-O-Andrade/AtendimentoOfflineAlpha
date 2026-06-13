# 🗺️ Estrutura do Frontend - ALPHA Atendimento Offline

Este documento mapeia a arquitetura atual do frontend, destacando os módulos principais e a hierarquia de componentes.

## 🚀 Pontos de Entrada
- `src/main.jsx`: Inicialização do React e estilos globais.
- `src/App.jsx`: **Roteador Principal** com Providers (Auth, Tenant) e Lazy Loading.
- `src/index.css`: Definições de Tailwind e variáveis de tema.

## 📂 Módulos (Apps)

### 1. Portal Corporativo (`src/apps/portal/`)
O hub central de acesso aos módulos do sistema.
- **Pages**: 
  - `PortalHomePage.tsx`: Dashboard principal com módulos agrupados.
  - `login/LoginPage.tsx`: Tela de login ultra-premium New Wave Enterprise.
- **Components**:
  - `PortalModuleCard.tsx`: Card de acesso aos módulos (Substitui ApplicationCard).
- **Hooks**:
  - `usePortalModules.ts`: Gestão de estado e busca de módulos autorizados.
- **Services**:
  - `branding.ts`: Configurações de identidade visual dinâmica.

### 2. Operacional (`src/apps/operacional/`)
Módulo de assistência e atendimento.
- **Core**: `AppOperacional.jsx` (Container principal).
- **Auth**: `AuthProvider.jsx` / `SecurityGuard.jsx`.
- **Contextos**: `SelecionarContexto.jsx`.

### 3. Painel de Chamadas (`src/apps/painel/`)
Interface para exibição de senhas e monitoramento.
- **Core**: `AppPainel.jsx`.

### 4. Totem de Autoatendimento (`src/apps/totem/`)
Interface de triagem inicial e geração de senhas.
- **Core**: `AppTotem.jsx`.

## 🛠️ Recursos Compartilhados
- `src/context/`: Contextos globais (TenantProvider).
- `src/services/`: Instância do Axios e interceptors de API.
- `src/shared/`: Tipagens TypeScript globais e utilitários.

## ⚠️ Arquivos Marcados para Remoção (Redundantes)
| Arquivo | Motivo | Substituto |
| :--- | :--- | :--- |
| `src/router/index.jsx` | Roteador legado estático | `src/App.jsx` |
| `src/apps/portal/pages/PortalHome.tsx` | Versão duplicada/obsoleta | `PortalHomePage.tsx` |
| `src/apps/portal/components/ApplicationCard.tsx` | Componente legado | `PortalModuleCard.tsx` |
| `src/apps/portal/components/ApplicationGrid.tsx` | Layout redundante | Grid CSS Nativo |
| `docs/*.tsx` | Rascunhos de design fora da src | `src/apps/portal/pages/login/*` |

## 🎨 Padrão de Nomenclatura
- **Páginas**: `[Nome]Page.tsx`
- **Componentes**: `PascalCase`
- **Hooks**: `use[Nome].ts`
- **Estilo**: Tailwind CSS + CSS Modules para casos específicos.

---
**Última Atualização:** 2024-05-20
**Status da Arquitetura:** Migração para TypeScript em progresso.