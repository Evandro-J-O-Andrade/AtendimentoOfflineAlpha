# KILO v6.1 — AUTO CODE GENERATOR ENGINE

## 🎯 OBJETIVO
Transformar automaticamente: DUMP → MDs → BRs → FRONTs

---

## 📦 PIPELINE PRINCIPAL

```
DUMP FILES
   ↓
STRUCTURE PARSER
   ↓
CALL GRAPH BUILDER
   ↓
DOMAIN CLUSTERING
   ↓
MD GENERATOR
   ↓
BR GENERATOR
   ↓
FRONT GENERATOR
```

---

## 🧠 TEMPLATES AUTOMÁTICOS

### MD Template
```md
# MD-XXX — <DOMAIN>

## ENTIDADES
- TABELA: nome (PK/FK usos)

## SPSS
- sp_xxx (TIPO + FUNÇÃO)

## FLUXO
Frontend → SP → TABLE → EVENT

## REGRAS
- BR-XXX vinculada
```

### BR Template  
```md
# BR-XXX — <REGRA>

## GATILHO
SP: sp_xxx

## VALIDAÇÕES
READS/WITES/EVENTS

## EFEITOS
TABELAS + ESTADO
```

### FRONT Template
```md
# FRONT-XXX — <MÓDULO>

## FLUXO UI
Screen → Action → SP

## API
POST /api/sp/dispatch (payload)

## ESTADO
FFA/senha/triagem
```

---

## ⚙️ AUTO CLASSIFICATION

```
DOMAINS:
- ASSISTENCIAL
- FARMACIA  
- ESTOQUE
- FATURAMENTO
- AUTH
- WORKFLOW
```

## 📁 OUTPUT
/mds, /brs, /fronts - sincronizados automaticamente