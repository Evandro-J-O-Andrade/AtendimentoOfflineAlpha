# MAP-018 — Document Domain Architecture

## Status
Documento Canônico de Arquitetura.
Arquitetura do domínio documental.

## Classificação
```text
Tipo: Domain Architecture
Camada: Domínio
Prioridade: Alta
Obrigatoriedade: Corporativo
```

## Objetivo
Definir a arquitetura completa do Document com bounded contexts, agregados, eventos e regras de negócio.

---

## Leis Canônicas Globais Aplicáveis

### LC-001 — Portal é a Entrada Oficial
```text
Login → Portal → Application Registry → Documents → Context Selection → Dashboard
```

### LC-005 — SP First Architecture
```text
Frontend → API → Service → Dispatcher → Stored Procedure → Database
```

### LC-008 — Audit First
```text
Toda versão é auditável.
```

---

## Lei Canônica MAP-018-001
```text
Documento não é arquivo. Documento é fluxo.
```

---

## Hierarquia de Domínios
```text
Document Domain
├── Documento Context
├── Versão Context
├── Aprovação Context
└── Assinatura Context
```

---

## Fluxo Documental Oficial
```text
Criar
↓
Rascunho
↓
Submeter
↓
Aprovar
↓
Assinar
↓
Arquivar
```

---

## Bounded Contexts

### Documento Context
Responsável por: Documento, Tipo, Status, Metadados, Proprietário
Agregado: Documento

### Versão Context
Responsável por: Versão, Conteúdo, Mudanças, Autor, Changelog
Agregado: Versao

### Aprovação Context
Responsável por: Aprovador, Status, Data, Comentários, Histórico
Agregado: Aprovacao

### Assinatura Context
Responsável por: Assinatura, Responsável, Data, Validade, Certificado
Agregado: Assinatura

---

## Agregados Principais

### Documento Aggregate
```text
documento_id (PK)
tenant_id (FK)
tipo_id (FK)
titulo
status
criado_por (user_id)
data_criacao
data_atualizacao
versao_atual
```

### Versao Aggregate
```text
versao_id (PK)
documento_id (FK)
numero
conteudo
mudancas
criado_por (user_id)
data_criacao
tamanho
```

### Aprovacao Aggregate
```text
aprovacao_id (PK)
documento_id (FK)
etapa
aprovador_id
status
comentarios
data_decisao
```

---

## Eventos Oficiais

### DocumentoCriado
Payload: {documento_id, tipo, titulo, tenant_id}

### VersaoCriada
Payload: {versao_id, documento_id, numero, autor_id}

### DocumentoSubmetido
Payload: {documento_id, workflow_id}

### DocumentoAprovado
Payload: {documento_id, aprovador_id, etapa}

### DocumentoRejeitado
Payload: {documento_id, motivo, aprovador_id}

### DocumentoAssinado
Payload: {documento_id, assinatura_id}

---

## Stored Procedures

### sp_documento_criar
Input: {tipo_id, titulo, conteudo}
Output: {documento_id}

### sp_documento_submeter
Input: {documento_id, workflow_id}
Output: {status}

### sp_documento_aprovar
Input: {documento_id, aprovador_id, comentarios}
Output: {status}

### sp_documento_assinar
Input: {documento_id, codigo}
Output: {assinatura_id}

---

## APIs Oficiais

### /api/v1/documents
POST - Criar documento
GET - Listar documentos

### /api/v1/documents/{id}/versions
POST - Nova versão

---

## Regras Arquiteturais

### Versionamento Rule
Todo documento tem histórico de versões.

### SP First Rule
Toda escrita passa por Stored Procedure.

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-008 — Workflow | Aprovações |
| MD-089 — Workflow Fabric | Workflows |
| FRONT-021 — Document Experience | UX |
| FRONT-023 — Approval Center | Aprovações |