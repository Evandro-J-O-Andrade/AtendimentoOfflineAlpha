# atendimento_prescricao

Objetivo: Registrar prescrições médicas durante atendimentos, controlando medicamento, posologia, via de administração e auditoria completa.

Descrição: Esta tabela armazena as prescrições médicas realizadas durante atendimentos, permitindo o registro do medicamento, posologia, via de administração, com auditoria completa de IP, dispositivo e sessão do usuário.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | bigint | NOT NULL | AUTO_INCREMENT | Identificador único da prescrição |
| id_unidade | bigint unsigned | NOT NULL | - | Identificador da unidade onde a prescrição foi realizada |
| id_ffa | bigint | NOT NULL | - | Identificador da FFA (Ficha de Atendimento) ao qual a prescrição pertence |
| id_usuario | bigint | NOT NULL | - | Identificador do usuário (médico) que realizou a prescrição |
| id_sessao_usuario | bigint | NOT NULL | - | Identificador da sessão do usuário no momento da prescrição |
| medicamento | varchar(255) | NOT NULL | - | Nome do medicamento prescrito |
| posologia | text | YES | NULL | Instruções de posologia (dose, frequência, duração) |
| via_administracao | varchar(50) | YES | NULL | Via de administração do medicamento (oral, IV, IM, SC, etc.) |
| ip_origem | varchar(45) | YES | NULL | Endereço IP de origem da requisição |
| device_info | varchar(255) | YES | NULL | Informações do dispositivo utilizado na prescrição |
| criado_em | datetime(6) | YES | NULL | Timestamp da data/hora de criação da prescrição |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |
| id_atendimento | bigint unsigned | NOT NULL | - | Chave estrangeira que referencia o atendimento ao qual a prescrição pertence |

## Chaves
- Primária: id
- Únicas: Nenhuma
- Estrangeiras: fk_apresc_unid - id_unidade → unidade(id_unidade) - Vincula a prescrição à unidade; fk_atendimento_prescricao_atendimento - id_atendimento → atendimento(id_atendimento) - Vincula a prescrição ao atendimento; fk_atendimento_prescricao_entidade - id_entidade → saas_entidade(id_entidade) - Vincula a prescrição à entidade |

## Índices
- fk_atendimento_prescricao_atendimento (KEY) - Índice para busca por atendimento
- fk_apresc_unid (KEY) - Índice para busca por unidade
- fk_atendimento_prescricao_entidade (KEY) - Índice para busca por entidade

## Constraints
- fk_apresc_unid - FOREIGN KEY - Restringe id_unidade à tabela unidade(id_unidade)
- fk_atendimento_prescricao_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com CASCADE
- fk_atendimento_prescricao_entidade - FOREIGN KEY - Restringe id_entidade à tabela saas_entidade(id_entidade)

## Relacionamentos e Cardinalidade
- N:1 com unidade - Cada prescrição está associada a uma unidade
- N:1 com atendimento - Cada prescrição está associada a um atendimento (com CASCADE)
- N:1 com saas_entidade - Cada prescrição pertence a uma entidade SaaS
- N:1 com usuario - Cada prescrição é realizada por um usuário
- N:1 com sessao_usuario - Cada prescrição tem uma sessão associada

## Dependências
- Tabelas que dependem desta: atendimento_checagem (via id_prescricao), administracao_medicacao_ordem (via id_item indiretamente)
- Tabelas das quais esta depende: unidade, atendimento, saas_entidade, usuario, sessao_usuario

## Fluxo de utilização dentro do sistema
- Registro de prescrições médicas durante atendimento
- Medicamento e posologia para orientação de medicação
- Via de administração para instruções de enfermeiros
- Auditoria completa com IP, dispositivo e sessão
- Checagem de administração via atendimento_checagem
- Cascade delete remove prescrições quando atendimento é excluído