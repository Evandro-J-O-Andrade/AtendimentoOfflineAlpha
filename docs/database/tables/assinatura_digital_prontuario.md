# assinatura_digital_prontuario

Objetivo: Registrar assinaturas digitais de evoluções no prontuário do paciente, garantindo autenticidade e integridade das notas clínicas.

Descrição: Esta tabela armazena as assinaturas digitais das evoluções clínicas no prontuário do paciente, vinculando o hash da assinatura ao registro de evolução, ao usuário responsável e ao certificado digital utilizado.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do registro de assinatura digital |
| id_ffa_evolucao | bigint | NOT NULL | - | Chave estrangeira que referencia a evolução do atendimento (FK para atendimento_evolucao) |
| hash_assinatura | text | NOT NULL | - | Hash criptográfico da assinatura digital para verificação de autenticidade |
| certificado_serial | varchar(255) | YES | NULL | Número serial do certificado digital utilizado na assinatura |
| data_assinatura | datetime | YES | CURRENT_TIMESTAMP | Timestamp automático da data/hora em que a assinatura foi realizada |
| id_usuario | bigint | NOT NULL | - | Chave estrangeira que referencia o usuário que realizou a assinatura |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |

## Chaves
- Primária: id
- Únicas: Nenhuma
- Estrangeiras: fk_ass_digital_evolucao - id_ffa_evolucao → atendimento_evolucao(id) ON DELETE CASCADE - Vincula a assinatura à evolução; fk_ass_digital_usuario - id_usuario → usuario(id_usuario) - Vincula a assinatura ao usuário

## Índices
- idx_ass_evolucao (KEY) - Índice para busca por evolução
- idx_ass_usuario (KEY) - Índice para busca por usuário

## Constraints
- fk_ass_digital_evolucao - FOREIGN KEY - Restringe id_ffa_evolucao à tabela atendimento_evolucao(id) com CASCADE DELETE
- fk_ass_digital_usuario - FOREIGN KEY - Restringe id_usuario à tabela usuario(id_usuario)

## Relacionamentos e Cardinalidade
- N:1 com atendimento_evolucao - Cada assinatura está vinculada a uma evolução específica (com CASCADE DELETE)
- N:1 com usuario - Cada assinatura é realizada por um único usuário

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para assinatura_digital_prontuario)
- Tabelas das quais esta depende: atendimento_evolucao, usuario

## Fluxo de utilização dentro do sistema
- Registro de assinatura digital a cada evolução clínica no prontuário
- Vinculação à evolução para rastreio de autenticidade
- Armazenamento do hash para verificação de integridade do documento
- Rastreio do certificado digital utilizado via serial
- Timestamp automático para auditoria
- Cascade delete remove assinaturas quando evolução é excluída