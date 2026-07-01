# AUDITORIA COMPLETA DAS 481 TABELAS
## docs/database/tables/*.md

---

## 1. CLASSIFICAÇÃO POR DOMÍNIO (Baseado em INVENTARIO_COMPLETO.md + refino)

| Classe | Quantidade | % do Total |
|--------|------------|----------|
| CORE_ENTERPRISE | 173 | 36% |
| INFRA (Runtime/KERNEL) | 34 | 7% |
| PLATFORM | 43 | 9% |
| APP/DOMAIN_HIS | 228 | 48% |
| **TOTAL** | **480** | **100%** |

**Nota**: O INVENTARIO_COMPLETO.md classifica como CORE 173 tabelas, mas algumas delas são tabulações de domínio assistencial. Após refino arquitetural:

| Classe Final | Quantidade Estimada |
|-------------|---------------------|
| CORE_ENTERPRISE | ~80 |
| SHARED_SERVICES | ~15 |
| CONTEXT_OP | ~11 |
| DOMAIN_HIS | ~200 |
| DOMAIN_OTHER | ~40 |
| KERNEL | ~40 |

---

## 2. CORE_ENTERPRISE - Tabelas Fundamentais

### Principais (do INVENTARIO_COMPLETO.md):
- **pessoa** - Tabela mestre de pessoas (pacientes, funcionários, profissionais)
- **usuario** - Gestão de usuários do sistema
- **saas_entidade** - Cadastro central de entidades/tenants
- **unidade** - Unidades de saúde
- **sistema** - Configurações do sistema
- **sessao_usuario** - Gestão de sessões
- **ffa** - Ficha de Atendimento (orquestradora)
- **atendimento** - Atendimentos médicos
- **internacao** - Internações hospitalares
- **senha** - Senhas de atendimento
- **estoque_produto** - Produtos do estoque
- **paciente** - Dados de pacientes
- **perfil**, **permissao** - Controle de acesso (RBAC)

---

## 3. SHARED_SERVICES - Serviços Transversais

- **totem** - Totens de autoatendimento
- **tv_rotativo** - TVs rotativas de chamada
- **agendamento** - Agendamentos médicos
- **notificacao_epidemiologica** - Notificações ao Ministério da Saúde
- **notificacao_violencia** - Notificações de violência
- **servico_agendamento** - Agendamento de serviços assistenciais

---

## 4. CONTEXT_OP - Contexto Operacional

- **local**, **local_operacional** - Locais físicos/lógicos
- **leito** - Leitos hospitalares
- **setor** - Setores organizacionais
- **hospital_leitos** - Ocupação de leitos
- **config_leitos** - Configuração de leitos

---

## 5. DOMAIN_HIS - Domínio Assistencial (HIS)

### Subdomínios:
- **Atendimento**: atendimento_*, triagem, anamnese
- **FFA**: ffa_*, senha_*
- **Internação**: internacao_*, prescricao_*, medicacao_*
- **Farmácia**: farm_*, dispensacao_*, estoque_*
- **Laboratório**: lab_*, exame_*, solicitacao_exame
- **Faturamento**: faturamento_*
- **Prontuário**: prontuario_*, evolucao_*

---

## 6. DOMAIN_OTHER - Demais Domínios

- **Financeiro**: caixa, venda, pdv_*, forma_pagamento
- **RH**: funcionario_*, plantao_*, escala_*
- **Logística**: viatura, transporte_ambulancia, remocao
- **CRM/SAC**: chamado, cliente, cat_* (acidente de trabalho)

---

## 7. KERNEL - Infraestrutura Runtime

- **runtime_*** - Runtime executors, sync, edge
- **kernel_*** - Authz policy, identity trust chain, ledger
- **ledger_*** - Sincronização global
- **assistencial_*** - Circuit breaker, checkpoint, telemetria
- **schema_patch** - Controle de patches

---

## 8. LACUNAS - Tabelas Core Enterprise Faltando

| Padrão Esperado | Status | Observação |
|-----------------|--------|------------|
| Role | ❌ | Implementado via `perfil` |
| Feature | ❌ | Não encontrado |
| Workspace | ❌ | Não encontrado |
| Notification | ⚠️ | Implementado como `notificacao_epidemiologica`, `notificacao_violencia` |
| Preference | ⚠️ | Implementado como `configuracao` |
| Favorite | ❌ | Não encontrado |

---

## 9. STORED PROCEDURES ANALISADAS

**Total**: 228 procedures/functions em docs/database/procedures/

| Classificação | Count | Prefixos |
|--------------|-------|----------|
| CORE | 59 | sp_executor_*, sp_master_*, sp_kernel_* |
| INFRA | 13 | sp_runtime_*, sp_sync_*, sp_schema_* |
| PLATFORM | 46 | sp_auth_*, sp_sessao_*, sp_usuario_* |
| APP (HIS) | 99 | sp_recepcao_*, sp_triagem_*, sp_atendimento_* |
| LEGACY | 11 | sp_seed_*, sp_fix_*, sp_backfill_* |

---

## 10. FLUXOS DE NEGÓCIO PRINCIPAIS

1. **Recepção**: Portal → sp_recepcao_gerar_senha → senha → ffa → atendimento
2. **Triagem**: Senha → sp_executor_assistencial_triagem_* → triagem
3. **Atendimento Médico**: FFA → sp_executor_assistencial_atendimento_*
4. **Prescrição/Medicação**: FFA → prescricao → sp_master_registrar_administracao_medicacao
5. **Laboratório**: FFA → lab_pedido → lab_amostra → lab_resultado
6. **Internação**: FFA → internacao → internacao_prescricao
7. **Farmácia**: Prescricao → sp_farm_*, sp_farmacia_*

---

## 11. ARQUIVOS GERADOS

- `audit_resultado.md` - Este relatório
- Dados originais em: `docs/database/tables/*.md`
- Procedures em: `docs/database/procedures/*.md`
- Inventário completo: `docs/database/tables/INVENTARIO_COMPLETO.md`