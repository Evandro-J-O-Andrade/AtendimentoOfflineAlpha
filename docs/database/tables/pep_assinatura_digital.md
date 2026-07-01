# pep_assinatura_digital

Objetivo: Armazenar assinaturas digitais de documentos do atendimento.
Descrição: Tabela que registra assinaturas digitais de documentos clínicos do atendimento, permitindo validação de autenticidade e integridade dos documentos.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador único da assinatura (chave primária, auto incremento) |
| id_atendimento | bigint | NOT NULL | - | ID do atendimento ao qual o documento está vinculado |
| hash_conteudo | varchar(255) | NOT NULL | - | Hash do conteúdo do documento para verificação de integridade |
| assinatura_base64 | text | YES | NULL | Assinatura digital codificada em Base64 |
| data_assinatura | datetime | YES | CURRENT_TIMESTAMP | Data/hora em que a assinatura foi realizada |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual a assinatura pertence |

## Chaves
- Primária: id
- Únicas: (nenhuma)
- Estrangeiras: (nenhuma foreign key explícita)

## Índices
- PRIMARY KEY (id)
- KEY idx_pep_assinatura (id_atendimento)

## Constraints
- PRIMARY KEY: id

## Relacionamentos e Cardinalidade
- N:1 com atendimento: Muitas assinaturas podem estar vinculadas a um atendimento

## Dependências
- Esta tabela depende de: saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para registrar assinaturas digitais de documentos clínicos. Antes de assinar, o conteúdo é hashado e armazenado. A assinatura em Base64 permite validar que o documento não foi alterado desde sua assinatura. Permite compliance com normas de segurança de documentos médicos.