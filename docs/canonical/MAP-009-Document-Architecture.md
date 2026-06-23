# MAP-009 — Document Architecture

## Status
Documento Canônico de Arquitetura.
Arquitetura de documentos corporativos.

---

## Classificação
```text
Tipo: Domain Architecture
Camada: Plataforma
Prioridade: Alta
Obrigatoriedade: Global
```

---

## Objetivo
Definir arquitetura de documentos como entidade viva.

---

## Lei Canônica MAP-009-001
```text
Documento não é arquivo.
Documento é fluxo.
```

---

## Entidades

### Document
```text
document_id (UUID)
tenant_id
type
title
content
status
version
created_by
created_at
updated_at
```

### DocumentVersion
```text
version_id (UUID)
document_id
version_number
content
changes
created_by
created_at
```

### DocumentComment
```text
comment_id (UUID)
document_id
user_id
content
created_at
parent_id
```

### DocumentApproval
```text
approval_id (UUID)
document_id
step
approver_id
status
comments
approved_at
```

---

## Document Lifecycle

### States
```text
DRAFT
PENDING_APPROVAL
APPROVED
REJECTED
ARCHIVED
SUPERSEDED
```

### Transitions
```text
Create → Draft
Submit → Pending Approval
Approve → Approved
Reject → Rejected
Archive → Archived
Update → Superseded
```

---

## Workflow Integration

### Approval Flow
```text
Document → Workflow Engine → Approvers → Approved/Rejected
```

### Signature Integration
```text
Approved document → Signature service
```

---

## Stored Procedures

### sp_document_create
Criar documento

### sp_document_submit
Submeter para aprovação

### sp_document_approve
Aprovar documento

### sp_document_reject
Rejeitar documento

### sp_document_version
Versionar documento

---

## Eventos Oficiais

### DocumentCreated
Documento criado

### DocumentSubmitted
Submetido para aprovação

### DocumentApproved
Documento aprovado

### DocumentRejected
Documento rejeitado

### DocumentSigned
Documento assinado

---

## Permissions Model

### Capabilities
```text
document:create
document:read
document:update
document:delete
document:approve
document:sign
document:comment
```

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-008 — Workflow | Aprovações |
| MD-098 — Risk Management | Auditoria |
| FRONT-021 — Document Experience | UX |
| FRONT-023 — Approval Center | Aprovações |