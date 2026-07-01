# rh_registro_profissional

Objetivo: Armazenar registros profissionais vinculados a vínculos de pessoas no RH, com controle de conselhos, validade e status.

Descrição: Tabela que mantém os registros profissionais (inscrições em conselhos) vinculados aos vínculos de pessoas no RH, permitindo diferentes tipos de conselho (CRM, COREN, CRF, etc.) e controle de validade.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_registro | bigint | NOT NULL | - | Chave primária da tabela, identificador único do registro profissional |
| id_pessoa | bigint | NOT NULL | - | Referência ao id da pessoa ao qual o registro está vinculado |
| conselho | enum('CRM','COREN','CRF','CRO','CREFITO','CRP','CRN','OUTRO') | NOT NULL | 'OUTRO' | Tipo do conselho: CRM, COREN, CRF, CRO, CREFITO, CRP, CRN ou OUTRO |
| numero | varchar(30) | NOT NULL | - | Número do registro no conselho profissional |
| uf | char(2) | YES | NULL | Unidade federativa da inscrição do conselho |
| uf_norm | char(2) | - | - | Campo gerado (generated) normalizado com UF ou '--' se nulo |
| especialidade | varchar(120) | YES | NULL | Especialidade do profissional registrado |
| validade | date | YES | NULL | Data de validade/renovação do registro profissional |
| status | enum('ATIVO','INATIVO','SUSPENSO') | NOT NULL | 'ATIVO' | Status do registro: ATIVO, INATIVO ou SUSPENSO |
| origem | enum('MANUAL','RH','IMPORTADO','INTEGRACAO') | NOT NULL | 'MANUAL' | Origem do cadastro: MANUAL, RH, IMPORTADO ou INTEGRACAO |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| atualizado_em | datetime | YES | NULL | Data e hora da última atualização do registro |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o registro é mantido |

## Chaves
- Primária: id_registro
- Únicas: uk_registro (conselho, numero, uf_norm)
- Estrangeiras: -

## Índices
- PRIMARY KEY (id_registro)
- UNIQUE KEY uk_registro (conselho, numero, uf_norm)
- KEY ix_registro_pessoa (id_pessoa)
- KEY ix_registro_status (status)

## Constraints
- -

## Relacionamentos e Cardinalidade
- N:1 com rh_pessoa_vinculo (um vínculo pode ter vários registros profissionais)

## Dependências
- Tabelas que dependem desta: rh_evento
| Esta tabela depende de: rh_pessoa_vinculo

## Fluxo de utilização dentro do sistema
- Criado ao vincular registro profissional a uma pessoa
- Permite controle de validade para renovação
- Unique constraint evita duplicação de registros no mesmo conselho
- Origem ajuda a rastrear se o registro foi importado ou digitado manualmente