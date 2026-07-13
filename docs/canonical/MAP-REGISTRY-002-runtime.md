# MAP-REGISTRY-002 — Runtime Registry Architecture

## Status
```text
CANÔNICO (ENGENHARIA)
CICLO 2.1 — Registry Canônico
Fase 3 — Etapa 2/5 (pós-MD, pré-SQL)
Sequência obrigatória (Art. 74): MD → MAP → BR → Contratos → SQL
Origem: MD-REGISTRY-002 (definição canônica de Runtime)
```

---

## Princípio deste MAP

```text
runtime_registry ARMAZENA Atributos do Runtime.
runtime_registry NÃO ARMAZENA listas de Capability/Master/
Contrato/Evento/Dependência.

Essas relações são ARESTAS DE GRAFO, descobertas pelo
metamodelo e pelo Knowledge Graph (Art. 72).

Uma responsabilidade, uma fonte de verdade.
```

---

## Estrutura: runtime_registry (Atributos)

```text
runtime_registry
 ├── id_runtime         BIGINT PK AUTO_INCREMENT
 ├── codigo            VARCHAR(60) UNIQUE   -- ex: portal, auth, farmacia
 ├── nome              VARCHAR(120)
 ├── dominio           VARCHAR(40)          -- ADAPT de permissao.dominio
 ├── descricao         TEXT
 ├── versao            VARCHAR(20)
 ├── status            ENUM(ATIVO, INATIVO, MANUTENCAO)
 ├── responsavel       VARCHAR(120)
 ├── tipo_consumidor   ENUM(HUMANO, COMPUTACIONAL, AMBOS)
 ├── runtime_type      ENUM(CORE, PLATFORM, DOMAIN, INFRASTRUCTURE, INTEGRATION)
 ├── endpoint_pattern  VARCHAR(120)         -- FAMÍLIA ex: /auth/*
 └── observacoes       TEXT
```

---

## Relações (arestas de grafo — NÃO colunas de lista)

Cada relação é resolvida por tabela de associação ou aresta no
Knowledge Graph, nunca duplicada no runtime_registry.

### Modelo de Aresta Canônica (reutilizável em TODOS os registries)

Toda aresta do metamodelo é cidadão de primeira classe
(ver MD-REGISTRY-000 — Metamodelo de Registries):

```text
id
codigo
origem
destino
role
status
versao
metadata       (json)
effective_from (opcional — evolução / versionamento / migração)
effective_to   (opcional — descontinuação sem quebrar histórico)
relationship_status (opcional — ACTIVE/DEPRECATED/PLANNED/EXPERIMENTAL/DISABLED)
created_at
updated_at
```

Habilita auditoria, versionamento, evolução e referências cruzadas.

### Arestas deste registry

```text
capability_runtime   Runtime N──N Capability   (Etapa 1: permissao)
   role ∈ { PRIMARY, SECONDARY, PROXY }
   PRIMARY   = EXATAMENTE 1 por Capability (unicidade; senão resolução ambígua)
   SECONDARY = exposição adicional
   PROXY     = não executa; resolve e encaminha ao PRIMARY
               (ex: AI Runtime → Runtime PRIMARY)
runtime_master      Runtime 1──N Master
runtime_contrato    Runtime 1──N Contrato
runtime_evento      Runtime 1──N Evento
runtime_dependencia Runtime N──N Runtime
   tipo ∈ { FUNCIONAL, OPERACIONAL }
   FUNCIONAL   : Portal ──▶ Auth          (depende funcionalmente)
   OPERACIONAL : Portal ──▶ Infrastructure (depende operacionalmente)
```

Nota: `capability_runtime` conecta `runtime_registry.id_runtime`
à `permissao.id_permissao` (Capability Registry da Etapa 1).
A cardinalidade N:N resolve a reserva BR-CAP-010.

### runtime_type é NATUREZA, não prioridade

```text
CORE não é "mais importante" que DOMAIN. São categorias. (BR-RT-010)
```

### endpoint_pattern nunca é endpoint concreto

```text
✅ /auth/*      ❌ /auth/login   (concreto pertence ao API Registry)  (BR-RT-007)
```

---

## Catálogo inicial de Runtimes (seed)

| codigo | runtime_type | tipo_consumidor | endpoint_pattern |
|--------|--------------|-----------------|-----------------|
| auth | CORE | AMBOS | /auth/* |
| portal | PLATFORM | HUMANO | /portal/* |
| context | PLATFORM | AMBOS | /context/* |
| notification | PLATFORM | AMBOS | /notify/* |
| workflow | PLATFORM | COMPUTACIONAL | /workflow/* |
| integration | INTEGRATION | COMPUTACIONAL | /integration/* |
| estoque | DOMAIN | AMBOS | /estoque/* |
| farmacia | DOMAIN | AMBOS | /farmacia/* |
| financeiro | DOMAIN | AMBOS | /financeiro/* |
| laboratorio | DOMAIN | AMBOS | /laboratorio/* |
| ai | INTEGRATION | COMPUTACIONAL | /ai/* |

---

## Fluxo coordenado pelo Runtime (LEI 25·26)

```text
Capability
   ↓
Runtime        (resolve + valida contrato/contexto + autorização)
   ↓
Master         (orquestra)
   ↓
Dispatcher
   ↓
Executor
   ↓
Stored Procedure
   ↓
Resultado → Evento → Auditoria → Runtime → Cliente
```

O Runtime coordena ida e volta; não assume regra de negócio
(Princípio da Neutralidade — MD-REGISTRY-002).

---

## Integrações

| Documento | Finalidade |
|------------|------------|
| MD-REGISTRY-002 | Definição canônica de Runtime |
| BR-REGISTRY-001 | Capability (Etapa 1), BR-CAP-010 (cardinalidade) |
| BR-REGISTRY-002 | Regras de Runtime (etapa seguinte) |
| MD-REGISTRY-001 | Capability Registry (permissao) |
| MAP-019-AI | AI Runtime / Capability Resolver |
| REGISTRY-CANONICO-AUDITORIA | Origem (PROPOSE: runtime_registry) |

---

## GATE-PLATFORM-001 (pré-validação da Etapa 2)

```text
Arquitetura : ✅ respeita Constituição
              ✅ não viola LEI 23–26
              ✅ não altera Kernel
              ✅ não cria fluxo paralelo
              ✅ não duplica listas entre registries
Banco Vivo  : ✅ auditado (runtime_* existe como infra)
Engenharia  : ✅ MD  ✅ MAP (este)  ✅ BR  ⏳ Contratos  ⏳ SQL
```

---

## Próximo passo (Etapa 2)

```text
1. ✅ MD-REGISTRY-002
2. ✅ MAP-REGISTRY-002 (este)
3. ✅ BR-REGISTRY-002 (regras de Runtime/Registry)
4. → Contratos + API de descoberta
   Regra: NÃO criar SQL do Discovery antes do contrato de
   resposta (já definido em MD-REGISTRY-000 — Discovery Query).
5. → SQL (ordem gradual, não tudo de uma vez):
     5.1 runtime_registry
     5.2 capability_runtime   (com role + unicidade PRIMARY)
     5.3 runtime_master
     5.4 runtime_dependencia  (FUNCIONAL / OPERACIONAL)
     5.5 runtime_evento
     5.6 runtime_contrato
6. → GATE final
```

### Sequência entre os próximos registries (em validação)
A ordem original Capability→Runtime→**Tool→API→Event** pode ser
reavaliada para **API→Tool→Event** (Tool consome API). Decisão
PENDENTE de auditoria do Banco Vivo (REUSE→ADAPT→EXTEND→MERGE→
PROPOSE), não por preferência. Registrada aqui; não altera a Etapa 2.
