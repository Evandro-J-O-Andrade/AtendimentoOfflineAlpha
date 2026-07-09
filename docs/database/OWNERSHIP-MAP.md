# OWNERSHIP-MAP.md — Catálogo de Responsabilidades

> Responde "**quem é dono do quê?**", não apenas "quem chama quem?". Vinculante
> (ver `MD-CANONICO-IA-007` e `DECISION-ENGINE.md`). Antes de implementar, a IA pergunta:
> "qual é o dono desta responsabilidade?" — não "onde eu coloco isso?".

## Matriz de Ownership

| Responsabilidade | Owner (DB-ID) | Fallback (DB-ID) | Camada | Status |
|---|---|---|---|---|
| Sessão | `sp_master_login` (DB-SP-0001) | `sp_guardiao_absoluto` | Master | Produção |
| Contexto operacional | `sp_auth_contexto_get` / `sp_auth_contexto_set` (DB-SP-0002/0003) | `sp_sessao_contexto_get` | Master/Executor | Produção |
| Permissão | `sp_auth_permissions_evaluate` (DB-SP-0042) | `sp_auth_menu_get` | Permission | PROPOSTO (CORE-005) |
| Menu / Portal | `sp_auth_menu_get` (DB-SP-0003) | `sp_master_login` | Executor | Produção |
| Runtime de Portal | `PortalRuntimeEngine` (RT-0009) | `PortalRuntimeProvider` | Runtime | Produção |
| Widgets | `WidgetRenderer` | `WidgetContract` | Frontend | Planned |
| Auditoria | `auditoria_evento` | `log_auditoria` | Auditoria | Produção |
| Ledger | `kernel_ledger` | `kernel_runtime_evento` | Ledger | Produção |
| Dispatcher | `sp_dispatcher_kernel` | `sp_master_dispatcher` | Dispatcher | Produção |
| Identidade/Pessoa | `usuario` / `pessoa` | `pessoa_vinculo` | IAM | Produção |

## Catálogo de responsabilidades (quem é dono do quê + fallback)

```text
Responsável: Sessão
  ↓ Owner
sp_master_login (DB-SP-0001)
  ↓ Fallback
sp_guardiao_absoluto
  ↓ Dado
sessao_usuario (DB-TB-0257)

Responsável: Portal Runtime
  ↓ Owner
PortalService (BACK-0011)
  ↓
PortalRuntimeEngine (RT-0009)
  ↓ Fallback
PortalRuntimeProvider
  ↓
EnterpriseShell (FRONT-0009)
```

## Regra do Owner

- Toda responsabilidade tem **um e apenas um owner** canônico, com **um fallback** definido.
- O fallback garante continuidade quando o owner evolui, é substituído ou fica indisponível.
- Nenhuma IA assume uma responsabilidade que já possui owner sem first consultar este mapa.
- Se uma funcionalidade nova couber a uma responsabilidade existente → **ADAPT/EXTEND no owner**.
- Se não houver owner → o PROPOSE define um (e seu fallback), registra aqui e em `CHANGELOG.md`.
- `MERGE` é a ferramenta para recolher responsabilidades fragmentadas a um único owner.

## Quando surgir uma nova funcionalidade

```text
1. Qual a responsabilidade?
2. Existe owner em OWNERSHIP-MAP?
     SIM → ADAPT/EXTEND no owner existente (fallback como reserva)
     NÃO → PROPOSE definindo owner + fallback + registrar aqui
3. Validar SYSTEM-INVARIANTS
4. Registrar decisão em DECISION-LOG.md
5. Implementar
```
