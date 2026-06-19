# AUDITORIA E CONSOLIDAÇÃO TOTAL — NEW WAVE PLATFORM ENTERPRISE

**Versão:** 1.0  
**Data:** 2026-06-17  
**Status:** DIRETRIZ OFICIAL  
**Aplicação:** Frontend + Backend + Banco + Documentação

---

## REGRAS PRÉ-EXECUÇÃO

1. **NÃO executar alterações imediatamente.**  
   Primeiro gerar relatórios. Depois, somente após validação, executar.

2. **NÃO deixar:**  
   - `TODO`  
   - `FIXME`  
   - `PLACEHOLDER`  
   - `STUB`  
   - arquivo vazio  
   - página vazia  
   - service vazio

3. **Se existir duplicidade:** manter a implementação mais completa.

4. **Se existir funcionalidade espalhada:** mesclar.

5. **Se existir estrutura melhor:** mover para a estrutura canônica.

6. **Obrigatório antes de qualquer exclusão:**  
   Gerar `BACKUP_PRE_CONSOLIDACAO.md` com lista completa dos arquivos removidos e o motivo da remoção.  
   Este arquivo é a garantia de rastreabilidade.

---

## OBJETIVO

Transformar o projeto para a estrutura canônica definida nos documentos de arquitectura já aprovados:

- `docs/auditoria/MAPA_CANONICO.md` (FASE 6)
- `docs/auditoria/ESTRUTURA_FINAL_ALVO.md` (FASE 9)
- `docs/auditoria/MAPA_STORED_PROCEDURES.md` (FASE 5)
- `docs/auditoria/MATRIZ_CONSOLIDACAO.md` (FASE 7)
- `docs/auditoria/PLANO_LIMPEZA.md` (FASE 8)

---

## ETAPA 1 — INVENTÁRIO REAL

Mapear fisicamente:

**Frontend:**
- todas as páginas (`.tsx`, `.jsx`)
- todos os componentes
- todos os hooks
- todos os providers
- todos os services
- todos os layouts
- todos os arquivos CSS

**Backend:**
- rotas (`routes/`)
- controllers (`controllers/`)
- middlewares (`middlewares/`)
- services (`services/`)
- kernel (`kernel/`)
- runtime (`runtime/`)
- integrations (`integrations/`)
- context (`context/`)
- ledger (`ledger/`)
- config (`config/`)

**Database:**
- stages (`database/stages/`)
- dumps (`backend/sql/`)
- procedures (dentro dos dumps)
- dispatchers (`database/dispatchers/`)

**Docs:**
- todos os `.md` em `docs/`

Gerar relatório:  
`docs/auditoria/RELATORIO_REAL_ESTRUTURA.md`

---

## ETAPA 2 — MAPA DE IMPORTAÇÃO

Construir árvore completa de importações:

```
main.tsx
→ App.tsx
→ Routes
→ Pages
→ Components
→ Services
→ APIs
```

Detectar:
- arquivos órfãos (sem importador)
- imports quebrados (referência inexistente)
- imports circulares
- componentes nunca utilizados
- hooks nunca utilizados
- services nunca utilizados

Gerar relatório:  
`docs/auditoria/RELATORIO_IMPORTS.md`

---

## ETAPA 3 — MAPA DE STORED PROCEDURES

Varrer todo o código (`backend/src` + `frontend/src`) procurando por:
- `CALL`
- `sp_`
- `sp_master_`

Mapear para cada ocorrência:
- arquivo
- linha
- procedure utilizada
- domínio

Formato:

```
ARQUIVO
LINHA
SP
DOMÍNIO

Exemplo:
services/farmacia_service.js
linha 45
sp_master_dispatcher
FARMACIA
```

Gerar relatório:  
`docs/auditoria/STORED_PROCEDURES_REAL.md`

---

## ETAPA 4 — MAPA DE ROTAS

### Frontend (React Router)
Mapear todas as rotas definidas em:
- `main.tsx`
- `App.tsx`
- `PortalRoutes.tsx`
- Qualquer outro roteador

Formato:
```
CAMINHO | COMPONENTE | PROTECAO | STATUS
/login | LoginPage | AuthRoute | ATIVO
/portal | PortalHomePage | PrivateRoute | ATIVO
/operacional/* | AppOperacional | PrivateRoute | ATIVO
```

### Backend (Express Router)
Mapear todas as rotas registradas em:
- `app.js`
- Cada arquivo em `routes/`

Formato:
```
METODO | CAMINHO | MIDDLEWARE | CONTROLLER/SERVICE | STATUS
POST | /api/auth/login | - | authController | ATIVO
GET | /api/fila | authMiddleware | filaRoutes | ATIVO
```

Gerar relatórios:  
`docs/auditoria/ROTAS_FRONTEND.md`  
`docs/auditoria/ROTAS_BACKEND.md`

---

## ETAPA 5 — COMPARAÇÃO COM ESTRUTURA CANÔNICA

Comparar estado REAL vs estrutura canônica definida em `ESTRUTURA_FINAL_ALVO.md`.

Para cada item:
- EXISTE
- FALTA
- DUPLICADO
- MORTO
- QUEBRADO

Gerar relatório:  
`docs/auditoria/GAP_ANALYSIS.md`

---

## ETAPA 6 — DETECÇÃO DE DUPLICAÇÕES

Detectar e listar:

- `.jsx` vs `.tsx` (mesmo nome, diferente extensão)
- APIs duplicadas (múltiplas instâncias axios, múltiplos `api.js`)
- Services duplicados
- Providers duplicados
- Layouts duplicados
- Hooks duplicados (`.ts` vs `.js`)
- Middlewares duplicados
- Controllers duplicados

Gerar relatório:  
`docs/auditoria/DUPLICACOES.md`

---

## ETAPA 7 — DETECÇÃO DE CÓDIGO MORTO

Detectar:

- arquivos nunca importados
- rotas nunca utilizadas (sem correspondente no Other Router ou em link)
- components órfãos
- services órfãos
- hooks órfãos
- controllers órfãos
- middlewares órfãos
- CSS não importado
- pastas inteiras mortas

Gerar relatório:  
`docs/auditoria/CODIGO_MORTO.md`

---

## ETAPA 8 — CONSOLIDAÇÃO (PROPOSTA)

Para CADA arquivo encontrado, propor uma ação:

- **MANTER** — está na estrutura correta, é canônico
- **MESCLAR** — funcionalidade duplicada, unir em um único arquivo
- **MOVER** — arquivo existe mas está na pasta errada
- **RENOMEAR** — nome não segue convenção canônica
- **EXCLUIR** — morto, quebrado ou duplicado sem valor
- **CRIAR** — não existe, mas é requerido pela arquitetura

Formato:

```
CAMINHO_ARQUIVO
AÇÃO
MOTIVO
ARQUIVO_DESTINO (se mover/mesclar)
```

Gerar relatório:  
`docs/auditoria/PLANO_CONSOLIDACAO.md`

---

## ETAPA 9 — VALIDAÇÃO DOS MÓDULOS CANÔNICOS

Validar existência e integração de cada módulo:

| Módulo | Status | Arquivos | Rotas | Backend |
|--------|--------|----------|-------|---------|
| Portal | COMPLETO / PARCIAL / INEXISTENTE | - | - | - |
| Contexto | COMPLETO / PARCIAL / INEXISTENTE | - | - | - |
| Operacional | COMPLETO / PARCIAL / INEXISTENTE | - | - | - |
| Painel | COMPLETO / PARCIAL / INEXISTENTE | - | - | - |
| Totem | COMPLETO / PARCIAL / INEXISTENTE | - | - | - |
| Admin | COMPLETO / PARCIAL / INEXISTENTE | - | - | - |
| Social | COMPLETO / PARCIAL / INEXISTENTE | - | - | - |
| Chat | COMPLETO / PARCIAL / INEXISTENTE | - | - | - |
| Wiki | COMPLETO / PARCIAL / INEXISTENTE | - | - | - |
| Analytics | COMPLETO / PARCIAL / INEXISTENTE | - | - | - |
| AVA | COMPLETO / PARCIAL / INEXISTENTE | - | - | - |
| Intranet | COMPLETO / PARCIAL / INEXISTENTE | - | - | - |
| Documentos | COMPLETO / PARCIAL / INEXISTENTE | - | - | - |
| CRM | COMPLETO / PARCIAL / INEXISTENTE | - | - | - |
| RH | COMPLETO / PARCIAL / INEXISTENTE | - | - | - |
| Financeiro | COMPLETO / PARCIAL / INEXISTENTE | - | - | - |
| BI | COMPLETO / PARCIAL / INEXISTENTE | - | - | - |
| Chamados | COMPLETO / PARCIAL / INEXISTENTE | - | - | - |

Gerar relatório:  
`docs/auditoria/MODULOS_STATUS.md`

---

## ETAPA 10 — EXECUÇÃO (APÓS APROVAÇÃO DOS RELATÓRIOS)

Executar automaticamente na ordem:

1. Excluir código morto
2. Remover duplicações
3. Corrigir imports quebrados
4. Unificar APIs (`api/api.js` como única instância axios)
5. Unificar providers (manter apenas `app/providers/`)
6. Unificar hooks (manter apenas `.ts`)
7. Unificar services (remover duplicatas)
8. Remover `backend/core/`
9. Remover `frontend/src/features/`
10. Corrigir `App.tsx`
11. Corrigir `PortalRoutes.tsx`
12. Corrigir `RuntimeContext.tsx`
13. Corrigir `AuthProvider.tsx`
14. Corrigir `TenantProvider.tsx`
15. Criar Social
16. Criar Chat
17. Criar Wiki
18. Criar Analytics
19. Criar AVA
20. Criar Intranet
21. Criar Documentos
22. Atualizar `tsconfig.json` paths
23. Atualizar aliases do Vite
24. Atualizar React Router (rotas canônicas)

---

## FLUXO ALVO (CONFIRMADO EM MDs)

```
Frontend:
Login → Portal → Seleção Contexto → Dashboard → Sistema Operacional

Backend:
Routes → Services → Kernel Dispatcher → Stored Procedures

Banco:
sp_master_dispatcher como ponto único de entrada
```

---

## ONTOLOGIA OBRIGATÓRIA (NÃO PULAR)

```
saas_entidade
→ pessoa
→ pessoa_vinculo
→ usuario
→ sessao_usuario
→ sistema
→ unidade
→ local_operacional
→ workflow
→ evento
→ auditoria_evento
```

---

## ENTREGÁVEIS FINAIS

Ao final de toda a execução, gerar:

`docs/auditoria/RELATORIO_FINAL_CONSOLIDACAO.md`

Conteúdo obrigatório:
- arquivos removidos (com motivos)
- arquivos criados (com propósitos)
- arquivos movidos (origem → destino)
- arquivos mesclados (origens → destino)
- imports corrigidos (antes → depois)
- rotas corrigidas (antes → depois)
- SPs utilizadas (mapeadas)
- módulos concluídos
- módulos pendentes
- validação final da estrutura canônica

---

## PROIBIÇÕES ABSOLUTAS

- ❌ Criar tabelas novas
- ❌ Criar procedures novas
- ❌ Alterar ontologia
- ❌ Alterar fluxo canônico
- ❌ Criar sistemas paralelos
- ❌ Criar autenticação paralela
- ❌ Criar sessão paralela
- ❌ Criar workflow paralelo
- ❌ Renomear objetos canônicos

Quando houver dúvida: **NÃO IMPLEMENTAR. NÃO INVENTAR. NÃO SUPOR.**

Primeiro consultar:
1. Ontologia
2. Dispatcher
3. Stored Procedures
4. Banco de Dados
5. Documentos canônicos (`docs/canonical/`)

Somente depois implementar.
