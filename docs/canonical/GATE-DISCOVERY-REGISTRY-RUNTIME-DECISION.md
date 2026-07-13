# GATE-DISCOVERY-REGISTRY-RUNTIME-DECISION

## 1. Objeto

Discovery + Registry Runtime

## 2. Conceito

Camada responsável por descobrir dinamicamente:
- módulos disponíveis
- capacidades do tenant/contexto
- recursos publicados
- metadados necessários para montagem do Portal Runtime

Não é menu.
Não é permissão.
Não é frontend.

É a camada que responde:
> "Dado este contexto autenticado, quais capacidades existem e podem ser resolvidas pelo Kernel?"

## 3. Estado da auditoria

| Item | Status |
|------|--------|
| Evidências SQL | ✅ Aprovadas |
| Achados | ✅ Aprovados |
| Gaps | ✅ Aprovados |
| Classificação técnica | ✅ Aprovada |

Referência: `AUDIT-DISCOVERY-REGISTRY-RUNTIME.md`

## 4. Decisão arquitetural

### 4.1 Matriz de classificação por objeto

| Objeto | Classificação | Justificativa |
|--------|---------------|---------------|
| `tenant_registry` | **REUSE** | Já existe, é o registro canônico de tenants. Não precisa ser recriado. |
| `saas_entidade` | **REUSE** | Já existe, é a entidade federadora. Base para multi-tenancy. |
| `sistema` | **REUSE** | Já existe como catálogo de sistemas operacionais. Não é um registry de módulos, mas é reutilizado como referência de contexto. |
| `usuario_contexto` | **REUSE** | Já existe, armazena snapshot do contexto ativo do usuário. |
| `runtime_contexto` | **REUSE** | Já existe, armazena estado runtime clínico/fluxo. |
| `permissao` | **ADAPT** | Existe mas está sobrecarregada. Precisa ser adaptada para separar Authorization de Navigation. Campos de menu (`grupo_menu`, `icone`, `ordem_menu`, `visivel_menu`, `acao_frontend`) devem ser preservados mas recontextualizados. |
| `perfil_permissao` | **ADAPT** | Existe mas não possui colunas `acao`, `recurso`, `ativo`. Precisa ser adaptada para suportar o modelo de permissão por ação/recurso. |
| `usuario_perfil` | **ADAPT** | Existe mas não possui `id_unidade`. Precisa ser adaptada para suportar perfil por unidade. |
| `module_registry` | **PROPOSE** | Nova tabela. Registry de módulos publicáveis pelo Kernel. |
| `capability` | **PROPOSE** | Nova tabela. Capacidades individuais dentro de módulos. |
| `tenant_capability` | **PROPOSE** | Nova tabela. Vínculo tenant ↔ capability com configuração. |
| `tenant_module` | **PROPOSE** | Nova tabela. Vínculo tenant ↔ módulo com configuração. |
| `permissao_local` | **PROPOSE** | Nova tabela. Restrição de permissão por local/sala. |
| `menu_evento` | **PROPOSE** | Nova tabela. Auditoria de eventos de menu. |
| `vw_usuario_permissoes` | **PROPOSE** | Nova view. Consolida permissões do usuário para consulta rápida. |
| `sp_discovery_capabilities_get` | **PROPOSE** | Nova procedure. Resolve capabilities disponíveis por contexto autenticado. |
| `sp_navigation_menu_get` | **PROPOSE** | Nova procedure. Monta menu dinâmico separada de auth. |

### 4.2 Por que não ADAPT/EXTEND em `tenant_registry` e `sistema`?

**`tenant_registry`**:
- É um registro de tenants, não de módulos/capabilities.
- Misturar módulos/capabilities com dados de tenant viola a separação de responsabilidades.
- Extender `tenant_registry` para incluir módulos criaria um acoplamento inadequado.
- **Decisão: REUSE** — usar como base do registry de tenants, mas não estender.

**`sistema`**:
- É um catálogo de sistemas operacionais (OPE, ASI, HIS, PA, UPA, UBS, FARMACIA, ADMIN).
- Módulos/capabilities são publicados pelo Kernel, não são sistemas operacionais.
- Um módulo pode existir em múltiplos sistemas, ou ser independente.
- Estender `sistema` para incluir módulos criaria uma falsa equivalência.
- **Decisão: REUSE** — usar como referência de contexto (`id_sistema`), mas não estender.

### 4.3 Fluxo de decisão

```
Discovery + Registry Runtime
        |
        +---- REUSE
        |       |
        |       +---- tenant_registry (registry de tenants)
        |       +---- saas_entidade (entidade federadora)
        |       +---- sistema (catálogo de sistemas)
        |       +---- usuario_contexto (contexto snapshot)
        |       +---- runtime_contexto (estado runtime)
        |
        +---- ADAPT
        |       |
        |       +---- permissao (separar auth de menu)
        |       +---- perfil_permissao (adicionar acao/recurso/ativo)
        |       +---- usuario_perfil (adicionar id_unidade)
        |
        +---- PROPOSE
                |
                +---- module_registry
                +---- capability
                +---- tenant_capability
                +---- tenant_module
                +---- permissao_local
                +---- menu_evento
                +---- vw_usuario_permissoes
                +---- sp_discovery_capabilities_get
                +---- sp_navigation_menu_get
```

## 5. Objetivos da materialização

1. **Separar Navigation de Authorization**: `permissao` não carrega mais metadados de menu sozinha.
2. **Criar registry canônico**: `module_registry` + `capability` + `tenant_capability` formam o metamodelo de descoberta.
3. **Implementar discovery dinâmico**: `sp_discovery_capabilities_get` resolve capabilities por tenant/contexto autenticado.
4. **Resolver incompatibilidades de schema**: Adaptar `permissao`, `perfil_permissao`, `usuario_perfil` para suportar o modelo novo.
5. **Criar Navigation Runtime separada**: `sp_navigation_menu_get` substitui `sp_auth_menu_get` com schema compatível.

## 6. Critérios de aceite do GATE

Para considerar este GATE aprovado, a materialização deve:

1. **REUSE** preservar dados existentes de `tenant_registry`, `saas_entidade`, `sistema`, `usuario_contexto`, `runtime_contexto`.
2. **ADAPT** executar migrações idempotentes em `permissao`, `perfil_permissao`, `usuario_perfil` sem perda de dados.
3. **PROPOSE** criar novas tabelas/procedures/views com schema documentado.
4. **Discovery** responder corretamente: "Dado este contexto autenticado, quais capacidades existem e podem ser resolvidas pelo Kernel?"
5. **Separação** ficar clara: Authorization ≠ Navigation ≠ Discovery.

## 7. Decisão

**APROVADO PARA DOSSIER — MATERIALIZAÇÃO BLOQUEADA**

A decisão é:
- REUSE: 5 objetos
- ADAPT: 3 objetos
- PROPOSE: 10 objetos

### 7.1 Bloqueio de materialização

Nenhum SQL, procedure, view, backend ou frontend será iniciado até que:

1. O **DOSSIER-DISCOVERY-REGISTRY-RUNTIME.md** seja aprovado
2. O **Modelo Conceitual** seja aprovado
3. A **Revisão Transversal** seja concluída e aprovada
4. O dossiê seja considerado **APROVADO**

### 7.2 Critérios para desbloqueio

- Todos os domínios estratégicos consultados (HIS, ERP, CRM, BI, Portal, Intranet, Mobile, API, Marketplace, Display/TV, Integrações)
- Matriz de consumo preenchida
- Nenhum conceito específico de um único domínio no Kernel
- Modelo suficientemente genérico
- Quantidade mínima de objetos

### 7.3 Próximo passo

Iniciar elaboração do **DOSSIER-DISCOVERY-REGISTRY-RUNTIME.md** e **Modelo Conceitual**.

Após aprovação, iniciar materialização (SQL, SPs, backend, frontend).
