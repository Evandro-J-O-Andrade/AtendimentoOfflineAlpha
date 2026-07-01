# ESTADO DA DOCUMENTAÇÃO — DUMP20260606.PRONTO_ATENDIMENTO
**Banco real:** `pronto_atendimento` (Dump20260606.sql)  
**Descartado como fonte principal:** `portal_schema.sql` (é um schema separado/histórico, não o alvo atual)  
**Data:** 2026-07-01  
**Status:** CHECKLIST CONCLUÍDO | INVENTÁRIO CONSOLIDADO | CATÁLOGOS GERADOS | PRÓXIMO: DOCUMENTAÇÃO DETALHADA

---

## CHECKLIST DE INTEGRIDADE CANÔNICA — RESULTADO

### Documentos canônicos
- **MDs:** 132 | **MAPs:** 45 | **BRs:** 5 | **FRONTs:** 83 | **ADRs:** 3

### Banco real vs documentação
- **478 tabelas** no dump
- **0 procedures/views/functions/triggers/events** no dump (schema + dados apenas)
- **481 docs de tabela** existentes em `docs/database/tables/` → **3 são extras** (INVENTARIO_COMPLETO, portal_categoria, portal_noticia)
- **228 procedures documentadas** em `docs/database/procedures/`
- **501 nomes de procedures** distintos no código fonte
- **0 views/functions/triggers/events** documentadas

### Conclusões do checklist
- ✅ 475 tabelas do dump estão documentadas corretamente
- ✅ 3 tabelas extras movidas para `docs/database/tables/_extra_nao_dump/`
- ⚠️ ~273 procedures faltantes (código referencia 501; docs tem 228; algumas são variações de nome)
- ⚠️ TODAS as 228 procedures têm objetivo genérico: *"conforme definida no dump SQL"*
- ❌ 0 views, functions, triggers, events documentados
- ❌ Nenhum ERD/dependência/fluxo documentado
- ✅ **INVENTARIO_PROCEDURES.md** gerado — inventário consolidado de 228 procedures
- ✅ **MAPA_DEPENDENCIAS_ERD.md** gerado — matriz de dependências e ordem de migrations
- ✅ **CATALOGO_ENTIDADES_CORE.md** gerado — classificação por domínio (478 tabelas)
- ✅ **MAPA_ESCRITA.md** gerado — mapa SP-First de escrita por tabela
- ✅ **MAPA_CONSUMO_MODULOS.md** gerado — consumo por módulo com fluxos concretos

---

## PRÓXIMOS PASSOS (ETAPAS)

1. ✅ **Remover/mover** as 3 tabelas extras de `docs/database/tables/`
2. ✅ **Inventário paralelo:**
    - Procedures faltantes no código
    - Views/Functions/Triggers/Events
    - Gargalos e duplicações
    - Mapa de dependências
3. 🔄 **Documentar 100% das tabelas** (com objetivo, colunas, FKs, índices, fluxo)
   - Melhorar docs existentes com detalhes reais do dump
   - Gerar ERD por domínio
4. 🔄 **Documentar 100% das procedures** (com objetivo real, fluxo, parâmetros, validações, transações)
   - Detalhar as 228 procedures existentes
   - Documentar as ~273 procedures faltantes
   - Gerar catálogo completo de procedures com consumo
5. ⏳ **Documentar views/functions/triggers/events**
6. ⏳ **Gerar blueprints, ERD, fluxos, domínios, MDs/BRs/MAPs/FRONTs**
   - Gerar MDs canônicos alinhados ao banco real
   - Gerar MAPs de domínio e fluxo
   - Gerar BRs das procedures principais
   - Gerar FRONTs de consumo (Login, Portal, HIS, etc.)

---

## ÂNCORA CONTEXTUAL
- Este arquivo resume o estado atual para continuidade.
- Qualquer IA deve lê-lo antes de prosseguir.
- Não recriar documentos existentes.
- Atualizar apenas o que falta.
