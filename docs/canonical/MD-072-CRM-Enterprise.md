# MD-072 — CRM Enterprise

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Transformar dados brutos em inteligência comercial acionável.

---

## Princípio Fundamental

```text
Todo ponto de contato com o cliente
é uma fonte de inteligência comercial.
```

---

## Componentes

### Contas

Organizações:

```text
Empresas
Hospitais
Clínicas
Escolas
Farmácias
Redes
```

### Contatos

Pessoas físicas:

```text
Pacientes
Clientes
Alunos
Parceiros
Colaboradores
```

### Leads

Oportunidades:

```text
Origem
Interesse
Qualificação
Funil
Score
Conversão
```

### Oportunidades

Negociações:

```text
Valor
Prazo
Estágio
Probabilidade
Origem
Responsável
```

### Atividades

Interações:

```text
Ligações
Reuniões
Emails
Visitas
Propostas
 Follow-ups
```

---

## Pipeline

```text
Lead
  ↓
Qualificado
  ↓
Proposta
  ↓
Negociação
  ↓
Fechamento
  ↓
Cliente
  ↓
Sucesso
  ↓
Expansão
```

---

## Regras

1. Todo lead nasce do Marketing ou do Customer 360.
2. Nenhuma negociação fora do Pipeline.canônico.
3. Toda atividade é registrada no Event Store.
4. Score é calculado por IA.
5. Regras de follow-up são automatizadas via N8N.
6. Dados são sempre enriquecidos pelo Customer 360.

---

## Integrações

```text
MD-071 Customer 360
MD-073 SAC Omnichannel
MD-074 Digital Commerce
MD-075 Marketplace Seller Hub
MD-076 Loyalty & Rewards
MD-087 Enterprise Search
MD-088 Global Notification Center
MD-081 AI Copilot
```

---

## Lei

```text
CRM não é um sistema.

CRM é a inteligência comercial

centralizada da plataforma.
```

---

## Responsabilidades

Plataforma é responsável por:

```text
Pipeline canônico
Score automatizado
Enriquecimento automático
Visão 360 do cliente
Regras de negócio centralizadas
```

Aplicações são responsáveis por:

```text
Capturar eventos relevantes
Disparar ações comerciais
Usar APIs do CRM
Respeitar regras de follow-up
```

---

## Métricas

```text
MRR
ARR
Pipeline
Conversão
Ticket Médio
CAC
LTV
Churn
Win Rate
```
