# IMPLEMENTATION PLAN — KILO v7

## FASE 1 — Core Fixes (P0) ✅ INPROGRESS

- [ ] Criar sp_senha_emitir (MD-105 compliance)
- [ ] Implementar sp_sessao_assert (referenciado em 8 SPs)
- [ ] Implementar sp_kernel_ledger_write (event canonical)

## FASE 2 — Event Migration (P0)

- [ ] Bridge events para kernel_ledger
- [ ] View v_event_unificado
- [ ] Dual-write nas SPs existentes

## FASE 3 — Flow Compliance (P1)

- [ ] Patch sp_executor_recepcao_abrir_atendimento
- [ ] Mandar FFA creation depois de senha
- [ ] Validar sp_ffa_create_from_senha

## FASE 4 — MD Canonization (P1)

- [ ] Atualizar MD-003: sp_gatekeeper como dispatcher
- [ ] Atualizar MD-004: sp_ffa_orquestrador como orchestrator
- [ ] Atualizar MD-105: fluxo real documentado

## FASE 5 — Backend Stubs (P2)

- [ ] Node.js/NestJS controllers
- [ ] Services stubs
- [ ] DTOs
- [ ] OpenAPI specs

## FASE 6 — Frontend Contracts (P2)

- [ ] React hooks
- [ ] Componentes
- [ ] Typescript types
- [ ] API contracts

---

## BACKLOG GERADO

| ID | Type | Description | Priority |
|----|------|-------------|----------|
| BR-001-001 | VIOLATION | FFA sem senha | P0 |
| MD-003 | DRIFT | sp_master_dispatcher → sp_gatekeeper | P0 |
| EVENT-001 | GAP | kernel_ledger não usado | P0 |
| SP-001 | MISSING | sp_senha_emitir | P0 |
| SP-002 | MISSING | sp_sessao_assert | P0 |