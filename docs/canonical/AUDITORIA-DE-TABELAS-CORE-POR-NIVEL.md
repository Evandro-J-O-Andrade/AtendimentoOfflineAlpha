# AUDITORIA-DE-TABELAS-CORE-POR-NIVEL.md

## Status
Documento de Auditoria.  
Classificação detalhada das 481 tabelas do Dump20260606 por nível arquitetural.

---

## 01. CORE ENTERPRISE (80 tabelas)

### IDENTIDADE & AUTENTICAÇÃO
| Tabela | Classificação | Observação |
|--------|---------------|------------|
| pessoa | CORE_ENTERPRISE | Entidade raiz da plataforma |
| usuario | CORE_ENTERPRISE | Usuários do sistema |
| usuario_log_acesso | CORE_ENTERPRISE | Log de acesso (auth) |
| usuario_refresh_token | CORE_ENTERPRISE | Refresh tokens |
| auth_sessao | CORE_ENTERPRISE | Sessão canônica |
| auth_token | CORE_ENTERPRISE | Tokens de autenticação |
| auth_tentativa_login | CORE_ENTERPRISE | Tentativas de login |
| auth_log | CORE_ENTERPRISE | Log de autenticação |
| auth_audit | CORE_ENTERPRISE | Auditoria de auth |

### TENANT & MULTI-TENANCY
| Tabela | Classificação | Observação |
|--------|---------------|------------|
| saas_entidade | CORE_ENTERPRISE | Tenant (entidade) |
| saas_contrato | CORE_ENTERPRISE | Contratos SaaS |
| saas_plano | LEGADO | Plano de negócio |
| tenant_registry | CORE_ENTERPRISE | Registry de tenants |

### PORTAL & APLICATIVOS
| Tabela | Classificação | Observação |
|--------|---------------|------------|
| sistema | CORE_ENTERPRISE | Configuração do sistema |
| unidade | CORE_ENTERPRISE | Unidades de negócio |
| setor | CONTEXT_OP | Setores organizacionais |
| local | CONTEXT_OP | Locais físicos |
| local_operacional | CONTEXT_OP | Locais operacionais |
| sessao_usuario | CORE_ENTERPRISE | Sessão ativa |
| sessao_contexto_historico | CORE_ENTERPRISE | Histórico de contextos |
| sessao_ativa | CORE_ENTERPRISE | Sessões ativas |

### FFA (ORQUESTRADORA CENTRAL)
| Tabela | Classificação | Observação |
|--------|---------------|------------|
| ffa | CORE_ENTERPRISE | Ficha de Atendimento (orquestradora) |
| atendimento | CORE_ENTERPRISE | Atendimento médico |
| senha | CORE_ENTERPRISE | Senha de atendimento |
| senha_status | CORE_ENTERPRISE | Status da senha |
| senha_eventos | CORE_ENTERPRISE | Eventos da senha |
| identidade_fluxo | CORE_ENTERPRISE | Identidade do fluxo |

### CONTEXTO & RUNTIME SHARED
| Tabela | Classificação | Observação |
|--------|---------------|------------|
| runtime_contexto | INFRA | Contexto stateless |
| runtime_api_session_token | INFRA | Token de sessão runtime |
| runtime_execution_queue | INFRA | Fila de execução |
| runtime_sync_queue | INFRA | Fila de sync offline |
| runtime_sync_log | INFRA | Log de sincronização |
| runtime_dispositivo | INFRA | Dispositivos registrados |
| usuario_contexto | CONTEXT_OP | Contexto por usuário |

---

## 02. SHARED SERVICES (15 tabelas)

### NOTIFICAÇÕES
| Tabela | Classificação | Observação |
|--------|---------------|------------|
| notificacao_epidemiologica | SHARED_SERVICES | Notificações gov |
| notificacao_violencia | SHARED_SERVICES | Notificações violência |
| sala_notificacao | SHARED_SERVICES | Notificações por sala |
| auth_notificacao | SHARED_SERVICES | Notificações auth |
| cat_notificacao | SHARED_SERVICES | Notificações CAT |

### ARQUIVOS & CODE
| Tabela | Classificação | Observação |
|--------|---------------|------------|
| codigo_universal | SHARED_SERVICES | Código universal |
| codigo_externo_map | SHARED_SERVICES | Mapa de códigos externos |
| codigo_externo_vinculo | SHARED_SERVICES | Vínculo de códigos |
| documento_* | SHARED_SERVICES | Sistema de documentos |

### PREFS & CONFIGS
| Tabela | Classificação | Observação |
|--------|---------------|------------|
| configuracao | SHARED_SERVICES | Configurações globais |
| usuario_perfil | CORE_ENTERPRISE | Perfil do usuário (RBAC) |

---

## 03. CONTEXT OP (11 tabelas)

### CONTEXT OPERACIONAL
| Tabela | Classificação | Observação |
|--------|---------------|------------|
| usuario_unidade | CONTEXT_OP | Usuário ↔ Unidade |
| usuario_setor | CONTEXT_OP | Usuário ↔ Setor |
| usuario_sala | CONTEXT_OP | Usuário ↔ Sala |
| usuario_local | CONTEXT_OP | Usuário ↔ Local |
| local_operacional | CONTEXT_OP | Local operacional |
| tipo_sala | CONTEXT_OP | Tipos de sala |
| tipo_local | CONTEXT_OP | Tipos de local |
| agenda_disponibilidade | CONTEXT_OP | Agenda por contexto |
| hospital_leitos | CONTEXT_OP | Leitos por hospital |
| config_leitos | CONTEXT_OP | Config de leitos |
| agendamento | SHARED_SERVICES | Agendamentos (multi-domínio) |

---

## 04. DOMAIN_HIS (200 tabelas)

### RECEPCIONE
| Prefixo | Tabelas Exemplo | Count Estimado |
|---------|-----------------|--------------|
| recepcao_* | recepcao, recepcao_evento | ~10 |
| senha_* | senha_agendamento, senha_sequencia, senha_transicao_matriz | ~15 |

### TRIAGEM
| Prefixo | Tabelas Exemplo | Count Estimado |
|---------|-----------------|--------------|
| triagem_* | triagem, classificacao_risco | ~8 |

### ATENDIMENTO
| Prefixo | Tabelas Exemplo | Count Estimado |
|---------|-----------------|--------------|
| atendimento_* | atendimento_anamnese, atendimento_observacao, atendimento_evolucao, atendimento_prescricao, atendimento_sinais_vitais, atendimento_exame_fisico | ~50 |

### INTERNCAO
| Prefixo | Tabelas Exemplo | Count Estimado |
|---------|-----------------|--------------|
| internacao_* | internacao, internacao_prescricao, internacao_medicacao_administracao | ~15 |

### FARMACIA
| Prefixo | Tabelas Exemplo | Count Estimado |
|---------|-----------------|--------------|
| farm_* | farm_dispensacao, farm_produto | ~20 |
| medicacao_* | administracao_medicacao, administracao_ordem | ~12 |

### LABORATÓRIO
| Prefixo | Tabelas Exemplo | Count Estimado |
|---------|-----------------|--------------|
| lab_* | lab_pedido, lab_amostra, lab_resultado | ~15 |
| exame_* | solicitacao_exame, exames_fisico | ~10 |

### FATURAMENTO
| Prefixo | Tabelas Exemplo | Count Estimado |
|---------|-----------------|--------------|
| faturamento_* | faturamento_producao, faturamento_guia | ~10 |
| tiss_* | tiss_tabela, tiss_procedimento | ~15 |

---

## 05. DOMAIN_OTHER (40 tabelas)

### FINANCEIRO
| Tabela | Classificação |
|--------|---------------|
| caixa | DOMAIN_OTHER |
| caixa_evento | DOMAIN_OTHER |
| venda | DOMAIN_OTHER |
| venda_* | DOMAIN_OTHER |
| forma_pagamento | DOMAIN_OTHER |
| contas | DOMAIN_OTHER |

### RH / WORKFORCE
| Tabela | Classificação |
|--------|---------------|
| funcionario | DOMAIN_OTHER |
| escala_* | DOMAIN_OTHER |
| plantao_* (via lab) | DOMAIN_OTHER |

### LOGÍSTICA
| Tabela | Classificação |
|--------|---------------|
| viatura | DOMAIN_OTHER |
| transporte_ambulancia | DOMAIN_OTHER |
| transporte_* | DOMAIN_OTHER |
| almoxarifado_* | DOMAIN_OTHER |

### CRM / SAC
| Tabela | Classificação |
|--------|---------------|
| chamado | DOMAIN_OTHER |
| chamado_* | DOMAIN_OTHER |
| cliente | DOMAIN_OTHER |
| cat_* | DOMAIN_OTHER |

---

## 06. KERNEL / INFRA (40 tabelas)

### RUNTIME INFRA
| Tabela | Classificação |
|--------|---------------|
| runtime_* | INFRA |
| kernel_* | KERNEL |
| assistencial_* | INFRA |
| schema_patch_* | INFRA |
| telemetria_* | INFRA |
| circuit_breaker | INFRA |
| watchdog | INFRA |
| checkpoint_* | INFRA |

---

## 07. LACUNAS - CORE ENTERPRISE FALTANDO

### TABELAS CANÔNICAS NÃO ENCONTRADAS
| Tabela Esperada | Status | Substituto/Noção |
|----------------|--------|-----------------|
| role | ❌ | Implementado via `perfil` |
| feature | ❌ | Não encontrado |
| workspace | ❌ | Não encontrado |
| notification (único) | ⚠️ | Fragmentado em notificacao_* |
| preference | ⚠️ | Configurado via `configuracao` |
| favorite | ❌ | Não encontrado |
| feature_toggle | ❌ | Não encontrado |

---

## 08. MATRIX DE DECISÃO

```text
Pergunta: A tabela tem sentido fora do HIS?
↓
SIM → CORE_ENTERPRISE ou SHARED_SERVICES ou CONTEXT_OP
↓
DEPENDE → É AUTH? É CONFIG? É NOTIFICAÇÃO?
↓
NÃO → DOMAIN_HIS ou DOMAIN_OTHER
```

---

## 09. PRÓXIMOS PASSOS

1. Mapear procedures `sp_master_*` para entender Dispatcher
2. Validar `runtime_contexto` como estado compartilhado
3. Criar Feature Toggle System (faltando)
4. Criar Favorite System (faltando)
5. Consolidar Notification Engine (fragmentado)
6. Definir contexto global vs contexto operacional

---

**Documento de Auditoria — 2026-06-30**  
Base: Dump20260606, 481 tabelas documentadas