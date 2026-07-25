# Auditoria de Stored Procedures — Dump Canônico vs Banco Real

**Data:** 2026-07-25  
**Status:** Em auditoria — nenhuma migration aplicada até aprovação  
**Escopo:** SPs afetadas pelo Dispatcher e domínio Assistencial  

---

## Metodologia

1. Comparar definição do dump canônico (`database/dump/Dump20260618.sql`) com o banco real (`pronto_atendimento`).
2. Identificar divergências de assinatura, colunas e lógica.
3. Classificar cada SP: REUSE / ADAPT / PROPOSE.
4. Propor ação somente após validação.

---

## SPs Auditadas

| # | SP | Existe no dump | Existe no banco real | Classificação |
|---|----|----------------|----------------------|---------------|
| 1 | `sp_master_registrar_evento` | Sim | Sim | ADAPT |
| 2 | `sp_master_dispatcher` | Sim | Sim | ADAPT |
| 3 | `sp_master_assistencial_salvar_orquestradora` | Sim | Sim | ADAPT |
| 4 | `sp_orquestrador_assistencial` | Sim | Sim | ADAPT |
| 5 | `sp_execucao_assistencial` | Sim | Sim | ADAPT |
| 6 | `sp_executor_assistencial_atendimento_finalizar` | Sim | Sim | ADAPT |

---

## Divergências Encontradas

### 1. `sp_master_registrar_evento`

| Aspecto | Dump canônico | Banco real | Realidade do banco |
|---------|---------------|------------|---------------------|
| Assinatura | Igual | Igual | Mantida |
| INSERT em `atendimento_evento` | `id_saas_entidade` | `id_saas_entidade` | Tabela real tem `id_entidade` |
| `uuid_transacao` no INSERT | Não | Não | Tabela real não tem `id_saas_entidade`, mas ganhou `uuid_transacao` via migration |

**Classificação:** ADAPT  
**Motivo:** Dump canônico também usa `id_saas_entidade`, então ambos estão divergentes do schema real. A correção alinha dump, banco e SPs.

**Ação proposta:** 
- Alterar INSERT para usar `id_entidade`
- Adicionar `uuid_transacao` ao INSERT
- Atualizar dump canônico posteriormente

---

### 2. `sp_master_dispatcher`

| Aspecto | Dump canônico | Banco real | Realidade do banco |
|---------|---------------|------------|---------------------|
| Assinatura | Igual | Igual | Mantida |
| SELECT de `sessao_usuario` | `id_saas_entidade, id_painel` | `id_saas_entidade, id_painel` | Tabela real tem `id_entidade`, não tem `id_painel` |
| Handler de erro | `tipo_evento` em `erro_evento` | `tipo_evento` em `erro_evento` | Tabela `erro_evento` não tem `tipo_evento` |
| Idempotência | Não implementada | Não implementada | Migration aplicada para adicionar `uuid_transacao` |

**Classificação:** ADAPT  
**Motivo:** Dump canônico também está divergente do schema real.

**Ação proposta:**
- Alterar SELECT para `id_entidade`
- Remover `id_painel`
- Corrigir handler de erro para usar colunas existentes em `erro_evento`
- Adicionar verificação de idempotência usando `uuid_transacao`

---

### 3. `sp_master_assistencial_salvar_orquestradora`

| Aspecto | Dump canônico | Banco real | Realidade do banco |
|---------|---------------|------------|---------------------|
| Assinatura | Igual | Igual | Mantida |
| INSERT dinâmico | `id_saas_entidade` | `id_saas_entidade` | Tabelas de domínio usam `id_entidade` |
| INSERT em `atendimento_evento` | `id_saas_entidade` | `id_saas_entidade` | Tabela usa `id_entidade` |

**Classificação:** ADAPT  
**Motivo:** Dump canônico usa `id_saas_entidade`, mas tabelas reais usam `id_entidade`.

**Ação proposta:**
- Alterar INSERT dinâmico para `id_entidade`
- Alterar INSERT em `atendimento_evento` para `id_entidade`

---

### 4. `sp_orquestrador_assistencial`

| Aspecto | Dump canônico | Banco real | Realidade do banco |
|---------|---------------|------------|---------------------|
| Assinatura | Igual | Igual | Mantida |
| INSERT em `atendimento_evento` | `id_saas_entidade` | `id_saas_entidade` | Tabela usa `id_entidade` |

**Classificação:** ADAPT  
**Motivo:** Mesma divergência de nomenclatura.

**Ação proposta:**
- Alterar INSERT para `id_entidade`

---

### 5. `sp_execucao_assistencial`

| Aspecto | Dump canônico | Banco real | Realidade do banco |
|---------|---------------|------------|---------------------|
| Assinatura | Igual | Igual | Mantida |
| INSERT em `atendimento_evento` | `id_saas_entidade` | `id_saas_entidade` | Tabela usa `id_entidade` |

**Classificação:** ADAPT  
**Motivo:** Mesma divergência.

**Ação proposta:**
- Alterar INSERT para `id_entidade`

---

### 6. `sp_executor_assistencial_atendimento_finalizar`

| Aspecto | Dump canônico | Banco real | Realidade do banco |
|---------|---------------|------------|---------------------|
| Assinatura | Igual | Igual | Mantida |
| INSERT em `atendimento_evolucao` | `id_saas_entidade` | `id_saas_entidade` | Tabela usa `id_entidade` |
| INSERT em `atendimento_diagnostico` | `id_saas_entidade, id_unidade, id_ffa, id_usuario, id_sessao_usuario, ip_origem, device_info` | `id_saas_entidade, id_unidade, id_ffa, id_usuario, id_sessao_usuario, ip_origem, device_info` | Tabela real tem apenas `id_atendimento, codigo_cid, descricao, principal, criado_em, id_entidade` |
| UPDATE em `atendimento` | `status_atendimento = 'FINALIZADO', data_fechamento` | `status_atendimento = 'FINALIZADO', data_fechamento` | Tabela real tem `status_execucao, finalizado_em` |

**Classificação:** ADAPT  
**Motivo:** Dump canônico também está divergente do schema real em múltiplos pontos.

**Ação proposta:**
- Alterar INSERT em `atendimento_evolucao` para `id_entidade`
- Remover colunas inexistentes do INSERT em `atendimento_diagnostico`
- Alterar UPDATE para usar `status_execucao = 'CONCLUIDO'` e `finalizado_em`

---

## Resumo da Auditoria

| SP | Classificação | Motivo |
|----|---------------|--------|
| `sp_master_registrar_evento` | ADAPT | Dump usa `id_saas_entidade`, real usa `id_entidade` |
| `sp_master_dispatcher` | ADAPT | Dump usa `id_saas_entidade` e `id_painel`, real usa `id_entidade` |
| `sp_master_assistencial_salvar_orquestradora` | ADAPT | Dump usa `id_saas_entidade`, real usa `id_entidade` |
| `sp_orquestrador_assistencial` | ADAPT | Dump usa `id_saas_entidade`, real usa `id_entidade` |
| `sp_execucao_assistencial` | ADAPT | Dump usa `id_saas_entidade`, real usa `id_entidade` |
| `sp_executor_assistencial_atendimento_finalizar` | ADAPT | Dump usa schema divergente em `atendimento_diagnostico` e `atendimento` |

**Nenhuma SP nova foi criada.**  
**Todas as divergências são de alinhamento entre dump canônico, banco real e schema.**

---

## Padrão Encontrado

```text
Dump canônico: id_saas_entidade
Banco real:    id_entidade
SPs:           id_saas_entidade (herdado do dump)
```

**Conclusão:** O dump canônico está desatualizado em relação ao banco real. As SPs herdaram essa divergência.

---

## Próximos Passos

1. **Aprovar este relatório**
2. **Gerar pacote de migrations** contendo apenas as diferenças reais
3. **Atualizar o dump canônico** após aplicação das migrations
4. **Re-executar suíte de regressão** para confirmar

---

**Fim do documento.**
