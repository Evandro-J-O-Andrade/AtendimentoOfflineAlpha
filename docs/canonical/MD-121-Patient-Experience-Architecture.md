# MD-121 — Patient Experience Architecture

## Status
Documento Canônico Supremo.
Arquitetura de experiência do paciente no Portal Midas.

## Classificação
```text
Tipo: Foundation Architecture
Camada: Platform Core
Prioridade: Crítica
Obrigatoriedade: Global
```

## Objetivo
Definir como o paciente interage com a plataforma Midas, integrando-se ao fluxo assistencial sem quebrar isolamento multi-tenant.

---

## Fluxo de Acesso

### Portal Único
```text
Login (Pessoa)
↓
Portal Enterprise
↓
Contextos Disponíveis
↓
Dashboard Paciente
```

---

### Contextos Disponíveis
Paciente pode possuir múltiplos contextos:

```text
Hospital A

UPA B

UBS C

Laboratório D

Farmácia E

Convênio F
```

---

## Lei Canônica MD-121-001
```text
Paciente entra pelo Portal Enterprise.
Nunca diretamente no HIS.
```

---

## Lei Canônica MD-121-002
```text
Contexto define visibilidade dos dados.
```

---

## Lei Canônica MD-121-003
```text
1 contexto = acesso direto ao dashboard.

N contextos = seleção de contexto.
```

---

# Dashboard do Paciente

## Componentes
```text
Card Agendamentos

Card Exames

Card Receitas

Card Fila

Card Atendimentos

Card Documentos

Card Satisfação

Card Notificações
```

---

## Dashboard Hospital
Exibe:

```text
Próxima Senha

Tempo Estimado

Fila Atual

Atendimentos

Exames

Receitas

Documentos
```

---

## Dashboard Laboratório
Exibe:

```text
Coletas Pendentes

Resultados Disponíveis

Laudos

Histórico
```

---

## Dashboard Farmácia
Exibe:

```text
Receitas Ativas

Medicamentos Disponíveis

Dispensações

Histórico
```

---

# QRCode de Identificação

## Pulseira
Contém:

```text
PersonID

PatientRoleID

TenantID

Token Seguro
```

---

## Uso Operacional
Quando profissional escaneia:

```text
QRCode
↓
Portal Interno
↓
Identifica Paciente + Contexto
```

---

# QRCode de Resultado

## Laboratório
Contém:

```text
ArtifactID

ExamID

TenantID
```

---

## Acesso
Paciente entra:

```text
QRCode
↓
Portal
↓
Login
↓
Resultado
```

---

# Eventos Oficiais

### PatientContextSelected
Payload: {person_id, tenant_id, context}

### PatientDashboardViewed
Payload: {person_id, tenant_id, components}

### PatientFeedbackSubmitted
Payload: {person_id, rating, comments}

---

# Stored Procedures

### sp_patient_dashboard_load
Input: {person_id, tenant_id}
Output: {dashboard_data}

### sp_patient_context_select
Input: {person_id, tenant_id}
Output: {contexts_available}

---

# Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-005 — Portal Architecture | Portal |
| MD-120 — Party Identity | Identidade |
| MAP-011 — HIS Domain | Dados assistenciais |
| FRONT-002 — Context Selection | UX Contexto |

---

# Status
```text
MD-001 → MD-121 ✅

Próximo: MD-122 — Patient Access Patterns
```