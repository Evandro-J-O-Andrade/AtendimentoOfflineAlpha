# MD-025 — Event Store Core

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Definir o núcleo de registro imutável de eventos da plataforma, garantindo rastreabilidade total, reconstrução de estado, auditoria e fundamentação para Analytics e IA.

---

## Princípio Fundamental

```text
Sem evento, não existe operação.
Evento é a única verdade histórica do sistema.
```

---

## Princípios

1. Evento é imutável após registrado.
2. Evento sempre carrega sessão, tenant e contexto.
3. Evento sempre referencia uma ação do Action Registry.
4. Evento alimenta Analytics, IA e Auditoria.
5. Evento permite reconstrução de estado.

---

## Modelo Canônico

```json
{
  "evento_uuid": "UUID",
  "execucao_uuid": "UUID",
  "acao": "FILA.CHAMAR",
  "dominio": "OPERACIONAL",
  "evento": "SENHA_CHAMADA",
  "id_sessao_usuario": 0,
  "id_tenant": 0,
  "id_unidade": 0,
  "id_local": 0,
  "payload": {},
  "resultado": {},
  "timestamp": "datetime"
}
```

---

## Responsabilidades

- Receber eventos de toda execução.
- Garantir ordem e imutabilidade.
- Indexar por domínio, tenant, sessão e tempo.
- Disponibilizar leitura para Analytics e Auditoria.
- Bloquear alteração ou exclusão de eventos.

---

## Regras

1. Toda ação registrada no Action Registry deve gerar evento.
2. Nenhum componente pode escrever diretamente no Event Store.
3. Eventos são append-only.
4. Correlação entre eventos é feita por `execucao_uuid`.
5. Consultas devem sempre respeitar `id_tenant`.
6. Eventos críticos são replicados para cofre imutável.

---

## Integração Com Outros MDs

- **MD-004 (Dispatcher)**: entrada de ações origina eventos.
- **MD-005 (EventStore)**: definição canônica de evento.
- **MD-022 (Action Mapping)**: toda ação mapeada gera evento.
- **MD-023 (Action Registry)**: execução validada produz evento.
- **MD-024 (Runtime)**: runtime emite evento obrigatório.
- **MD-011 (Analytics)**: consome Event Store como fonte primária.

---

## Proibições

São proibidos:

```text
Evento sem ação canônica
Evento sem tenant
Evento sem sessão
Evento sem timestamp
Alteração de evento registrado
Exclusão de evento
Leitura cross-tenant sem autorização
Escrita fora do pipeline oficial
```

---

## Lei Do Event Store Core

```text
Evento é história.
História não se apaga.
História não se altera.
Toda ação vira história.
```

---












