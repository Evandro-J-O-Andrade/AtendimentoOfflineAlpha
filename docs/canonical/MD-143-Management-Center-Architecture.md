# MD-143 — Management Center Architecture

## Status

Documento Canônico de Arquitetura.
Define a arquitetura interna do **Management Center** (Subportal Administrativo do Portal Enterprise).
Companheiro de: MD-020 (Portal Core), MD-123 (Portal Canonical Experience), FRONT-003 (Portal Enterprise Experience), FRONT-049 (Admin Center), MAP-006 (Application Registry).

---

## Objetivo

Definir a arquitetura interna do Management Center: a estrutura de containers, o layout do Dashboard de Gestão, o mecanismo de registro de subportais administrativos por módulo e a descoberta automática desses módulos pelo Portal Runtime.

---

## Princípio Fundamental

```text
O Portal Enterprise é o núcleo (MD-020).
O Management Center é o ambiente de administração DENTRO do Portal.
O Portal nunca conhece um módulo específico.
O Management Center nunca possui telas codificadas.
Tudo é descoberto por metadados no Runtime.
```

---

## Lei Canônica MC-001 — Management Center é Subportal, não Módulo

```text
Management Center não é uma aplicação de negócio.
É um ambiente administrativo orquestrador.
Ele não contém regras de negócio de produtos.
Ele hospeda os subportais administrativos dos módulos.
```

---

## Lei Canônica MC-002 — Containers são Modulares

```text
O Management Center é composto por containers.
Cada container = um módulo instalado no tenant.
Sem módulo instalado → sem container.
Nenhum container é fixo em código.
```

---

## Lei Canônica MC-003 — Cada Módulo Publica sua Administração

```text
Cada produto expõe dois contratos:
  Operação  (usado no Mundo Operacional)
  Administração (usado no Management Center)
O subportal administrativo é declarado, não codificado.
```

---

## Lei Canônica MC-004 — Descoberta Automática

```text
O Portal Runtime descobre os módulos habilitados.
O Management Center monta os containers a partir do catálogo.
Novo produto = novo registro no catálogo.
Zero alteração estrutural no Portal ou no Management Center.
```

---

## Lei Canônica MC-005 — Backend é Fonte de Verdade

```text
O frontend do Management Center apenas renderiza.
Autorização e composição são decididas no backend (SP-First).
O MC nunca decide o que o usuário pode administrar.
```

---

## 1) Estrutura dos Containers

O Management Center é uma grade de containers. Cada container é instanciado a partir de um módulo habilitado no tenant.

```text
Management Center
│
┌────────────────────┐  ┌────────────────────┐  ┌────────────────────┐
│ Portal             │  │ HIS                │  │ AVA                │
└────────────────────┘  └────────────────────┘  └────────────────────┘
┌────────────────────┐  ┌────────────────────┐  ┌────────────────────┐
│ Intranet           │  │ GLPI               │  │ Displays           │
└────────────────────┘  └────────────────────┘  └────────────────────┘
┌────────────────────┐  ┌────────────────────┐
│ Workforce          │  │ (novo produto)     │
└────────────────────┘  └────────────────────┘
```

Modelo de container (metadado):

```text
container_id
modulo_codigo
nome
icone
ordem
habilitado
tem_administracao
rota_subportal
permissao_requerida
```

Regras:
- Container aparece somente se `tenant_modulo.habilitado = true`.
- Container aparece somente se a pessoa possui `permissao_requerida`.
- Container com `tem_administracao = false` não abre subportal (apenas operação).

---

## 2) Layout do Dashboard de Gestão

O Dashboard de Gestão é o "home" do Management Center. Ele é orientado por metadados e segue o Dashboard Framework (FRONT-005 / MD-109).

```text
┌──────────────────────────────────────────────────────────────┐
│ MANAGEMENT CENTER                            [Tenant: HOSPITAL] │
├──────────────────────────────────────────────────────────────┤
│ Busca Global de Configuração                                   │
├──────────────────────────┬───────────────────────────────────┤
│ Containers (grade)       │ Ações Rápidas (widgets)            │
│  [Portal][HIS][AVA]...   │  Licenciamento                     │
│                          │  Auditoria                        │
│                          │  Segurança                        │
│                          │  Feature Flags                    │
├──────────────────────────┴───────────────────────────────────┤
│ Atividade Administrativa Recente (eventos)                    │
└──────────────────────────────────────────────────────────────┘
```

Regiões do Dashboard de Gestão:
- **Busca Global de Configuração** — indexa configurações de todos os subportais.
- **Grade de Containers** — montada por descoberta (MC-004).
- **Ações Rápidas** — widgets de plataforma (Licenciamento, Auditoria, Segurança, Feature Flags).
- **Atividade Administrativa Recente** — eventos do Event Store filtrados por domínio administrativo.

---

## 3) Registro de Subportais Administrativos

Cada módulo declara seu subportal administrativo via um manifesto de administração (contrato). O manifesto é lido pelo Runtime; nada é hard-coded.

Manifesto de Administração (exemplo lógico):

```text
modulo: HIS
administracao:
  subportal: /management/his
  permissoes: [his.admin, tenant.owner]
  secoes:
    - Especialidades
    - Prontuário
    - Recepção
    - Filas
    - Painéis
    - Médicos
    - Setores
    - Escalas
    - Parâmetros
    - Integrações
  config_json_schema: configuracao_his.schema.json
```

Para o Portal (não-HIS):

```text
modulo: Portal
administracao:
  subportal: /management/portal
  secoes:
    - Logo
    - Tema
    - Menus
    - Widgets
    - Página Inicial
    - Layout
    - Apps
    - Busca
    - Notificações
    - Favoritos
```

Regras:
- O subportal é montado a partir de `secoes` + permissões da pessoa.
- Cada `secao` mapeia para um `config_json_schema` versionado.
- O módulo é dono de sua administração; o Management Center apenas orquestra a navegação.

---

## 4) Descoberta Automática pelo Portal Runtime

O fluxo de montagem do Management Center após autenticação:

```text
sp_portal_runtime(pessoa_id, tenant_id, contexto_id)
   │
   ├─ sp_modulo_catalogo_ativo(tenant_id)        → módulos habilitados
   ├─ sp_modulo_administracao(pessoa_id)         → subportais autorizados
   ├─ sp_mc_container_list(pessoa_id, tenant_id) → containers visíveis
   └─ sp_mc_widget_list(pessoa_id, tenant_id)    → ações rápidas
        │
        ▼
Contrato JSON entregue ao frontend
```

Contrato de resposta (resumo):

```json
{
  "management": {
    "enabled": true,
    "containers": [
      { "codigo": "portal", "nome": "Portal", "rota": "/management/portal", "ordem": 1 },
      { "codigo": "his",    "nome": "HIS",    "rota": "/management/his",    "ordem": 2 }
    ],
    "widgets": [ "licenciamento", "auditoria", "seguranca", "feature_flags" ],
    "search_scope": "all_admin"
  }
}
```

Se `management.enabled = false`, o card "Gestão" não é entregue ao frontend (MC-005).

---

## Modelo de Persistência (Canônico)

Tabelas de suporte à descoberta e configuração modular. SP-First: escrita exclusiva via SP.

```text
plataforma_modulo
  id, codigo, nome, categoria, icone, rota, versao, status

tenant_modulo
  id, tenant_id, modulo_id, habilitado, licenciado, ordem, config_json

tenant_modulo_config
  id, tenant_modulo_id, chave, valor

tenant_modulo_menu
  id, tenant_modulo_id, rotulo, rota, ordem, visivel

tenant_modulo_widget
  id, tenant_modulo_id, widget, ordem, visivel

tenant_modulo_tema
  id, tenant_modulo_id, logo, cores, fontes

tenant_modulo_integracao
  id, tenant_modulo_id, tipo, endpoint, credencial_ref
```

Regras:
- `plataforma_modulo` define o que EXISTE na plataforma.
- `tenant_modulo` define o que está HABILITADO para o cliente.
- Configuração é carregada apenas quando o módulo está habilitado.

---

## Stored Procedures

### sp_modulo_catalogo_ativo
Lista módulos habilitados no tenant.

### sp_modulo_administracao
Lista subportais administrativos autorizados para a pessoa.

### sp_mc_container_list
Monta a grade de containers do Management Center.

### sp_mc_widget_list
Monta as ações rápidas do Dashboard de Gestão.

### sp_modulo_register
Registra novo módulo na plataforma (catálogo).

### sp_tenant_modulo_habilitar
Habilita/desabilita módulo no tenant.

### sp_tenant_modulo_config_upsert
Grava configuração de módulo (SP-First).

---

## Eventos Oficiais

### ModuleRegistered
Módulo registrado no catálogo da plataforma.

### TenantModuleEnabled
Módulo habilitado para o tenant.

### TenantModuleDisabled
Módulo desabilitado para o tenant.

### ModuleConfigChanged
Configuração administrativa de módulo alterada.

### ManagementCenterAccessed
Acesso ao Management Center registrado.

---

## Proibições

```text
Container codificado em frontend
Subportal administrativo fixo em rota
Portal alterado para adicionar produto
Management Center com regra de negócio de produto
Autorização decidida no frontend
Módulo sem manifesto de administração
Acesso direto a tabela de configuração fora de SP
```

---

## Integrações

| MD / FRONT | Finalidade |
|------------|-----------|
| MD-020 — Portal Core | Núcleo do Portal |
| MD-123 — Portal Canonical Experience | Experiência do Portal |
| FRONT-003 — Portal Enterprise Experience | Entry point |
| FRONT-049 — Admin Center | Centro de administração |
| MAP-006 — Application Registry | Registro de apps |
| FRONT-005 / MD-109 — Dashboard Framework | Framework de dashboard |

---

## Resumo

O Management Center é o ambiente administrativo do Portal Enterprise. Sua arquitetura interna é 100% orientada por metadados: containers são descobertos a partir do catálogo de módulos habilitados, cada módulo publica seu próprio subportal administrativo via manifesto, e o Portal Runtime monta tudo em uma única chamada (SP-First). Novos produtos entram na plataforma apenas por registro, sem alterar Portal ou Management Center.
