# FUNCTIONS.md — Inventário Vivo de Funções

> Seed 2026-07-09. Fonte: `database/dump/Dump20260618.sql`.
> ⚠️ **Parcial:** apenas funções referenciadas por SPs já mapeados estão confirmadas.
> Completar com leitura de `CREATE FUNCTION` no dump (TODO FASE DUMP-001 contínuo).

## Funções confirmadas (evidência)

### fn_decision_fingerprint
- **Responsabilidade:** Gerar fingerprint de decisão para idempotência/roteamento
- **Usada por:** `sp_dispatcher_kernel` (parâmetros: `p_acao`, `p_id_tenant`, `p_id_usuario`, `p_payload`)
- **Domínio:** Kernel / Runtime
- **Status:** REUSE

## Funções prováveis (a confirmar no dump)
- `fn_*` ligadas a `sp_codigo_*` (prefixo/resolução de código externo)
- funções de hash/validação usadas por `sp_assistencial_evento_hash`, `assistencial_evento_hash`
- funções de `kernel_identity_trust_chain` (trust chain)

> Regra: antes de criar qualquer `fn_*`, procurar aqui e em `CALL-GRAPH.md`. Não duplicar
> lógica de fingerprint/hash/validação já existente.
