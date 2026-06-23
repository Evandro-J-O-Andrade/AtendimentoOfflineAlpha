# FRONT-054 — Organization 360 Experience

## Status

Documento Canônico de Frontend.
Define a experiência de visão 360° da organização (tenant).

---

## Objetivo

Fornecer visão completa da estrutura organizacional para diretoria, governança e controladoria.

---

## Princípio Fundamental

```text
Organização não é apenas pessoas.
Organização é:
  Estrutura
  Processos
  Dados
  Custos
  Riscos
  Performance
```

---

## Componentes

### OrgStructure

```text
Hierarquia visual:
  - Tenant (raiz)
  - Unidades
  - Departamentos
  - Setores
  - Locais
  - Cargos/Perfis
Visualização em árvore ou organograma
Navegação por clique (drill-down)
Indicadores por nó:
  - Usuários ativos
  - Apps utilizadas
  - Custos
  - Performance
```

### AppsMap

```text
Mapa de apps ativas por unidade/local
Taxa de adoção por app
Uso por perfil
Integrações ativas
Custo por app (se contratado separadamente)
Roadmap de apps por unidade
```

### UsersMap

```text
Distribuição de usuários por:
  - Unidade
  - Departamento
  - Perfil
  - App
Status:
  - Ativos
  - Inativos
  - Bloqueados
  - Suspensos
Custo por usuário (benchmark)
```

### CustosMap

```text
Infraestrutura por unidade
Apps por custo
Storage por tenant
Tokens IA consumidos por unidade
Custo de integrações
Projeção de crescimento
Benchmark por vertical
```

### PerformanceMap

```text
SLA por unidade
Tempo de resposta por app
Uptime por serviço
Throughput por local
Incidentes por unidade
Tempo de resolução
Health score por unidade
```

### RiscosMap

```text
Riscos por unidade
Incidentes abertos
Vulnerabilidades
Compliance status
Acesso indevido (tentativas bloqueadas)
Dados sensíveis expostos (alertas)
```

---

## Regras

### Acesso

```text
C-Level: visão global de todas as unidades
Diretor: visão das suas unidades
Gerente: visão da sua unidade/local
Compliance: visão de riscos e conformidade
TI: visão de infra e performance
```

### Isolamento

```text
Usuário NÃO vê dados de outras unidades alem das suas.
Admin global vê tudo (auditado).
Dados sensíveis mascarados conforme perfil.
Log de visualização no Event Store.
```

### Atualização

```text
Dados atualizados via eventos.
Dashboard refresh conforme perfil:
  - Estratégico: 24h
  - Gerencial: 1h
  - Operacional: 30min
Cache por unidade/local.
```

---

## Integrações

| MD / FRONT | Finalidade |
|-----------|-----------|
| MD-017 — Multi-Tenant | Isolamento |
| MD-107 — Tenant Architecture | Estrutura de tenant |
| MD-078 — Revenue Operations | Custos |
| MD-098 — Enterprise Risk Management | Riscos |
| MD-099 — Strategic Command Center | Command Center |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-015 — Command Center UX | Dashboard executivo |
| FRONT-029 — Admin Console UX | Administração |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | OrgStructure, AppsMap, UsersMap, CustosMap, PerformanceMap, RiscosMap |
| Backend | APIs de consulta organizacional |
| Dispatcher | Roteamento para SPs e Analytics |
| SP | Regras de acesso, agregação por unidade |
| Event Store | Registrar visualizações |
| IA | Anomalias, previsão de custo, risco preditivo |

---

## Métricas

```text
Unidades ativas
Departamentos ativos
Apps ativas por unidade
Usuários por unidade
Adoção de apps (%)
Custo por unidade
SLA por unidade
Incidentes por unidade
Health score por unidade
Tempo para visualizar relatório organizacional
```

---

## Lei

```text
Organização é estrutura, pessoas, processos, dados e custos.
Organization 360 é a visão do todo.
Diretoria decide com dados, não com feeling.
```

---

## Próximo

```text
FRONT-054 completo
  ↓
FRONT-055 — Knowledge Hub Experience
```
