# INVENTÁRIO COMPLETO DO BANCO DE DADOS - Dump20260606

## Sumário Executivo

- **Total de Tabelas**: 478
- **Total de Procedures**: 225
- **Total de Functions**: 3
- **Total de Rotinas**: 228
- **Total de Foreign Keys**: 563
- **Documentos Existentes (tables_raw)**: 478 JSON
- **Documentos Existentes (tables/*.md)**: 480 MD
- **Documentos Existentes (procedures_raw)**: 228 JSON
- **Documentos Existentes (procedures/*.md)**: 228 MD

---

## 1. CLASSIFICAÇÃO DAS TABELAS (Regra 14)

### CORE - 173 tabelas
Componentes fundamentais da plataforma (pessoa, tenant, workflow, ledger)

**Principais**: pessoa, usuario, perfil, permissao, saas_entidade, unidade, sistema, sessao_usuario, ffa, atendimento, internacao, senha, estoque_produto, estoque_local, paciente, medico, prescricao, exame, lab_pedido

**Árvore Core**:
```
pessoa
  ↓
usuario
  ↓
saas_entidade (tenant)
  ↓
unidade
  ↓
sistema
  ↓
ffa (Ficha de Atendimento)
  ↓
atendimento
  ↓
fluxos (triagem, evolução, prescrição, faturamento)
```

### INFRA - 34 tabelas
Infraestrutura técnica, runtime, circuit breaker, heartbeat

**Tabelas**: runtime_*, kernel_*, assistencial_checkpoint_*, circuit_breaker, sync_log, lock_*, telemetria_*, watchdog, schema_patch

### PLATFORM - 43 tabelas
Serviços transversais: auth, sessão, painel, totem, TV, config, código, documento

**Tabelas**: auth_*, sessao_*, painel_*, totem_*, tv_*, config, codigo_*, documento_*, dispositivo_*, nucleo_governanca

### APP - 228 tabelas
Aplicações específicas do tenant (HIS)

**Domínios**: assistencial (atendimento_*, triagem, internacao), farmacêutico, laboratorial, de exames, de estoque detalhado, de faturamento, de auditoria, de CAT, de óbito, assistência social

### LEGACY - 0 tabelas
Nenhuma tabela classificada como legado específico

---

## 2. CLASSIFICAÇÃO DAS PROCEDURES/FUNCTIONS (Regra 14)

### CORE - 59 procedures
Executors, Masters, Dispatcher, Ledger, Kernel, Fluxo, Guardião

**Arquitetura Core**:
- **sp_executor_* (8)**: Runtime executors, orquestradores
- **sp_master_* (22)**: Masters de operações principais
- **sp_kernel_* (4)**: Operações de kernel runtime
- **sp_ledger_* (2)**: Registro de eventos canônicos
- **sp_fluxo_* (4)**: Orquestração de fluxos
- **sp_guardiao_* (3)**: Decision engine, runtime decisão
- **sp_gatekeeper_* (1)**: Portão de entrada
- **sp_dispatcher_kernel (1)**: Roteamento central

### INFRA - 13 procedures
Runtime, sync, schema, retry, tenant

**Funções**: sp_runtime_*, sp_sync_*, sp_schema_*, sp_retry_*, sp_tenant_*, sp_invariant_*

### PLATFORM - 46 procedures
Auth, sessão, painel, totem, código, protocolo

**Funções**: sp_auth_*, sp_sessao_*, sp_painel_*, sp_totem_*, sp_usuario_*, sp_codigo_*, sp_protocolo_*, sp_patch_*

### APP - 99 procedures
Operações específicas do HIS

**Domínios**: recepção, triagem, médico, farmácia, laboratório, internação, faturamento, estoque, CAT, óbito

### LEGACY - 11 procedures
Seed e procedures de manutenção

**Procedures**: sp_seed_*, seed_usuarios_teste, sp_fix_*, sp_recreate_fk_entidade, sp_backfill_entidade

---

## 3. GAP - DOCUMENTOS FALTANDO

**RESULTADO**: ZERO GAPS IDENTIFICADOS

- ✓ Todas as 478 tabelas possuem documentação JSON em `tables_raw/`
- ✓ Todas as 478 tabelas possuem documentação MD em `tables/` (480 MD existentes)
- ✓ Todos os 228 procedures/functions possuem documentação JSON em `procedures_raw/`
- ✓ Todos os 228 procedures/functions possuem documentação MD em `procedures/`

---

## 4. MAPA ERD - RELATIONSHIPS

### Top 20 Tabelas Mais Referenciadas

| Rank | Tabela | # FK | Class |
|------|--------|------|-------|
| 1 | usuario | 99 | CORE |
| 2 | saas_entidade | 78 | CORE |
| 3 | atendimento | 59 | CORE |
| 4 | unidade | 58 | CORE |
| 5 | pessoa | 15 | CORE |
| 6 | sessao_usuario | 13 | PLATFORM |
| 7 | internacao | 13 | CORE |
| 8 | sistema | 9 | CORE |
| 9 | local | 9 | APP |
| 10 | painel | 9 | APP |
| 11 | estoque_lote | 8 | APP |
| 12 | local_operacional | 7 | APP |
| 13 | perfil | 7 | CORE |
| 14 | fila_operacional | 7 | CORE |
| 15 | funcionario | 7 | APP |
| 16 | medico | 6 | APP |
| 17 | farmaco | 6 | APP |
| 18 | local_atendimento | 5 | APP |
| 19 | cliente | 5 | APP |
| 20 | estoque_produto | 5 | CORE |

### Domínios de Relacionamento

| Domínio | Tabelas Principais |
|---------|-------------------|
| IAM/Auth | usuario → usuario_perfil, perfil → perfil_permissao, auth_* |
| Tenant/SaaS | saas_entidade → todas as tabelas via id_entidade |
| Atendimento | senha → ffa → atendimento → todas as sub-tabelas |
| Estoque | estoque_produto → estoque_local → estoque_movimento → estoque_saldo |

---

## 5. FLUXOS DE NEGÓCIO IDENTIFICADOS

### Fluxo 1: Recepção (Regra 13)
```
Entrada de Paciente
Portal → Recepção → sp_recepcao_gerar_senha → senha
↓
sp_recepcao_complementar_e_abrir_ffa → ffa
↓
sp_master_atendimento_iniciar → atendimento
↓
status: INICIADO → EM_CURSO → CONCLUIDO/CANCELADO
```
**Procedures**: sp_recepcao_*, sp_criar_senha, sp_senha_*, sp_executor_recepcao_*

### Fluxo 2: Triagem
```
Senha → ffa → sp_executor_assistencial_triagem_*
↓
triagem → classificacao_risco
↓
sp_triagem_finalizar → atendimento
```
**Procedures**: sp_triagem_*, sp_executor_assistencial_triagem_*

### Fluxo 3: Atendimento Médico
```
FFA → sp_executor_assistencial_atendimento_*
↓
atendimento_* (anamnese, exame_fisico, evolucao, prescricao)
↓
sp_atendimento_finalizar → status CONCLUIDO
```
**Procedures**: sp_atendimento_*, sp_executor_assistencial_atendimento_*, sp_medico_*

### Fluxo 4: Prescrição → Medicação
```
FFA → prescricao → sp_master_registrar_administracao_medicacao
↓
administracao_medicacao → administracao_medicacao_ordem
↓
sp_medicacao_* → farm_dispensacao
```
**Procedures**: sp_prescricao_*, sp_administracao_*, sp_farm_*, sp_medicacao_*

### Fluxo 5: Laboratório
```
FFA → solicitacao_exame → lab_pedido
↓
lab_amostra → lab_resultado
↓
sp_lab_* → sp_finalizar_procedimento_*
```
**Procedures**: sp_lab_*, sp_laboratorio_*, sp_finalizar_procedimento_laboratorio

### Fluxo 6: Raio-X
```
FFA → sp_iniciar_execucao_procedimento_rx
↓
sp_rx_finalizar → sp_finalizar_senha
```
**Procedures**: sp_rx_*, sp_iniciar_execucao_procedimento_rx

### Fluxo 7: Internação
```
FFA → internacao → internacao_*
↓
internacao_prescricao, internacao_medicacao_administracao
↓
sp_internacao_*, sp_internacao_registrar_evasao
```
**Procedures**: sp_internacao_*, internacao_*

### Fluxo 8: Farmácia
```
Prescricao → farm_dispensacao_criar
↓
farm_dispensacao → farm_dispensacao_item
↓
sp_farmacia_dispensar_registrar
```
**Procedures**: sp_farm_*, sp_farmacia_*

---

## 6. PATTERNS ARQUITETURAIS DETECTADOS

### Pattern CORE-01: id_entidade em todas as tabelas
Multi-tenant implementado via id_entidade como chave estrangeira em todas as tabelas

### Pattern CORE-02: FFA como orquestradora
FFA (Ficha de Atendimento) centraliza o fluxo assistencial

### Pattern CORE-03: Eventos com UUID
Cada operação possui uuid_sync e hash_estado para rastreabilidade

### Pattern INFRA-01: Circuit Breaker
assistencial_circuit_breaker monitora componentes

### Pattern INFRA-02: Heartbeat Runtime
runtime_*_heartbeat mantém estado de dispositivos

### Pattern PLATFORM-01: Sessão como contexto
sessao_usuario é a unidade de contexto em todas as operações

---

## 7. NOTAS DE ENGENHARIA REVERSA

1. **Todas as tabelas possuem id_entidade** - Evidência de arquitetura multi-tenant

2. **563 Foreign Keys** - Alta conectividade, indicando forte acoplamento de domínio

3. **Tabela `usuario` é a mais referenciada (99 FK)** - Confirma papel central no CORE

4. **Prefixo `sp_` indica procedures arquiteturais**

5. **Prefixo `ffa_` indica domínio assistencial**

6. **Prefixo `estoque_` indica domínio de suprimentos**

7. **Prefixo `farm_` indica domínio farmacêutico**

8. **Prefixo `lab_` indica domínio laboratorial**

---

*Documento gerado via engenharia reversa do Dump20260606.sql*