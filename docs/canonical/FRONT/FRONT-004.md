# FRONT-004 — Application Registry

> **Status:** Canônico  
> **Domínio:** FRONT  
> **Tipo:** Registro de Aplicações  
> **Companheiro:** FRONT-000 (Constituição), FRONT-001 (Login), FRONT-002 (Context Selection), FRONT-003 (Portal Enterprise), MD-093 (SDK Extensions Framework), MD-020 (Portal Core), MAP-001 (Enterprise Domain Architecture)

---

## 1. Objetivo

Define como uma aplicação entra no ecossistema da plataforma SaaS Enterprise.

O Application Registry é o mecanismo que transforma um módulo de domínio (`apps/his`, `apps/workforce`, `apps/displays`, etc.) em uma aplicação disponível no Portal Enterprise.

Fluxo canônico:

```text
ApplicationContract
    ↓
Module SDK
    ↓
Registry
    ↓
Portal Runtime
    ↓
Application Launcher
```

Nenhuma aplicação é hardcoded no Portal.

---

## 2. Registry

O Registry é a camada que mantém o catálogo de aplicações disponíveis para o contexto ativo.

Responsabilidades:

- receber `ApplicationContract[]` do backend;
- persistir o catálogo em memória durante a sessão;
- disponibilizar o catálogo para o `PortalRuntimeEngine`;
- atualizar o catálogo quando o contexto mudar.

O Registry **não**:

- define aplicações hardcoded;
- conhece módulos de domínio;
- acessa banco diretamente;
- chama Stored Procedures.

---

## 3. Module SDK

O Module SDK é a interface pública que módulos de domínio usam para se registrar no ecossistema.

Responsabilidades:

- expor `registerModule()` para módulos;
- validar `ApplicationContract`;
- encaminhar o registro para o Registry.

O Module SDK **não**:

- avalia permissões;
- aplica regras de negócio;
- acessa banco.

---

## 4. Registration Flow

Fluxo de registro de uma aplicação:

```text
Módulo carrega
    ↓
registerModule({
  application: ApplicationContract,
  permissions: string[],
  widgets: WidgetContract[],
  dashboard?: DashboardContract
})
    ↓
Module SDK valida contrato
    ↓
Registry armazena em memória
    ↓
Portal Runtime inclui no PortalRuntimeContract
    ↓
Application Launcher renderiza
```

Regras:

- O registro acontece **apenas após** a resolução do contexto ativo.
- O registro não bloqueia o carregamento do Portal.
- Aplicações sem `ApplicationContract` válido são ignoradas silenciosamente.

---

## 5. ApplicationContract

Contrato oficial de aplicação:

```typescript
interface ApplicationContract {
  id: string
  code: string
  name: string
  icon?: string
  route: string
  category?: string
  enabled: boolean
  licensed?: boolean
  permission?: string
}
```

Regras:

- `id` é imutável após o registro.
- `code` é o identificador canônico do módulo (ex.: `his`, `workforce`, `displays`).
- `enabled` controla visibilidade no Application Launcher.
- `permission` indica a permissão mínima necessária para exibir a aplicação.
- `route` é a rota onde a aplicação será renderizada.
- `licensed` indica se a aplicação requer licenciamento ativo.

Local: `packages/contracts/src/application/ApplicationContract.ts`

---

## 6. Versionamento

Cada aplicação possui:

- `version`: semântico (`major.minor.patch`);
- `minPlatformVersion`: versão mínima da plataforma suportada.

O Registry compara `minPlatformVersion` com a versão da plataforma e oculta aplicações incompatíveis.

Regras:

- A versão da aplicação é definida pelo módulo, não pelo Portal.
- O Portal não atualiza aplicações; apenas verifica compatibilidade.

---

## 7. Permissões

Permissões são avaliadas em duas camadas:

1. **Platform Permission** — permissão mínima para exibir a aplicação no Launcher (`ApplicationContract.permission`).
2. **Module Permission** — permissões internas do módulo após o carregamento.

Regras:

- O Portal avalia apenas `ApplicationContract.permission`.
- Permissões internas do módulo são responsabilidade do próprio módulo.
- O Portal não conhece permissões específicas de domínio.

---

## 8. Menu

Itens de menu podem ser associados a aplicações.

```typescript
interface NavigationItemContract {
  id: string
  label: string
  route: string
  permission?: string
  applicationId?: string
}
```

Regras:

- `applicationId` vincula o item de menu à aplicação.
- Itens sem `applicationId` são considerados links externos ou placeholders.
- O Portal não criar menus; apenas renderiza os fornecidos pelo backend.

---

## 9. Widgets

Aplicações podem registrar widgets associados.

```typescript
interface WidgetContract {
  id: string
  type: string
  title?: string
  config?: Record<string, unknown>
  order?: number
  applicationId?: string
}
```

Regras:

- `applicationId` indica o proprietário do widget.
- Widgets sem `applicationId` são considerados widgets de sistema.
- O Portal não cria widgets; apenas renderiza os fornecidos pelo contrato.

---

## 10. Dashboards

Aplicações podem registrar dashboards associados.

```typescript
interface DashboardContract {
  id: string
  title: string
  layout: string
  widgets: WidgetContract[]
  applicationId?: string
}
```

Regras:

- `applicationId` indica o proprietário do dashboard.
- Dashboards sem `applicationId` são considerados dashboards de sistema.
- O Portal não cria dashboards; apenas renderiza os fornecidos pelo contrato.

---

## 11. Feature Flags

Aplicações podem ser condicionadas por feature flags.

```typescript
interface ApplicationContract {
  // ...
  featureFlags?: string[]
}
```

Regras:

- Feature flags são avaliadas pelo Portal Runtime.
- Aplicações com feature flags não atendidas são ocultadas.
- Feature flags são definidas no backend, não no frontend.

---

## 12. Eventos

Eventos padronizados emitidos pelo Application Registry:

```text
APPLICATION_REGISTERED
APPLICATION_UNREGISTERED
APPLICATION_ENABLED
APPLICATION_DISABLED
APPLICATION_LAUNCHED
APPLICATION_ERROR
```

Esses eventos são publicados no barramento de eventos da plataforma e estarão disponíveis para integração futura com o Event Store.

Nenhum evento específico de domínio (ex.: `HIS_REGISTERED`) pode ser criado no Registry.

---

## 13. Estados

O Registry possui os seguintes estados canônicos:

```text
LOADING_CATALOG
CATALOG_READY
CATALOG_ERROR
CONTEXT_REQUIRED
```

Transições válidas:

```text
LOADING_CATALOG
    ↓ (sucesso)
CATALOG_READY
    ↓ (falha)
CATALOG_ERROR
    ↓ (sem contexto)
CONTEXT_REQUIRED
```

---

## 14. Critérios de Aceitação

O Application Registry é aprovado somente quando:

- aplicações são descobertas via `ApplicationContract[]` do backend;
- aplicações são registradas dinamicamente pelo Module SDK;
- aplicações sem contrato válido são ignoradas;
- aplicações são filtradas por `enabled` e permissões;
- aplicações são disponibilizadas para o Application Launcher;
- o versionamento é verificado;
- feature flags são avaliadas;
- nenhuma aplicação é hardcoded no Portal;
- todos os tipos vêm de `packages/contracts`.

---

## 15. Critérios de Rejeição

O KILO rejeita implementações que:

- definam aplicações hardcoded no Portal;
- acessem banco diretamente;
- chamem Stored Procedures do frontend;
- misturem registros de módulos de domínio com regras do Portal;
- criem rotas de aplicações estáticas no Portal;
- declarem tipos dentro do Registry ou do Module SDK;
- ignorem `packages/api` e chamem `fetch()`/`axios()` diretamente;
- utilizem eventos específicos de domínio.

---

## 16. Regra Permanente

```text
Rotas de aplicações de domínio não são registradas estaticamente no Portal.

Elas são registradas dinamicamente pelo Module SDK via ApplicationRegistry quando os módulos forem carregados.
```

Essa regra é irrevogável e complementa FRONT-003 Seção 20.

---

## 17. Dependências

### Permitidas

```text
packages/contracts
packages/api
packages/runtime
```

### Proibidas

```text
apps/his
apps/workforce
apps/displays
apps/management
apps/financeiro
apps/crm
apps/chat
apps/ava
apps/intranet
database/
modules/
```

---

## Integrações

| FRONT / MD | Finalidade |
|---|
| FRONT-000 — Frontend Platform Architecture Constitution | Constituição |
| FRONT-001 — Canonical Login Experience | Autenticação |
| FRONT-002 — Canonical Context Selection Experience | Seleção de contexto |
| FRONT-003 — Portal Enterprise Experience | Experiência do Portal |
| MD-020 — Portal Core | Núcleo do Portal |
| MD-093 — SDK Extensions Framework | SDK de módulos |
| MAP-001 — Enterprise Domain Architecture | Domínios |
| FRONT-005 — Dashboard Framework | Framework de dashboards |

---

*Última atualização: 2026-07-07*
