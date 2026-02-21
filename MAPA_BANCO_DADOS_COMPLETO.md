# MAPA ESTRUTURADO DO BANCO DE DADOS - SISTEMA PRONTO ATENDIMENTO

**Data:** Fevereiro 2026  
**Versão MySQL:** 8.0.44  
**Database:** `pronto_atendimento`  
**Encoding:** UTF8MB4  
**Propósito:** Sistema de Gerenciamento de Pronto Atendimento/UPA com Farmácia, Estoque, Lab e Internação  

---

## 📊 ÍNDICE

- [1. VISÃO GERAL DO SISTEMA](#visão-geral)
- [2. MÓDULOS FUNCIONAIS](#módulos)
- [3. TABELAS PRINCIPAIS POR MÓDULO](#tabelas)
- [4. ENUMS E VALORES CONSTANTES](#enums)
- [5. PROCEDURES E FUNCTIONS](#procedures)
- [6. FLUXOS DE NEGÓCIO PRINCIPAIS](#fluxos)

---

## 🎯 VISÃO GERAL DO SISTEMA {#visão-geral}

O banco de dados `pronto_atendimento` implementa um **sistema integrado de pronto atendimento (PA/UPA)** com os seguintes componentes principais:

### Características Técnicas:
- **Storage Engine:** InnoDB (todas as tabelas)
- **Collation:** utf8mb4_0900_ai_ci (padrão)
- **Padrão de Design:** Domain-Driven Design (DDD)
- **Auditoria:** Completa em nível de transação e entidade
- **Segurança:** LGPD-compliance com auditoria de acesso a registros
- **Versionamento:** Master Data com competências (CID-10, CNES, SIGTAP, SIGPAT)

### Capacidades Operacionais:
- ✅ Gerenciamento de Filas e Senhas (Recepção/Triagem/Serviços)
- ✅ Fluxo de Atendimento Completo (Triagem → Médico → Alta/Transferência)
- ✅ Prescrição e Dispensação de Medicamentos
- ✅ Gestão de Estoque e Almoxarifado
- ✅ Requisições e Resultados de Laboratorial
- ✅ Internação e Cuidados Hospitalares
- ✅ Relatórios e Faturamento
- ✅ Integrações Externas (HL7, FHIR, SINAN, CAT, etc.)

---

## 🏢 MÓDULOS FUNCIONAIS {#módulos}

| Módulo | Objetivo | Tabelas | Status |
|--------|----------|---------|--------|
| **Autenticação & Sessão** | Controle de acesso e contexto de usuário | 4 | ✅ |
| **Paciente & Pessoa** | Dados demográficos e clínicos do paciente | 6 | ✅ |
| **Fila & Atendimento** | Gerenciamento de fila, senhas, triagem | 12 | ✅ |
| **Clínico & Prescrição** | Evolução clínica, vital signs, diagnósticos | 15 | ✅ |
| **Farmácia** | Medicamentos, dispensação, GPAT | 10 | ✅ |
| **Estoque & Inventário** | Gestão de produtos, movimentação, consumo | 12 | ✅ |
| **Laboratório** | Pedidos, amostras, resultados | 6 | ✅ |
| **Internação** | Hospitalizações, leitos, prescrições | 13 | ✅ |
| **Auditoria & Segurança** | Logs, acessos, eventos, rastreabilidade | 11 | ✅ |
| **Alertas & Notificações** | Sistema de alertas, SINAN, CAT, Violência | 8 | ✅ |
| **Configuração e Master Data** | Setores, especialidades, referências SUS | 22 | ✅ |
| **Faturamento & Financeiro** | Documentos, formas pagto, repasse médico | 4 | ✅ |

**Total: 122+ tabelas | ~80 Procedures | ~30 Functions | ~5 Views**

---

## 📋 TABELAS PRINCIPAIS POR MÓDULO {#tabelas}

### 1️⃣ MÓDULO: AUTENTICAÇÃO & SESSÃO

#### Tabela: `usuario`
```
Objetivo: Registro centralizado de usuários do sistema
Campos Principais:
  - id_usuario (PK, AUTO_INCREMENT)
  - id_pessoa (FK → pessoa)
  - login (UNIQUE)
  - senha_hash (bcrypt/SHA256)
  - id_conselho (FK → conselho_profissional) [opcional]
  - registro_profissional VARCHAR(20) [CRM/COREN/CRF/etc]
  - ativo TINYINT(1)
  - primeiro_login, forcar_troca_senha
  - senha_atualizada_em, bloqueado_ate, tentativas_login
  
Índices:
  - idx: login, id_pessoa
```

#### Tabela: `sessao_usuario`
```
Objetivo: Rastreamento de sessões ativas com contexto operacional
Campos Principais:
  - id_sessao_usuario (PK, AUTO_INCREMENT)
  - id_usuario (FK → usuario)
  - id_sistema (FK → sistema)
  - id_unidade (FK → unidade)
  - id_local_operacional (FK → local_operacional)
  - token TEXT (JWT único)
  - ip_acesso, user_agent
  - iniciado_em, expira_em, encerrado_em
  - ativo = 1 (flag de validade)

Índices:
  - idx: id_usuario, id_sessao_token, ativo + expira_em
```

#### Tabela: `perfil`
```
Objetivo: Perfis de acesso e permissões
Campos: id_perfil, nome, descricao, ativo
```

#### Tabela: `usuario_perfil`
```
Objetivo: Mapeamento N:N usuario → perfil (permissões)
Campos: id_usuario (FK), id_perfil (FK) - PK composto
```

---

### 2️⃣ MÓDULO: PACIENTE & PESSOA

#### Tabela: `pessoa`
```
Objetivo: Entidade base de pessoas (pacientes, usuários, acompanhantes)
Campos Principais:
  - id_pessoa (PK)
  - nome_completo VARCHAR(200) [required]
  - nome_social VARCHAR(200)
  - cpf VARCHAR(14) [unique quando preenchido]
  - cns VARCHAR(20) [Cartão Nac. Saúde]
  - rg VARCHAR(20), data_nascimento DATE
  - sexo ENUM('M','F','O')
  - nome_mae VARCHAR(200)
  - email, telefone
  - criado_em, atualizado_em (timestamps)

Índices:
  - idx: cpf, cns, rg (para merge)
```

#### Tabela: `paciente`
```
Objetivo: Extensão de pessoa com dados clínicos de paciente
Campos Principais:
  - id (PK/AUTO_INCREMENT)
  - id_pessoa (FK → pessoa, UNIQUE)
  - prontuario VARCHAR(30) [gerado: "PR" + id_pessoa]
  - cns_vigente VARCHAR(20)
  - criado_em, atualizado_em

Observação: Relação 1:1 com pessoa; permite paciente ser referenciado sem ser usuário
```

#### Tabela: `paciente_cns`
```
Objetivo: Histórico e validação de CNS (SUS)
Campos: id, id_paciente (FK), cns, status (ATIVO/INATIVO), validado, origem, data_validacao
```

#### Tabela: `pessoa_endereco`
```
Objetivo: Endereços de pessoa (múltiplos, com flag principal)
Campos: id, id_pessoa (FK), principal, cep, logradouro, numero, complemento, bairro, cidade, uf, criado_em, atualizado_em
```

#### Tabela: `acompanhante`
```
Objetivo: Registro de acompanhantes/responsáveis vinculados a paciente
Campos:
  - id (PK)
  - id_paciente (FK → paciente)
  - id_pessoa (FK → pessoa)
  - tipo ENUM('PAI','MAE','RESPONSAVEL_LEGAL','ACOMPANHANTE','OUTRO')
  - criado_em, atualizado_em
```

---

### 3️⃣ MÓDULO: FILA, SENHAS & ATENDIMENTO

#### Tabela: `senhas`
```
Objetivo: CENTRAL - Controle de senhas/tickets de fila da recepção
Campos Principais:
  - id (PK/AUTO_INCREMENT)
  - id_sistema, id_unidade (FK)
  - numero INT (diário por prefixo)
  - prefixo VARCHAR(5) [A, P, PR, X, V, E]
  - codigo VARCHAR(10) [humano: A001, P001, PR001]
  - data_ref DATE [data da emissão]
  
  Status Control:
  - status ENUM: GERADA → AGUARDANDO → CHAMANDO → EM_COMPLEMENTACAO → ENCAMINHADO → 
                 EM_ATENDIMENTO → NAO_COMPARECEU → FINALIZADO | CANCELADO
  - tipo_atendimento ENUM: CLINICO, PEDIATRICO, PRIORITARIO, EMERGENCIA, VISITA, EXAME
  - lane ENUM: ADULTO, PEDIATRICO, PRIORITARIO
  - prioridade INT (0=normal, >0=prioritário)
  - origem ENUM: TOTEM, RECEPCAO, ADMIN, SAMU
  
  Patient Link:
  - id_paciente (FK → paciente) [NULL até complementação]
  - id_ffa (FK → ffa) [NULL até abertura FFA]
  
  Timeline:
  - criada_em, posicionado_em, chamada_em, inicio_complementacao_em, fim_complementacao_em
  - inicio_atendimento_em, finalizada_em, nao_compareceu_em
  
  Return Window:
  - retorno_permitido_ate DATETIME [vence janela de retorno]
  - retorno_utilizado TINYINT [flag do retorno] 
  - retorno_em DATETIME [quando retornou]
  
  Operador Control:
  - id_usuario_operador, id_usuario_chamada, id_usuario_complementacao, id_usuario_complementacao_fim (FKs)
  - id_local_operacional (FK → local_operacional)

Índices:
  - UK: (id_sistema, id_unidade, data_ref, codigo) - identpara hoje
  - idx: id_paciente, id_ffa, status, lane, prioridade + criada_em
  - idx: id_usuario_chamada, id_local_operacional + status
```

#### Tabela: `fila_senha`
```
Objetivo: Status de fila (recepção/painel pública)
Campos: id_senha (PK/FK → senhas), status ENUM: AGUARDANDO, CHAMANDO, EM_COMPLEMENTACAO, ENCAMINHADO
Propósito: Sincronização com painel público / recepção
```

#### Tabela: `senha_eventos`
```
Objetivo: Auditoria de transições de estado da senha
Campos:
  - id (PK)
  - id_sessao_usuario (FK)
  - id_senha (FK)
  - tipo_evento VARCHAR(60) [EMITIR, CHAMAR, INICIAR_COMPLEMENTACAO, COMPLEMENTAR_E_ABRIR_FFA, MARCAR_RETORNO, NAO_COMPARECEU, CANCELAR, FINALIZAR, RECHAMAR]
  - detalhe TEXT [contexto]
  - status_de, status_para VARCHAR(50)
  - criado_em DATETIME
```

#### Tabela: `ffa` (Ficha de Fila de Atendimento)
```
Objetivo: CENTRAL - Documento primário de atendimento; ONE-TO-ONE com atendimento
Campos Principais:
  - id (PK)
  - id_atendimento (FK → atendimento, UNIQUE) [1:1]
  - id_paciente (FK → paciente)
  - id_senha (FK → senhas)
  
  Status & Priority:
  - status ENUM: ABERTO, EM_TRIAGEM, AGUARDANDO_CHAMADA_MEDICO, AGUARDANDO_RX, 
                 AGUARDANDO_COLETA, AGUARDANDO_ECG, AGUARDANDO_RETORNO, 
                 EM_ATENDIMENTO_MEDICO, ENCAMINHADO, INTERNADO, FINALIZADO
  - classificacao_cor ENUM: VERMELHO (emergência),  LARANJA, AMARELO, VERDE, AZUL
  - motivo TEXT [razão do atendimento]
  - retorno_ativo TINYINT [permite retorno]
  
  Timeline:
  - criado_em, atualizado_em, data_triagem, data_chamada_medico, data_alta_em
  - id_usuario_abertura, id_usuario_alteracao (FKs → usuario)
```

#### Tabela: `atendimento`
```
Objetivo: Registro de visita/consulta do paciente
Campos Principais:
  - id (PK)
  - id_unidade (FK → unidade)
  - id_paciente (FK → paciente)
  - id_senha (FK → senhas)
  - origem VARCHAR(20) [TOTEM, RECEPCAO, SAMU, etc]
  - protocolo VARCHAR(30) [UNIQUE, ex: GPAT-20260215-0000000001]
  - status ENUM: ABERTO, FINALIZANDO, FINALIZADO
  - criado_em, atualizado_em, id_usuario_abertura
  
Relação: Tem 1:1 com ffa via atendimento.id ↔ ffa.id_atendimento
```

#### Tabela: `fila_operacional`
```
Objetivo: Fila operacional por setor (TRIAGEM, MEDICO, RX, ECG, MEDICACAO, EXAME, COLETA, PROCEDIMENTO, OBSERVACAO)
Campos:
  - id_fila (PK)
  - id_ffa (FK → ffa) [qual paciente]
  - tipo VARCHAR(20) [setor]
  - substatus VARCHAR(30): AGUARDANDO, CHAMANDO, EM_EXECUCAO, FINALIZADO, NAO_COMPARECEU, SUSPENSO, REAVALIAR
  - prioridade ENUM: VERMELHO, LARANJA, AMARELO, VERDE, AZUL
  - data_entrada, entrada_original_em (quando entrou nesta fila)
  - data_inicio, data_fim, nao_compareceu_em
  - reavaliar_em (timeout tracking)
  - id_responsavel (FK → usuario) [quem está atendendo]
  - observacao TEXT
  - id_local_operacional (FK)
```

#### Tabela: `fila_operacional_evento`
```
Objetivo: Auditoria de fila operacional
Campos: id_fila (FK), id_sessao_usuario (FK), tipo_evento, detalhe, criado_em
```

#### Tabela: `fila_retorno`
```
Objetivo: Agendamentos de retorno
Campos: id, id_ffa (FK), data_retorno_agendada, status, criado_em
```

---

### 4️⃣ MÓDULO: CONSULTA & CLÍNICO

#### Tabela: `triagem`
```
Objetivo: Avaliação inicial de risco
Campos:
  - id_triagem (PK)
  - id_atendimento (FK, UNIQUE)
  - id_risco (FK → classificacao_risco)
  - queixa TEXT [motivo principal]
  - sinais_vitais JSON [PA, FC, FR]
  - observacao TEXT
  - id_enfermeiro (FK → usuario)
  - data_hora DATETIME
```

#### Tabela: `atendimento_sinais_vitais`
```
Objetivo: Monitoramento de sinais vitais ao longo do atendimento
Campos:
  - id (PK)
  - id_atendimento (FK)
  - pressao_sistolica, pressao_diastolica INT [mmHg]
  - frequencia_cardiaca INT [bpm]
  - frequencia_respiratoria INT [irpm]
  - temperatura DECIMAL(4,2) [°C]
  - saturacao_o2 INT [%]
  - hgt DECIMAL [glicemia]
  - dor INT [0-10]
  - id_usuario (FK)
  - criado_em
```

#### Tabela: `atendimento_evolucao`
```
Objetivo: Notas de progresso clínico (médico/enfermeiro)
Campos:
  - id_evolucao (PK)
  - id_atendimento (FK)
  - tipo_profissional ENUM: MEDICO, ENFERMEIRO, TECNICO, OUTROS
  - descricao TEXT [narrativa clínica]
  - id_usuario (FK)
  - criado_em
```

#### Tabela: `atendimento_exame_fisico`
```
Objetivo: Registro padronizado de exame físico
Campos:
  - id (PK)
  - id_atendimento (FK)
  - estado_geral ENUM [BOM, REGULAR, GRAVE]
  - nivel_consciencia ENUM [ALERTA, LETARGICO, ESTUPOR, COMA]
  - mucosas ENUM [NORMOCORADAS, PÁLIDAS, CIANÓTICAS, ICTÉRICAS]
  - estado_nutricional ENUM [EUTRÓFICO, DESNUTRIDO, OBESO]
  - edema TINYINT(1)
  - observacao TEXT
  - id_usuario (FK)
  - criado_em
```

#### Tabela: `atendimento_diagnosticos`
```
Objetivo: CIDs associados ao atendimento
Campos:
  - id (PK)
  - id_atendimento (FK)
  - cid10 VARCHAR(10) [FK → md_cid10]
  - tipo ENUM: PRINCIPAL, SECUNDARIO, HIPOTESE
  - observacao TEXT
  - id_usuario (FK)
  - criado_em
```

#### Tabela: `atendimento_escalas_risco`
```
Objetivo: Escalas de risco padronizadas
Campos:
  - id (PK)
  - id_atendimento (FK)
  - tipo ENUM: MORSE_QUEDA, BRADEN_LESÃO_PELE, GLASGOW
  - score INT
  - classificacao ENUM [por tipo]
  - criado_em
```

#### Tabela: `atendimento_pedidos_exame`
```
Objetivo: Solicitações de exame (Lab/Imagem)
Campos:
  - id (PK)
  - id_atendimento (FK)
  - tipo ENUM: LABORATORIO, RX, ECG, ULTRASSOM, TOMOGRAFIA, etc
  - status ENUM: SOLICITADO, COLETADO, EM_ANALISE, LAUDADO, ENTREGUE, CANCELADO
  - descricao TEXT
  - id_usuario_solicitante (FK)
  - data_solicitacao, data_execucao, data_entrega
```

#### Tabela: `atendimento_prescricao`
``` 
Objetivo: Prescrições de medicamentos/procedimentos
Campos:
  - id (PK)
  - id_atendimento (FK)
  - id_medicamento (FK → farmaco)
  - dose, via, frequencia VARCHAR() [posologia]
  - dias INT [duração]
  - status ENUM: ATIVO, SUSPENSO, CONCLUIDO
  - id_usuario_prescritor (FK)
  - criado_em
```

#### Tabela: `atendimento_desfecho`
```
Objetivo: Resultado do atendimento (alta/transferência/óbito)
Campos:
  - id (PK)
  - id_atendimento (FK, UNIQUE)
  - tipo_desfecho ENUM: ALTA_MEDICA, ALTA_A_PEDIDO, TRANSFERENCIA, OBITO, EVASAO
  - motivo TEXT
  - destino VARCHAR [se transferência]
  - data_desfecho DATETIME
  - id_usuario_responsavel (FK)
```

#### Tabela: `atendimento_sumario_alta`
```
Objetivo: Resumo de alta hospitalar
Campos:
  - id (PK)
  - id_atendimento (FK, UNIQUE)
  - motivo_internacao TEXT
  - resumo_clinico TEXT
  - procedimentos_realizados TEXT
  - orientacoes_pos_alta TEXT
  - medicamentos_receitados TEXT
  - id_usuario_redator (FK)
  - criado_em
```

---

### 5️⃣ MÓDULO: FARMÁCIA & MEDICAMENTOS

#### Tabela: `farmaco`
```
Objetivo: Catálogo de medicamentos
Campos:
  - id (PK)
  - codigo VARCHAR(30) [UNIQUE]
  - nome VARCHAR(255)
  - principio_ativo TEXT
  - concentracao VARCHAR(50)
  - unidade_padrao VARCHAR(20) [COMPRIMIDO, AMPOLA, FRASCO, etc]
  - fabricante VARCHAR(100)
  - lote VARCHAR(50)
  - validade DATE
  - preco_unitario DECIMAL(10,2)
  - ativo TINYINT(1)
```

#### Tabela: `farmaco_lote`
```
Objetivo: Rastreamento de lotes de medicamentos
Campos:
  - id (PK)
  - id_farmaco (FK)
  - lote VARCHAR(50) [UNIQUE compound]
  - fabricacao DATE
  - validade DATE [CRITICAL]
  - quantidade INT [entrada]
  - quantidade_saldo INT [saldo atual]
  - status ENUM: ATIVO, QUARENTENA, DEVOLVIDO, VENCIDO
  - nf_entrada VARCHAR(50)
  - fornecedor_id (FK → fornecedor)
  - criado_em, atualizado_em
```

#### Tabela: `administracao_medicacao`
```
Objetivo: Registro real que medicamento foi administrado ao paciente
Campos:
  - id (PK)
  - id_atendimento (FK)
  - id_prescricao (FK → atendimento_prescricao)
  - id_farmaco (FK)
  - dose_administrada DECIMAL
  - via ENUM [ORAL, IV, IM, SC, TOPICA, INALATORIA]
  - data_hora_administracao DATETIME
  - id_usuario_administrador (FK) [quem deu]
  - id_usuario_verificador (FK) [quem vericou dupla conferência]
  - observacao TEXT
  - criado_em
```

#### Tabela: `dispensacao_medicacao`
```
Objetivo: Saída de medicamento da farmácia (baixa de estoque)
Campos:
  - id (PK)
  - id_atendimento (FK)
  - id_farmaco (FK)
  - id_lote (FK → farmaco_lote)
  - quantidade DECIMAL
  - status ENUM: DISPENSADO, DEVOLVIDO, PERDIDO
  - id_usuario_dispensador (FK)
  - criado_em
```

#### Tabela: `gpat_atendimento` (Gerador de Prescrição Assistida)
```
Objetivo: Formulário de prescrição externa/interna
Campos:
  - id (PK)
  - id_ffa (FK) [qual paciente]
  - tipo_prescritor ENUM: INTERNO (médico do PA), EXTERNO (receita manuscrita)
  - data_emissao DATE
  - data_validade DATE
  - data_dispensacao DATE
  - status ENUM: ABERTO, DISPENSADO, CANCELADO, EXPIRADO
  - cpf_prescritor VARCHAR(14)
  - nome_prescritor VARCHAR(255)
```

#### Tabela: `gpat_item`
```
Objetivo: Medicamentos em prescrição GPAT
Campos:
  - id (PK)
  - id_gpat (FK → gpat_atendimento)
  - id_farmaco (FK)
  - quantidade_total DECIMAL
  - dias INT [duração]
  - posologia VARCHAR(255) [instruções]
  - status ENUM: PENDENTE_DISPENSACAO, DISPENSADO, CANCELADO
```

#### Tabela: `gpat_dispensacao`
```
Objetivo: Saída de medicamento via prescrição GPAT
Campos:
  - id (PK)
  - id_gpat_item (FK → gpat_item)
  - quantidade_dispensada DECIMAL
  - status ENUM: ENTREGUE, ESTORNADO
  - data_dispensacao DATETIME
  - id_usuario_dispensador (FK)
```

---

### 6️⃣ MÓDULO: ESTOQUE & ALMOXARIFADO

#### Tabela: `estoque_produto`
```
Objetivo: Catálogo de produtos do estoque (não medicamentos)
Campos:
  - id (PK)
  - codigo VARCHAR(30) [UNIQUE]
  - nome VARCHAR(255)
  - descricao TEXT
  - unidade_padrao VARCHAR(20) [CAIXA, UNIDADE, KG, LITRO, etc]
  - fabricante VARCHAR(100)
  - preco_unitario DECIMAL
  - ativo TINYINT(1)
```

#### Tabela: `estoque_almoxarifado`
```
Objetivo: Saldo por local/almoxarifado
Campos:
  - id (PK)
  - id_produto (FK → estoque_produto)
  - id_local_operacional (FK)
  - quantidade_atual DECIMAL [saldo]
  - min_estoque DECIMAL [ponto de reposição]
  - max_estoque DECIMAL
  - criado_em, atualizado_em
```

#### Tabela: `estoque_almoxarifado_central`
```
Objetivo: Estoque centralizado com rastreamento de lote/validade
Campos:
  - id (PK)
  - id_produto (FK)
  - lote VARCHAR(50)
  - validade DATE
  - quantidade INT
  - nf_entrada VARCHAR(50)
  - fornecedor_id (FK)
  - status ENUM: ATIVO, BLOQUEADO, VENCIDO, DESCARTADO
  - criado_em
```

#### Tabela: `estoque_movimento`
```
Objetivo: Auditoria de todas as movimentações
Campos:
  - id (PK)
  - id_produto (FK)
  - tipo ENUM: ENTRADA, SAIDA, AJUSTE, DEVOLUCAO
  - quantidade DECIMAL
  - saldo_anterior, saldo_posterior DECIMAL
  - motivo TEXT
  - id_usuario (FK)
  - id_sessao_usuario (FK)
  - criado_em
```

#### Tabela: `estoque_inventario`
```
Objetivo: Contagem física períodica
Campos:
  - id (PK)
  - data_inventario DATE
  - status ENUM: ABERTO, EM_CONTAGEM, FECHADO, CANCELADO
  - quantidade_esperada DECIMAL
  - quantidade_realizada DECIMAL
  - diferenca DECIMAL
  - criado_em, encerrado_em
```

#### Tabela: `estoque_alerta`
```
Objetivo: Alertas de baixο estoque / vencimento
Campos:
  - id (PK)
  - id_produto (FK)
  - tipo_alerta ENUM: BAIXO_ESTOQUE, CRITICO, VENCIMENTO
  - quantidade_alerta DECIMAL
  - status ENUM: ABERTO, ATUADO, CANCELADO
  - criado_em, atualizado_em
```

#### Tabela: `consumo_insumo`
```
Objetivo: Rastreamento de consumo real (farmácia/almoxarifado/manutencao)
Campos:
  - id (PK)
  - id_produto (FK)
  - origem ENUM: FARMACIA, ALMOXARIFADO, MANUTENCAO
  - quantidade DECIMAL
  - motivo TEXT [ROTINA, REPOSICAO, COMPRA, DOACAO, etc]
  - id_usuario (FK)
  - criado_em
```

---

### 7️⃣ MÓDULO: LABORATÓRIO

#### Tabela: `lab_pedido`
```
Objetivo: Requisição de teste laboratorial
Campos:
  - id_pedido (PK)
  - id_atendimento (FK)
  - protocol_interno VARCHAR(30) [UNIQUE]
  - status ENUM: SOLICITADO, COLETADO, ENVIADO, RECEBIDO_LAB, FINALIZADO, CANCELADO
  - data_solicitacao DATETIME
  - data_coleta DATETIME
  - observacao TEXT
  - id_usuario_solicitante (FK)
```

#### Tabela: `lab_amostra`
```
Objetivo: Amostra biológica coletada
Campos:
  - id (PK)
  - id_pedido (FK)
  - codigo_amostra VARCHAR(30) [UNIQUE]
  - tipo_material VARCHAR(30) [SANGUE, URINA, FEZES, etc]
  - volume DECIMAL
  - status ENUM: RECEBIDA, ANALISANDO, UTILIZADA, DESCARTADA
  - data_coleta DATETIME
```

#### Tabela: `lab_resultado`
```
Objetivo: Resultado de teste
Campos:
  - id (PK)
  - id_amostra (FK)
  - teste_codigo VARCHAR(50)
  - teste_nome VARCHAR(255)
  - resultado_texto TEXT [valor + unidade]
  - resultado_link DECIMAL [valor numérico se aplicável]
  - referencia VARCHAR(50) [range normal]
  - critico TINYINT(1) [valor anormal?]
  - data_resultado DATETIME
```

#### Tabela: `laboratorio_protocolo`
```
Objetivo: Protocolo/rastreamento com sistema externo
Campos:
  - id (PK)
  - codigo VARCHAR(30) [UNIQUE]
  - barcode VARCHAR(100) [UNIQUE]
  - status ENUM: ATIVO, CANCELADO
  - sistema_externo VARCHAR(100) [nome do laboratorio]
  - id_protocolo_externo VARCHAR(50)
```

---

### 8️⃣ MÓDULO: INTERNAÇÃO & HOSPITALIZAÇAO

#### Tabela: `internacao`
```
Objetivo: Registro de hospitalização
Campos:
  - id_internacao (PK)
  - id_ffa (FK) [qual paciente]
  - id_leito (FK → leito)
  - tipo ENUM: OBSERVACAO (< 24h), INTERNACAO (≥ 24h)
  - status ENUM: ATIVA, ENCERRADA, TRANSFERIDA, OBITO
  - precaucao ENUM: PADRAO, CONTATO, GOTICULAS, AEROSSOIS
  - previsao_alta DATE
  - data_entrada DATETIME
  - data_saida DATETIME
  - id_usuario_responsavel (FK)
```

#### Tabela: `internacao_prescricao`
```
Objetivo: Prescrições de leito (medicamentos/dietas/gases)
Campos:
  - id (PK)
  - id_internacao (FK)
  - data_prescricao DATE
  - status ENUM: ATIVA, SUSPENSA, ENCERRADA
  - prescrito_por (FK → usuario)
```

#### Tabela: `internacao_prescricao_item`
```
Objetivo: Item individual da prescrição
Campos:
  - id (PK)
  - id_prescricao (FK → internacao_prescricao)
  - tipo ENUM: MEDICAMENTO, DIETA, CUIDADO, OUTRO
  - descricao TEXT
  - frequencia VARCHAR(50)
  - status ENUM: ATIVA, SUSPENSA, CONCLUIDA
```

#### Tabela: `internacao_medicacao_administracao`
```
Objetivo: Medicação real administrada  
Campos:
  - id (PK)
  - id_internacao (FK)
  - id_medicamento (FK)
  - dose, via ENUM
  - horario_prescrito DATETIME
  - horario_executado DATETIME
  - status ENUM: ADMINISTRADO, RECUSADO, SUSPENSO, NAO_DISPONIVEL
  - id_usuario_executador (FK)
  - observacao TEXT
```

#### Tabela: `internacao_dietas`
```
Objetivo: Prescrição de dieta hospitalar
Campos:
  - id (PK)
  - id_internacao (FK)
  - tipo ENUM: LIVRE, BRANDAS, PASTOSA, LIQUIDA, ZERO, ENTERAL, PARENTERAL
  - observacao TEXT
  - prescrito_por (FK → usuario)
  - criado_em
```

#### Tabela: `internacao_dispositivos`
```
Objetivo: Rastreamento de tubos/cateteres/sondas
Campos:
  - id (PK)
  - id_internacao (FK)
  - tipo ENUM: CVC, SVD (cateter urinário), SNG (sonda nasogastrica), SNE, DRENO, CATETER_PERIFERICO, CANULA_TRAQUEO
  - local TEXT [onde inserido]
  - data_insercao DATETIME
  - intervalo_troca INT [dias]
  - status ENUM: ATIVO, REMOVIDO, RETIRADO
```

#### Tabela: `internacao_cuidados`
```
Objetivo: Ordens de cuidados especiais
Campos:
  - id (PK)
  - id_internacao (FK)
  - tipo ENUM: FERIDA, DRENAGEM, SONDA, OXIGENIO, SINAIS_VITAIS, MOVILIZACAO, OUTRO
  - frequencia VARCHAR(50) [2H, 4H, 6H, 12H, TURNO, EVENTUAL]
  - descricao TEXT
  - prescrito_por (FK)
```

#### Tabela: `internacao_ferida_avaliacao`
```
Objetivo: Avaliação de feridas (LPP, cirúrgicas, etc)
Campos:
  - id (PK)
  - id_internacao (FK)
  - tipo ENUM: FERIDA, LPP (lesão por pressão), CIRURGICA, OUTRA
  - localizacao TEXT
  - estagio_lpp ENUM: I, II, III, IV, NAO_CLASSIFICAVEL, TECIDO_PROFUNDO [se LPP]
  - dimensoes TEXT
  - drenagem TEXT
  - appearancia TEXT
  - observacao TEXT
  - criado_em
```

#### Tabela: `internacao_braden_avaliacao`
```
Objetivo: Escala de Braden (prevenção de LPP)
Campos:
  - id (PK)
  - id_internacao (FK)
  - score_total INT [6-23]
  - risco ENUM: SEM_RISCO, LEVE, MODERADO, ALTO, MUITO_ALTO
  - data_avaliacao DATETIME
```

#### Tabela: `internacao_registro_enfermagem`
```
Objetivo: Notas de enfermagem por turno
Campos:
  - id (PK)
  - id_internacao (FK)
  - turno VARCHAR(20) [MANHA, TARDE, NOITE]
  - periodicidade ENUM: 2H, 4H, 6H, TURNO, EVENTUAL
  - observacoes TEXT
  - sinais_vitais JSON [PA, FC, etc]
  - protusis TINYINT(1) [teve protusão?]
  - criado_em
```

#### Tabela: `leito`
```
Objetivo: Catálogo de leitos disponíveis
Campos:
  - id_leito (PK)
  - id_setor (FK → setor)
  - numero INT
  - identificacao VARCHAR(20) [Ex: A01, B02]
  - tipo ENUM: COMUM, ISOLAMENTO, CTI, SEMI_UTI
  - status ENUM: DISPONIVEL, OCUPADO, RESERVADO, LIMPEZA, MANUTENCAO, INTERDITADO
  - criado_em, atualizado_em
```

---

### 9️⃣ MÓDULO: AUDITORIA & SEGURANÇA

#### Tabela: `auditoria_evento`
```
Objetivo: CENTRAL - Log de eventos de negócio por transação
Campos:
  - id (PK)
  - id_sessao_usuario (FK)
  - entidade VARCHAR(50) [qual tabela/entidade]
  - id_entidade BIGINT [qual registro]
  - acao VARCHAR(50) [CRIAR, MODIFICAR, DELETAR, CHAMAR, ENCAMINHAR, etc]
  - detalhe TEXT [o que mudou/contexto]
  - tabela VARCHAR(50) [nome técnico]
  - id_usuario_espelho BIGINT [denormalizado para query rápida]
  - criado_em DATETIME

Índices:
  - idx: entidade + id_entidade + criado_em
  - idx: id_sessao_usuario + criado_em
  - idx: id_usuario_espelho + criado_em
```

#### Tabela: `auditoria_erro`
```
Objetivo: Log de erros SQL/aplicação
Campos:
  - id (PK)
  - id_sessao_usuario (FK)
  - rotina VARCHAR(100) [nome do SP/procedure]
  - sqlstate VARCHAR(10)
  - errno INT
  - mensagem TEXT
  - contexto TEXT
  - criado_em
```

#### Tabela: `auditoria_acesso`
```
Objetivo: Auditoria de acesso a dados (READ/SEARCH/EXPORT/PRINT)
Campos:
  - id (PK)
  - id_sessao_usuario (FK)
  - acao VARCHAR(20) ENUM: READ, SEARCH, EXPORT, PRINT, DOWNLOAD, VIEW
  - tabela VARCHAR(50)
  - filtros TEXT [quais registros acessados]
  - ip VARCHAR(45)
  - user_agent TEXT
  - criado_em
```

#### Tabela: `auditoria_visualizacao_prontuario`
```
Objetivo: LGPD - Auditoria de quem acessou prontuário (CRITICAL)
Campos:
  - id (PK)
  - id_paciente (FK)
  - id_usuario_acesso (FK)
  - id_sessao_usuario (FK)
  - tipo_acesso ENUM: VISUALIZADO, IMPRESSO, EXPORTADO
  - motivo TEXT [por que acessou?]
  - criado_em
```

#### Tabela: `auditoria_ffa`
```
Objetivo: Auditoria específica de FFA
Campos:
  - id (PK)
  - id_ffa (FK)
  - id_sessao_usuario (FK)
  - acao VARCHAR(50)
  - detalhe TEXT
  - criado_em
```

---

### 🔟 MÓDULO: ALERTAS & NOTIFICAÇÕES

#### Tabela: `alerta`
```
Objetivo: Sistema de alertas genéricos (paciente complexo, baixo estoque, etc)
Campos:
  - id (PK)
  - tipo VARCHAR(50) [PACIENTE_COMPLEXO, ESTOQUE_CRITICO, MEDICAMENTO_VENCENDO, etc]
  - titulo VARCHAR(255)
  - descricao TEXT
  - severidade ENUM: INFO, ATENCAO, ALTA
  - status ENUM: ABERTO, LIDO, EM_ATENDIMENTO, RESOLVIDO, CANCELADO
  - id_usuario_criador (FK)
  - criado_em, atualizado_em
```

#### Tabela: `alerta_destinatario`
```
Objetivo: Roteamento de alertas
Campos:
  - id (PK)
  - id_alerta (FK)
  - tipo_destino ENUM: USUARIO, PERFIL, PAINEL, LOCAL, UNIDADE, SISTEMA
  - id_destino BIGINT
```

#### Tabela: `notificacao_epidemiologica` (SINAN)
```
Objetivo: Notificações ao SINAN
Campos:
  - id (PK)
  - id_ffa (FK)
  - id_paciente (FK)
  - doenca_notificavel VARCHAR(50) [CID]
  - data_notificacao DATE
  - status_notificacao ENUM: PENDENTE, ENVIADO_MS, ARQUIVADO
  - protocolo_ms VARCHAR(30)
  - criado_em
```

#### Tabela: `notificacao_violencia`
```
Objetivo: Notificações de violência
Campos:
  - id (PK)
  - id_ffa (FK)
  - id_paciente (FK)
  - categoria ENUM: VIOLENCIA, AGRESSAO, ABUSO, TRANSITO, OUTRA
  - descricao TEXT
  - status ENUM: ABERTA, EM_INVESTIGACAO, ENVIADA, ARQUIVADA
  - criado_em
```

#### Tabela: `cat_acidente_trabalho`
```
Objetivo: Comunicação de Acidente de Trabalho
Campos:
  - id (PK)
  - id_ffa (FK)
  - tipo_acidente ENUM: TIPICO, TRAJETO, DOENCA_OCUPACIONAL, OUTRO
  - data_acidente DATE
  - descricao TEXT
  - status_cat ENUM: ABERTA, EMITIDA, ENVIADA, ARQUIVADA
  - criado_em
```

---

### 1️⃣1️⃣ MÓDULO: CONFIGURAÇÃO & MASTER DATA

#### Tabela: `local_operacional`
```
Objetivo: Locais onde atendimento ocorre (Recepção, Triagem, Consultório, RX, etc)
Campos:
  - id_local_operacional (PK)
  - id_unidade (FK)
  - id_sistema (FK)
  - codigo VARCHAR(10) [REC01, TRI01, MEDC1, RX01, MED01, MEDP01, etc]
  - nome VARCHAR(255)
  - tipo VARCHAR(50) [RECEPCAO, TRIAGEM, CONSULTORIO, RX, LABORATORIO, FARMACIA, MEDICACAO, etc]
  - exibe_em_painel_publico TINYINT(1) [mostra na TV?]
  - gera_tts_publico TINYINT(1) [anuncia em voz?]
  - eh_nao_definida TINYINT(1) [flag local genérico]
  - ativo TINYINT(1)
  - criado_em
```

#### Tabela: `setor`
```
Objetivo: Departamentos/setores (Pronto Socorro, Observação, UTI, etc)
Campos:
  - id_setor (PK)
  - id_unidade (FK)
  - nome VARCHAR(100)
  - tipo ENUM: PRONTO_SOCORRO, OBSERVACAO, INTERNACAO, UTI_ADULTO, UTI_PEDIATRICA, CENTRO_CIRURGICO
  - responsavel_id (FK → usuario)
  - ativo TINYINT(1)
```

#### Tabela: `unidade`
```
Objetivo: Unidades de negócio deoperação (hospital, UPA, PA)
Campos:
  - id_unidade (PK)
  - id_sistema (FK)
  - id_cidade (FK → cidade)
  - nome VARCHAR(150)
  - cnes CHAR(7) [cadastro no CNES]
  - tipo ENUM: UPA, HOSPITAL, PA, CLINICA
  - ativo TINYINT(1)
```

#### Tabela: `sistema`
```
Objetivo: Sistemas de TI (Pronto Atendimento, UBS, etc)
Campos:
  - id_sistema (PK)
  - codigo VARCHAR(20)
  - nome VARCHAR(150)
  - descricao VARCHAR(255)
  - ativo TINYINT(1)
```

#### Tabela: `especialidade`
```
Objetivo: Especialidades médicas
Campos:
  - id (PK)
  - nome VARCHAR(255)
  - codigo VARCHAR(50)
  - ativo TINYINT(1)
```

#### Tabela: `conselho_profissional`
```
Objetivo: Conselhos de classe para validação de registro
Campos:
  - id (PK)
  - sigla VARCHAR(10) [CRM, COREN, CRF, CRO, CREFITO, CRP, CRN, OUTRO]
  - nome VARCHAR(255)
  - ativo TINYINT(1)
```

#### Tabela: `classificacao_risco`
```
Objetivo: Cores de classificação de risco (Manchester)
Campos:
  - id_risco (PK)
  - cor ENUM: VERMELHO, LARANJA, AMARELO, VERDE, AZUL
  - descricao VARCHAR(100)
  - tempo_max_minutos INT [tempo até atendimento]
  - ordem INT [para ordenação]
```

#### Tabela: `md_cid10` (Master Data)
```
Objetivo: Referência de CIDs vigentes do SUS
Campos:
  - cid10 VARCHAR(10) (PK combination)
  - descricao VARCHAR(255)
  - sexo_restricao ENUM('A'=ambos,'M','F')
  - idade_min_meses INT
  - idade_max_meses INT
  - ativo TINYINT(1)
```

#### Tabela: `md_cnes_estabelecimento`
```
Objetivo: Referência de CNES do Brasil
Campos:
  - cnes VARCHAR(7) (PK combination)
  - nome VARCHAR(255)
  - municipio VARCHAR(120)
  - uf CHAR(2)
```

#### Tabela: `md_sigtap_procedimento`
```
Objetivo: Referência de procedimentos SUS (SIGTAP)
Campos:
  - codigo VARCHAR(20)
  - descricao VARCHAR(255)
  - complexidade ENUM: BASICA, MEDIA, ALTA
  - exige_cat_default TINYINT(1)
  - exige_sinan_default TINYINT(1)
```

#### Tabela: `painel`
```
Objetivo: Configuração de painéis públicos (TV, Totem)
Campos:
  - id_painel (PK)
  - codigo VARCHAR(60) [UNIQUE]
  - tipo ENUM: PAINEL, TOTEM, TV
  - nome VARCHAR(255)
  - id_unidade (FK)
  - id_sistema (FK)
  - intervalo_segundos INT [atualização]
  - emite_som TINYINT(1)
  - tts_habilitado TINYINT(1) [text-to-speech]
  - intervalo_pisca INT [blinking time]
  - ativo TINYINT(1)
```

#### Tabela: `painel_config`
```
Objetivo: Configurações dinâmicas de painel (KEY-VALUE flexível)
Campos:
  - id_painel (FK, PK)
  - chave VARCHAR(80) (PK)
  - valor_bool TINYINT
  - valor_int INT
  - valor_decimal DECIMAL(12,4)
  - valor_text TEXT
  - valor_json JSON
  - valor_enum VARCHAR(80)
  - atualizado_em DATETIME
```

---

### 1️⃣2️⃣ MÓDULO: FATURAMENTO & FINANCEIRO

#### Tabela: `forma_pagamento`
```
Objetivo: Métodos de pagamento disponíveis
Campos:
  - id (PK)
  - descricao VARCHAR(100) [DINHEIRO, PIX, DEBITO, CREDITO, CARTAO_DEBITO, CARTAO_CREDITO, CONVENIO, OUTRO]
  - ativo TINYINT(1)
```

#### Tabela: `documento_tipo_config`
```
Objetivo: Tipos de documentos gerados (receita, atestado, encaminhamento, etc)
Campos:
  - id (PK)
  - tipo ENUM: ATESTADO, ENCAMINHAMENTO, RECEITA_CONTROLADO, RECEITUARIO_CASA, REGISTRO_ATENDIMENTO, SOLIC_EXAME, MEDICACAO_INTERNA
  - descricao VARCHAR(255)
  - template TEXT [HTML/markup]
  - ativo TINYINT(1)
```

#### Tabela: `documento_emissao`
```
Objetivo: Rastreamento de documentos emitidos
Campos:
  - id (PK)
  - tipo_documento VARCHAR(50)
  - numeroDocumento VARCHAR(50)
  - id_atendimento (FK, nullable)
  - id_usuario_gerador (FK)
  - status ENUM: GERADO, IMPRESSO, CANCELADO
  - hash_documento CHAR(64) [SHA256]
  - criado_em, data_cancelamento
```

#### Tabela: `financeiro_repasse_medico`
```
Objetivo: Pagamentos a médicos
Campos:
  - id (PK)
  - id_medico (FK → usuario)
  - periodo_mes VARCHAR(7)
  - valor_procedimento DECIMAL
  - percentual_repasse DECIMAL [%]
  - valor_repasse DECIMAL [calculado]
  - status_pagamento ENUM: PREVIA, APROVADO, PAGO, GLOSADO
  - criado_em, data_pagamento
```

---

## 📌 ENUMS E CONSTANTES {#enums}

### Principais ENUM Types:

#### STATUS DE SENHA:
```
GERADA → AGUARDANDO → CHAMANDO → EM_COMPLEMENTACAO → ENCAMINHADO → 
EM_ATENDIMENTO → NAO_COMPARECEU → FINALIZADO | CANCELADO
```

#### STATUS DE FFA:
```
ABERTO → EM_TRIAGEM → AGUARDANDO_CHAMADA_MEDICO → AGUARDANDO_RX → 
AGUARDANDO_COLETA → AGUARDANDO_ECG → AGUARDANDO_RETORNO → 
EM_ATENDIMENTO_MEDICO → ENCAMINHADO → INTERNADO → FINALIZADO
```

#### CLASSIFICAÇÃO DE RISCO (MANCHESTER):
```
VERMELHO (emergência 0 min)
LARANJA (muito urgente, 10 min)
AMARELO (urgente, 60 min)
VERDE (pouco urgente, 120 min)
AZUL (não urgente, 240 min)
```

#### TIPO DE ATENDIMENTO (SENHAS):
```
CLINICO, PEDIATRICO, PRIORITARIO, EMERGENCIA, VISITA, EXAME
```

#### VIA DE ADMINISTRAÇÃO:
```
ORAL, IV, IM, SC, TOPICA, INALATORIA
```

#### TIPO DE INTERNAÇÃO:
```
OBSERVACAO (< 24h)
INTERNACAO (≥ 24h)
```

#### STATUS DE INTERNAÇÃO:
```
ATIVA, ENCERRADA, TRANSFERIDA, OBITO
```

#### DESFECHO DE ATENDIMENTO:
```
ALTA_MEDICA, ALTA_A_PEDIDO, TRANSFERENCIA, OBITO, EVASAO
```

#### DISPOSITIVOS HOSPITALARES:
```
CVC (Central Venous Catheter)
SVD (Catheter Urinary)
SNG (Nasogastric probe)
SNE (Nasoenteral probe)
DRENO
CATETER_PERIFERICO
CANULA_TRAQUEO
```

---

## 🔧 PROCEDURES E FUNCTIONS {#procedures}

### Procedures Principais (54 identificadas):

#### Autenticação:
```
sp_sessao_abrir        → Abre nova sessão de usuário
sp_sessao_assert       → Valida sessão ativa/vigente (usado em todas operações)
sp_sessao_encerrar     → Encerra sessão
sp_sessao_contexto_get → Retorna contexto (usuário, unidade, local)
sp_sessao_tem_permissao → Valida permissão de operação
sp_permissao_assert    → Afirma terção de permissão
```

#### Senha & Fila:
```
sp_senha_emitir                      → Gera nova senha na recepção
sp_senha_chamar_proxima              → Chama próxima da fila (com concorrência)
sp_recepcao_iniciar_complementacao   → Inicia preenchimento de dados
sp_recepcao_complementar_e_abrir_ffa → Completa dados + abre FFA
sp_recepcao_encaminhar_ffa           → Encaminha para triagem/setor
sp_recepcao_nao_compareceu           → Marca não compareceu + abre janela retorno
sp_senha_nao_compareceu              → Helper de nao_compareceu
sp_senha_finalizar                   → Finaliza senha
sp_senha_cancelar                    → Cancela senha
sp_senha_rechamar                    → Rechama (novo chamado)
sp_senha_iniciar_complementacao      → Inicia complementação dados (helper)
sp_senha_retorno_reinserir           → Retorno na janela (reinserir ou nova)
```

#### Triagem:
```
sp_triagem_chamar      → Chama paciente para triagem
```

#### Médico/Consultório:
```
sp_medico_chamar               → Chama para consulta médica
sp_medico_marcar_retorno       → Agenda retorno (janela de tempo)
sp_medico_encaminhar           → Encaminha para exame/procedimento
sp_medico_finalizar            → Finaliza atendimento médico
sp_operacao_encaminhar         → Core: encaminha para outro local
```

#### RX/Imagem:
```
sp_rx_chamar              → Chama para RX
sp_rx_finalizar           → Finaliza RX
```

#### Medicação:
```
sp_medicacao_marcar_executado  → Marca medicação como dada
sp_medicacao_finalizar         → Finaliza setor medicação
sp_medicacao_nao_respondeu     → Paciente não compareceu em medicação
```

#### Paciente & Dados:
```
sp_paciente_cns_set → Atualiza/registra CNS do paciente
```

#### Configuração:
```
sp_painel_config_set                   → Set de configuração de painel (type-safe)
sp_painel_filtro_locais_seed           → Seed de filtros de painel por local
sp_painel_seed_especialidades          → Cria estrutura de painéis (especialidades/ligas)
```

#### PDV/Venda:
```
sp_pdv_venda_criar     → Cria venda de varejo
```

#### Pedidos Médicos:
```
sp_pedido_medico_criar      → Cria pedido médico (com GPAT)
sp_pedido_medico_item_add   → Adiciona item ao pedido
```

#### Procedimentos/Protocolos:
```
sp_procedimento_protocolo_criar  → Cria protocolo de procedure (RX/EXAME)
sp_rechamar_procedimento         → Rechama procedimento
sp_protocolo_emitir              → Emite protocolo com número sequencial
sp_sequencia_proximo_numero      → Helper: próximo número em sequência
```

#### Timeout & Limpeza:
```
sp_timeout_ffa              → Finaliza FFAs abandonadas (timeout)
sp_timeout_procedimento_rx  → Marca RX para reavaliar (timeout)
```

#### Auditoria & Logging (Core):
```
sp_auditar_erro_sql           → Log erro SQL
sp_auditoria_evento_registrar → Log evento de negócio (CENTRAL)
```

#### Helpers de Controle:
```
sp_assert_true        → Afirmação com exceção
sp_assert_not_null    → Não nulo
sp_raise              → Lança exceção (SQLSTATE 45000)
```

#### Fila Operacional (Internos):
```
sp_fila_chamar_proxima         → Core: chama próxima da fila
sp_fila_tipo_por_local         → Mapeia tipo de fila por local
sp_fila_finalizar              → Finaliza fila operacional
```

#### Schema Helpers:
```
sp_schema_add_column_if_missing → Migração: adiciona coluna se não existe
sp_schema_add_index_if_missing  → Migração: adiciona índice se não existe
```

### Functions (Não identificadas explicitamente, mas inferidas):
- Funções de cálculo (idade, score Braden, etc)
- Funções de formatação
- Funções de validação (CPF, CNPJ, etc)
- Funções de geração de barcode

---

## 🔄 FLUXOS DE NEGÓCIO PRINCIPAIS {#fluxos}

### 1️⃣ FLUXO: EMISSÃO DE SENHA → ATENDIMENTO COMPLETO

```
┌─────────────────────────────────────────────────────────────────┐
│ 1. CHEGADA & EMISSÃO (Recepção)                                │
├──────────────────────────────────────────────────────────────────┤
  → Paciente chega e pega senha (TOTEM ou RECEPCAO)
     ↓
  CALL sp_senha_emitir(
     p_tipo_atendimento = 'CLINICO'|'PEDIATRICO'|'PRIORITARIO'|'EMERGENCIA',
     p_origem = 'TOTEM'|'RECEPCAO'|'ADMIN'|'SAMU',
     out p_id_senha, out p_codigo  ← Senha gerada (ex: A001)
  )
     ↓
  Senha criada: status = GERADA → AGUARDANDO
  Registra em fila_senha (recepção/painel pública)
│
├──────────────────────────────────────────────────────────────────┤
│ 2. CHAMADA & COMPLEMENTAÇÃO (Recepção)                          │
├──────────────────────────────────────────────────────────────────┤
  → Operador chama: status AGUARDANDO → CHAMANDO
     ↓
  CALL sp_senha_chamar_proxima(
     p_id_local_operacional = REC01,
     p_lane = 'ADULTO'|'PEDIATRICO'|'PRIORITARIO'|NULL,
     out p_id_senha, out p_codigo
  )
     ↓
  Inicia chamada: status = CHAMANDO (painel grita)
     ↓
  Operador abre complementação:
  CALL sp_recepcao_iniciar_complementacao(p_id_senha)
     ↓
  Status = EM_COMPLEMENTACAO (operador coleta dados)
     ↓
  Operador submete dados (nome, CPF, CNS, data_nascimento, etc):
  CALL sp_recepcao_complementar_e_abrir_ffa(
     p_id_senha,
     p_nome_completo, p_cpf, p_cns, p_data_nascimento, p_sexo,
     p_email, p_telefone,
     p_logradouro, p_numero, p_complemento, p_bairro, p_cidade, p_uf,
     out p_id_pessoa, out p_id_paciente, out p_id_atendimento, 
     out p_id_ffa, out p_gpat
  )
     ↓
  Operações:
  - Encuentra pessoa por CPF/CNS (merge se existe)
  - Cria/atualiza paciente
  - Cria atendimento (protocolo = GPAT)
  - Cria FFA (documento primário)
  - Atualiza senha: status = ENCAMINHADO
     ↓
  Status final: FFA ABERTO, pronto para triagem
│
├──────────────────────────────────────────────────────────────────┤
│ 3. ENCAMINHAMENTO (Recepção → Triagem)                          │
├──────────────────────────────────────────────────────────────────┤
  → Operador encaminha para triagem:
     ↓
  CALL sp_recepcao_encaminhar_ffa(p_id_ffa)
     ↓
  Cria fila_operacional:
  - tipo = TRIAGEM
  - substatus = AGUARDANDO
  - id_ffa = paciente
  - id_local_operacional = TRI01 (local triagem)
     ↓
  FFA status = EM_TRIAGEM
│
└──────────────────────────────────────────────────────────────────┘
```

### 2️⃣ FLUXO: TRIAGEM → AVALIAÇÃO INICIAL

```
┌──────────────────────────────────────────────────────────────────┐
│ 4. TRIAGEM (Enfermeiro)                                         │
├──────────────────────────────────────────────────────────────────┤
  → Enfermeiro chama de triagem:
     ↓
  CALL sp_triagem_chamar(p_id_local_operacional = TRI01)
     ↓
  Seleciona próxima fila_operacional com tipo=TRIAGEM
  Status = AQUARDANDO → CHAMANDO
  Senha status = CHAMANDO (painel grita "TRIAGEM")
     ↓
  Enfermeiro coleta dados:
  - Sinais vitais (PA, FC, FR, Temp, O2, HGT)
  - Queixa principal
  - Classificação Manchester (VERMELHO/LARANJA/AMARELO/VERDE/AZUL)
     ↓
  INSERT triagem:
  - id_atendimento, id_risco, queixa, sinais_vitais JSON
  
  UPDATE ffa: status = AGUARDANDO_CHAMADA_MEDICO
  UPDATE fila_operacional (TRIAGEM): substatus = FINALIZADO
│
└──────────────────────────────────────────────────────────────────┘
```

### 3️⃣ FLUXO: CONSULTA MÉDICA → PRESCRIÇÃO

```
┌──────────────────────────────────────────────────────────────────┐
│ 5. CONSULTÓRIO MÉDICO (Médico)                                  │
├──────────────────────────────────────────────────────────────────┤
  → Médico chama para consulta:
     ↓
  CALL sp_medico_chamar(p_id_local_operacional = MEDC1)
     ↓
  Seleciona próxima fila_operacional com tipo=MEDICO
  Status AGUARDANDO → CHAMANDO
  Senha status = CHAMANDO
     ↓
  Médico examina:
  - Exame físico (estado geral, nível consciência, etc)
  - Prescreve: medicamentos, exames (RX, Lab), procedimentos
  - Registra diagnóstico (CID-10)
     ↓
  INSERT atendimento_evolucao (notas médicas)
  INSERT atendimento_exame_fisico
  INSERT atendimento_diagnosticos (CID)
  INSERT atendimento_prescricao (medicamentos)
  INSERT atendimento_pedidos_exame (requisição Lab/RX)
     ↓
  Médico encaminha:
  - Se medicação urgente → MEDICACAO
  - Se RX → RX
  - Se Lab → COLETA
  - Se procedimento → PROCEDIMENTO
  - Se repouso → OBSERVACAO
     ↓
  CALL sp_medico_encaminhar(
     p_id_ffa,
     p_id_local_operacional_destino = MED01 (próx local)
  )
     ↓
  Cria nova fila_operacional para próximo setor
  FFA status = AGUARDANDO_RX | AGUARDANDO_COLETA | ...
│
└──────────────────────────────────────────────────────────────────┘
```

### 4️⃣ FLUXO: FARMÁCIA (MEDICAÇÃO URGENTE)

```
┌──────────────────────────────────────────────────────────────────┐
│ 6. SETOR MEDICAÇÃO (Farm + Enfermeiro)                          │
├──────────────────────────────────────────────────────────────────┤
  → FFA encaminhado para MEDICACAO
  → Fila_operacional criada: tipo = MEDICACAO, substatus = AGUARDANDO
     ↓
  Trabalho N1: Farmacêutico prepara (seleciona lote, valida posologia)
  - Confere:  prescrição → medicamento → lote (validade)
  - INSERT dispensacao_medicacao (saída de estoque)
  - UPDATE estoque_almoxarifado_central: quantidade -= quantidadeDispensada
     ↓
  Trabalho N2: Enfermeiro administra
  - Insert administracao_medicacao (data/hora, dose, via[IV/IM/VO])
  - Dupla conferência (enfermeiro + técnico)
     ↓
  CALL sp_medicacao_marcar_executado(p_id_fila)
     ↓
  Fila_operacional: substatus = FINALIZADO
  FFA pronta para próximo setor ou alta
│
└──────────────────────────────────────────────────────────────────┘
```

### 5️⃣ FLUXO: ALTA / DESFECHO

```
┌──────────────────────────────────────────────────────────────────┐
│ 7. DESFECHO/ALTA (Médico)                                       │
├──────────────────────────────────────────────────────────────────┤
  → Após exames/tratamentos concluídos:
     ↓
  Médico registra desfecho:
  INSERT atendimento_desfecho:
  - tipo_desfecho = ALTA_MEDICA | ALTA_A_PEDIDO | TRANSFERENCIA | OBITO
  - motivo, destino (se transferência)
     ↓
  Se ALTA normal:
  - INSERT atendimento_sumario_alta (resumo clínico)
  - INSERT documento_emissao (receita, atestado, etc)
     ↓
  FFA status = FINALIZADO
  Senha status = FINALIZADO
     ↓
  Paciente segue com receitas + encaminhamentos
│
└──────────────────────────────────────────────────────────────────┘
```

### 6️⃣ FLUXO: NÃO COMPARECIMENTO & RETORNO

```
┌──────────────────────────────────────────────────────────────────┐
│ 8. NÃO COMPARECIMENTO (Qualquer setor)                          │
├──────────────────────────────────────────────────────────────────┤
  → Paciente não responde chamado:
     ↓
  CALL sp_recepcao_nao_compareceu(
     p_id_senha,
     p_janela_minutos = 60 (padrão)
  )
     ↓
  UPDATE senhas:
  - status = NAO_COMPARECEU
  - retorno_permitido_ate = NOW() + 60 min
  - retorno_utilizado = 0 (ainda não usou)
     ↓
  Paciente pode retornar em até 60 min sem nova senha
│
├──────────────────────────────────────────────────────────────────┤
│ 9. RETORNO NA JANELA                                            │
├──────────────────────────────────────────────────────────────────┤
  → Paciente volta em tempo:
     ↓
  CALL sp_senha_retorno_reinserir(
     p_id_senha,
     p_janela_retorno_min = 60,
     out p_id_senha_result, out p_codigo_result
  )
     ↓
  Se dentro da janela (retorno_permitido_ate >= NOW()):
    UPDATE senhas: status = AGUARDANDO, posicionado_em = NOW()
    Reinserir ao fim da fila
  Se expirado:
    UPDATE senhas (velha): status = FINALIZADA
    CALL sp_senha_emitir (nova senha)
│
└──────────────────────────────────────────────────────────────────┘
```

---

## 📊 ESTRUTURA DE DADOS COMPLEMENTAR

### Tabelas de Auditoria (Padrão em todas operações):

Toda operação registra em:
1. **auditoria_evento** - Log de negócio (entidade, ação, detalhe)
2. **senha_eventos** - Histórico de transição de estado
3. **fila_operacional_evento** - Histórico de fila
4. **log_auditoria** - Log geral

**Padrão de chamada (em todo SP):**
```sql
CALL sp_auditoria_evento_registrar(
    p_id_sessao_usuario,
    'ENTIDADE',           -- ex: 'SENHA', 'FFA', 'FILA_OPERACIONAL'
    p_id_entidade,        -- id do registro
    'ACAO',               -- ex: 'CHAMAR', 'ENCAMINHAR', 'FINALIZAR'
    'contexto/detalhe',   -- informações
    NULL,                 -- valor anterior (JSON)
    'tabela',             -- nome técnico
    NULL                  -- id_usuario_espelho
);
```

---

## 📈 MÉTRICAS DO BANCO

| Métrica | Valor |
|---------|-------|
| **Total de Tabelas** | 122+ |
| **Total de Stored Procedures** | 80+ |
| **Total de Functions** | ~30 |
| **Total de Views** | ~5 |
| **Campos de Total** | ~2000+ |
| **Índices** | ~180+ |
| **Foreign Keys** | ~150+ |
| **Enums (Tipos)** | ~35+ |

---

## 🎯 PRÓXIMOS PASSOS PARA DESENVOLVIMENTO

### Backend (API):
1. Implementar endpoints REST para login/sessão
2. CRUD operations para main entities (paciente, atendimento, ffa)
3. Integração com Procedures via prepared statements
4. Validações de permissão (RBAC)
5. Error handling e mapeamento de exceções SQL

### Frontend (Web/Mobile):
1. Telas de Recepção (emissão de senha, chamada)
2. Telas de Triagem (sinais vitais, classificação risco)
3. Telas de Médico (consulta, prescrição, encaminhamento)
4. Telas de Farmácia (dispensação, administração)
5. Painéis de Monitoramento (Público/Operacional)
6. Dashboard de Métricas

### Integrations:
1. SINAN (notificações epidemiológicas)
2. CAT (acidentes do trabalho)
3. HL7/FHIR (laboratorial eletrônico)
4. Payment gateways (faturamento)

---

## 📝 NOTAS FINAIS

- **Versionamento:** Banco usa master data com competências (CID-10 v2024, CNES, SIGTAP)
- **Compliance:** LGPD implementado via `auditoria_visualizacao_prontuario`
- **Performance:** Índices em força relações críticas, denormalização seletiva (id_usuario_espelho)
- **Escalabilidade:** Partidas por data em tabelas de eventos (timestamp clustering)
- **Security:** Senhas hasheadas (bcrypt/SHA256), RBAC via perfil
- **Concorrência:** Locks pessimistas (FOR UPDATE) em operações críticas

---

**Documento gerado:** 2026-02-20
**Status:** COMPLETO - Pronto para Implementação Frontend & Backend
