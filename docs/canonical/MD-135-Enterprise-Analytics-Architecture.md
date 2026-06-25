# MD-135 — Enterprise Analytics Architecture

## Status
Documento Canônico da Plataforma. Analytics como aplicação.

## Classificação
```text
Tipo: Application Architecture
Camada: Platform Core
Prioridade: Alta
Obrigatoriedade: Global
```

---

## Objetivo
Analytics é aplicação separada do Portal. Fonte de eventos, não de telemetria.

---

## Lei Canônica MD-135-001
```text
Analytics é aplicação autônoma.
Eventos são fonte primária.
Toda decisão gera evento analisável.
```

---

## Analytics Sources

```text
Operational Events
├── Senha chamada
├── Tempo de espera
├── Fluxo atendimento
└── Classificação

Financial Events
├── Fatura gerada
├── Pagamento realizado
├── Estorno
└── Recebimento

Quality Events
├── Protocolo violado
├── Alerta crítico
├── Tempo excedido
└── Erro operacional
```

---

## Integrações
| MD | Finalidade |
|----|---|
| MD-123 | Portal Canonical Experience |
| MD-136 | Event Driven Enterprise |
| MD-142 | Unified Enterprise Operating System |