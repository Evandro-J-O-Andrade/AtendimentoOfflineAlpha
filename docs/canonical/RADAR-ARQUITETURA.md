# RADAR-ARQUITETURA — Maturidade dos Domínios

## Status
EM EVOLUÇÃO

---

# Legenda

```text
██████████ 100% — CONSOLIDADO
████████░░  80% — AVANÇADO
██████░░░░  60% — EM CONSTRUÇÃO
████░░░░░░  40% — INICIAL
██░░░░░░░░  20% — RASCUNHO
█░░░░░░░░░   0% — NÃO INICIADO
aguardando  — AGUARDANDO DEPENDÊNCIA
```

---

# CORE ENTERPRISE (Portal Focus)

```text
Pessoa              ██████████ 100% — CONSOLIDADO
Usuário             ██████████ 100% — CONSOLIDADO
IAM                 ██████████ 100% — CONSOLIDADO
Contexto            ██████████ 100% — CONSOLIDADO
Portal              ██████████ 100% — CONSOLIDADO
FFA                 █████████░  90% — AVANÇADO
Tenant              ██████████ 100% — CONSOLIDADO
Dispatcher          ██████████ 100% — CONSOLIDADO
Ledger              ██████████ 100% — CONSOLIDADO
Workflow Engine     ██████████ 100% — CONSOLIDADO
Runtime             █████████░  90% — AVANÇADO
Kernel              █████████░  90% — AVANÇADO
```

# SHARED SERVICES (Context-Independent)

```text
Notificações        ████░░░░░░  40% — INICIAL (fragmentado)
Agenda              █████████░  90% — AVANÇADO
Chat                ██░░░░░░░░  20% — RASCUNHO
AVA                 ████░░░░░░  40% — INICIAL
GLPI                ████░░░░░░  40% — INICIAL
Documents           ██████░░░░  60% — EM CONSTRUÇÃO
Storage             ████░░░░░░  40% — INICIAL
Help Center         ██░░░░░░░░  20% — RASCUNHO
Social              ██░░░░░░░░  20% — RASCUNHO
Ramal               ██░░░░░░░░  20% — RASCUNHO
```

# CONTEXT OP (Operacional)

```text
Unidade/Setor/Local  ██████████ 100% — CONSOLIDADO
Escala              ███████░░░  60% — EM CONSTRUÇÃO
Leitos              █████████░  90% — AVANÇADO
Displays            █████████░  90% — AVANÇADO
Totens              █████████░  90% — AVANÇADO
```

---

# PLATFORM

```text
Design System       █████████░  90% — AVANÇADO
App Registry        █████████░  90% — AVANÇADO
API Gateway         █████████░  80% — AVANÇADO
Observabilidade     ████████░░  80% — AVANÇADO
SRE Platform      ███████░░░  60% — EM CONSTRUÇÃO (MAP-021 integra)
N8N / Automação     ███████░░░  60% — EM CONSTRUÇÃO
IA Core             ███████░░░  60% — EM CONSTRUÇÃO
Notificações        ████░░░░░░  40% — INICIAL
Storage Service     ████░░░░░░  40% — INICIAL
Search              ███░░░░░░░  30% — RASCUNHO
Service Mesh        █░░░░░░░░░  10% — NÃO INICIADO
```

---

# APPS

```text
APP HIS             █████████░  90% — AVANÇADO
  ├── Senha        █████████░  90% — AVANÇADO
  ├── Fila         █████████░  90% — AVANÇADO
  ├── FFA          █████████░  80% — AVANÇADO
  ├── Triagem      █████████░  80% — AVANÇADO
  ├── Execução     █████████░  70% — EM CONSTRUÇÃO
  ├── Farmácia     ███████░░░  60% — EM CONSTRUÇÃO
  ├── Faturamento  ███████░░░  60% — EM CONSTRUÇÃO

APP CRM             ██░░░░░░░░  20% — RASCUNHO
APP RH              ██░░░░░░░░  20% — RASCUNHO
APP Financeiro      ██░░░░░░░░  20% — RASCUNHO
APP SAC             █░░░░░░░░░   0% — NÃO INICIADO
APP Logística       █░░░░░░░░░   0% — NÃO INICIADO
APP Social          █░░░░░░░░░   0% — NÃO INICIADO
APP Chat            █░░░░░░░░░   0% — NÃO INICIADO
APP Wiki            █░░░░░░░░░   0% — NÃO INICIADO
APP Analytics       ███████░░░  60% — EM CONSTRUÇÃO
```

---

# INTEGRAÇÕES

```text
TISS                ██░░░░░░░░  20% — RASCUNHO
PIX                 ██░░░░░░░░  20% — RASCUNHO
Cartão              ██░░░░░░░░  20% — RASCUNHO
Laboratório Ext.    ██░░░░░░░░  20% — RASCUNHO
Imaging PACS        █░░░░░░░░░  10% — NÃO INICIADO
ERP Financeiro      █░░░░░░░░░  10% — NÃO INICIADO
Email Gateway       ██░░░░░░░░  20% — RASCUNHO
SMS Gateway         ██░░░░░░░░  20% — RASCUNHO
CRM Legado          ██░░░░░░░░  20% — RASCUNHO
```

---

# INFRA

```text
Filas               █████████░  90% — AVANÇADO
Jobs                █████████░  90% — AVANÇADO
Sync Engine         █████████░  90% — AVANÇADO
Runtime Queue       █████████░  90% — AVANÇADO
Caches              ████░░░░░░  40% — INICIAL
Message Brokers     ████░░░░░░  40% — INICIAL
Load Balancer       ████░░░░░░  40% — INICIAL (MAP-021)
API Pool            ████░░░░░░  40% — INICIAL (MAP-021)
```

---

# LEGADO (Em Análise)

```text
Dump SQL            ███████░░░  60% — EM CONSTRUÇÃO
Procedures         ███████░░░  60% — EM CONSTRUÇÃO
Functions          ████░░░░░░  40% — INICIAL
Views              ████░░░░░░  40% — INICIAL
Eventos            ████░░░░░░  40% — INICIAL
```

---

# Regras de Atualização

```text
❌ Nunca retroceder maturidade.
✅ Avançar maturidade apenas com evidência.
✅ Atualizar após cada ciclo de evolução concluído.
✅ Registrar data da última atualização.
```

---

# Histórico

```text
2026-06-29 — Versão inicial do Radar.
2026-06-30 — MAP-021 — Platform Infrastructure Domain adicionado (Load Balancer, API Pool).
2026-06-30 — Classificação Core Enterprise atualizada (MASTER-CONSOLIDADO).
```

Documento Canônico — RADAR-ARQUITETURA

**Este documento reflete o estado atual da maturidade arquitetural.**
