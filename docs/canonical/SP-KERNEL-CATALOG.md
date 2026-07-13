# SP-KERNEL-CATALOG

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Catálogo de stored procedures do Kernel.
```

---

## 1. Propósito

Este documento é o **catálogo oficial de stored procedures** do Kernel Enterprise.

Ele serve para:
- Listar todas as SPs do Kernel
- Definir tipo e responsabilidade de cada SP
- Garantir que toda regra de negócio reside em SP
- Servir como referência para implementação

Stored Procedures são a **única porta de escrita** no banco.
Nenhuma camada acima escreve diretamente.

---

## 2. Princípio Fundamental

```text
SP é a única porta de escrita.
Frontend exibe.
Backend roteia.
SP executa.
Nenhuma escrita direta em tabela.
```

---

## 3. Tipos de SP

| Tipo | Sigla | Responsabilidade |
|------|-------|------------------|
| MASTER | MAS | Entrada única, valida contrato e permissão |
| DISPATCHER | DIS | Roteia para executor apropriado |
| ORCHESTRATOR | ORC | Coordena múltiplas SPs, gerencia transação |
| EXECUTOR | EXE | Executa operação específica |
| ASSERT | ASR | Valida entrada antes da operação |
| QUERY | QRY | Consulta apenas leitura |
| COMMAND | CMD | Alteração de estado |
| EVENT | EVT | Registra evento no Event Store |
| LEDGER | LED | Registra evidência no Ledger |

---

## 4. Catálogo de SPs

### 4.1 Foundation Layer

| SP | Tipo | Entidade | Descrição |
|----|------|----------|-----------|
| sp_pessoa_get | QRY | pessoa | Obter pessoa por ID |
| sp_pessoa_create | CMD | pessoa | Criar pessoa |
| sp_pessoa_update | CMD | pessoa | Atualizar pessoa |
| sp_pessoa_list | QRY | pessoa | Listar pessoas |
| sp_usuario_get | QRY | usuario | Obter usuário por ID |
| sp_usuario_create | CMD | usuario | Criar usuário |
| sp_usuario_update | CMD | usuario | Atualizar usuário |
| sp_usuario_list | QRY | usuario | Listar usuários |
| sp_usuario_authenticate | ASR | usuario | Autenticar usuário |
| sp_tenant_get | QRY | tenant | Obter tenant por ID |
| sp_tenant_create | CMD | tenant | Criar tenant |
| sp_tenant_update | CMD | tenant | Atualizar tenant |
| sp_tenant_list | QRY | tenant | Listar tenants |
| sp_sessao_create | CMD | sessao | Criar sessão |
| sp_sessao_validate | ASR | sessao | Validar sessão |
| sp_sessao_revoke | CMD | sessao | Revogar sessão |
| sp_sessao_expire | CMD | sessao | Expirar sessão |
| sp_sessao_get | QRY | sessao | Obter sessão por ID |
| sp_contexto_resolve | ORC | contexto | Resolver contexto |
| sp_contexto_switch | CMD | contexto | Trocar contexto |
| sp_contexto_get | QRY | contexto | Obter contexto ativo |
| sp_contexto_options | QRY | contexto | Listar opções de contexto |

### 4.2 Governance Layer

| SP | Tipo | Entidade | Descrição |
|----|------|----------|-----------|
| sp_auth_evaluate | MAS | auth | Avaliar acesso |
| sp_auth_permit | CMD | auth | Permitir acesso |
| sp_auth_deny | CMD | auth | Negar acesso |
| sp_auth_audit | LED | auth | Auditar decisão |
| sp_auth_policy_get | QRY | auth_policy | Obter política |
| sp_auth_policy_create | CMD | auth_policy | Criar política |
| sp_auth_role_get | QRY | auth_role | Obter papel |
| sp_auth_role_create | CMD | auth_role | Criar papel |
| sp_auth_permission_get | QRY | auth_permission | Obter permissão |
| sp_auth_permission_create | CMD | auth_permission | Criar permissão |
| sp_event_publish | EVT | event_stream | Publicar evento |
| sp_event_consume | QRY | event_stream | Consumir evento |
| sp_event_get | QRY | event_stream | Obter evento |
| sp_ledger_append | LED | kernel_ledger | Anexar evidência |
| sp_ledger_query | QRY | kernel_ledger | Consultar ledger |
| sp_ledger_archive | CMD | kernel_ledger | Arquivar evidência |

### 4.3 Runtime Layer

| SP | Tipo | Entidade | Descrição |
|----|------|----------|-----------|
| sp_registry_module_get | QRY | registry_module | Obter módulo |
| sp_registry_module_create | CMD | registry_module | Criar módulo |
| sp_registry_module_list | QRY | registry_module | Listar módulos |
| sp_registry_capability_get | QRY | registry_capability | Obter capability |
| sp_registry_capability_create | CMD | registry_capability | Criar capability |
| sp_registry_capability_list | QRY | registry_capability | Listar capabilities |
| sp_discovery_resolve | ORC | discovery | Resolver descoberta |
| sp_discovery_query | QRY | discovery | Consultar descoberta |
| sp_discovery_invalidate | CMD | discovery | Invalidar cache |
| sp_runtime_execute | EXE | runtime_execution | Executar capability |
| sp_runtime_status | QRY | runtime_execution | Obter status |
| sp_runtime_cancel | CMD | runtime_execution | Cancelar execução |
| sp_runtime_compensate | CMD | runtime_execution | Compensar execução |
| sp_navigation_project | ORC | navigation | Projetar navegação |
| sp_navigation_query | QRY | navigation | Consultar navegação |

### 4.4 Integration Layer

| SP | Tipo | Entidade | Descrição |
|----|------|----------|-----------|
| sp_workflow_start | ORC | workflow_process | Iniciar workflow |
| sp_workflow_transition | EXE | workflow_process | Transicionar workflow |
| sp_workflow_state | QRY | workflow_process | Obter estado |
| sp_workflow_compensate | CMD | workflow_process | Compensar workflow |
| sp_workflow_state_create | CMD | workflow_state | Criar estado |
| sp_workflow_transition_create | CMD | workflow_transition | Criar transição |
| sp_integration_execute | EXE | integration_registry | Executar integração |
| sp_integration_get | QRY | integration_registry | Obter integração |
| sp_integration_create | CMD | integration_registry | Criar integração |
| sp_integration_adapter_get | QRY | integration_adapter | Obter adaptador |
| sp_integration_contract_get | QRY | integration_contract | Obter contrato |

---

## 5. Padrões

### 5.1 Nomenclatura

```text
sp_{tipo}_{acao}_{entidade}

Tipos:
  mas = master
  dis = dispatcher
  orc = orchestrator
  exe = executor
  asr = assert
  qry = query
  cmd = command
  evt = event
  led = ledger

Exemplos:
  sp_mas_auth_evaluate
  sp_exe_runtime_execute
  sp_cmd_usuario_create
  sp_qry_tenant_list
  sp_evt_event_publish
  sp_led_ledger_append
```

### 5.2 Estrutura

```sql
CREATE PROCEDURE sp_{tipo}_{acao}_{entidade}(
  IN p_id_tenant BIGINT,
  IN p_id_usuario BIGINT,
  IN p_id_sessao BIGINT,
  ...
)
BEGIN
  -- Validações
  -- Lógica de negócio
  -- Eventos
  -- Retorno
END;
```

### 5.3 Retorno

```sql
-- Sucesso
SELECT 
  'success' AS resultado,
  dados AS payload;

-- Erro
SELECT 
  'error' AS resultado,
  codigo_erro AS codigo,
  mensagem_erro AS mensagem;
```

---

## 6. Regras

### 6.1 Criação

```text
Nova SP:
1. Verificar se já existe SP equivalente
2. Se existir: reutilizar
3. Se não existir: criar com tipo definido
4. Documentar em SP-KERNEL-CATALOG.md
5. Aprovar
6. Implementar
```

### 6.2 Alteração

```text
Alterar SP:
1. Avaliar impacto
2. Testar
3. Documentar
4. Aprovar
5. Implementar
```

### 6.3 Exclusão

```text
Excluir SP:
1. Verificar dependências
2. Migrar consumidores
3. Marcar como deprecated
4. Remover após período
```

---

## 7. Integração com Kernel

### 7.1 SPs por domínio

| Domínio | SPs |
|---------|-----|
| Identity | sp_pessoa_*, sp_usuario_* |
| Tenant | sp_tenant_* |
| Session | sp_sessao_* |
| Context | sp_contexto_* |
| Authorization | sp_auth_* |
| Discovery | sp_discovery_* |
| Registry | sp_registry_* |
| Runtime | sp_runtime_* |
| Navigation | sp_navigation_* |
| Workflow | sp_workflow_* |
| Event | sp_event_* |
| Ledger | sp_ledger_* |
| Integration | sp_integration_* |

### 7.2 Fluxo de execução

```text
Frontend
  ↓
Backend
  ↓
SP Master (valida contrato, permissão)
  ↓
SP Dispatcher (roteia)
  ↓
SP Executor (executa)
  ↓
Banco
  ↓
SP Event (registra evento)
  ↓
SP Ledger (registra evidência)
  ↓
Response
```

---

## 8. Próximos Artefatos

| Prioridade | Artefato | Descrição |
|------------|----------|-----------|
| Baixa | [Nenhum] | Catálogo completo |

---

## 9. Referências

- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
- MD-KERNEL-001 até MD-KERNEL-014
- MAP-CORE-PLATFORM
- BR-CATALOG
- MAP-RUNTIME-FLOW
- MAP-DATA-CANONICAL
- REVIEW-KERNEL-TRANSVERSAL
- MODEL-LOGICAL-KERNEL
- MODEL-PHYSICAL-KERNEL
- MAPA DO KERNEL ENTERPRISE
- MD-KERNEL-DEPENDENCY-MAP
- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica
- 000-CONSTITUICAO-IA.md

---

## 10. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação do catálogo de procedures |

---

Documento Canônico — SP-KERNEL-CATALOG

**Este é o catálogo oficial de stored procedures do Kernel da plataforma New Wave Enterprise.**
