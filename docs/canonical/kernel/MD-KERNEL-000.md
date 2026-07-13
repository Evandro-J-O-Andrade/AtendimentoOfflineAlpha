# MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Documento raiz de toda a arquitetura da plataforma.
Todos os MD-KERNEL-001 até MD-KERNEL-014 dependem deste documento.
```

---

## 1. Propósito

### 1.1 Por que o Kernel Enterprise existe

O Kernel Enterprise representa o núcleo canônico da plataforma. Seu objetivo é concentrar os conceitos transversais compartilhados por todos os produtos, módulos e serviços, preservando uma única fonte de verdade para:

- identidade
- contexto
- capacidades
- execução
- governança

### 1.2 O que ele resolve

- **Duplicação de conceitos**: cada produto não precisa reinventar identidade, sessão, tenant, permissão.
- **Acoplamento entre produtos**: HIS, Portal, ERP, CRM compartilham o mesmo Kernel.
- **Falta de governança**: sem um núcleo canônico, cada domínio define suas próprias regras.
- **Evolução por quebra**: mudanças em um produto afetam outros porque não há um contrato central.

### 1.3 Garantias oferecidas

- Fonte única de verdade.
- Reutilização entre produtos.
- Baixo acoplamento.
- Evolução controlada.
- Independência tecnológica.

---

## 2. Visão da Plataforma

### 2.1 Antes

```text
HIS
  ↓
Portal
  ↓
Banco
```

Cada produto construía sua própria arquitetura. O banco era específico do HIS.

### 2.2 Agora

```text
Kernel Enterprise
  ↓
Banco Canônico
  ↓
Runtime
  ↓
HIS
ERP
CRM
BI
Portal
Intranet
Mobile
Display
Marketplace
...
```

O Kernel é a espinha dorsal. Os produtos são consumidores.

---

## 3. Missão do Kernel

1. **Centralizar conceitos transversais**: identidade, sessão, tenant, contexto, capabilities, autorização, navegação, runtime, eventos, ledger, workflow, integração.
2. **Evitar duplicação**: um conceito existe uma única vez.
3. **Garantir interoperabilidade**: todos os produtos falam a mesma língua.
4. **Permitir evolução sem ruptura**: mudanças no Kernel não quebram produtos existentes.

---

## 4. Objetivos Arquiteturais

4.1 Fonte única de verdade para conceitos transversais.
4.2 Reutilização máxima entre produtos.
4.3 Acoplamento mínimo entre domínios.
4.4 Evolução controlada por GATEs e dossiês.
4.5 Independência tecnológica: o Kernel não depende de MySQL, React, Node.js ou qualquer tecnologia específica.
4.6 Governança canônica: toda mudança segue o processo definido em MD-110 e MD-005.
4.7 Materialização baseada em evidência: o Banco Vivo é a fonte primária.
4.8 Descoberta dinâmica: capabilities são descobertas, não hardcoded.
4.9 Separação de responsabilidades: cada domínio tem uma única razão de existir.
4.10 Escalabilidade: o Kernel cresce sem precisar ser reescrito.

---

## 5. Princípios Arquiteturais

### 5.1 Princípio Fundamental

```text
O Kernel Enterprise é a única espinha dorsal da plataforma.
Todo produto, todo módulo, toda integração passa pelo Kernel.
Nenhum produto cria seu próprio banco, seu próprio login,
sua própria auditoria ou seu próprio conceito de identidade.
```

### 5.2 Princípios Específicos

| Princípio | Regra |
|-----------|-------|
| Singularidade | Um conceito = um objeto canônico. Sem duplicação. |
| Transversalidade | Nenhum conceito entra no Kernel se for específico de um produto. |
| Materialização dirigida pelo banco | Conceito → Banco → SP → Backend → Frontend. Nunca o inverso. |
| SP-first | Toda regra de negócio reside em Stored Procedure. |
| Banco Vivo | O dump é a fonte de verdade. Nenhuma camada acima é fonte. |
| REUSE → ADAPT → EXTEND → MERGE → PROPOSE | Ordem obrigatória antes de criar qualquer objeto. |
| Descoberta dinâmica | Nenhuma capability é hardcoded. Toda é descoberta pelo Runtime. |
| Separação de responsabilidades | Identity ≠ Auth ≠ Context ≠ Discovery ≠ Navigation ≠ Portal. |
| Independência tecnológica | O Kernel deve fazer sentido sem banco, sem frontend, sem backend. |
| Governança first | Nenhuma materialização sem dossiê, GATE e revisão transversal aprovados. |

### 5.3 Referências

Estes princípios são detalhados em:
- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica
- MD-005 — Lei de Engenharia e Materialização
- MD-007 — Lei de Evolução Documental

---

## 6. Camadas do Kernel

### 6.1 Foundation Layer

Camada de fundação. Fornece os conceitos básicos sem os quais nenhum outro domínio funciona.

```text
Foundation Layer
  ├── Identity
  ├── Tenant
  ├── Session
  └── Context
```

### 6.2 Runtime Layer

Camada de execução e descoberta. Resolve capacidades, orquestra fluxos e expõe interfaces.

```text
Runtime Layer
  ├── Runtime
  ├── Discovery
  ├── Registry
  └── Capability
```

### 6.3 Governance Layer

Camada de governança. Controla autorização, auditoria, eventos e imutabilidade.

```text
Governance Layer
  ├── Authorization
  ├── Ledger
  └── Event
```

### 6.4 Integration Layer

Camada de integração. Conecta o Kernel com o mundo externo e com fluxos complexos.

```text
Integration Layer
  ├── Workflow
  ├── Integration
  └── Notification
```

### 6.5 Diagrama consolidado

```text
Kernel Enterprise
│
├── Foundation Layer
│      Identity
│      Tenant
│      Session
│      Context
│
├── Runtime Layer
│      Runtime
│      Discovery
│      Registry
│      Capability
│
├── Governance Layer
│      Authorization
│      Ledger
│      Event
│
└── Integration Layer
       Workflow
       Integration
       Notification
```

---

## 7. Domínios Canônicos

### 7.1 Domínios pertencentes ao Kernel

| Ordem | Domínio | Camada | MD |
|-------|---------|--------|-----|
| 1 | Identity | Foundation | MD-KERNEL-001 |
| 2 | Tenant | Foundation | MD-KERNEL-002 |
| 3 | Session | Foundation | MD-KERNEL-003 |
| 4 | Context | Foundation | MD-KERNEL-004 |
| 5 | Authorization | Governance | MD-KERNEL-005 |
| 6 | Discovery | Runtime | MD-KERNEL-006 |
| 7 | Registry | Runtime | MD-KERNEL-007 |
| 8 | Capability | Runtime | MD-KERNEL-008 |
| 9 | Runtime | Runtime | MD-KERNEL-009 |
| 10 | Navigation | Runtime | MD-KERNEL-010 |
| 11 | Workflow | Integration | MD-KERNEL-011 |
| 12 | Event | Governance | MD-KERNEL-012 |
| 13 | Ledger | Governance | MD-KERNEL-013 |
| 14 | Integration | Integration | MD-KERNEL-014 |

### 7.2 Ordem de dependência

A ordem acima não é aleatória. Ela respeita dependências conceituais:

- Identity é pré-requisito para Session.
- Session é pré-requisito para Context.
- Context é pré-requisito para Authorization.
- Authorization é pré-requisito para Discovery.
- Discovery depende de Registry.
- Registry depende de Capability.
- Capability depende de Runtime.
- Navigation é projeção de Capability.
- Workflow depende de Runtime.
- Event e Ledger dependem de Authorization.
- Integration depende de todos os anteriores.

---

## 8. Boundaries

### 8.1 Não pertencem ao Kernel

Os seguintes sistemas e conceitos **consomem** o Kernel, mas não fazem parte dele:

- Portal Enterprise
- HIS
- ERP
- CRM
- BI
- Dashboard
- Intranet
- Marketplace
- Mobile
- Display/TV
- Totem
- APIs específicas de produto
- Dashboards específicos

### 8.2 Por que essa separação é importante

```text
Se um conceito serve apenas a um produto,
ele pertence ao produto.

Se um conceito serve a dois ou mais produtos,
ele pertence ao Kernel.
```

Essa regra evita que o HIS "empurre" tabelas, SPs e regras para o Core que só fazem sentido para o HIS.

---

## 9. Relações entre Domínios

### 9.1 Visão geral

```text
Identity
  ↓
Session
  ↓
Context
  ↓
Tenant
  ↓
Discovery
  ↓
Registry
  ↓
Capability
  ↓
Authorization
  ↓
Navigation
  ↓
Runtime
```

### 9.2 Relações detalhadas

```text
Identity
  ├── Session (um usuário tem N sessões)
  ├── Tenant (um usuário pertence a N tenants)
  └── Context (um usuário tem N contextos)

Session
  ├── Context (uma sessão tem um contexto ativo)
  ├── Authorization (uma sessão valida permissões)
  └── Runtime (uma sessão executa capabilities)

Tenant
  ├── Registry (um tenant tem N módulos/capabilities)
  ├── Discovery (um tenant descobre suas capabilities)
  └── Authorization (um tenant define permissões)

Discovery
  ├── Registry (consulta o registry)
  ├── Capability (descobre capabilities)
  └── Navigation (fornece capabilities para menu)

Registry
  ├── Module Registry (cataloga módulos)
  ├── Capability Registry (cataloga capabilities)
  └── Tool Registry (cataloga ferramentas)

Capability
  ├── Authorization (exige permissão)
  ├── Runtime (é executado por um runtime)
  └── Navigation (é projetado como menu)

Authorization
  ├── Identity (quem é o usuário)
  ├── Session (qual sessão)
  ├── Context (qual contexto)
  └── Ledger (registra decisões)

Runtime
  ├── Master (orquestra)
  ├── Dispatcher (roteia)
  ├── Executor (executa)
  └── SP (materializa regra)

Event
  ├── Ledger (registra evento)
  └── Notification (notifica interessados)

Ledger
  ├── Event (registra evento)
  └── Authorization (registra decisão)
```

### 9.3 Princípio de dependência

```text
Nenhum domínio pode depender de um domínio que está abaixo dele
na hierarquia de camadas.

Foundation → Runtime → Governance → Integration
```

---

## 10. Regras de Evolução

### 10.1 Referências canônicas

As regras de evolução do Kernel estão definidas em:
- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica
- MD-005 — Lei de Engenharia e Materialização
- MD-007 — Lei de Evolução Documental
- GATEs aprovados
- ADRs aprovados
- Dossiês de arquitetura

### 10.2 Regras específicas do Kernel

10.2.1 Todo novo domínio deve demonstrar transversalidade antes de entrar no Kernel.
10.2.2 Nenhum domínio específico de produto pode ser promovido ao Kernel sem auditoria.
10.2.3 A materialização depende da aprovação do modelo conceitual.
10.2.4 Nenhuma tabela, SP ou view pode ser criada sem classificação REUSE/ADAPT/EXTEND/MERGE/PROPOSE.
10.2.5 Nenhuma SP pode ser criada sem classificação de tipo (MASTER, DISPATCHER, ORCHESTRATOR, EXECUTOR, ASSERT, QUERY, COMMAND, LEDGER, EVENT).
10.2.6 Toda alteração no Kernel exige GATE aprovado.
10.2.7 Todo conceito novo no Kernel exige MD-KERNEL-XXX aprovado.
10.2.8 O Banco Vivo é a evidência; nenhum documento substitui o dump.
10.2.9 Artefatos derivados (índices, mapas, catálogos) são regeneráveis; o banco não.

---

## 11. Critérios para entrada no Kernel

### 11.1 Checklist obrigatório

Para que um conceito entre no Kernel, ele deve responder SIM a todas as perguntas:

| Pergunta | Resposta |
|----------|----------|
| É transversal? | |
| É reutilizável por mais de um produto? | |
| Não pertence apenas ao HIS? | |
| Não pertence apenas ao Portal? | |
| Não pertence apenas ao ERP? | |
| Não pertence apenas ao CRM? | |
| Não pertence apenas ao BI? | |
| Não duplica outro conceito do Kernel? | |
| Respeita a Lei da Singularidade Canônica? | |

### 11.2 Aprovação

- Checklist preenchido.
- Dossiê aprovado.
- GATE aprovado.
- Revisão transversal aprovada.
- MD-KERNEL-XXX aprovado.

Apenas depois disso o conceito é materializado.

---

## 12. Referências

### 12.1 Documentos canônicos

- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica
- MD-005 — Lei de Engenharia e Materialização
- MD-007 — Lei de Evolução Documental

### 12.2 GATEs aprovados

- GATE-DISCOVERY-REGISTRY-RUNTIME-AUDIT
- GATE-DISCOVERY-REGISTRY-RUNTIME-DECISION

### 12.3 Dossiês aprovados

- DOSSIER-DISCOVERY-REGISTRY-RUNTIME

### 12.4 Outras referências

- 000-CONSTITUICAO-PLATAFORMA.md
- 000-CONSTITUICAO-IA.md
- docs/canonical/MD-CANONICO-IA-007-Lei-Banco-Fonte-Verdade-Knowledge-Graph.md
- docs/canonical/MAP-001-Enterprise-Domain-Architecture.md

---

## 13. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação do documento raiz do Kernel Enterprise |

---

Documento Canônico — MD-KERNEL-000

**Este é o documento raiz de toda a arquitetura da plataforma New Wave Enterprise.**
