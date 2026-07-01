# assinatura_digital_documentos

Objetivo: Registrar assinaturas digitais de documentos clínicos emitidos durante atendimentos, armazenando hash da assinatura e informações do certificado digital.

Descrição: Esta tabela controla a assinatura digital de documentos clínicos como evoluções, receitas, laudos e altas, permitindo a verificação de autenticidade e integridade dos documentos emitidos no sistema.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id | bigint | NOT NULL | AUTO_INCREMENT | Identificador único do registro de assinatura digital |
| id_registro_clinico | bigint | NOT NULL | - | Identificador do registro clínico ao qual o documento pertence |
| tipo_documento | enum('EVOLUCAO','RECEITA','LAUDO','ALTA') | YES | NULL | Tipo de documento clínico assinado: evolução, receita, laudo ou alta |
| hash_assinatura | text | NOT NULL | - | Hash criptográfico da assinatura digital para verificação de autenticidade |
| certificado_serial | varchar(100) | YES | NULL | Número serial do certificado digital utilizado na assinatura |
| data_assinatura | datetime | YES | CURRENT_TIMESTAMP | Timestamp automático da data/hora em que a assinatura foi realizada |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade (organização/unidade) à qual o registro pertence |

## Chaves
- Primária: id
- Únicas: Nenhuma
- Estrangeiras: Nenhuma

## Índices
- Nenhum índice adicional definido

## Constraints
- Nenhuma constraint adicional definida

## Relacionamentos e Cardinalidade
- Esta tabela não possui relacionamentos com outras tabelas via foreign key

## Dependências
- Tabelas que dependem desta: Nenhuma (não há FK apontando para assinatura_digital_documentos)
- Tabelas das quais esta depende: Nenhuma

## Fluxo de utilização dentro do sistema
- Registro de assinaturas digitais em documentos clínicos
- Armazenamento do hash para verificação de integridade e autenticidade
- Rastreio do certificado digital utilizado via serial
- Timestamp automático para auditoria de quando o documento foi assinado
- Suporte a diferentes tipos de documentos clínicos (evolução, receita, laudo, alta)