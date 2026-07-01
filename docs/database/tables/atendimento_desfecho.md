# atendimento_desfecho

Objetivo: Registrar o desfecho do atendimento médico, controlando o tipo de desfecho, observações e auditoria completa do encerramento.

Descrição: Esta tabela armazena informações sobre como o atendimento médico foi encerrado, permitindo o registro do tipo de desfecho (alta, transferência, óbito, remoção), observações e controle de timestamp de criação e atualização.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_desfecho | bigint unsigned | NOT NULL | AUTO_INCREMENT | Identificador único do desfecho do atendimento |
| id_atendimento | bigint unsigned | NOT NULL | - | Chave estrangeira que referencia o atendimento ao qual o desfecho pertence |
| tipo_desfecho | enum('ALTA','TRANSFERENCIA','OBITO','REMOCAO','CONVENIO') | NOT NULL | - | Tipo de desfecho: alta, transferência, óbito, remoção ou convênio |
| observacao | text | YES | NULL | Campo de texto livre para observações sobre o desfecho |
| criado_em | datetime(6) | NOT NULL | CURRENT_TIMESTAMP(6) | Timestamp automático da data/hora de criação do desfecho |
| atualizado_em | datetime(6) | YES | NULL ON UPDATE CURRENT_TIMESTAMP(6) | Timestamp automático de atualização do desfecho |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |

## Chaves
- Primária: id_desfecho
- Únicas: Nenhuma
- Estrangeiras: fk_atendimento_desfecho_atendimento - id_atendimento → atendimento(id_atendimento) - Vincula o desfecho ao atendimento; fk_atendimento_desfecho_entidade - id_entidade → saas_entidade(id_entidade) - Vincula o desfecho à entidade; fk_desfecho_atendimento - id_atendimento → atendimento(id_atendimento) - Vincula o desfecho ao atendimento (constraint duplicada) |

## Índices
- idx_desfecho_atendimento (KEY) - Índice para busca por atendimento
- idx_adesf_ent (KEY) - Índice para busca por entidade

## Constraints
- fk_atendimento_desfecho_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com CASCADE
- fk_atendimento_desfecho_entidade - FOREIGN KEY - Restringe id_entidade à tabela saas_entidade(id_entidade)
- fk_desfecho_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento)

## Relacionamentos e Cardinalidade
- N:1 com atendimento - Cada desfecho está associado a um atendimento (várias constraints)
- N:1 com saas_entidade - Cada desfecho pertence a uma entidade SaaS

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para atendimento_desfecho)
- Tabelas das quais esta depende: atendimento, saas_entidade

## Fluxo de utilização dentro do sistema
- Registro do desfecho ao finalizar o atendimento
- Tipos de desfecho diferenciados (alta, transferência, óbito, etc.)
- Observações para detalhar o motivo ou circunstâncias do desfecho
- Timestamp automático de criação e atualização
- Vinculação ao atendimento para contexto completo
- Múltiplas constraints FK apontando para atendimento (arquitetura redundante para integridade)