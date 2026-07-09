# DECISION-LOG.md — Histórico de Decisões Arquitetônicas

> **Não é um log de commits.** É o registro de **decisões de engenharia** tomadas pelo processo
> de governança (ver `DECISION-ENGINE.md` e `MD-CANONICO-IA-007`). Ele existe para ensinar
> futuras IAs **como este projeto costuma decidir** — tornando o comportamento determinístico
> reproduzível e auditável.

## Formato

Cada entrada:

```text
DEC-XXXX
  Problema:    <o que estava em questão>
  Domínio:     <IAM / Portal / Runtime / ...>
  Dono:        <responsabilidade → owner (DB-ID)>
  Resultado:   REUSE | ADAPT | EXTEND | MERGE | PROPOSE
  Invariantes: <INV-xxx respeitados / violados>
  Motivo:      <por que esta classificação>
```

## Seed

### DEC-0001

```text
Problema:    Criar dashboard_widget / dashboard / dashboard_layout
Domínio:     Portal / Display
Dono:        Portal Runtime → PortalRuntimeEngine (RT-0009)
Resultado:   REUSE
Invariantes: INV-007 (widget nasce de WidgetContract) respeitado
Motivo:      A família painel_* (painel, painel_config, painel_lane, painel_local,
             painel_grupo, painel_mensagem, painel_evento_stream, fila_painel_runtime,
             assistencial_runtime_panel) já cobre o domínio de painéis/monitores.
             Criar dashboard_* seria duplicação semântica (DUPLICATION-MAP).
```

### DEC-0002

```text
Problema:    Nova procedure de contexto operacional
Domínio:     IAM / Contexto
Dono:        Sessão → sp_master_login (DB-SP-0001)
Resultado:   MERGE
Invariantes: INV-001 (sessão obrigatória) respeitado
Motivo:      sp_master_login (ramos AUTH.CONTEXTO.*), sp_auth_contexto_get,
             sp_auth_contexto_set e sp_sessao_contexto_get já representam a
             responsabilidade. Consolidar no Master + Executor canônico; não criar outra.
```

### DEC-0003

```text
Problema:    sp_auth_permissions_evaluate (chamada por PermissionService) ausente no dump
Domínio:     IAM / Permissão
Dono:        Permissão → sp_auth_permissions_evaluate (DB-SP-0042)
Resultado:   PROPOSE (CORE-005)
Invariantes: INV-004 (permissão só no Permission Engine) — exige materialização
Motivo:      Referência no código (PermissionService) mas sem equivalente no Dump.
             ADAPT a partir de sp_auth_menu_get; materializar SQL em
             database/migrations/proposed/ e registrar em CHANGELOG.
```

### DEC-0004

```text
Problema:    Governança atingiu cobertura estável do ciclo de decisão
Domínio:     Governança / Kernel Enterprise
Dono:        Arquitetura → MD-CANONICO-IA-007 (frozen)
Resultado:   FREEZE (Kernel de Governança v1.0)
Invariantes: todos os INV-001..INV-007 respeitados
Motivo:      O conjunto (Dump + Knowledge Graph + DATABASE-MAP + DECISION-ENGINE + OWNERSHIP
            + INVARIANTS + ARCHITECTURE-TESTS + CALLGRAPH + INVENTORY + CHANGELOG + DECISION-LOG)
            já cobre todo o ciclo. Retorno de novos documentos < retorno de aplicá-los.
            A partir daqui, medir cumprimento, não criar regra.
```

### DEC-0005

```text
Problema:    Criar domínio de metadados de composição do Portal Enterprise
             (widgets / dashboards / layouts / preferências da home do usuário)
Domínio:     Portal Enterprise
Dono:        Portal Runtime → PortalRuntimeEngine (RT-0009)
Resultado:   PROPOSE
Invariantes: INV-007 (widget nasce de WidgetContract) respeitado;
             INV-005 (frontend não chama SQL) respeitado
Motivo:      Auditoria de domínio (IA-007 §5.1 / DUMP-001 §11): `painel_*` é domínio
             Clínico/TV Display (FKs → unidade/local/fila; sp_painel_* = operations em
             tools/sp-analyzer; modules/painel clínico; nomes assistenciais). O Portal
             Enterprise NÃO existe no dump (só `portal_categoria`, órfã). Não há
             responsabilidade equivalente → PROPOSE legítimo de
             portal_widget / portal_dashboard / portal_dashboard_widget / portal_widget_config /
             portal_layout / portal_usuario_dashboard / portal_dashboard_permission + sp_master_portal.
Revoga/Refina: DEC-0001 (que tratou dashboard como REUSE de painel_*): painel_* atende o
             Painel Clínico, NÃO o Portal Enterprise — são bounded contexts distintos.
Status:      PROPOSED / REQUIRE APPROVAL (aguarda ADR + MD Portal Enterprise + MAP Portal Domain
             + contratos Front + migration SQL final). Backend segue mock [] até aprovação.
```

## Regra de Congelamento (Freeze v1.0)

> Nenhum novo documento de governança será criado, salvo se um problema real demonstrar uma
> lacuna que não possa ser resolvida pelos artefatos existentes.

Isso impede que a documentação cresça mais rápido que o sistema.

## Métricas de Cumprimento (o foco agora é "a regra está sendo seguida?")

| Indicador            | Objetivo                                                     |
| -------------------- | ------------------------------------------------------------ |
| REUSE Rate           | Quanto do que foi implementado reutilizou objetos existentes |
| MERGE Rate           | Quantas duplicações foram eliminadas                         |
| PROPOSE Rate         | Quantos objetos realmente novos precisaram ser criados       |
| Impact Coverage      | Toda alteração passou pelo grafo de impacto?                 |
| Decision Compliance  | Todos os Gates 1–9 foram cumpridos?                          |
| Runtime Coverage     | Toda funcionalidade nova entrou no runtime?                  |
| SP Coverage          | Toda API termina em uma Master/Executor conhecida?          |

## Redirecionamento para a Plataforma (bloqueios conhecidos)

1. **CORE-005** — `sp_auth_permissions_evaluate` ausente no Dump (único bloqueio funcional do
   pipeline authz). Materializar via ADAPT de `sp_auth_menu_get`.
2. **Widget Runtime** — `WidgetRenderer` não existe (há `WidgetContract` + `WidgetResolver` que
   apenas ordena). Criar o componente estrutural que mapeia `WidgetContract.type` → componente.
3. **Runtime de Painéis (Portal Enterprise)** — domínio Portal Enterprise **NÃO existe** no dump
   (DEC-0005: PROPOSE `portal_*`, **não** reutilizar `painel_*` clínico). Hoje `widgets: []` (mock);
   materializar via ADR + migration `portal_*` após aprovação.
4. **Permission Runtime** — fechar `Portal Runtime → Permission Engine → WidgetRenderer →
   EnterpriseShell` (widgets filtrados por permissão/contexto).
5. **Runtime Enterprise** — fechar `Sessão → Contexto → Permission → Portal Runtime →
   Applications → Dashboard Runtime → Widget Renderer → EnterpriseShell`.

## Regra

- Toda saída PROPOSE/MERGE do `DECISION-ENGINE.md` gera uma entrada aqui.
- O log é consultado pelo motor antes de reabrir uma decisão já tomada.
- Decisão revisada → nova entrada DEC-XXXX com "Revoga: DEC-YYYY", nunca edição da anterior.
