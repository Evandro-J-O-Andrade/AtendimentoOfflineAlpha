# Auditoria de Impacto — `sp_master_registrar_evento`

**Data:** 2026-07-25  
**Status:** 🔴 Divergência confirmada — não é apenas nomenclatura  
**SP analisada:** `sp_master_registrar_evento`  
**Referência:** `docs/DATABASE_SCHEMA_ALIGNMENT_REPORT.md`  

---

## Achado Principal

A SP usa coluna `id_saas_entidade` em tabelas que possuem `id_entidade`.

Não é uma troca simples de nome. É um desalinhamento estrutural que afeta múltiplas SPs.

---

## Padrão do Banco Real

| Tabela | Coluna correta |
|--------|---------------|
| `atendimento` | `id_saas_entidade` |
| `atendimento_evento` | `id_entidade` |
| `atendimento_evolucao` | `id_entidade` |
| `atendimento_triagem` | `id_entidade` |
| `atendimento_anamnese` | `id_entidade` |
| `atendimento_diagnostico` | `id_entidade` |
| `ffa` | `id_entidade` |
| `coordenador_estado_global` | `id_saas_entidade` |
| `guardiao_runtime_final` | `id_saas_entidade` |
| `runtime_invariant_log` | `id_saas_entidade` |

**Conclusão:** O banco usa `id_saas_entidade` em tabelas de runtime/coordenador, e `id_entidade` em tabelas de domínio/evento.

---

## SPs Afetadas pela Divergência

| SP | Tabela afetada | Coluna usada pela SP | Coluna real na tabela | Status |
|----|----------------|----------------------|----------------------|--------|
| `sp_master_registrar_evento` | `atendimento_evento` | `id_saas_entidade` | `id_entidade` | 🔴 ERRO |
| `sp_execucao_assistencial` | `atendimento_evento` | `id_saas_entidade` | `id_entidade` | 🔴 ERRO |
| `sp_master_assistencial_salvar_orquestradora` | `atendimento_evento` | `id_saas_entidade` | `id_entidade` | 🔴 ERRO |
| `sp_orquestrador_assistencial` | `atendimento_evento` | `id_saas_entidade` | `id_entidade` | 🔴 ERRO |

**Total:** 4 SPs críticas bloqueadas por esta divergência.

---

## Causa Raiz

As SPs foram escritas assumindo que todas as tabelas usam `id_saas_entidade`, mas o banco real separa:

- **Tabelas de domínio/evento:** `id_entidade`
- **Tabelas de runtime/coordenador:** `id_saas_entidade`

Isso provavelmente ocorreu porque:
1. O modelo inicial usava `id_saas_entidade` em todas as tabelas
2. O banco foi alterado para `id_entidade` nas tabelas de domínio
3. As SPs não foram atualizadas

---

## Opções de Correção

### Opção A — Alterar SPs para usar `id_entidade` nas tabelas de domínio/evento

**Ação:** Modificar as 4 SPs para usar `id_entidade` ao invés de `id_saas_entidade` nas tabelas `atendimento_evento`, `atendimento_evolucao`, `atendimento_triagem`, `atendimento_anamnese`.

**Vantagem:** Alinha com o schema real.
**Risco:** Baixo. Apenas renomeação de coluna no INSERT.
**Impacto:** Desbloqueia todo o fluxo do Dispatcher.

### Opção B — Alterar tabelas para adicionar `id_saas_entidade`

**Ação:** Adicionar coluna `id_saas_entidade` em todas as tabelas de domínio/evento.

**Vantagem:** Mantém SPs como estão.
**Risco:** Alto. Altera schema de dezenas de tabelas.
**Impacto:** Duplicação de colunas (`id_entidade` + `id_saas_entidade`).

### Opção C — Manter como está e criar adapter no banco

**Ação:** Criar uma SP fachada que faz o mapeamento.

**Vantagem:** Isola a divergência.
**Risco:** Alto. Aumenta complexidade e camadas.
**Impacto:** Não resolve o problema estrutural.

---

## Recomendação

**Opção A** — Alterar as SPs afetadas para usar `id_entidade` nas tabelas de domínio/evento.

Justificativa:
- Alinha com o schema canônico do banco
- Menor risco de alteração
- Desbloqueia o Dispatcher imediatamente
- Mantém `id_saas_entidade` apenas onde realmente existe no banco

---

## SPs a Corrigir

| Ordem | SP | Tabela | Alteração |
|-------|----|--------|-----------|
| 1 | `sp_master_registrar_evento` | `atendimento_evento` | `id_saas_entidade` → `id_entidade` |
| 2 | `sp_execucao_assistencial` | `atendimento_evento` | `id_saas_entidade` → `id_entidade` |
| 3 | `sp_master_assistencial_salvar_orquestradora` | `atendimento_evento` | `id_saas_entidade` → `id_entidade` |
| 4 | `sp_orquestrador_assistencial` | `atendimento_evento` | `id_saas_entidade` → `id_entidade` |

---

## Próximos Passos

1. Aprovar esta análise
2. Corrigir `sp_master_registrar_evento` (prioridade máxima — bloqueia Dispatcher)
3. Corrigir `sp_execucao_assistencial`
4. Corrigir `sp_master_assistencial_salvar_orquestradora`
5. Corrigir `sp_orquestrador_assistencial`
6. Re-executar smoke test
7. Atualizar dump canônico se necessário

---

**Fim do documento.**
