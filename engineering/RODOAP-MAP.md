# PROJECT ROADMAP — POST KILO FREEZE

## ✅ FASES CONCLUÍDAS

| FASE | OBJETIVO | STATUS |
|------|---------|--------|
| FASE 00 | Leis Canônicas | ✅ CONCLUÍDA |
| FASE 01 | Arquitetura Base | ✅ CONCLUÍDA |
| FASE 02 | KILO ENGINE v7 | ✅ CONGELADO |

---

## 🔄 FASES PENDENTES

| FASE | OBJETIVO | DESCRIÇÃO |
|------|---------|---------|
| FASE 03 | DISCOVERY | Analisar todos os dumps |
| FASE 04 | INVENTORY | Inventory completo (tabelas, SPs, eventos, FKs) |
| FASE 05 | METADATA | Grafos e mapeamentos de domínio |
| FASE 06 | CANONICAL SYNC | Atualizar/criar arquivos canônicos |
| FASE 07 | MDS | Sync dos MDs baseados no dump |
| FASE 08 | BRS | Derivar regras de negócio |
| FASE 09 | MAPS | Mapear domínios arquiteturais |
| FASE 10 | FRONTS | Contratos de UI |
| FASE 11 | CONTRACTS | SP/API/Database/Events contracts |
| FASE 12 | BACKEND | NodJS/NestJS stubs |
| FASE 13 | FRONTEND | React/Next.js contracts |
| FASE 14 | MOBILE | React Native contracts |
| FASE 15 | CI/CD | integração contínua |

---

## 🎯 PROXIMA ETAPA

**FASE 03 — DISCOVERY**

Aguardando: DUMP FILES

Formato esperado:
```
engineering/dumps/*.sql
engineering/dumps/*.json
```

---

## 🧬 FLUXO OFICIAL POR DOMÍNIO

```
Discovery
   ↓
Inventory
   ↓
Domain Detection
   ↓
Canonical Mapping
   ↓
MD Sync
   ↓
BR Derivation
   ↓
MAP Creation
   ↓
FRONT Generation
   ↓
Contract Generation
   ↓
Review/Aprovação
```

---

## 🔑 REGRAS ARQUITETURAIS

- SP-First: toda regra em SP
- Event-Driven: kernel_ledger obrigatório
- Dump-First: dump é fonte primária
- Pessoa Raiz: pessoa → usuario → sessão
- Portal First: Portal → Contexto → Apps
- Auto Sync: KILO mantém documentação viva

---

*FCA/MIDAS Enterprise Architecture - KILO ENGINE v7*