# FRONT-027 — Integration Hub Experience

## Status

Documento Canônico de Frontend.
Define a centralização de integrações na plataforma.

---

## Objetivo

Centralizar todas as integrações em única experiência de configuração e monitoramento.

---

## Princípio Fundamental

```text
Integração não é dispersa.
Integração é centralizada.
Integração é monitorada.
Integração é confiável.
Integração é recuperável.
```

---

## Componentes

### ConnectorManager

```text
Lista de conectores configurados
Status visual de cada conector
Configurações de conexão
Testar conexão
Editar credenciais
Desativar conector
```

### StatusDashboard

```text
Status em tempo real (verde/amarelo/vermelho)
Uptime por conector
Latência média
Taxa de erro
Total de integrações por tipo
```

### LogViewer

```text
Logs de integração em tempo real
Filtrar por conector
Filtrar por nível (info, warn, error)
Payload de entrada/saída
Timestamps
Busca em logs
Export de logs
```

### FailureCenter

```text
Falhas agrupadas por conector
Detalhe da falha
Payload que causou erro
Stack trace (quando disponível)
Status de retry
```

### RetryPanel

```text
Retry automático configurável
Retry manual sob demanda
Fila de retry pendente
Configuração de backoff
Limite de tentativas
```

### MonitoringView

```text
Métricas de integração
Gráficos de volume
Gráficos de erro
Alertas configuráveis
Threshold de falhas
```

---

## Conectores

```text
WhatsApp: API oficial ou BSP
Email: SMTP, IMAP, SendGrid, SES
Google: Workspace, Drive, Calendar, Gmail
Microsoft: Graph API, Outlook, Teams, SharePoint
ERP: SAP, Totvs, Protheus, RM
APIs: REST, SOAP, GraphQL
Banco de dados: PostgreSQL, MySQL, SQL Server
Arquivos: FTP, SFTP, Azure Blob, S3
Webhooks: entrada e saída
```

---

## Regras

### Obrigatório

```text
Status é atualizado a cada 30 segundos
Falhas são logadas automaticamente
Retry tem backoff exponencial
Monitoramento tem alertas configuráveis
Webhook tem validação de assinatura
```

### Proibido

```text
Credencial hardcoded
Retry infinito
Log sem payload limitado
Falha sem alerta
Conector sem status
```

---

## Integrações

| MD / FRONT | Finalidade |
|-----------|-----------|
| MD-070 — Integration Hub | Hub central de integrações |
| MD-071 — API Gateway | APIs externas |
| MD-072 — Webhook System | Webhooks |
| MD-073 — File Transfer | Transferência de arquivos |
| MD-065 — Observability Platform | Logs e métricas |
| MD-052 — Audit Trail Architecture | Auditoria |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-013 — Notification Center | Notificações via integração |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | Painéis, logs, status, retry, monitoramento |
| Backend | APIs de conectores, status, integração |
| Dispatcher | Roteamento para SPs de integração |
| SP | Execução de integrações, retry, validação |
| Event Store | Registrar falhas, sucessos, retry |

---

## Métricas

```text
Integrações ativas
Taxa de sucesso por conector
Latência média por integração
Falhas por dia
Tentativas de retry
Volume de dados transferidos
Conectores mais usados
Tempo de recuperação após falha
Alertas disparados
```

---

## Lei

```text
Integração é centralizada.
Integração é monitorada.
Integração é confiável.
Integração é recuperável.
```

---

## Próximo

```text
FRONT-027 completo
  ↓
FRONT-028 — Enterprise Analytics Experience
```