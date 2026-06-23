# MD-105 — HIS Canonical Flow

## Status

Documento Canônico de Domínio Saúde.
Define o fluxo canônico do sistema de saúde (HIS/Hospital/Clínica/UPA/PA).

---

## Objetivo

Definir o fluxo assistencial canônico, garantindo que a entrada operacional seja a Senha, não o Paciente.

---

## Princípio Fundamental

```text
Paciente existe no cadastro mestre.
Operacionalmente, quem entra no fluxo é a Senha.

Paciente é identidade.
Senha é entrada operacional.
```

---

## Lei Suprema do Domínio Assistencial

```text
No HIS, a senha é a entidade de entrada operacional.
O paciente não entra no fluxo operacional.
A senha entra no fluxo.
A senha referencia o paciente.
```

---

## Fluxo Canônico do Domínio Assistencial

```
Senha
  ↓
Fila
  ↓
FFA (Fluxo de Fluxo Assistencial)
  ↓
Atendimento
  ↓
Triagem
  ↓
Execução Clínica
  ↓
Farmácia
  ↓
Faturamento
```

---

## Camadas do Fluxo

### Camada 1 — Senha

**Entidade de entrada operacional.**

```text
A senha é gerada no momento da chegada do paciente.
A senha pertence a uma unidade/local.
A senha tem tipo (normal, preferencial, risco).
A senha tem status (aguardando, chamando, em_atendimento, finalizada).
A senha referencia o paciente (opcional no momento da emissão).
```

**Tabelas canônicas:**
- `senha`
- `senha_tipo`
- `senha_status`
- `senha_emitida`

**SPs canônicas:**
- `sp_senha_emitir`
- `sp_senha_chamar`
- `sp_senha_finalizar`
- `sp_senha_cancelar`
- `sp_senha_nao_compareceu`
- `sp_senha_transicionar_status`
- `sp_totem_gerar_senha`

---

### Camada 2 — Fila

**Organização das senhas por serviço e local.**

```text
A fila organiza senhas por tipo de atendimento.
A fila tem ordem (FIFO, prioridade).
A fila respeita capacidade do local.
A fila pode ser por setor (farmácia, lab, triagem).
```

**Tabelas canônicas:**
- `fila`
- `fila_operacional`
- `fila_tipo`

**SPs canônicas:**
- `sp_fila_chamar_proxima`
- `sp_fila_finalizar`
- `sp_fila_tipo_por_local`

---

### Camada 3 — FFA (Fluxo de Fluxo Assistencial)

**Maquinário de estado do atendimento.**

```text
O FFA é o orquestrador do fluxo assistencial.
O FFA define as etapas possíveis.
O FFA controla transições entre etapas.
O FFA garante que nenhuma etapa seja pulada.
O FFA registra timestamps por etapa.
```

**Tabelas canônicas:**
- `ffa`
- `ffa_etapa`
- `ffa_transicao`

**SPs canônicas:**
- `sp_ffa_orquestrador_transicao`
- `sp_ffa_movimentar`
- `sp_ffa_adicionar_item`
- `sp_ffa_gpat_gerar`
- `sp_ffa_gpat_garantir`
- `sp_workflow_ffa_rebuild`

---

### Camada 4 — Atendimento

**Núcleo clínico do fluxo.**

```text
Atendimento é a instância de cuidado.
Atendimento pertence a uma senha (via FFA).
Atendimento pertence a um paciente.
Atendimento tem profissional responsável.
Atendimento tem tipo (urgência, eletivo, retorno).
Atendimento tem status (aberto, em_andamento, finalizado, cancelado).
```

**Tabelas canônicas:**
- `atendimento`
- `atendimento_movimentacao`
- `atendimento_evolucao`

**SPs canônicas:**
- `sp_master_atendimento_iniciar`
- `sp_master_atendimento_finalizar`
- `sp_master_atendimento_cancelar`
- `sp_master_atendimento_transicionar`
- `sp_atendimento_finalizar_evasao`
- `sp_atendimento_senha_nao_compareceu`
- `sp_atendimento_transicionar`
- `sp_executor_assistencial_atendimento_iniciar`

---

### Camada 5 — Triagem

**Classificação de risco e direcionamento.**

```text
Triagem classifica o paciente (verde, amarela, laranja, vermelha).
Triagem é feita por profissional habilitado.
Triagem gera registro no prontuário.
Triagem pode direcionar para exames ou atendimento.
```

**Tabelas canônicas:**
- `triagem`
- `triagem_classificacao`
- `triagem_motivo`

**SPs canônicas:**
- `sp_triagem_finalizar`

---

### Camada 6 — Execução Clínica

**Ações de cuidado propriamente ditas.**

```text
Prescrição médica
Administração de medicamentos
Procedimentos (ECG, curativo, etc.)
Exames
Evolução médica/enfermagem
Alta
Óbito
```

**Tabelas canônicas:**
- `prescricao`
- `prescricao_item`
- `evolucao`
- `exame`
- `procedimento`
- `alta`
- `obito`

**SPs canônicas:**
- `sp_finalizar_procedimento_ecg`
- `sp_finalizar_procedimento_geral`
- `sp_master_cancelar_administracao_medicacao`

---

### Camada 7 — Farmácia

**Dispensação vinculada ao atendimento.**

```text
Farmácia é acionada por prescrição.
Dispensação referencia o atendimento/FFA.
Controle de lote e validade.
Controle de estoque.
Produtos controlados (psicotrópicos) exigem regras especiais.
```

**Tabelas canônicas:**
- `farm_dispensacao`
- `farmacia_dispensacao`
- `dispensacao_medicacao`
- `gpat`
- `estoque`
- `produto`
- `lote`

**SPs canônicas:**
- `sp_farmacia_*`

---

### Camada 8 — Faturamento

**Geração de cobrança assistencial.**

```text
Faturamento é gerado após conclusão do atendimento.
Faturamento referencia procedimentos SUS/SIH.
Faturamento gera guias.
Faturamento concilia com estoque e farmácia.
Faturamento alimenta financeiro.
```

**Tabelas canônicas:**
- `faturamento`
- `faturamento_evento`
- `faturamento_guia`
- `gpat`
- `nota_fiscal`

**SPs canônicas:**
- `sp_conciliador_estoque_faturamento`
- `sp_faturamento_*`

---

## Regras de Transição

### Transitividade Obrigatória

```text
Senha → Fila: obrigatório (senha deve estar em uma fila)
Fila → FFA: obrigatório (FFA movimenta senhas)
FFA → Atendimento: obrigatório (atendimento nasce do FFA)
Atendimento → Triagem: obrigatório (todo atendimento deve ter triagem)
Triagem → Execução: obrigatório (execução nasce da triagem)
Execução → Farmácia: condicional (se houver prescrição)
Execução → Faturamento: obrigatório (após conclusão)
```

### Proibido

```text
Criar atendimento sem senha
Pular triagem em atendimento (a menos que regra específica)
Finalizar atendimento sem execução registrada
Faturar sem atendimento vinculado
Alterar status de senha sem registrar evento
Deletar senha ou atendimento (apenas soft delete com auditoria)
```

---

## Fluxo Alternativo: Retorno

```text
Alta
  ↓
Retorno (nova senha)
  ↓
Fila
  ↓
FFA
  ↓
Atendimento (continuidade)
```

**SPs canônicas:**
- `sp_senha_retorno_reinserir`

---

## Fluxo Alternativo: Não Comparecimento

```text
Senha gerada
  ↓
Paciente não comparece
  ↓
Status: não atendida
  ↓
Evento registrado
  ↓
Contador atualizado
```

**SPs canônicas:**
- `sp_senha_nao_compareceu`
- `sp_atendimento_senha_nao_compareceu`

---

## Integrações

```text
MD-003 — Contexto Operacional
MD-004 — Dispatcher
MD-005 — Event Store Core
MD-025 — Event Store Core
MD-034 — Identity Access Management
MD-101 — Canonical Data Architecture
MD-102 — SP First Architecture
MD-103 — Dispatcher Execution Model
MD-104 — Event Convergence Architecture
```

---

## Responsabilidades

Plataforma é responsável por:

```text
Manter fluxo canônico
Garantir transitividade obrigatória
Registrar eventos em cada transição
Garantir integridade referencial
Auditar todas as mudanças de estado
```

Desenvolvedores são responsáveis por:

```text
Seguir ordem canônica do fluxo
Não criar atalhos
Emitir eventos em cada transição
Respeitar status e estados
Usar SPs canônicas
```

---

## Métricas

```text
Tempo médio de espera (senha → atendimento)
Tempo médio de atendimento
Taxa de não comparecimento
Taxa de evasão
Taxa de retorno
Throughput por unidade/local
Taxa de finalização
Fila média por local
```
