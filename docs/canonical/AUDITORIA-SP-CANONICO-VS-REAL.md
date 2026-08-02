# Auditoria de Stored Procedures — Dump Canônico vs Dump Real

**Data:** 2026-07-26  
**Status:** Em auditoria — nenhuma migration aplicada até aprovação  
**Escopo:** SPs afetadas pelo Dispatcher e domínio Assistencial + Auditoria completa de 225 SPs

---

## Metodologia

1. Comparar definição do dump canônico (`database/dump/Dump20260618.sql`) com o dump real (`database/dump/Dump20260726.sql`).
2. Identificar divergências de assinatura, colunas e lógica.
3. Classificar cada SP: REUSE / ADAPT / PROPOSE.
4. Propor ação somente após validação.

---

## Resultado Global

| Métrica | Valor |
|---------|-------|
| SPs no dump canônico | 225 |
| SPs no dump real | 226 |
| SPs em comum | 225 |
| SPs apenas no dump real | 1 (`sp_auth_permissions_evaluate`) |
| SPs divergentes | **7** |
| SPs idênticas | 218 |

---

## SPs Divergentes

### 1. `sp_master_login`

| Aspecto | Dump canônico | Dump real |
|---------|---------------|-----------|
| `SQL SECURITY INVOKER` | Presente | Removido |
| Comentários de seção | Presentes | Removidos |

**Classificação:** ADAPT  
**Motivo:** Produção removeu `SQL SECURITY INVOKER` e comentários.

**Ação proposta:**
- Remover `SQL SECURITY INVOKER` do canônico
- Remover comentários de seção do canônico

---

### 2. `sp_auth_contexto_get`

| Aspecto | Dump canônico | Dump real |
|---------|---------------|-----------|
| `collation_connection` | `utf8mb4_0900_ai_ci` | `utf8mb4_unicode_ci` |
| `sql_mode` | Sem `IGNORE_SPACE` | Com `IGNORE_SPACE` |
| Comentários | Com acentos (ex: `SESSÃO`) | Sem acentos (ex: `SESSAO`) |
| Lógica | Idêntica | Idêntica |

**Classificação:** ADAPT  
**Motivo:** Produção ajustou collation, sql_mode e removeu acentos de comentários.

**Ação proposta:**
- Alinhar `collation_connection` para `utf8mb4_unicode_ci`
- Adicionar `IGNORE_SPACE` ao `sql_mode`
- Remover acentos dos comentários

---

### 3. `sp_auth_contexto_set`

| Aspecto | Dump canônico | Dump real |
|---------|---------------|-----------|
| `collation_connection` | `utf8mb4_0900_ai_ci` | `utf8mb4_unicode_ci` |
| `sql_mode` | Sem `IGNORE_SPACE` | Com `IGNORE_SPACE` |
| Comentários | Com acentos | Sem acentos |
| Lógica | Idêntica | Idêntica |

**Classificação:** ADAPT  
**Motivo:** Mesmo padrão de `sp_auth_contexto_get`.

**Ação proposta:**
- Alinhar `collation_connection` para `utf8mb4_unicode_ci`
- Adicionar `IGNORE_SPACE` ao `sql_mode`
- Remover acentos dos comentários

---

### 4. `sp_master_dispatcher`

| Aspecto | Dump canônico | Dump real |
|---------|---------------|-----------|
| Declaração de variáveis | `v_id_painel` presente | `v_id_painel` removido |
| Comentários | Presentes | Removidos |

**Classificação:** ADAPT  
**Motivo:** Produção removeu variável `v_id_painel` (não utilizada) e comentários.

**Ação proposta:**
- Remover `v_id_painel` da declaração
- Remover comentários de seção

---

### 5. `sp_master_assistencial_salvar_orquestradora`

| Aspecto | Dump canônico | Dump real |
|---------|---------------|-----------|
| Parâmetros | Com comentários inline | Sem comentários inline |
| Comentários de seção | Presentes | Removidos |

**Classificação:** ADAPT  
**Motivo:** Produção removeu comentários inline e de seção.

**Ação proposta:**
- Remover comentários inline dos parâmetros
- Remover comentários de seção

---

### 6. `sp_orquestrador_assistencial`

| Aspecto | Dump canônico | Dump real |
|---------|---------------|-----------|
| Comentários de bloco | Presentes | Removidos |
| Formatação SQL | Com quebras de linha extras | Compactada |

**Classificação:** ADAPT  
**Motivo:** Produção removeu comentários de bloco e ajustou formatação.

**Ação proposta:**
- Remover comentários de bloco
- Compactar formatação SQL

---

### 7. `sp_executor_assistencial_atendimento_finalizar`

| Aspecto | Dump canônico | Dump real |
|---------|---------------|-----------|
| Declaração de variáveis | `v_id_unidade`, `v_id_saas` presentes | Removidas |
| Comentários de seção | Presentes | Removidos |

**Classificação:** ADAPT  
**Motivo:** Produção removeu variáveis não utilizadas e comentários.

**Ação proposta:**
- Remover `v_id_unidade` e `v_id_saas` das declarações
- Remover comentários de seção

---

## SP Nova no Dump Real

| SP | Situação |
|----|----------|
| `sp_auth_permissions_evaluate` | PROPOSE — Nova SP não presente no dump canônico |

---

## SPs Reutilizáveis (218)

Todas as demais SPs (225 comuns - 7 divergentes = 218) estão **idênticas** entre o dump canônico e o dump real.

---

## Padrão Encontrado

```text
Maioria das SPs: IDÊNTICAS
Divergências: Comentários, formatação, collation e sql_mode
Mudanças reais: Remoção de variáveis não utilizadas (v_id_painel, v_id_unidade, v_id_saas)
SP nova: sp_auth_permissions_evaluate
```

**Conclusão:** O dump canônico está majoritariamente alinhado com o banco real. As divergências são de refatoração cosmética e remoção de código morto.

---

## Próximos Passos

1. **Aprovar este relatório**
2. **Gerar pacote de migrations** contendo apenas as diferenças reais
3. **Atualizar o dump canônico** após aplicação das migrations
4. **Re-executar suíte de regressão** para confirmar

---

**Fim do documento.**
