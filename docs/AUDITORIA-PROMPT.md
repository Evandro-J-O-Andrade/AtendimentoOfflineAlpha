# Prompt Padrão para Auditorias

Este prompt deve ser usado como base para todas as auditorias do projeto.

---

## Instruções Obrigatórias

Antes de iniciar qualquer auditoria, leia obrigatoriamente:

1. `docs/canonical/MD-000-Constituicao-Arquitetural.md` — Fonte de verdade arquitetural
2. MDs específicos da área analisada
3. `MYSQLBANCO.md` — Especificação do banco
4. `database/dump/Dump20260618.sql` — Implementação SQL (quando necessário)
5. `backend/src/` — Implementação backend
6. `packages/` — Implementação frontend

---

## Ordem de Análise

Sempre seguir esta ordem:

```
MD-000 (Constituição)
    ↓
MDs específicos
    ↓
MYSQLBANCO.md
    ↓
Dump SQL / SPs
    ↓
Backend
    ↓
Frontend
```

**Nunca analisar o código antes de entender a arquitetura documentada.**

---

## Regras de Auditoria

1. **Banco é fonte da verdade da regra de negócio**
   - Não conclusões baseadas apenas em React/TypeScript
   - Stored Procedures são a autoridade final

2. **Todo fluxo deve ser mapeado**
   - Frontend → Endpoint → Controller → Service → SP → Tabela

3. **Toda conclusão deve informar:**
   - Regra arquitetural usada
   - Documento de origem
   - Evidência encontrada (arquivo/linha ou SP)
   - Status: ✅ Conforme / 🟡 Parcial / 🔴 Divergente / ⚪ Não materializado

4. **Proibido:**
   - Assumir REST tradicional sem confirmar nos MDs
   - Assumir controller como regra de negócio
   - Sugerir mudança sem rastrear MD de origem
   - Criar arquitetura nova

---

## Template de Saída

```markdown
# Auditoria: [NOME]

**Data:** YYYY-MM-DD  
**Auditor:** Kilo  
**Status:** Em andamento / Concluída  

---

## Ordem de Leitura

1. ✅ MD-000
2. ✅ MD-[ESPECÍFICO]
3. ✅ MYSQLBANCO.md
4. ✅ Dump SQL
5. ✅ Backend
6. ✅ Frontend

---

## Achados

| # | Item | Status | Observação |
|---|------|--------|------------|
| 1 | [Achado 1] | ✅/🟡/🔴/⚪ | [Detalhe] |

---

## Conclusão

[Resumo executivo]

---

## Próximos Passos

1. [Ação 1]
2. [Ação 2]
```

---

## Exemplo de Uso

```
Auditoria: Master SP Architecture

Antes de iniciar qualquer auditoria:

Leia obrigatoriamente:

1. docs/canonical/MD-000-Constituicao-Arquitetural.md

Depois:

2. MDs específicos da área analisada
3. MYSQLBANCO.md
4. Dump SQL quando necessário
5. Backend
6. Frontend

Toda conclusão deve informar:
- Regra arquitetural usada
- Documento de origem
- Evidência encontrada
- Status: ✅ Conforme / 🟡 Parcial / 🔴 Divergente / ⚪ Não materializado

Nunca analisar código antes de entender a arquitetura documentada.
```

---

**Fim do documento.**
