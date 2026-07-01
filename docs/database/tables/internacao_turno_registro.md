# internacao_turno_registro

Objetivo: Registrar informações gerais de cada turno de trabalho durante internações hospitalares.
Descrição: Tabela que documenta os registros realizados ao final de cada turno (manhã, tarde, noite) de uma internação, permitindo o acompanhamento do cuidado ao paciente entre as trocas de plantonistas. Cada registro contém observações gerais sobre o estado do paciente no turno.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| `id_internacao_turno_registro` | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do registro de turno de internação |
| `id_internacao` | bigint | NOT NULL | - | Referência à internação à qual o registro pertence |
| `data_referencia` | date | NOT NULL | - | Data de referência do turno |
| `turno` | enum('MANHA','TARDE','NOITE') | NOT NULL | - | Turno do registro: MANHA, TARDE ou NOITE |
| `observacoes_gerais` | text | NULL | NULL | Observações gerais sobre o turno e o estado do paciente |
| `id_usuario_responsavel` | bigint | NOT NULL | - | Usuário responsável por realizar o registro do turno |
| `id_sessao_usuario` | bigint | NULL | NULL | Sessão do usuário que realizou o registro |
| `criado_em` | datetime | NOT NULL | CURRENT_TIMESTAMP | Timestamp de criação do registro |
| `atualizado_em` | datetime | NULL | NULL ON UPDATE CURRENT_TIMESTAMP | Timestamp da última atualização |
| `id_atendimento` | bigint unsigned | NOT NULL | - | Referência ao atendimento hospitalar |
| `id_entidade` | bigint unsigned | NOT NULL | - | Referência à entidade proprietária do registro |

## Chaves
- Primária: `id_internacao_turno_registro`
- Únicas: -
- Estrangeiras: 
  - `fk_internacao_turno_registro_atendimento` (`id_atendimento`) → `atendimento` (`id_atendimento`) - Relaciona o registro ao atendimento; exclui em cascata e atualiza em cascata
  - `fk_internacao_turno_registro_entidade` (`id_entidade`) → `saas_entidade` (`id_entidade`) - Vincula o registro à entidade proprietária
  - `fk_itr_internacao` (`id_internacao`) → `internacao` (`id_internacao`) - Relaciona o registro à internação
  - `fk_itr_usuario` (`id_usuario_responsavel`) → `usuario` (`id_usuario`) - Identifica o usuário responsável

## Índices
- `idx_itr_internacao` (KEY) - Índice na coluna `id_internacao`
- `idx_itr_data_turno` (KEY) - Índice composto em `data_referencia` e `turno`
- `idx_itr_criado_em` (KEY) - Índice na coluna `criado_em`
- `idx_itr_usuario` (KEY) - Índice na coluna `id_usuario_responsavel`
- `fk_itr_sessao` (KEY) - Índice na coluna `id_sessao_usuario`
- `fk_internacao_turno_registro_atendimento` (KEY) - Índice na coluna `id_atendimento`
- `idx_int_turno_ent` (KEY) - Índice na coluna `id_entidade`

## Constraints
- `fk_internacao_turno_registro_atendimento` FOREIGN KEY - Relaciona `id_atendimento` com `atendimento`.`id_atendimento` (ON DELETE CASCADE ON UPDATE CASCADE)
- `fk_internacao_turno_registro_entidade` FOREIGN KEY - Relaciona `id_entidade` com `saas_entidade`.`id_entidade`
- `fk_itr_internacao` FOREIGN KEY - Relaciona `id_internacao` com `internacao`.`id_internacao`
- `fk_itr_usuario` FOREIGN KEY - Relaciona `id_usuario_responsavel` com `usuario`.`id_usuario`

## Relacionamentos e Cardinalidade
- N:1 com `internacao` - Muitos registros de turno pertencem a uma internação
- N:1 com `atendimento` - Muitos registros de turno estão associados a um atendimento
- N:1 com `usuario` - Muitos registros podem ser criados pelo mesmo usuário
- N:1 com `sessao_usuario` - Muitos registros podem estar associados a uma sessão
- N:1 com `saas_entidade` - Muitos registros pertencem a uma entidade

## Dependências
- Esta tabela é referenciada por: (não possui FK apontando para ela)
- Esta tabela depende de: `internacao`, `atendimento`, `usuario`, `sessao_usuario`, `saas_entidade`

## Fluxo de utilização dentro do sistema
1. Ao final de cada turno (manhã, tarde, noite), o profissional de saúde registra informações sobre o paciente internado
2. O registro é vinculado à internação, ao atendimento e ao usuário responsável
3. As observações gerais são passadas para o próximo plantonista
4. Permite a continuidade do cuidado ao paciente entre as trocas de equipe
5. Usado para auditoria e responsabilidade no atendimento de enfermagem