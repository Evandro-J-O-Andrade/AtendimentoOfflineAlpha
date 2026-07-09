# GATE FRONT-001 — Discovery (Fronteend)

## Status: **APROVADO** ✅ (FASE 0.1 oficialmente congelada)

Data: 2026-07-09
Responsável: Kilo (descoberta) + Gemini (análise arquitetural) + Projeto (fonte da verdade)

FASE 0.1 é a **descoberta da estrutura real** do frontend, antes de qualquer análise visual
ou proposta de código. Esta gate congela o estado descoberto.

---

## Checklist de Fechamento

| Item                                  | Status | Evidência                                                      |
| :------------------------------------ | :----- | :------------------------------------------------------------- |
| Estrutura real mapeada                | ✅     | `frontend-inventory.md` (monorepo pnpm: `apps/`, `packages/`)  |
| Packages reais inventariados          | ✅     | `contracts`(20), `runtime`(11), `auth`(6), `api`(5); 14 vazios |
| Apps reais inventariados              | ✅     | `portal`(58 arquivos); `admin/displays/intranet/mobile` vazios |
| Contracts reais mapeados              | ✅     | `packages/contracts/src/**` (Widget/Dashboard/PortalRuntime/…) |
| Runtime encontrado                    | ✅     | `PortalRuntimeEngine`, `PortalRuntimeBuilder`, `PortalApi`     |
| Duplicações removidas                 | ✅     | removido `docs/canonical/FRONTEND-INVENTORY.md` (inventário duplicado) |
| Arquivos órfãos removidos             | ✅     | removidos 3 TSX/CSS vazios de `docs/database/procedures_raw_texts/` |

---

## Regras desta Gate

1. **Nenhum código (TSX/CSS/componente/pasta) foi criado na FASE 0.1.** Apenas documentos de
   descoberta factual.
2. A fonte da verdade é a **árvore real do projeto**, não documentação ou inferência.
3. Inventário único: `frontend-inventory.md` (raiz). Não há segundo inventário.
4. O backend (`sp_auth_permissions_evaluate.sql`) é artefato oficial do CORE-005 (ADAPT),
   não arquivo órfão — mantido em `docs/database/procedures_raw_texts/`.

---

## Saída autorizada

- `frontend-inventory.md` — inventário real (FASE 0.1)
- `frontend-runtime-discovery.md` — discovery do runtime (FASE 0.2, concluída)
- `docs/engineering/runtime-map.md` — mapa técnico de fluxo do runtime

## Próximo passo

FASE 1 — Análise das imagens (`docs/design/dashboard/`) → `frontend-analysis.md`
(REUSE / ADAPT / EXTEND / PROPOSE), respeitando o GATE FRONT-002.
