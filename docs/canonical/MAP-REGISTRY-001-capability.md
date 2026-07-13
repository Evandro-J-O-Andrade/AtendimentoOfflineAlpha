# MAP-REGISTRY-001 — Capability Registry Architecture

## Status
```text
CANÔNICO (ENGENHARIA)
CICLO 2.1 — Registry Canônico
Etapa 1/5 — Capability (EXTEND de permissao)
```

---

## Estrutura Resultante (`permissao` estendida)

```text
permissao
 ├── id_permissao        (PK, existe)
 ├── codigo              (existe)
 ├── nome                (existe)
 ├── descricao           (existe)
 ├── dominio             (existe)
 ├── nome_procedure      (existe → liga à SP / LEI 05·26)
 ├── acao_frontend       (existe → liga à UI)
 ├── metadata            (existe, json)
 ├── grupo_menu/icone/ordem_menu/visivel_menu (existe, catálogo UI)
 ├── tipo_capability     (NOVO — OPERACAO/CONSULTA/EVENTO/INTEGRACAO/SISTEMA/IA)
 ├── capacidade_codigo   (NOVO — código canônico ex: farmacia.dispensar)
 ├── id_contrato         (NOVO — ADAPT de contrato/saas_contrato)
 ├── id_runtime          (NOVO — etapa 2, nullable)
 ├── id_tool             (NOVO — etapa 3, nullable)
 └── payload_contrato    (NOVO — json)
```

---

## Fluxo de Resolução (LEI 25·26)

```text
Cliente (humano ou IA)
   ↓
{ "capability": "farmacia.dispensar", "tenant": ..., "payload": {} }
   ↓
Capability Resolver
   ↓ lê permissao.capacidade_codigo
   ↓
Authorization (permissao + perfil_permissao + auth_grupo_permissao)
   ↓
Execution (permissao.nome_procedure → SP)
   ↓
Banco Canônico
```

O cliente NUNCA sabe qual SP foi usada.

---

## Integrações

| Documento | Finalidade |
|------------|------------|
| MD-REGISTRY-001 | Materialização da capability |
| BR-REGISTRY-001 | Regras de capability |
| MAP-006-Permissoes | Autorização base |
| MAP-019-AI | AI Runtime / Capability Resolver |
| sp_auth_permissions_evaluate | Evaluate de permissão de sessão |
| REGISTRY-CANONICO-AUDITORIA | Fase 1+2 (origem) |

---

## Revisão de Cardinalidade

```text
id_runtime / id_tool são colunas NULL, sem FK (BR-CAP-010).
Cardinalidade Capability↔Runtime e Capability↔Tool está EM
REVISÃO. Se uma Capability puder ser consumida por múltiplos
Runtimes/Tools, adota-se associação N:N (tabela de junção) nas
etapas 2/3, sem retrabalho da Etapa 1.
```

---

## Próximas etapas (trilha única)

```text
1. ✅ Capability Registry (este doc)
2. → runtime_registry
3. → tool_registry
4. → api_registry
5. → event_registry
```
