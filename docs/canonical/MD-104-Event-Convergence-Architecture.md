# MD-104 — Event Convergence Architecture

## Status

Documento Canônico Fundacional de Eventos.
Define a convergência de múltiplos motores de eventos para o Event Store canônico.

---

## Objetivo

Convergir múltiplos motores de eventos legados em um único Event Store canônico.

---

## Princípio Fundamental

```text
Evento é rastro oficial.
Evento é imutável.
Evento é a memória da plataforma.
Sem evento, a operação não existe.
```

---

## Motores Legados Identificados

| Motor | Tabela(s) | Domínio | Status |
|-------|-----------|---------|--------|
| Auditoria Canônico | `auditoria_evento` | Global | CANONICO |
| Event Store Global | `kernel_ledger` | Global | CANONICO |
| Eventos Assistenciais | `atendimento_evento` | Saúde | LEGADO |
| Eventos FFA | `evento_ffa` | Saúde | LEGADO |
| Eventos de Fila | `fila_evento`, `fila_operacional_evento` | Operacional | LEGADO |
| Workflow de Eventos | `workflow_ffa_evento` | Automação | LEGADO |
| Motor Genérico de Fluxo | `eventos_fluxo` | Workflow | LEGADO |
| Eventos de Faturamento | `faturamento_evento` | Financeiro | LEGADO |
| Ledger de Estoque | `estoque_ledger` | Estoque | LEGADO |
| Eventos de Venda | `venda_evento`, `caixa_evento` | PDV | LEGADO |
| Eventos de Chamado | `chamado_evento` | SAC | LEGADO |
| Eventos de CAT | `cat_evento` | Saúde | LEGADO |
| Evento de Óbito | `obito_evento` | Saúde | LEGADO |

---

## Arquitetura de Convergência

```
┌─────────────────────────────────────────────────────┐
│                  APLICAÇÕES / SPs                    │
│   (emitem eventos durante operações)                │
└──────────────────┬──────────────────────────────────┘
                   │
                   │
       ┌───────────┼───────────┐
       │           │           │
       ▼           ▼           ▼
  ┌─────────┐ ┌─────────┐ ┌─────────┐
  │ App A   │ │ App B   │ │ SP C    │
  └────┬────┘ └────┬────┘ └────┬────┘
       │           │           │
       └───────────┼───────────┘
                   │
                   ▼
       ┌───────────────────────┐
       │   EVENT ADAPTER       │
       │  (camada de bridging) │
       │  transforma eventos   │
       │  legados em canônicos │
       └───────────┬───────────┘
                   │
                   ▼
       ┌───────────────────────┐
       │   EVENT STORE         │
       │   (kernel_ledger)     │
       │                       │
       │  ┌─────────────────┐  │
       │  │  Evento Canônico │  │
       │  │  - id            │  │
       │  │  - tenant        │  │
       │  │  - app           │  │
       │  │  - ação          │  │
       │  │  - entidade      │  │
       │  │  - payload       │  │
       │  │  - timestamp     │  │
       │  │  - imutável      │  │
       │  └─────────────────┘  │
       └───────────┬───────────┘
                   │
       ┌───────────┼───────────┐
       │           │           │
       ▼           ▼           ▼
  ┌─────────┐ ┌─────────┐ ┌─────────┐
  │ Analytics│ │ Audit   │ │ Replay  │
  │ (BI)     │ │ Trail   │ │ Engine  │
  └─────────┘ └─────────┘ └─────────┘
```

---

## Evento Canônico

```json
{
  "id_evento": "UUID",
  "id_tenant": 0,
  "id_unidade": 0,
  "id_local": 0,
  "id_usuario": "UUID",
  "id_sessao": "UUID",
  "app": "string",
  "acao": "string",
  "entidade": "string",
  "id_entidade": "UUID",
  "payload": {},
  "payload_resumo": "string",
  "resultado": "SUCESSO|ERRO|PARCIAL",
  "codigo_erro": "string|null",
  "ip": "string",
  "user_agent": "string",
  "device_fingerprint": "string",
  "timestamp": "datetime",
  "criado_em": "datetime",
  "imutavel": true
}
```

---

## Regras de Convergência

1. **kernel_ledger** é a tabela canônica única de eventos.
2. Todos os demais ledgers são considerados legados e devem ser migrados.
3. Nenhuma SP nova deve escrever em tabela de evento legada.
4. Event Adapter converte eventos legados para formato canônico durante a migração.
5. Eventos legados são preservados (não deletados) para auditoria histórica.
6. A partir da data de corte (go-live do Event Store canônico), todo evento novo vai para `kernel_ledger`.
7. Queries de Analytics e BI passam a ler do Event Store canônico.
8. Auditoria histórica pode consultar tanto legado quanto canônico durante o período de transição.

---

## Event Adapter

### Responsabilidades

- Ler eventos de tabelas legadas em lotes (batch)
- Transformar schema legado → schema canônico
- Enriquecer com tenant/unidade/local quando disponível
- Escrever em `kernel_ledger`
- Garantir idempotência (não criar duplicatas)
- Reportar progresso e erros

### Engine de Convergência

```text
Fase 1 — Mapeamento
  - Mapear todas as tabelas de evento legadas
  - Definir regras de transformação
  - Validar com amostra

Fase 2 — Migração Histórica
  - Migrar eventos antigos em lotes
  - Marcar eventos legados como "migrados"
  - Manter legado como fonte secundária

Fase 3 — Validação
  - Comparar totais: legado vs canônico
  - Validar integridade referencial
  - Assinar conformidade

Fase 4 — Go-Live
  - Data de corte definida
  - A partir de então, tudo vai para kernel_ledger
  - Legado vira read-only para consulta histórica
```

---

## Eventos por Domínio (Exemplos)

| Domínio | App | Ação | Entidade |
|---------|-----|------|----------|
| AUTH | AUTH | LOGIN | sessao |
| AUTH | AUTH | LOGOUT | sessao |
| AUTH | AUTH | TROCA_SENHA | usuario |
| OPERACIONAL | OPERACIONAL | GERAR_SENHA | senha |
| OPERACIONAL | OPERACIONAL | CHAMAR_SENHA | senha |
| OPERACIONAL | OPERACIONAL | FINALIZAR_SENHA | senha |
| OPERACIONAL | OPERACIONAL | INICIAR_ATENDIMENTO | atendimento |
| OPERACIONAL | OPERACIONAL | TRANSICIONAR_ATENDIMENTO | atendimento |
| FARMACIA | FARMACIA | DISPENSAR_MEDICAMENTO | dispensacao |
| FATURAMENTO | FATURAMENTO | GERAR_FATURA | faturamento |
| FATURAMENTO | FATURAMENTO | CONCILIAR | conciliacao |
| CRM | CRM | CRIAR_OPORTUNIDADE | oportunidade |
| SAC | SAC | ABRIR_CHAMADO | chamado |
| CAT | CAT | ABRIR_POR_ITEM | notificacao |

---

## Integrações

```text
MD-003 — Contexto Operacional
MD-004 — Dispatcher
MD-005 — Event Store Core
MD-016 — Auditoria
MD-017 — Multi-Tenant
MD-025 — Event Store Core
MD-038 — Integration Hub
MD-040 — Governance Compliance Center
MD-065 — Observability Platform
MD-071 — Customer 360 Platform
```

---

## Regras

1. Todo evento canônico tem `id_evento` UUID único.
2. Nenhum evento é editado após criação.
3. Nenhum evento é deletado.
4. Evento sempre carrega contexto (tenant, unidade, local).
5. Evento sempre carrega identidade (usuário, sessão).
6. Evento sempre carrega origem (app, ação, entidade).
7. Payload completo é armazenado.
8. Payload resumido é armazenado para busca.
9. Timestamp é gerado pelo banco (não pelo frontend).
10. Eventos são particionados por tenant para performance.

---

## Lei

```text
Sem evento não existe operação.
Evento é a memória da plataforma.
Evento é imutável.
Evento é consultável.
Evento é a fonte de verdade histórica.
```

---

## Responsabilidades

Plataforma é responsável por:

```text
Manter Event Store canônico
Garantir convergência dos motores legados
Fornecer APIs de consulta de eventos
Garantir performance e particionamento
Manter auditoria histórica
```

Desenvolvedores são responsáveis por:

```text
Emitir eventos para kernel_ledger
Não escrever em tabelas de evento legadas
Usar contratos de evento canônicos
Respeitar formato JSON padrão
```

---

## Métricas

```text
Eventos por segundo
Latência de escrita de evento
Latência de consulta de evento
Tamanho médio do payload
Particionamento por tenant
Volume histórico migrado
Taxa de erro na convergência
Disponibilidade do Event Store
```
