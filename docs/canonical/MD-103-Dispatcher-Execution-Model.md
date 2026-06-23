# MD-103 — Dispatcher Execution Model

## Status

Documento Canônico Fundacional de Execução.
Define o modelo de execução canônico da plataforma.

---

## Objetivo

Padronizar como toda requisição flui desde o frontend até o banco e retorna.

---

## Princípio Fundamental

```text
Nenhuma aplicação executa sozinha.
Toda execução passa pelo Dispatcher.
Toda execução respeita sessão, tenant,
unidade, local, perfil e permissão.
```

---

## Fluxo Canônico

```
Frontend (React/TSX)
  ↓ API Call (HTTP/HTTPS)
Backend (Node/Express)
  ↓ Auth Middleware
IAM (MD-034)
  ↓ Context Resolution
Context Engine (MD-108)
  ↓ Permission Check
Permission Engine (MD-034)
  ↓ Routing
Dispatcher (MD-004)
  ↓ Stored Procedure Call
MySQL (MD-101)
  ↓ Success?
  ↓
  ├── Sim → Evento (Event Store)
  │         ↓
  │       Auditoria
  │         ↓
  │       Resposta ao Frontend
  │
  └── Não → Erro Canônico
            ↓
          Rollback (se necessário)
            ↓
          Auditoria de Erro
            ↓
          Resposta de Erro ao Frontend
```

---

## Componentes

### Frontend

```text
Captura input do usuário
Validação estrutural (tipos, campos obrigatórios)
Chama API oficial
Recebe resposta canônica
Atualiza UI
Gera evento local (opcional, para analytics)
```

**Restrições:**
- Frontend NÃO decide regra de negócio
- Frontend NÃO valida permissão
- Frontend NÃO acessa banco diretamente
- Frontend NÃO monta payload de regra

### Backend / Node

```text
Recebe requisição HTTP
Valida autenticação (JWT + Refresh Token)
Valida sessão ativa
Extrai contexto (tenant, unidade, local, perfil)
Valida permissão para a ação
Monta payload canônico
Encaminha para Dispatcher
Trata resposta
Retorna para frontend
```

**Restrições:**
- Backend NÃO decide regra de negócio
- Backend NÃO valida regra de negócio
- Backend NÃO acessa banco diretamente
- Backend NÃO executa SPs sem Dispatcher

### Dispatcher

```text
Recebe: app, ação, payload
Valida: app existe no Registry
Valida: ação existe na App
Valida: permissão para ação
Valida: contexto válido para ação
Monta: chamada SP canônica
Executa: via conexão MySQL segura
Captura: resultado, linhas afetadas, erros
Emite: evento no Event Store
Retorna: código canônico de resultado
```

**Responsabilidades:**
- Roteamento único para SPs
- Validação de contrato de entrada
- Tratamento de erro transacional
- Garantia de imutabilidade de eventos

### Stored Procedure

```text
Valida permissões finais (defesa em profundidade)
Valida contexto final
Executa regra de negócio
Executa transação ACID
Gera/atualiza dados canônicos
Retorna código canônico
```

**Responsabilidades:**
- Única camada de escrita no banco
- Regra de negócio definitiva
- Integridade referencial garantida
- Auditoria interna (logs de banco)

### Event Store

```text
Registra: evento canônico
Formato: JSON padronizado
Conteúdo: app, ação, usuário, tenant, timestamp, payload resumido, resultado
Imutável: nunca atualizado, nunca deletado
Disponível: para consulta e replay
```

---

## Códigos Canônicos de Resultado

| Código | Significado | Ação do Frontend |
|--------|-------------|------------------|
| 200 | Sucesso | Exibir resultado |
| 201 | Criado | Exibir novo registro |
| 400 | Dados inválidos | Mostrar erro de validação |
| 401 | Não autenticado | Redirecionar para login |
| 403 | Sem permissão | Mostrar acesso negado |
| 404 | Recurso não encontrado | Mostrar não encontrado |
| 409 | Conflito (ex: senha já finalizada) | Mostrar conflito |
| 422 | Regra de negócio violada | Mostrar erro específico |
| 500 | Erro interno | Mostrar erro genérico + reportar |
| 503 | Indisponível | Mostrar temporariamente indisponível |

---

## Segurança

### Autenticação

```text
JWT no header Authorization
Refresh Token em HttpOnly Cookie
Validação em cada requisição
Revogação imediata por admin
```

### Autorização

```text
IAM valida: usuário tem permissão para app?
IAM valida: usuário tem permissão para ação?
IAM valida: contexto permite execução?
Tríplice validação: Backend + Dispatcher + SP
```

### Isolamento Multi-Tenant

```text
Toda requisição carrega id_tenant
Toda SP recebe id_tenant como primeiro parâmetro
Filtro automático por tenant em todas as queries
Nenhuma query cruza dados de tenants
```

---

## Tratamento de Erro

### Erro de Validação (400)

```text
Frontend enviou dados inválidos.
Dispatcher rejeita antes da SP.
Evento: VALIDATION_ERROR
Auditoria: registro de tentativa inválida
```

### Erro de Permissão (403)

```text
Usuário sem permissão para ação.
Backend ou IAM detecta.
Dispatcher NÃO encaminha para SP.
Evento: PERMISSION_DENIED
Auditoria: registro de acesso negado
```

### Erro de Regra de Negócio (422)

```text
SP executou e detectou violação de regra.
Ex: senha já finalizada, estoque insuficiente.
Evento: BUSINESS_RULE_VIOLATION
Auditoria: registro da tentativa
Transação: rollback
```

### Erro de Sistema (500)

```text
Falha não esperada.
Dispatcher captura exceção.
Evento: SYSTEM_ERROR
Auditoria: registro completo de erro
Alerta: para SRE/Admin
Transação: rollback
```

---

## Performance

| Camada | Meta |
|--------|------|
| Frontend → Backend | P95 < 200ms |
| Backend → Dispatcher | P95 < 100ms |
| Dispatcher → MySQL | P95 < 300ms |
| Response total (happy path) | P95 < 500ms |
| Response total (complexo) | P95 < 2000ms |

---

## Integrações

```text
MD-001 — Núcleo da Plataforma
MD-002 — Autenticação
MD-003 — Contexto Operacional
MD-004 — Dispatcher
MD-005 — Event Store Core
MD-010 — Security
MD-016 — Auditoria
MD-017 — Multi-Tenant
MD-019 — App Registry Canônico
MD-025 — Event Store Core
MD-034 — Identity Access Management
MD-038 — Integration Hub
MD-101 — Canonical Data Architecture
MD-102 — SP First Architecture
MD-104 — Event Convergence Architecture
```

---

## Responsabilidades

| Camada | Responsabilidade | Não Responsabilidade |
|--------|------------------|---------------------|
| Frontend | UI, input, exibição | Regra de negócio, escrita direta |
| Backend | Auth, contexto, roteamento | Regra de negócio, escrita direta |
| Dispatcher | Orquestração, contrato, SP | Lógica de negócio |
| SP | Regra de negócio, escrita | Roteamento, UI, auth |
| Event Store | Rastro, auditoria | Comando, escrita de negócio |

---

## Lei Final

```text
Frontend pede.
Backend autoriza.
Dispatcher orquestra.
SP executa.
Evento registra.
Banco é a verdade.
```
