# MAPA_APIS - FASE 3
**Data:** 2026-06-17

---

## FRONTEND/src/api/

### api.js (CANÔNICO - 1955 bytes)
- Axios instance
- Base URL: /api
- Content-Type: application/json
- SEM token injetado (frontend atualizado usa api.ts diferente)
- **STATUS: CANÔNICO**

### spApi.js (CANÔNICO - 3501 bytes)
- fetch-based SP caller
- Métodos: call(rota, payload), getEntity, list, create, update, remove
- **STATUS: CANÔNICO**

### spApi.ts (DUPLICADO - 127 bytes)
- Axios wrapper (incompleto)
- 7 linhas apenas, re-export
- **STATUS: EXCLUIR** (duplicata de api.js + spApi.js)

---

## FRONTEND/src/services/

### api.ts (DUPLICADO - 1041 bytes)
- Axios instance separada (não é a mesma de api/api.js)
- Base URL: /api
- SEM JWT interceptor
- callSP(rota, payload) → POST /sp
- **STATUS: EXCLUIR** (duplicata de api/api.js, sem JWT)

### FilaService.ts (STUB - 271 bytes)
- Mock stubs apenas
- Implementação real em FilaService.js
- **STATUS: EXCLUIR**

### FilaService.js (CANÔNICO - 3125 bytes)
- Implementação completa
- Chamadas a: fila/gerar, fila/, fila/chamar, fila/iniciar, fila/finalizar, fila/encaminhar, fila/cancelar
- **STATUS: CANÔNICO**

### AssistencialService.js (CANÔNICO - 7038 bytes)
- Implementação completa
- Chamadas SP assistenciais
- **STATUS: CANÔNICO**

### loginService.js (CANÔNICO - 9212 bytes)
- Login, logout, refresh, getProfile
- **STATUS: CANÔNICO**

### PermissionService.js (CANÔNICO - 1569 bytes)
- getPermissions, hasPermission
- **STATUS: CANÔNICO**

### PacienteService.js (CANÔNICO - 2431 bytes)
- Pacientes, busca, cadastro
- **STATUS: CANÔNICO**

### UserService.js (CANÔNICO - 1183 bytes)
- Usuário, perfil, contexto
- **STATUS: CANÔNICO**

### sessionService.js (CANÔNICO - 221 bytes)
- getSession
- **STATUS: CANÔNICO**

### syncService.js (CANÔNICO - 4603 bytes)
- Sincronização offline
- **STATUS: CANÔNICO**

### runtime.service.js (CANÔNICO - 989 bytes)
- Runtime dispatch
- **STATUS: CANÔNICO**

### runtimeService.js (DUPLICADO - 232 bytes)
- Duplicata mínima de runtime.service.js
- **STATUS: EXCLUIR**

### index.js (MORTO - 618 bytes)
- Exporta AuthService (não existe)
- **STATUS: EXCLUIR**

---

## MATRIZ DE APIs

| Arquivo | Tipo | Status | Observação |
|---------|------|--------|-------------|
| api/api.js | Axios base | CANÔNICO | Manter |
| api/spApi.js | fetch SP | CANÔNICO | Manter |
| api/spApi.ts | axios stub | EXCLUIR | Duplicata incompleta |
| services/api.ts | Axios base | EXCLUIR | Duplicata sem JWT |
| services/FilaService.js | Service | CANÔNICO | Manter |
| services/FilaService.ts | Service stub | EXCLUIR | Mock apenas |
| services/runtime.service.js | Service | CANÔNICO | Manter |
| services/runtimeService.js | Service | EXCLUIR | Duplicata mínima |
| services/index.js | Barrel | EXCLUIR | Importa arquivo morto |

---

## DUPLICAÇÕES DE AXIOS INSTANCES

**Problema:**  
`api/api.js` e `services/api.ts` criam INSTÂNCIAS SEPARADAS do axios.

**Impacto:**
- Interceptors do JWT não se aplicam a `services/api.ts`
-可能有 inconsistência de headers entre instâncias

**Resolução:**
- Manter apenas `api/api.js` (CANÔNICO)
- Todos os serviços devem importar de `api/api.js`
- Remover `services/api.ts`

FIM DO RELATÓRIO FASE 3
