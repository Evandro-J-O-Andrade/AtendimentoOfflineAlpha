# MD-113 — Lei da Singularidade Canônica

## Status

ACEITO / IMUTÁVEL

---

## 1. Princípio Fundamental

```text
Para cada conceito de negócio existe exatamente um objeto canônico
responsável por sua materialização.

É proibida a duplicação de lógica, nomenclatura ou responsabilidade
por meio de variações de nomes, sufixos, prefixos, versionamentos
ou objetos paralelos.

Toda evolução deve seguir obrigatoriamente a sequência:
  REUSE → ADAPT → EXTEND → MERGE → PROPOSE

preservando a unicidade do domínio.
```

---

## 2. Um Conceito = Um Objeto

```text
Capability
  ↓
Uma tabela canônica
  ↓
Uma responsabilidade
```

Nunca:

```text
capability
capability_v2
capability_new
capability_core
capability_runtime
```

Isso fragmenta o domínio.

---

## 3. Sem Versionamento no Nome

❌ Errado

```sql
usuario_v2
portal_new
module_registry2
runtime_final
capability_beta
```

✅ Correto

```sql
usuario
module_registry
capability
runtime_contexto
```

A evolução deve ser feita por migração, nunca pelo nome.

---

## 4. Sem Prefixos ou Sufixos Desnecessários

Evitar:

```sql
tb_usuario
tbl_usuario
t_usuario
new_usuario
his_usuario
core_usuario
```

Se o banco é canônico, o contexto já define o domínio.

---

## 5. Uma Lógica = Uma Implementação

Essa é a regra mais importante.

Se existe:

```text
Resolver Capability
```

Existe apenas um fluxo oficial.

Nunca:

```text
sp_capability_get
sp_capability_runtime_get
sp_capability_portal_get
sp_capability_new_get
```

Todos fazendo praticamente a mesma coisa.

---

## 6. Uma Responsabilidade por SP

| Tipo         | Responsabilidade                                                                       |
| ------------ | -------------------------------------------------------------------------------------- |
| MASTER       | Entrada pública do domínio. Coordena o fluxo. Nunca acessa muitas tabelas diretamente. |
| DISPATCHER   | Decide quem executa. Não contém regra de negócio pesada.                               |
| ORCHESTRATOR | Coordena várias SPs e transações.                                                      |
| EXECUTOR     | Executa regra específica sobre o banco. CRUD, validações, cálculos.                    |
| ASSERT       | Apenas valida invariantes e permissões.                                                |
| QUERY        | Somente leitura. Nunca altera dados.                                                   |
| COMMAND      | Escreve no banco.                                                                      |
| LEDGER       | Auditoria e eventos.                                                                   |
| EVENT        | Publicação de eventos internos.                                                        |

---

## 7. Nada Duplicado

Antes de criar qualquer objeto:

```text
Existe?
  ↓
REUSE
  ↓
Não atende?
  ↓
ADAPT
  ↓
Ainda não atende?
  ↓
EXTEND
  ↓
Ainda não atende?
  ↓
MERGE
  ↓
Só então
PROPOSE
```

Essa ordem é obrigatória.

---

## 8. O Nome Representa o Conceito

Não o módulo.

Errado:

```sql
portal_dashboard
his_dashboard
crm_dashboard
```

Melhor:

```sql
dashboard
```

Quem define o contexto é a relação com módulo, tenant, capability ou aplicação, não o nome da tabela.

---

## 9. O Banco Não Conhece Produtos

Essa é uma regra estratégica.

O banco deve conhecer conceitos como:

- Pessoa
- Tenant
- Module
- Capability
- Resource
- Action
- Contexto
- Sessão
- Workflow

Ele não deveria ser modelado pensando apenas em "Portal", "HIS" ou "CRM". Esses são consumidores do Kernel.

---

## 10. Árvore de Execução Canônica

Toda SP deve ter uma classificação explícita na árvore:

```text
MASTER
  │
  ├── DISPATCHER
  │      │
  │      ├── ORCHESTRATOR
  │      │        │
  │      │        ├── EXECUTOR
  │      │        ├── EXECUTOR
  │      │        ├── QUERY
  │      │        └── ASSERT
  │      │
  │      └── QUERY
  │
  └── LEDGER
```

Essa árvore vira um mapa de execução do Kernel.

---

## 11. Ficha Obrigatória para Novos Objetos

Antes de criar qualquer objeto, produzir:

```text
Nome
  ↓
Tipo
  ↓
Responsabilidade
  ↓
Entradas
  ↓
Saídas
  ↓
Quem chama
  ↓
Quem é chamado
  ↓
Tabelas utilizadas
  ↓
Views utilizadas
  ↓
Functions utilizadas
  ↓
Transação?
  ↓
Auditoria?
  ↓
Ledger?
  ↓
Status (REUSE/ADAPT/EXTEND/MERGE/PROPOSE)
```

---

## 12. Integração com MD-110

```text
Todos os MDs canônicos (MD-001 até MD-113) são complementares.
Em caso de conflito, MD-110 prevalece.
Qualquer alteração em MD-113 impacta toda a plataforma.
Mudança exige ADR + aprovação do Arquiteto Chefe.
```

---

Documento Canônico Supremo — MD-113
