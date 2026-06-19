# MD-013 — Frontend Shell

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Definir o Portal Enterprise como shell universal da plataforma, responsável por autenticação, navegação, contexto e registro de aplicações.

---

## Princípio Fundamental

```text
O usuário acessa o Portal.
O Portal carrega as aplicações.
Nenhuma aplicação existe sem Registry.
Nenhuma aplicação carrega diretamente.
```

---

## Fluxo Canônico

```
Login
  ↓
Portal Shell
  ↓
Auth Canônico
  ↓
Contexto Operacional (quando necessário)
  ↓
App Registry
  ↓
Aplicação Registrada
  ↓
Módulos Da Aplicação
```

---

## Estrutura Física

```
frontend/
  shell/
    app/
      main.tsx
      router.tsx
      providers.tsx
    components/
      shell/
        Sidebar/
        Header/
        Menu/
        ThemeToggle/
        TenantSwitcher/
        UserMenu/
        NotificationCenter/
    hooks/
      use-auth.ts
      use-contexto.ts
      use-registry.ts
    layouts/
      ShellLayout.tsx
      AuthLayout.tsx
    pages/
      login/
      dashboard/
      selecao-contexto/
    services/
      auth.service.ts
      contexto.service.ts
      registry.service.ts
    utils/
      constants.ts
      tipos.ts
  portal/
    app/
    components/
    hooks/
    layouts/
    pages/
    services/
  registry/
    config/
      apps.config.ts
    components/
      AppCard/
      AppGrid/
      AppLauncher/
    hooks/
      use-apps.ts
    services/
      registry.api.ts
  apps/
    his/
    pdv/
    crm/
    sac/
    cat/
    farmacia/
    estoque/
    faturamento/
    bi/
    financeiro/
    admin/
  shared/
    componentes/
      Button/
      Input/
      DataTable/
      Modal/
      Drawer/
      Form/
      Charts/
      Layout/
    hooks/
      use-tenant.ts
      use-permissoes.ts
      use-dispatcher.ts
    servicos/
      dispatcher.api.ts
      evento.api.ts
    utils/
      validacao.ts
      formatacao.ts
      criptografia.ts
    tipos/
      auth.ts
      contexto.ts
      dispatcher.ts
      evento.ts
  providers/
    auth.provider.tsx
    contexto.provider.tsx
    tema.provider.tsx
    tenant.provider.tsx
  design-system/
    tokens/
      cores.ts
      tipografia.ts
      espacamento.ts
    componentes/
      primitivos/
    estilos/
      globals.css
      tema.css
```

---

## Responsabilidades Do Shell

Shell é responsável por:

```text
Autenticação (login, logout, sessão, refresh)
Navegação global (menu, rotas, breadcrumb)
Seleção de contexto operacional
Registry de aplicações
Tema e branding dinâmico por tenant
Troca de tenant (quando multi-tenant)
Gerenciamento de sessão global
Notificações globais
Acesso unificado a aplicações
```

---

## Responsabilidades Do Portal

Portal é responsável por:

```text
Dashboard executivo
Widgets corporativos
KPIs consolidados (via Analytics)
Comunicação interna
Agenda corporativa
Documentos
Links úteis
Rede social corporativa
AVA
IA Chat Corporativo
```

Portal NÃO executa:

```text
Regra assistencial
Regra de domínio
Operação transacional
Contexto operacional assistencial
```

---

## App Registry No Frontend

Registry é a fonte única de aplicações disponíveis.

```text
Aplicações são carregadas dinamicamente.
Aplicações são ativadas/desativadas por tenant.
Aplicações declaram dependência de contexto.
Shell valida contexto antes de abrir aplicação.
Nenhuma rota de aplicação existe sem entrada no Registry.
```

### Configuração Canônica

```json
{
  "codigo": "HIS",
  "nome": "Sistema de Saúde",
  "rota": "/his",
  "icone": "local_hospital",
  "contexto_obrigatorio": true,
  "ativo": true,
  "permissoes": ["HIS.ACESSAR"],
  "modulos": ["fila", "triagem", "enfermagem", "medico"]
}
```

---

## Providers Globais

Providers são responsáveis por estados globais da plataforma.

```text
AuthProvider: sessão, login, logout, refresh, perfil
ContextoProvider: tenant, unidade, local, perfil ativo
TemaProvider: tema, cores, branding
TenantProvider: dados do tenant, unidades disponíveis
DispatcherProvider: chamadas canônicas, eventos
```

---

## Regras De Navegação

1. Shell possui rotas globais: /login, /dashboard, /selecao-contexto.
2. Rotas de aplicação são carregadas dinamicamente via Registry.
3. Aplicações com contexto_obrigatorio=true não abrem sem contexto ativo.
4. Shell valida permissão antes de carregar aplicação.
5. Navegação entre aplicações não requer novo login.
6. URLs de aplicação são sempre precedidas por /apps/{codigo}/.
7. Breadcrumb reflete caminho: Shell → Aplicação → Módulo.

---

## Integração Com Dispatcher

Shell é o ponto de origem de todas as chamadas ao Dispatcher.

```text
Componente ou hook de aplicação
  ↓
DispatcherProvider (shell)
  ↓
dispatcher.api.ts (shared)
  ↓
POST /api/runtime/dispatch
```

Nenhuma aplicação chama API diretamente.
Nenhuma aplicação monta URL de domínio diretamente.

---

## Design System

Shell e aplicações compartilham o mesmo Design System.

```text
Componentes canônicos em design-system/
Nenhum componente duplicado.
Nenhum estilo inline exceto em overrides declarados.
Temas definidos em tokens.
```

---

## Responsabilidades Por Time

### Time De Plataforma

```text
Shell
Auth
Contexto
Registry
Providers
Design System
Rotas globais
```

### Time De Aplicação

```text
Aplicação (pasta em apps/)
Módulos da aplicação
Componentes específicos da aplicação
Regras de apresentação da aplicação
Integração com Dispatcher via contratos compartilhados
```

---

## Regras De Responsividade

```text
Shell funciona em desktop e tablet.
Aplicações são responsáveis por própria responsividade móvel.
Sidebar colapsa em tablet.
Menu vira drawer em mobile.
```

---

## Performance

```text
Shell carrega apenas código necessário para inicialização.
Aplicações são carregadas sob demanda (lazy load).
Design System é tree-shaken.
Providers são inicializados uma única vez.
Cache de Registry e permissões.
```

---

## Proibições

São proibidos:

```text
Login fora do Shell
Navegação fora do Registry
Componente de shell replicado em aplicação
Auth replicado em aplicação
Contexto operacional replicado em aplicação
Rota hardcoded para aplicação
Aplicação carregada por import direto
Estilo global definido em aplicação
Tema definido em aplicação
Provider duplicado
```

---

## Lei Do Shell

```text
Portal é a porta.
Toda aplicação passa pela porta.
Nenhuma aplicação existe fora do Registry.
```

---

## Responsabilidades

Plataforma É Responsável Por:

```text
Shell funcionar como porta única
Registry estar sempre atualizado
Auth e Contexto estarem disponíveis
Design System ser consistente
Performance do Shell
Segurança da navegação
```

Aplicações São Responsáveis Por:

```text
Funcionar dentro do Shell
Respeitar contratos do Registry
Utilizar componentes do Design System
Utilizar Dispatcher canônico
Respeitar permissões recebidas
NÃO implementar funcionalidades do Shell
