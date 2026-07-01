# internacao_registro_enfermagem

Objetivo: Registrar as atividades de enfermagem realizadas durante internações, incluindo avaliações de sinais vitais e demais procedimentos de enfermagem.
Descrição: Tabela que documenta o registro de enfermagem realizado em pacientes internados, capturando dados clínicos como pressão arterial, temperatura, frequências cardíaca e respiratória, saturação de O2, glicemia, balanço hídrico e observações. Cada registro está associado a um turno específico (manhã, tarde, noite, indefinido) e periodicidade de avaliação.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_internacao_registro_enfermagem` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do registro de enfermagem |
| `id_internacao` | bigint | NOT NULL | - | Referência à internação à qual o registro pertence |
| `data_hora` | datetime | NOT NULL | CURRENT_TIMESTAMP | Data e hora do registro de enfermagem |
| `turno` | enum('MANHA','TARDE','NOITE','INDEFINIDO') | NOT NULL | 'INDEFINIDO' | Turno em que o registro foi realizado |
| `periodicidade` | enum('2H','4H','6H','TURNO','EVENTUAL') | NOT NULL | 'EVENTUAL' | Periodicidade da avaliação de enfermagem |
| `pressao_arterial` | varchar(10) | NULL | NULL | Medida da pressão arterial (formato texto para capturar valores como "120/80") |
| `temperatura` | decimal(4,1) | NULL | NULL | Temperatura corporal em graus Celsius |
| `frequencia_cardiaca` | int | NULL | NULL | Frequência cardíaca em batimentos por minuto |
| `frequencia_respiratoria` | int | NULL | NULL | Frequência respiratória em respirações por minuto |
| `saturacao_o2` | int | NULL | NULL | Saturação de oxigênio em percentual |
| `glicemia` | int | NULL | NULL | Nível de glicemia em mg/dL |
| `entradas_ml` | int | NULL | NULL | Volume total de entradas hídricas em mililitros |
| `saidas_ml` | int | NULL | NULL | Volume total de saídas hídricas em mililitros |
| `diurese_evacuacao` | text | NULL | NULL | Registro de diurese e evacuações |
| `observacoes` | text | NULL | NULL | Observações complementares sobre o registro |
| `id_usuario_responsavel` | bigint | NOT NULL | - | Usuário que realizou o registro de enfermagem |
| `id_sessao_usuario` | bigint | NULL | NULL | Sessão do usuário que realizou o registro |
| `criado_em` | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp de criação do registro |
| `id_atendimento` | bigint unsigned | NOT NULL | - | Referência ao atendimento hospitalar |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária do registro |

## Chaves
- Primária: `id_internacao_registro_enfermagem`
- Únicas: -
- Estrangeiras: 
  - `fk_internacao_registro_enfermagem_atendimento` (`id_atendimento`) → `atendimento` (`id_atendimento`) - Relaciona o registro ao atendimento; exclui em cascata e atualiza em cascata
  - `fk_internacao_registro_enfermagem_entidade` (`id_entidade`) → `saas_entidade` (`id_entidade`) - Vincula o registro à entidade proprietária
  - `fk_ire_internacao` (`id_internacao`) → `internacao` (`id_internacao`) - Relaciona o registro à internação
  - `fk_ire_usuario` (`id_usuario_responsavel`) → `usuario` (`id_usuario`) - Identifica o usuário responsável pelo registro

## Índices
- `idx_ire_internacao` (KEY) - Índice na coluna `id_internacao`
- `idx_ire_data_hora` (KEY) - Índice na coluna `data_hora`
- `idx_ire_usuario` (KEY) - Índice na coluna `id_usuario_responsavel`
- `idx_ire_sessao` (KEY) - Índice na coluna `id_sessao_usuario`
- `fk_internacao_registro_enfermagem_atendimento` (KEY) - Índice na coluna `id_atendimento`
- `idx_int_regenf_ent` (KEY) - Índice na coluna `id_entidade`

## Constraints
- `fk_internacao_registro_enfermagem_atendimento` FOREIGN KEY - Relaciona `id_atendimento` com `atendimento`.`id_atendimento` (ON DELETE CASCADE ON UPDATE CASCADE)
- `fk_internacao_registro_enfermagem_entidade` FOREIGN KEY - Relaciona `id_entidade` com `saas_entidade`.`id_entidade`
- `fk_ire_internacao` FOREIGN KEY - Relaciona `id_internacao` com `internacao`.`id_internacao`
- `fk_ire_usuario` FOREIGN KEY - Relaciona `id_usuario_responsavel` com `usuario`.`id_usuario`

## Relacionamentos e Cardinalidade
- N:1 com `internacao` - Muitos registros de enfermagem pertencem a uma internação
- N:1 com `atendimento` - Muitos registros de enfermagem estão associados a um atendimento
- N:1 com `usuario` - Muitos registros podem ser criados pelo mesmo usuário (via `id_usuario_responsavel`)
- N:1 com `sessao_usuario` - Muitos registros podem estar associados a uma sessão
- N:1 com `saas_entidade` - Muitos registros pertencem a uma entidade

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `internacao`, `atendimento`, `usuario`, `sessao_usuario`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Durante a internação, o enfermeiro realiza avaliações periódicas dos sinais vitais do paciente
2. Cada registro é classificado por turno e periodicidade
3. Os dados de sinais vitais são armazenados para acompanhamento clínico
4. O balanço hídrico (entradas/saídas) é documentado para controle de fluids
5. O registro é vinculado ao atendimento e à internação para rastreabilidade
6. Usado para emissão de relatórios de evolução e monitoramento de pacientes