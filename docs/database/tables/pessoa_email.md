# pessoa_email

Objetivo: Armazenar endereços de email de uma pessoa.
Descrição: Tabela que mantém os endereços de email de uma pessoa, com categorização por tipo (pessoal, profissional, financeiro, emergência), validação e período de validade.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_pessoa_email | bigint | NOT NULL | - | Identificador único do email (chave primária, auto incremento) |
| id_pessoa | bigint | NOT NULL | - | ID da pessoa à qual o email pertence |
| email | varchar(200) | NOT NULL | - | Endereço de email |
| tipo | enum('PESSOAL','PROFISSIONAL','FINANCEIRO','EMERGENCIA','OUTRO') | YES | 'PESSOAL' | Tipo de email: pessoal, profissional, financeiro, emergência ou outro |
| principal | tinyint(1) | YES | '0' | Flag indicando se este é o email principal da pessoa |
| verificado | tinyint(1) | YES | '0' | Flag indicando se o email foi verificado |
| ativo | tinyint(1) | YES | '1' | Flag indicando se o email está ativo |
| valido_de | date | YES | NULL | Data de início da validade do email |
| valido_ate | date | YES | NULL | Data de fim da validade do email |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Data/hora de criação do registro |
| atualizado_em | datetime(6) | YES | NULL | Data/hora da última atualização |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o email pertence |

## Chaves
- Primária: id_pessoa_email
- Únicas: uk_email_unico (email)
- Estrangeiras: 
  - fk_pessoa_email_pessoa: id_pessoa → pessoa (id_pessoa)

## Índices
- PRIMARY KEY (id_pessoa_email)
- UNIQUE KEY uk_email_unico (email)
- KEY idx_email_pessoa (id_pessoa)
- KEY idx_email_principal (principal)

## Constraints
- PRIMARY KEY: id_pessoa_email
- UNIQUE: uk_email_unico
- FOREIGN KEY: fk_pessoa_email_pessoa

## Relacionamentos e Cardinalidade
- N:1 com pessoa: Muitos emails pertencem a uma pessoa

## Dependências
- Esta tabela depende de: pessoa, saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para armazenar emails de pessoas no sistema. O tipo permite categorizar para diferentes finalidades. O campo verificado controla se o email foi confirmado por envio de código. O email principal é usado como prioridade para comunicações oficiais. Permite envio de notificações e comprovantes.