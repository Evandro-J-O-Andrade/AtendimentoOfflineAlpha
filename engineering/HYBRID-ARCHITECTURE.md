# NEW WAVE Enterprise Platform - HYBRID ARCHITECTURE

## DECISÃO
- **LEGACY BACKEND = ATIVO EXISTENTE (mantido)**
- **FRONTEND = NOVA EXPERIÊNCIA (construída)**
- **MD/BR = CAMADA DE CONTROLE (documentação)**

---

## 3 CAMADAS

```
1. LEGACY BACKEND (MySQL + SPs)
   ↓
2. API ADAPTER (normaliza rotas)
   ↓
3. NEW WAVE FRONTEND (React)
```

---

## LEGACY MAPPING BLOCOS

### Auth Block
- /api/login → sp_usuario_login
- /api/session → sp_sessao_assert
- /api/logout

### Core Business Block  
- /api/pessoas → sp_pessoa_*
- /api/unidades → sp_unidade_*

### Context/Tenant Block
- /api/contexto/select → sp_contexto_select
- /api/portal/load → sp_portal_*

---

## CLASSIFICAÇÃO LEGACY

| Tipo | Ação |
|------|------|
| KEEP | usar direto |
| WRAP | adapter necessário |
| DROP | ignorar |

---

## FLUXO DE IMPLEMENTAÇÃO

```
Mapear Legacy → Classificar APIs → Conectar FRONT → Validar Tela
```

---

**FRONT + LEGACY = PRODUTO RÁPIDO**