# pessoa_telefone

Objetivo: Armazenar números de telefone de uma pessoa com WhatsApp e validade.
Descrição: Tabela que mantém os números de telefone de uma pessoa, categorizados por tipo (celular, residencial, comercial, WhatsApp, emergência) com datas de validade.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_pessoa_telefone | bigint | NOT NULL | - | Identificador único do telefone (chave primária, auto incremento) |
| id_pessoa | bigint | NOT NULL | - | ID da pessoa à qual o telefone pertence |
| numero | varchar(20) | NOT NULL | - | Número do telefone no formato armazenado |
| tipo | enum('CELULAR','RESIDENCIAL','COMERCIAL','WHATSAPP','EMERGENCIA','OUTRO') | YES | 'CELULAR' | Tipo do telefone: celular, residencial, comercial, WhatsApp, emergência ou outro |
| principal | tinyint(1) | YES | '0' | Flag indicando se este é o telefone principal da pessoa |
| whatsapp | tinyint(1) | YES | '0' | Flag indicando se o número tem WhatsApp |
| ativo | tinyint(1) | YES | '1' | Flag indicando se o telefone está ativo |
| valido_de | date | YES | NULL | Data de início da validade do número |
| valido_ate | date | YES | NULL | Data de fim da validade do número |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Data/hora de criação do registro |
| atualizado_em | datetime(6) | YES | NULL | Data/hora da última atualização |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o telefone pertence |

## Chaves
- Primária: id_pessoa_telefone
- Únicas: (nenhuma)
- Estrangeiras: 
  - fk_pessoa_telefone_pessoa: id_pessoa → pessoa (id_pessoa)

## Índices
- PRIMARY KEY (id_pessoa_telefone)
- KEY idx_telefone_pessoa (id_pessoa)
- KEY idx_telefone_principal (principal)

## Constraints
- PRIMARY KEY: id_pessoa_telefone
- FOREIGN KEY: fk_pessoa_telefone_pessoa

## Relacionamentos e Cardinalidade
- N:1 com pessoa: Muitos telefones pertencem a uma pessoa

## Dependências
- Esta tabela depende de: pessoa, saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para armazenar telefones de pessoas no sistema. O campo tipo permite diferenciar entre celular, residencial, etc. O campo whatsapp indica se o número pode receber notificações via WhatsApp. Permite envio de lembretes, confirmações e informações importantes. As datas de validade permitem histórico de números antigos.