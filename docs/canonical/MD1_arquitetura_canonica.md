# MD 1 — ARQUITETURA CANÔNICA DA PLATAFORMA

## Definição

A plataforma é um:

```text
DB-Driven Distributed Workflow Engine
com SP Master Layer como núcleo de controle
e execução baseada em Stored Procedures por domínio
```

MySQL atua como runtime operacional. O backend é uma fachada de transporte, autenticação, autorização, contexto e chamada de Stored Procedures.

## Camadas Oficiais

### 1. Frontend Layer

Responsabilidade:

- enviar comandos estruturados
- exibir respostas
- manter estado de interface

Proibido:

- regra de negócio
- decisão assistencial, operacional, financeira ou farmacêutica
- acesso direto a tabelas

### 2. API Layer

Responsabilidade:

- transporte HTTP
- autenticação
- autorização
- validação de entrada
- repasse de payload para Stored Procedures

Proibido:

- lógica de domínio
- regras assistenciais
- decisões de fluxo
- escrita direta em tabelas de negócio

### 3. SP Master Layer

Componentes:

- `sp_master_dispatcher`
- `sp_master_dispatcher_runtime`
- `sp_master_orquestradora`
- `sp_master_routes`

Responsabilidades:

- validar sessão
- validar permissões
- validar contexto operacional
- garantir idempotência via `uuid_transacao`
- rotear comandos
- selecionar executor
- governar execução

Proibido:

- executar regra de negócio
- persistir estado final complexo
- substituir executores especializados

### 4. Domain Execution Layer

SPs especializadas:

- `sp_executor_assistencial_*`
- `sp_executor_estoque_*`
- `sp_executor_fila_*`
- `sp_executor_faturamento_*`
- `sp_executor_farmacia_*`

Responsabilidade:

- executar regra de negócio
- atualizar tabelas canônicas
- gerar eventos
- retornar resultado padronizado

### 5. Event + State Layer

Responsabilidade:

- auditoria
- rastreabilidade
- snapshots de estado
- logs por domínio
- reconstrução de estado

Estado atual:

- fragmentado
- funcional
- não canônico

## Lei Arquitetural

```text
Frontend
  ↓
API
  ↓
sp_master_dispatcher
  ↓
sp_master_orquestradora
  ↓
sp_executor_*
  ↓
tabelas de estado + eventos
```
