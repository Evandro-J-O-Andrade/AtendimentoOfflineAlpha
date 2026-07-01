# atendimento_diagnostico

Objetivo: Registrar diagnósticos médicos associados a atendimentos, controlando o código CID, descrição e identificação do diagnóstico principal.

Descrição: Esta tabela armazena os diagnósticos médicos realizados durante atendimentos, permitindo o vínculo ao CID (Classificação Internacional de Doenças), descrição detalhada, e identificação do diagnóstico principal entre múltiplos registrados.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_diagnostico | bigint unsigned | NOT NULL | AUTO_INCREMENT | Identificador único do diagnóstico no atendimento |
| id_atendimento | bigint unsigned | NOT NULL | - | Chave estrangeira que referencia o atendimento ao qual o diagnóstico pertence |
| codigo_cid | varchar(10) | NOT NULL | - | Código CID do diagnóstico (Classificação Internacional de Doenças) |
| descricao | varchar(255) | YES | NULL | Descrição textual do diagnóstico |
| principal | tinyint(1) | YES | '0' | Flag que indica se este é o diagnóstico principal (1) ou secundário (0) |
| criado_em | datetime(6) | NOT NULL | CURRENT_TIMESTAMP(6) | Timestamp automático da data/hora de criação do diagnóstico |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |

## Chaves
- Primária: id_diagnostico
- Únicas: Nenhuma
- Estrangeiras: fk_atendimento_diagnostico_atendimento - id_atendimento → atendimento(id_atendimento) - Vincula o diagnóstico ao atendimento; fk_atendimento_diagnostico_entidade - id_entidade → saas_entidade(id_entidade) - Vincula o diagnóstico à entidade; fk_diagnostico_atendimento - id_atendimento → atendimento(id_atendimento) - Vincula o diagnóstico ao atendimento (constraint duplicada) |

## Índices
- idx_diag_atendimento (KEY) - Índice para busca por atendimento
- idx_adiag_ent (KEY) - Índice para busca por entidade

## Constraints
- fk_atendimento_diagnostico_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento) com CASCADE
- fk_atendimento_diagnostico_entidade - FOREIGN KEY - Restringe id_entidade à tabela saas_entidade(id_entidade)
- fk_diagnostico_atendimento - FOREIGN KEY - Restringe id_atendimento à tabela atendimento(id_atendimento)

## Relacionamentos e Cardinalidade
- N:1 com atendimento - Cada diagnóstico está associado a um atendimento (várias constraints)
- N:1 com saas_entidade - Cada diagnóstico pertence a uma entidade SaaS

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para atendimento_diagnostico)
- Tabelas das quais esta depende: atendimento, saas_entidade

## Fluxo de utilização dentro do sistema
- Registro de diagnósticos médicos durante o atendimento
- Vínculo ao código CID para padronização de classificação
- Identificação do diagnóstico principal via campo principal
- Descrição livre para complementar informações do diagnóstico
- Timestamp automático de criação para auditoria
- Múltiplas constraints FK apontando para atendimento (arquitetura redundante para integridade)