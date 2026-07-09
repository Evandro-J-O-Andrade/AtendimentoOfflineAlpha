# DUPLICATION-MAP.md — Regra de Não-Duplicação

> Antes de criar qualquer objeto, consulte aqui. Se já existe equivalente por responsabilidade,
> **REUSE/ADAPT**, não PROPOSE. Evidência: `DUMP-001-audit.md` + `DATABASE-MAP.md`.

## Algoritmo de busca (obrigatório)

```text
NUNCA criar objeto só porque não achou o nome esperado.
Procurar, nesta ordem:
1. Mesmo nome
2. Mesmo domínio
3. Mesma responsabilidade
4. Mesmo fluxo
5. Mesmo call graph
6. Mesmo contrato
7. Mesma tabela
Só se TODAS falharem → PROPOSE.
```

## Casos conhecidos (evidência no dump)

### Caso: "quero criar dashboard / dashboard_widget"
- **Existe?** Não exatamente.
- **Equivalente?** SIM — família `painel_*`:
  `painel`, `painel_config`, `painel_config_def`, `painel_lane`, `painel_local`,
  `painel_grupo`, `painel_grupo_local`, `painel_mensagem`, `painel_mensagem_consumo`,
  `painel_evento_stream`, `painel_alertas_tempo`, `painel_consumo_evento`, `painel_fila_tipo`,
  `painel_monitoramento_especialidade`, `fila_painel_runtime`, `assistencial_runtime_panel`.
- **Decisão:** **REUSE / ADAPT** a família `painel_*`. Não criar `dashboard_*`.

### Caso: "quero criar nova SP de contexto"
- **Existe?** SIM (múltiplas):
  `sp_auth_contexto_get`, `sp_auth_contexto_set`, `sp_sessao_contexto_get`,
  `sp_master_login` (ramos `AUTH.CONTEXTO.GET` / `AUTH.CONTEXTO.SET`).
- **Decisão:** **ADAPT** — consolidar em Master + Executor; não criar nova SP de contexto.
- **Referência:** `DUMP-001-audit.md` DUP-1 / DUP-2.

### Caso: "quero criar novo dispatcher"
- **Existe?** SIM: `sp_dispatcher_kernel`, `sp_master_dispatcher`, `sp_master_query_dispatcher`,
  `sp_master_routes`, `sp_master_*`, `sp_executor_*`.
- **Decisão:** **REUSE** — ligar no dispatcher existente; não criar outro.

### Caso: "quero criar tabela de permissões do portal"
- **Existe?** SIM: `permissao`, `perfil_permissao`, `perfil`, `usuario_perfil`, `usuario_unidade`,
  `usuario_local`, `usuario_contexto`, `guardiao_acl_runtime`.
- **Decisão:** **REUSE**.

### Caso: "quero criar runtime de fila"
- **Existe?** SIM: `fila_painel_runtime`, `fila_operacional`, `fila_evento`, `runtime_*`, `kernel_*`.
- **Decisão:** **REUSE**.

## Regra de ouro

> Se a responsabilidade já é coberta por um objeto existente (mesmo que com outro nome ou em
> outra camada), **adapte**, não crie. O dump é a fonte primária da verdade; a documentação here
> apenas reflete.

## Quando PROPOSE é legítimo
- `sp_auth_permissions_evaluate`: chamada por `PermissionService` e **ausente no dump** →
  ADAPT de `sp_auth_menu_get` (CORE-005). Apenas se nenhuma SP existente cobrir a avaliação de
  permissões de sessão, cria-se nova — e registra em `CHANGELOG.md`.
