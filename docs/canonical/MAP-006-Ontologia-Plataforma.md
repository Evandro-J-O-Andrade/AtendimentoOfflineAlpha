# MAP-006 — Mapa Ontológico da Plataforma

## Status

Documento Canônico De Mapeamento.
Fonte: dump + estrutura legada + MDs canônicos + regras de negócio.

---

## Princípio Fundamental

```text
Ontologia é a fonte da verdade conceitual.
Banco é a fonte da verdade operacional.
MDs são a lei canônica.
MAPs conectam os três.
```

---

## Camadas Ontológicas

### Camada 0 — Plataforma (Global)

```text
┌─────────────────────────────────────────────┐
│                  TENANT                       │
│   (Cliente SaaS: Hospital, Rede, Empresa)    │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│                 UNIDADE                      │
│      (Filial, Hospital, Clínica, Loja)       │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│                  LOCAL                       │
│   (Setor, Sala, Guichê, Painel, PDV)        │
└─────────────────────────────────────────────┘
```

**Tabelas canônicas:**
- `tenant_registry` / `sistema`
- `unidade`
- `local_operacional`

---

### Camada 1 — Identidade (IAM)

```text
┌─────────────────────────────────────────────┐
│                  USUÁRIO                     │
│         (Identidade permanente)              │
│  ┌───────────────────────────────────────┐  │
│  │  id_usuario                           │  │
│  │  nome / email / status                │  │
│  │  tenant (dominant context)            │  │
│  │  perfis_dinamicos                     │  │
│  └───────────────────────────────────────┘  │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│                  PESSOA                      │
│      (Dados pessoais, físicos/jurídicos)     │
│  ┌───────────────────────────────────────┐  │
│  │  id_pessoa                            │  │
│  │  cpf / cnpj / rg                      │  │
│  │  nome_razao_social                    │  │
│  │  dados_contato                        │  │
│  └───────────────────────────────────────┘  │
└─────────────────────────────────────────────┘
```

**Tabelas canônicas:**
- `usuario`
- `pessoa`
- `perfil`
- `permissao`
- `perfil_permissao`

---

### Camada 2 — Contexto Operacional

```text
┌─────────────────────────────────────────────┐
│                  USUÁRIO                     │
│                                             │
│  ┌─────────────┐    ┌─────────────┐        │
│  │  Tenant A   │    │  Tenant B   │        │
│  └──────┬──────┘    └──────┬──────┘        │
│         │                  │               │
│  ┌──────▼──────┐    ┌──────▼──────┐        │
│  │  Unidade 1 │    │  Unidade 2 │        │
│  └──────┬──────┘    └──────┬──────┘        │
│         │                  │               │
│  ┌──────▼──────┐    ┌──────▼──────┐        │
│  │   Local X  │    │   Local Y  │        │
│  └─────────────┘    └─────────────┘        │
│                                             │
│          Contexto é variável               │
└─────────────────────────────────────────────┘
```

**Tabelas canônicas:**
- `usuario_contexto`
- `contexto_atendimento`
- `usuario_unidade`
- `usuario_local`

---

### Camada 3 — Sessão

```text
┌─────────────────────────────────────────────┐
│                  SESSÃO                      │
│  ┌───────────────────────────────────────┐  │
│  │  id_sessao (UUID)                     │  │
│  │  id_usuario                           │  │
│  │  id_tenant                            │  │
│  │  id_unidade                           │  │
│  │  id_local                             │  │
│  │  device_fingerprint                   │  │
│  │  ip / user_agent                      │  │
│  │  expires_at                           │  │
│  │  status (ativa/revogada/expirada)     │  │
│  └───────────────────────────────────────┘  │
└─────────────────────────────────────────────┘
```

**Tabelas canônicas:**
- `sessao_usuario`
- `auth_sessao`
- `usuario_refresh_token`

---

### Camada 4 — Domínio Assistencial (HIS)

```text
┌─────────────────────────────────────────────┐
│                 SENHA                        │
│         (Entrada operacional)                │
│  ┌───────────────────────────────────────┐  │
│  │  id_senha                             │  │
│  │  id_paciente                          │  │
│  │  id_unidade / id_local               │  │
│  │  tipo (normal, preferencial, risco)  │  │
│  │  numero                               │  │
│  │  status (aguardando, chamando,         │  │
│  │          em_atendimento, finalizada)  │  │
│  │  data_geracao                         │  │
│  │  data_chamada                         │  │
│  │  data_atendimento                     │  │
│  └───────────────────────────────────────┘  │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│                  FILA                        │
│  ┌───────────────────────────────────────┐  │
│  │  id_fila                              │  │
│  │  id_unidade / id_local               │  │
│  │  id_servico                           │  │
│  │  capacidade                           │  │
│  │  ordem                                │  │
│  │  status                               │  │
│  └───────────────────────────────────────┘  │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│                   FFA                        │
│    (Fluxo de Fluxo Assistencial)             │
│  ┌───────────────────────────────────────┐  │
│  │  id_ffa                               │  │
│  │  id_senha                             │  │
│  │  id_atendimento                       │  │
│  │  etapas (triagem → execução...)       │  │
│  │  status                               │  │
│  │  timestamps por etapa                  │  │
│  └───────────────────────────────────────┘  │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│               ATENDIMENTO                    │
│  ┌───────────────────────────────────────┐  │
│  │  id_atendimento                       │  │
│  │  id_paciente                          │  │
│  │  id_profissional                      │  │
│  │  id_unidade / id_local               │  │
│  │  data_entrada                         │  │
│  │  tipo (urgência, eletivo...)          │  │
│  │  status                               │  │
│  │  evolucao                             │  │
│  └───────────────────────────────────────┘  │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│                TRIAGEM                       │
│  ┌───────────────────────────────────────┐  │
│  │  id_triagem                           │  │
│  │  id_atendimento                       │  │
│  │  classificacao (verde, amarela...)    │  │
│  │  motivo                                │  │
│  │  profissional_triagem                 │  │
│  │  data_triagem                         │  │
│  └───────────────────────────────────────┘  │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│            EXECUÇÃO CLÍNICA                  │
│  ┌───────────────────────────────────────┐  │
│  │  prescricao                           │  │
│  │  evolucao                             │  │
│  │  exame                                │  │
│  │  procedimento                         │  │
│  │  cirurgia                             │  │
│  │  alta                                 │  │
│  └───────────────────────────────────────┘  │
└─────────────────────────────────────────────┘
```

**Tabelas canônicas:**
- `senha_*`
- `fila_*`
- `ffa_*`
- `atendimento_*`
- `triagem_*`
- `prescricao_*`
- `evolucao_*`
- `exame_*`

---

### Camada 5 — Domínio Farmacêutico

```text
┌─────────────────────────────────────────────┐
│               PRESCRIÇÃO                     │
│                 (Médica)                     │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│               DISPENSAÇÃO                    │
│  ┌───────────────────────────────────────┐  │
│  │  id_dispensacao                       │  │
│  │  id_prescricao                        │  │
│  │  id_medicamento                       │  │
│  │  quantidade                           │  │
│  │  lote / validade                      │  │
│  │  profissional_farmacia                │  │
│  │  status                               │  │
│  └───────────────────────────────────────┘  │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│                 ESTOQUE                      │
│  ┌───────────────────────────────────────┐  │
│  │  id_produto                           │  │
│  │  id_lote                              │  │
│  │  saldo                                │  │
│  │  validade                             │  │
│  │  id_local_estoque                     │  │
│  └───────────────────────────────────────┘  │
└─────────────────────────────────────────────┘
```

**Tabelas canônicas:**
- `farm_*`
- `farmacia_*`
- `dispensacao_medicacao`
- `gpat_*`
- `estoque_*`
- `produto_*`
- `lote_*`
- `saldo_*`

---

### Camada 6 — Domínio Comercial

```text
┌─────────────────────────────────────────────┐
│                 CLIENTE                      │
│  ┌───────────────────────────────────────┐  │
│  │  id_cliente                           │  │
│  │  id_pessoa                            │  │
│  │  tipo (física/jurídica)               │  │
│  │  classificacao                        │  │
│  │  dados_contato                        │  │
│  └───────────────────────────────────────┘  │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│               CONTRATO                       │
│  ┌───────────────────────────────────────┐  │
│  │  id_contrato                          │  │
│  │  id_cliente                           │  │
│  │  id_plano                             │  │
│  │  data_inicio / data_fim              │  │
│  │  valor                                │  │
│  │  status                               │  │
│  └───────────────────────────────────────┘  │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│               VENDA / PEDIDO                  │
│  ┌───────────────────────────────────────┐  │
│  │  id_venda / id_pedido                 │  │
│  │  id_cliente                           │  │
│  │  itens                                │  │
│  │  valor_total                          │  │
│  │  forma_pagamento                      │  │
│  │  status                               │  │
│  └───────────────────────────────────────┘  │
└─────────────────────────────────────────────┘
```

**Tabelas canônicas:**
- `cliente`
- `fornecedor`
- `contrato`
- `pdv_*`
- `venda_*`
- `caixa_*`
- `forma_pagamento`

---

### Camada 7 — Domínio Financeiro

```text
┌─────────────────────────────────────────────┐
│               CONTA / LANCAMENTO             │
│  ┌───────────────────────────────────────┐  │
│  │  id_conta                             │  │
│  │  id_tenant                            │  │
│  │  tipo (receita/despesa)              │  │
│  │  categoria                            │  │
│  │  valor                                │  │
│  │  data_vencimento / data_pagamento    │  │
│  │  status                               │  │
│  └───────────────────────────────────────┘  │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│               FATURAMENTO                     │
│  ┌───────────────────────────────────────┐  │
│  │  id_faturamento                       │  │
│  │  id_contrato / id_cliente            │  │
│  │  competencia                          │  │
│  │  valor_total                          │  │
│  │  guias                                │  │
│  │  status                               │  │
│  └───────────────────────────────────────┘  │
└─────────────────────────────────────────────┘
```

**Tabelas canônicas:**
- `financeiro_*`
- `repasse_*`
- `faturamento_*`
- `nota_fiscal_*`

---

### Camada 8 — Domínio Social & Workplace

```text
┌─────────────────────────────────────────────┐
│                  USUÁRIO                     │
│                                             │
│  ┌─────────────┐    ┌─────────────┐        │
│  │   POST      │    │   CHAT      │        │
│  └─────────────┘    └─────────────┘        │
│  ┌─────────────┐    ┌─────────────┐        │
│  │  COMENTÁRIO │    │  COMUNIDADE │        │
│  └─────────────┘    └─────────────┘        │
│  ┌─────────────┐    ┌─────────────┐        │
│  │   EVENTO    │    │  CALENDÁRIO │        │
│  └─────────────┘    └─────────────┘        │
└─────────────────────────────────────────────┘
```

**Tabelas canônicas:**
- `social_*` (inferido)
- `chat_*` (inferido)
- `comunidade_*` (inferido)
- `evento_*`
- `agenda_*`

---

### Camada 9 — IA & Conhecimento

```text
┌─────────────────────────────────────────────┐
│                  CONHECIMENTO                │
│  ┌───────────────────────────────────────┐  │
│  │  Entidades (pessoa, produto, doc...) │  │
│  │  Relacionamentos (trabalha_em, usa...)│  │
│  │  Propriedades (score, confiança...)   │  │
│  │  Inferência (IA)                      │  │
│  └───────────────────────────────────────┘  │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│               AGENTES IA                     │
│  ┌───────────────────────────────────────┐  │
│  │  Agente (nome, versão, autor)        │  │
│  │  Execução (log, input, output)       │  │
│  │  Prompt (versionado, aprovado)       │  │
│  │  Ação (auditada, aprovável)          │  │
│  └───────────────────────────────────────┘  │
└─────────────────────────────────────────────┘
```

**Tabelas canônicas:**
- (Futuro) `knowledge_graph_*`
- (Futuro) `agent_*`
- (Futuro) `prompt_*`
- (Futuro) `copilot_*`

---

## Event Store Canônico (Fonte de Verdade Operacional)

```text
Todo evento relevante gera registro imutável:
  ├── Criação (CREATE)
  ├── Leitura (READ) — opcional, para compliance
  ├── Atualização (UPDATE)
  ├── Exclusão (DELETE) — soft delete
  ├── Ação de negócio (EXECUTE)
  └── Mudança de contexto (CONTEXT_SWITCH)
```

**Tabelas canônicas de eventos:**
- `kernel_ledger` (global canônico)
- `auditoria_evento` (imutável)
- `atendimento_evento` (domínio HIS)
- `evento_ffa` (fluxo assistencial)
- `fila_evento` / `fila_operacional_evento` (operação de fila)
- `workflow_ffa_evento` (workflow)
- `eventos_fluxo` (motor genérico)
- `faturamento_evento` (financeiro)
- `estoque_ledger` (estoque)
- `venda_evento` / `caixa_evento` (PDV)
- `chamado_evento` / `cat_evento` (SAC/CAT)

**Convergência:**
- `kernel_ledger` é o Event Store canônico global.
- Demais ledgers são espelhamentos ou domínio-específicos.
- Plataforma futura: todos os eventos fluem para `kernel_ledger`.

---

## SPs Canônicas (Fonte de Verdade de Negócio)

| Grupo | Padrão | Domínio |
|-------|--------|---------|
| AUTH | `sp_auth_*` | Autenticação, autorização, contexto |
| AUDITORIA | `sp_auditar_*` | Auditoria imutável |
| DISPATCHER | `sp_checkpoint_*`, `sp_codigo_*` | Roteamento seguro |
| OPERACIONAL | `sp_atendimento_*`, `sp_chamar_senha` | HIS, fila, senha |
| FARMÁCIA | `sp_farmacia_*` | Dispensação, estoque |
| FATURAMENTO | `sp_conciliador_*` | Conciliação, faturamento |
| CAT | `sp_cat_*` | Notificação compulsória |
| ADMIN | `sp_admin_*`, `seed_*` | Administração, bootstrap |

**Total identificado:** 225 SPs no dump.

---

## Leis de Integridade Ontológica

```text
1. Usuário ≠ Paciente. Podem ser a mesma pessoa física,
   mas ontologicamente distintos na plataforma.

2. Usuário é permanente. Contexto é variável.

3. Senha é entrada operacional do HIS.
   Paciente existe no cadastro mestre.
   Operacionalmente só entra via Senha.

4. Banco é a Fonte da Verdade.
   Frontend exibe. Backend roteia.
   SP executa. Evento registra.

5. Nenhuma regra de negócio fora de SP.

6. Nenhuma alteração direta em tabela canônica
   sem passar por SP + Evento + Auditoria.

7. Ontologia não muda por feature.
   Ontologia muda por MD canônico.

8. dump.sql é a fonte histórica.
   MDs são a lei atual.
   MAPs são o mapa executável.
```

---

## Fluxo Ontológico Completo

```
Tenant
  ↓
Unidade
  ↓
Local
  ↓
Usuário (com perfis dinâmicos)
  ↓
Login (IAM)
  ↓
Sessão (tenant + unidade + local)
  ↓
Contexto Operacional
  ↓
App Registry (apps autorizadas)
  ↓
Aplicação
  ↓
Dashboard (app + perfil + permissão + contexto)
  ↓
Operação (Senha → Fila → FFA → Atendimento → Triagem → Execução)
  ↓
Evento (kernel_ledger)
  ↓
Auditoria (imutável)
  ↓
Analytics (Data Lakehouse)
  ↓
IA (Copilot / Agent)
  ↓
Automação (Workflow Fabric / N8N)
```

---

## Responsabilidades

Plataforma é responsável por:

```text
Manter ontologia estável
Documentar entidades e relações
Garantir integridade referencial
Evitar ilhas de dados
Evoluir via MD canônico
```

Desenvolvedores são responsáveis por:

```text
Seguir contratos ontológicos
Não criar entidades fantasma
Respeitar fluxo canônico
Emitir eventos padrão
```

---

## Próximos Passos

1. Validar MAP-006 contra dump.sql linha por linha.
2. Criar dicionário de dados canônico (MAP-003 já existe).
3. Consolidar eventos em kernel_ledger (MAP-005).
4. Documentar todas as 225 SPs com descrição canônica (MAP-004).
5. Gerar diagramas ER a partir da ontologia.
6. Alinhar frontend (MAP-010) com entidades do banco.
