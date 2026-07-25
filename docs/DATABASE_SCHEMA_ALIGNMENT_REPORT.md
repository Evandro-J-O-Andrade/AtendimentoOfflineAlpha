# Relatório de Alinhamento de Schema — Banco Real vs Dump Canônico

**Data:** 2026-07-25  
**Status:** 🟢 Todas as divergências corrigidas  
**Fonte canônica:** `database/dump/Dump20260618.sql`  
**Banco real:** `pronto_atendimento` (localhost:3306)  

---

## Objetivo

Identificar diferenças entre o schema canônico (dump) e o banco de dados real, priorizando objetos usados pelo Dispatcher e Kernel.

---

## Metodologia

1. Comparar estrutura de tabelas do dump contra `INFORMATION_SCHEMA` do banco real.
2. Comparar definições de Stored Procedures do dump contra banco real.
3. Classificar divergências por severidade.

---

## Divergências Encontradas e Corrigidas

### 1. ✅ CORRIGIDA — Coluna `id_saas_entidade` vs `id_entidade` em `atendimento_evento`

**Tabela:** `atendimento_evento`

| Fonte | Coluna usada |
|-------|--------------|
| Dump canônico | `id_entidade` |
| SP `sp_master_registrar_evento` (antes) | `id_saas_entidade` |
| Tabela real | `id_entidade` |

**Correção aplicada:**
- `sp_master_registrar_evento` alterada para usar `id_entidade` em `atendimento_evento`
- `uuid_transacao` adicionado ao INSERT para suporte a idempotência

**Arquivo:** `docs/SP_ENTITY_ALIGNMENT_PATCH.md`

---

### 2. ✅ CORRIGIDA — Coluna `id_saas_entidade` vs `id_entidade` em tabelas de domínio

**Tabelas:** `atendimento_triagem`, `atendimento_evolucao`, `atendimento_anamnese`

| Fonte | Coluna usada |
|-------|--------------|
| Dump canônico | `id_entidade` |
| SP `sp_master_assistencial_salvar_orquestradora` (antes) | `id_saas_entidade` |
| Tabela real | `id_entidade` |

**Correção aplicada:**
- `sp_master_assistencial_salvar_orquestradora` alterada para usar `id_entidade` nas tabelas de domínio e em `atendimento_evento`

---

### 3. ✅ CORRIGIDA — Coluna `id_saas_entidade` vs `id_entidade` em `atendimento_evento` (orquestrador)

**SP:** `sp_orquestrador_assistencial`

**Correção aplicada:**
- INSERT em `atendimento_evento` alterado para usar `id_entidade`

---

### 4. ✅ CORRIGIDA — Coluna `id_saas_entidade` vs `id_entidade` em `atendimento_evento` (executor)

**SP:** `sp_execucao_assistencial`

**Correção aplicada:**
- INSERT em `atendimento_evento` alterado para usar `id_entidade`

---

### 5. ✅ CORRIGIDA — Colunas divergentes em `atendimento_diagnostico`

**Tabela:** `atendimento_diagnostico`

| Dump canônico | Tabela real |
|---------------|-------------|
| `id_unidade`, `id_ffa`, `id_usuario`, `id_sessao_usuario`, `ip_origem`, `device_info` | Apenas `id_atendimento`, `codigo_cid`, `descricao`, `principal`, `criado_em`, `id_entidade` |

**Correção aplicada:**
- `sp_executor_assistencial_atendimento_finalizar` alterada para usar apenas colunas existentes

---

### 6. ✅ CORRIGIDA — Handler de erro da `sp_master_dispatcher`

**Problema:** Handler estava mascarando erros de negócio com `ERRO_INTERNO [<errno>]`

**Correção aplicada:**
- Handler agora captura `MESSAGE_TEXT` original e re-signaliza a mensagem preservada
- Backend (`DispatcherService.ts`) captura `error.sqlMessage` e retorna mensagem real da SP
- Backend (`DispatcherController.ts`) removido `try/catch` que mascara erros

---

### 7. ✅ CRIADA — Migration de idempotência

**Problema:** Coluna `uuid_transacao` ausente em `atendimento_evento`

**Correção aplicada:**
- Migration `database/migrations/20260725_add_uuid_transacao_evento.sql` criada e aplicada
- Adiciona coluna `uuid_transacao` e índice `idx_evento_uuid`
- Atualiza `sp_master_dispatcher` para incluir verificação de idempotência

---

### 8. ✅ CORRIGIDA — Backend: suporte a `uuid_transacao`

**Problema:** Backend gerava UUID interno e ignorava `uuid_transacao` da requisição

**Correção aplicada:**
- `DispatcherRequest` agora aceita `uuid_transacao` opcional
- Backend usa `uuid_transacao` da requisição se fornecido, senão gera novo UUID
- Suporte a testes de idempotência e chamadas externas com correlation ID

---

### 9. ✅ CORRIGIDA — Backend: leitura de resultset do MySQL

**Problema:** `DispatcherService.ts` lia o último resultset, que é um objeto de status do driver MySQL

**Correção aplicada:**
- Código ajustado para ler o penúltimo resultset, que contém o JSON de resposta da SP

---

### 10. ✅ CORRIGIDA — Collation divergente em `atendimento_evento`

**Problema:** `atendimento_evento` tinha collation `utf8mb4_unicode_ci`, enquanto outras tabelas usam `utf8mb4_0900_ai_ci`

**Correção aplicada:**
- Coluna `uuid_transacao` criada com collation `utf8mb4_0900_ai_ci` para compatibilidade

---

## Lições Aprendidas

1. **Auditoria incremental é eficaz:** A primeira impressão ("coluna ausente") foi refinada para "divergência de nomenclatura", e depois para "padrão de modelagem separado entre runtime e domínio".

2. **SPs transversais exigem validação camada por camada:** `sp_master_registrar_evento` e `sp_master_dispatcher` afetam todo o fluxo. Erros nelas se manifestam como falhas genéricas.

3. **Banco real pode divergir do dump em múltiplas dimensões:** Não apenas colunas, mas também collations, handlers de erro e semântica de colunas.

4. **Idempotência é feature, não bug:** A ausência da coluna `uuid_transacao` não era um bug, mas uma feature não implementada. A migration formaliza a evolução.

---

## Estado Final

| Componente | Status |
|------------|--------|
| `sp_master_registrar_evento` | 🟢 Alinhada |
| `sp_master_dispatcher` | 🟢 Alinhada |
| `sp_master_assistencial_salvar_orquestradora` | 🟢 Alinhada |
| `sp_orquestrador_assistencial` | 🟢 Alinhada |
| `sp_execucao_assistencial` | 🟢 Alinhada |
| `sp_executor_assistencial_atendimento_finalizar` | 🟢 Alinhada |
| `atendimento_evento` | 🟢 Schema completo |
| `atendimento_diagnostico` | 🟢 Schema real respeitado |
| Backend (`DispatcherService`) | 🟢 Contrato fechado |
| Backend (`DispatcherController`) | 🟢 Erros propagados |
| Migration idempotência | 🟢 Aplicada |

---

**Fim do documento.**

**Definição real da tabela:**
```sql
CREATE TABLE `atendimento_evento` (
    ...
    `id_entidade` bigint unsigned NOT NULL,  -- ✅ Coluna correta
    ...
);
```

**Impacto:**
- 🚨 **Bloqueia toda execução do Dispatcher**
- `sp_master_dispatcher` chama `sp_master_registrar_evento` antes de executar qualquer domínio
- Nenhum comando consegue passar pelo Dispatcher

**Cenário:** O banco real está com a coluna `id_entidade`, mas a SP foi alterada para usar `id_saas_entidade` (ou o dump está desatualizado em relação à SP).

---

### 2. 🟡 MÉDIA — Tabela `atendimento_evento` no dump tem estrutura diferente da real

**Comparação de colunas:**

| # | Coluna | Dump | Banco Real | Status |
|---|--------|------|------------|--------|
| 1 | `id_evento` | bigint NOT NULL AUTO_INCREMENT | bigint NO auto_increment | ✅ |
| 2 | `id_unidade` | bigint unsigned NOT NULL | bigint unsigned NO | ✅ |
| 3 | `id_ffa` | bigint DEFAULT NULL | bigint YES NULL | ✅ |
| 4 | `id_atendimento` | bigint unsigned NOT NULL | bigint unsigned NO | ✅ |
| 5 | `id_paciente` | bigint DEFAULT NULL | bigint YES NULL | ✅ |
| 6 | `dominio` | varchar(40) NOT NULL | varchar(40) NO | ✅ |
| 7 | `tipo_evento` | varchar(60) NOT NULL | varchar(60) NO | ✅ |
| 8 | `estado_origem` | varchar(40) DEFAULT NULL | varchar(40) YES NULL | ✅ |
| 9 | `estado_destino` | varchar(40) DEFAULT NULL | varchar(40) YES NULL | ✅ |
| 10 | `contexto_fluxo` | varchar(60) DEFAULT NULL | varchar(60) YES NULL | ✅ |
| 11 | `payload` | json DEFAULT NULL | json YES NULL | ✅ |
| 12 | `id_sessao_usuario` | bigint DEFAULT NULL | bigint YES NULL | ✅ |
| 13 | `id_usuario` | bigint DEFAULT NULL | bigint YES NULL | ✅ |
| 14 | `hash_evento` | char(64) DEFAULT NULL | char(64) YES NULL | ✅ |
| 15 | `criado_em` | datetime(6) DEFAULT CURRENT_TIMESTAMP(6) | datetime(6) YES DEFAULT_GENERATED | ✅ |
| 16 | `id_entidade` | bigint unsigned NOT NULL | bigint unsigned NO | ✅ |
| 17 | `id_saas_entidade` | **NÃO EXISTE** | **NÃO EXISTE** | ⚠️ N/A |

**Conclusão:** A tabela `atendimento_evento` no dump tem a coluna correta `id_entidade`. A SP no banco real está usando uma coluna inexistente `id_saas_entidade`.

---

## Análise de Causa Raiz

### Hipótese 1 — SP foi alterada no banco real

A SP `sp_master_registrar_evento` foi modificada para usar `id_saas_entidade`, mas a tabela não foi alterada correspondentemente.

**Evidência:**
- SP no banco real usa `id_saas_entidade`
- Tabela real tem `id_entidade`
- Dump canônico tem `id_entidade`

### Hipótese 2 — Dump está desatualizado

O dump pode refletir uma versão anterior onde a coluna era `id_saas_entidade`, e o banco foi atualizado para `id_entidade` sem atualizar o dump.

**Evidência:**
- Dump tem `id_entidade`
- Tabela real tem `id_entidade`
- SP real usa `id_saas_entidade`

**Hipótese mais provável:** A SP foi alterada no banco real sem correspondente alteração na tabela.

---

## Impacto no Dispatcher

| Camada | Status | Observação |
|--------|--------|------------|
| Backend | 🟢 OK | `DispatcherService.ts` com contrato correto |
| Rota `/dispatcher/` | 🟢 OK | Respondendo corretamente |
| `sp_master_dispatcher` | 🟡 OK | Executa até chamar `sp_master_registrar_evento` |
| `sp_master_registrar_evento` | 🔴 BLOQUEADO | INSERT usa coluna inexistente |
| `atendimento_evento` | 🟡 OK | Tabela existe, mas com coluna diferente |

---

## Recomendações

### Opção A — Corrigir a SP (recomendado)

Alterar `sp_master_registrar_evento` para usar `id_entidade` ao invés de `id_saas_entidade`.

```sql
-- Antes
INSERT INTO atendimento_evento (id_saas_entidade, ...) VALUES (v_id_saas, ...);

-- Depois
INSERT INTO atendimento_evento (id_entidade, ...) VALUES (v_id_saas, ...);
```

**Vantagem:** Alinha SP com tabela real.
**Risco:** Baixo. Apenas renomeação de coluna no INSERT.

---

### Opção B — Alterar a tabela

Adicionar coluna `id_saas_entidade` na tabela `atendimento_evento`.

```sql
ALTER TABLE atendimento_evento ADD COLUMN id_saas_entidade bigint unsigned NOT NULL;
```

**Vantagem:** Mantém SP como está.
**Risco:** Médio. Altera schema de tabela crítica de eventos.

---

### Opção C — Atualizar dump canônico

Se a decisão for manter `id_saas_entidade`, atualizar o dump para refletir a alteração.

**Vantagem:** Dump fica alinhado com banco real.
**Risco:** Baixo, mas requer validação de impacto.

---

## Próximos Passos

1. **Decidir qual opção seguir** (recomenda-se Opção A)
2. Aplicar correção no banco real
3. Re-executar smoke test
4. Atualizar dump canônico se necessário
5. Gerar migration se houver alteração de schema

---

## Evidências Coletadas

| Objeto | Dump | Banco Real | Divergente |
|--------|------|------------|------------|
| `atendimento_evento.tipo_evento` | ✅ Existe | ✅ Existe | ❌ Não |
| `atendimento_evento.id_entidade` | ✅ Existe | ✅ Existe | ❌ Não |
| `atendimento_evento.id_saas_entidade` | ❌ Não existe | ❌ Não existe | ❌ Não |
| `sp_master_registrar_evento` | Usa `id_entidade` | Usa `id_saas_entidade` | ✅ SIM |

---

**Fim do documento.**
