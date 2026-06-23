# MAP-018 — Document Domain Architecture

## Status
Documento Canônico de Arquitetura.
Arquitetura do domínio documental.

---

## Classificação
```text
Tipo: Domain Architecture
Camada: Domínio
Prioridade: Alta
Obrigatoriedade: Corporativo
```

---

## Objetivo
Definir arquitetura de documentos com versionamento e workflow.

---

## Bounded Contexts

### Documento Context
```text
Documento
Versão
Tipo
Status
```

### Versão Context
```text
Versão
Documento
Conteúdo
Changelog
Autor
```

### Aprovação Context
```text
Aprovador
Status
Data
Comentários
```

### Assinatura Context
```text
Assinatura
Documento
Responsável
Data
Validade
```

---

## Agregados

### Documento Aggregate
```text
documento_id
tenant_id
tipo_id
titulo
status
criado_por
data_criacao
data_atualizacao
versao_atual
```

### Versão Aggregate
```text
versao_id
documento_id
numero
conteudo
mudancas
criado_por
data_criacao
```

---

## Eventos Oficiais

### DocumentoCriado
### VersaoCriada
### DocumentoSubmetido
### DocumentoAprovado
### DocumentoRejeitado
### DocumentoAssinado

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-001 — Enterprise Domain | Foundation |
| MAP-008 — Workflow | Workflows |
| FRONT-021 — Document Experience | UX |
| FRONT-023 — Approval Center | Aprovações |