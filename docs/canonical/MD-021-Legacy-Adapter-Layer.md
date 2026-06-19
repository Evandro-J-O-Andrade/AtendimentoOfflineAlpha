# MD-021 — Legacy Adapter Layer

## Status

Documento Canônico De Migração E Compatibilidade Arquitetural.

---

## Objetivo

Definir a camada de adaptação controlada entre o novo Portal Core e o sistema legado existente, garantindo transição sem parada, sem perda de funcionalidade e sem reintroduzir padrões arquiteturais antigos.

---

## Princípio Fundamental

```text
O legado não é reescrito.
O legado não é ignorado.
O legado é encapsulado.
```

---

## Os Dois Mundos

### Legado (Existente)

- Express routes
- SQL direto
- SPs (225+ procedimentos)
- Frontend apps antigos
- Lógica espalhada

### Portal Core (Novo)

- Portal como shell único
- App Registry
- Dispatcher único
- Event Store obrigatório
- SP-first limpo

---

## Problema Que O Adapter Resolve

Sem Adapter Layer:

- Quebra o sistema inteiro
- Replica o caos em arquitetura nova
- Perde funcionalidades validadas em produção

Com Adapter Layer:

- Encapsula legado
- Traduz ações entre mundos
- Preserva SPs existentes
- Gera eventos canônicos
- Permite migração gradual

---

## Estrutura

```
adapter/
  gateway/
    dispatch.adapter.ts
    sp.adapter.ts
    route.adapter.ts
  registry/
    action.map.ts
    sp.map.ts
  translators/
    payload.translator.ts
    response.normalizer.ts
  legacy/
    sp.client.ts
    mysql.client.ts
```

---

## Responsabilidades

### O Que O Adapter Faz

- Traduz ação do Portal para legado
- Chama SPs existentes
- Normaliza payloads
- Normaliza respostas
- Emite eventos canônicos
- Mapeia rotas legado para ações Portal

### O Que O Adapter Não Faz

- Regra de negócio clínica
- Regra de negócio nova
- SQL direto novo
- Duplicação de SP
- Substituição de comportamento existente
- Validação complexa de negócio

---

## Fluxo Oficial

```
1. Portal Core envia ação
        ↓
2. Adapter recebe comando
        ↓
3. Lookup no Action Map
        ↓
4. Resolve SP ou Route Legacy
        ↓
5. Executa no legado
        ↓
6. Normaliza resposta
        ↓
7. Emite evento no Event Store
        ↓
8. Retorna para Portal
```

---

## Action Mapping

Exemplo:

```ts
export const ACTION_MAP = {
  "FILA.CHAMAR": {
    type: "sp",
    target: "sp_chamar_senha"
  },
  "TRIAGEM.INICIAR": {
    type: "sp",
    target: "sp_triar_iniciar"
  },
  "FARMACIA.DISPENSAR": {
    type: "sp",
    target: "sp_farmacia_dispensar"
  }
}
```

---

## Integração Com Portal Core

```
PORTAL CORE
   ↓
DISPATCHER
   ↓
ADAPTER LAYER
   ↓
LEGACY (SP + Express)
```

Portal nunca chama legado diretamente.

---

## Regras De Segurança

1. Toda ação carrega `id_sessao_usuario` obrigatório.
2. Toda ação carrega `id_tenant`, `id_unidade`, `id_local`.
3. Nenhuma ação sem sessão válida.
4. Nenhuma action sem mapeamento explícito.
5. Evento emitido em toda execução.

---

## Estratégia De Migração

### Fase 1

```
Portal → Adapter → Legacy SP
```

### Fase 2

```
Portal → Event Store → Adapter reduzido
```

### Fase 3

```
Portal → Services novos → SP reduzido
```

### Fase 4

```
Legado eliminado gradualmente
```

---

## Proibições

São proibidos:

```text
SQL direto novo no Adapter
Lógica clínica no Adapter
Regra de negócio no Adapter
Duplicação de SP
Substituição de comportamento existente
Chamada direta de banco sem SP
Bypass de Dispatcher
Acesso cross-tenant
Ação sem geração de evento
```

---

## Lei Do Adapter

```text
Adapter traduz, não decide.
Adapter encaminha, não altera.
Legado continua, não duplica.
Portal evolui, não quebra.
```

---

## Próxima Entrega

Depois deste documento:

- MD-022 — Legacy Mapping Table (225 SPs + rotas mapeadas)
- MD-023 — Migration Runbook (passo a passo da transição)
