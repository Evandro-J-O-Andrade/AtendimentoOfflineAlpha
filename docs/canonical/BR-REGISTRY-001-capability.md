# BR-REGISTRY-001 — Capability Registry Rules

## Status
```text
CANÔNICO (ENGENHARIA)
CICLO 2.1 — Registry Canônico
Etapa 1/5 — Capability
```

---

## Regras

### BR-CAP-001 — Capability nasce de `permissao`
```text
Não existe tabela `capability_registry` isolada.
Capability é a evolução de `permissao` (EXTEND, não nova tabela).
```

### BR-CAP-002 — Código canônico obrigatório
```text
Toda capability possui capacidade_codigo único e estável,
no formato <dominio>.<acao> (ex: farmacia.dispensar).
Usado pelo Capability Resolver e pelo AI Runtime.
```

### BR-CAP-003 — Tipo definido
```text
tipo_capability é obrigatório e pertence ao enum:
OPERACAO, CONSULTA, EVENTO, INTEGRACAO, SISTEMA, IA.
```

### BR-CAP-004 — Execução via SP
```text
Toda capability operacional aponta para exatamente uma SP
via nome_procedure. Não há execução fora de SP (LEI 05·26).
```

### BR-CAP-005 — Autorização é centralizada
```text
Avaliação de permissão ocorre somente em sp_auth_permissions_evaluate
(INV-004). A capability descreve O QUE existe; a permissao descreve
QUEM pode.
```

### BR-CAP-006 — Rastreabilidade completa
```text
Uma capability só está COMPLETA quando responde:
  MD → MAP → BR → Contrato → API → Runtime → Master
     → Executor → SP → Tabela
Elo ausente → STATUS INCOMPLETO (Art. 76).
```

### BR-CAP-007 — Dependência de downstream
```text
id_runtime e id_tool entram NULL e são preenchidos nas etapas
2 e 3. Capability nunca depende de registry ainda não criado.
```

### BR-CAP-008 — Consumível por IA
```text
Capabilities de tipo IA/CONSULTA/OPERACAO/INTEGRACAO podem ser
expostas ao AI Runtime mediante Tool Registry (etapa 3).
```

### BR-CAP-009 — payload_contrato é metadado
```text
payload_contrato descreve o contrato ESPERADO para descoberta
e validação. Ele NÃO substitui o contrato canônico materializado
(Contratos em MD/MAP/BR + api_registry). É metadado, não definição.
```

### BR-CAP-010 — Cardinalidade em revisão (reserva de aprovação)
```text
Modelo atual (Etapa 1): Capability → id_runtime / id_tool
  (colunas NULL, sem FK; 1:1 embrionário).

PERGUNTA ABERTA: uma Capability pode ser exposta por múltiplos
Runtimes (Portal, AI, API, Mobile) e por múltiplas Tools?

Se SIM, a relação correta é N:N via tabela de associação:
  Capability ─┐
               ├─ capability_runtime ─ Runtime
  Capability ─┘
  (análogo para capability_tool)

Decisão pendente de ADR. Até lá, id_runtime/id_tool permanecem
NULL e sem FK. Nenhuma modelagem 1:1 é tratada como lei.
```
