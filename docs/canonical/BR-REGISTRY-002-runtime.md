# BR-REGISTRY-002 — Runtime Registry Rules

## Status
```text
CANÔNICO (ENGENHARIA)
CICLO 2.1 — Registry Canônico
Etapa 2/5 — Runtime (pós-MAP)
Origem: MD-REGISTRY-002 / MAP-REGISTRY-002
```

---

## Regras (curto e fundamental)

### BR-RT-001 — Runtime não contém regra de negócio
```text
Runtime coordena execução; não implementa regra de domínio.
Toda regra permanece em Executor / Stored Procedure (Neutralidade).
```

### BR-RT-002 — Runtime resolve Capabilities
```text
Runtime é responsável por resolver, validar e encaminhar
Capabilities via pipeline canônico (LEI 25·26).
```

### BR-RT-003 — Toda Capability possui exatamente um Runtime PRIMARY
```text
Toda Capability tem ≥1 Runtime associado e EXATAMENTE 1 PRIMARY.
PRIMARY = 2 é inválido (resolução ambígua).
Demais associações usam SECONDARY ou PROXY.
```

### BR-RT-004 — Runtime não referencia Stored Procedures
```text
Runtime nunca aponta direto para SP. Resolve via Master→Dispatcher
→Executor→SP (LEI 25·26).
```

### BR-RT-005 — Runtime descobre Masters pelo metamodelo
```text
A relação Runtime─Master é ARESTA (runtime_master), não lista
interna. Descoberta via metamodelo / Knowledge Graph.
```

### BR-RT-006 — Runtime coordena auditoria, não a implementa
```text
Runtime emite/propaga Evento e Auditoria; não escreve a regra
de auditoria.
```

### BR-RT-007 — Runtime não expõe endpoints concretos
```text
endpoint_pattern é FAMÍLIA (/auth/*). Endpoint concreto pertence
ao API Registry.
```

### BR-RT-008 — Runtime não conhece consumidores específicos
```text
Runtime atende consumidores humanos e computacionais de forma
uniforme; não acopla a nenhum cliente.
```

### BR-RT-009 — Runtime é imutável por identidade
```text
codigo (identidade) NUNCA muda.
AUTH não vira AUTH_V2, AUTH2 ou AUTH_NOVO.
Quem muda é versao e status.
Garante rastreabilidade histórica e integridade do grafo.
```

### BR-RT-010 — runtime_type é natureza, não prioridade
```text
CORE não é "mais importante" que DOMAIN.
São categorias de natureza, não hierarquia de importância.
```

### BR-RT-011 — endpoint_pattern nunca é endpoint concreto
```text
endpoint_pattern é FAMÍLIA (/auth/*).
Endpoint concreto (/auth/login) pertence ao API Registry.
```

### BR-RT-012 — Resolver ≠ Registry
```text
Registry GUARDA conhecimento (identidade, atributos, arestas).
Resolver CONSULTA conhecimento (capability/runtime/tool).
Lógica de resolução NUNCA vive dentro do Registry (MD-REGISTRY-000).
```

---

## Relação com Etapa 1

```text
BR-CAP-010 (cardinalidade em revisão) é resolvida aqui por
capability_runtime N:N com role {PRIMARY, SECONDARY, PROXY}.
```
