# pessoa_identificador

Objetivo: Armazenar identificadores externos de uma pessoa (MRN, códigos de sistemas externos).
Descrição: Tabela que mantém identificadores externos à pessoa, como MRN (Medical Record Number), códigos de sistemas legados, municipais, estaduais, nacionais, ou de convênios e laboratórios.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_pessoa_identificador | bigint | NOT NULL | - | Identificador único do registro (chave primária, auto incremento) |
| id_pessoa | bigint | NOT NULL | - | ID da pessoa à qual o identificador pertence |
| tipo_identificador | enum('MRN','CODIGO_INTERNO','CODIGO_LEGADO','CODIGO_MUNICIPAL','CODIGO_ESTADUAL','CODIGO_NACIONAL','CODIGO_CONVENIO','CODIGO_LABORATORIO','CODIGO_FARMACIA','CODIGO_SAAS','OUTRO') | NOT NULL | - | Tipo do identificador: MRN, código interno, legado, municipal, estadual, nacional, convênio, laboratório, farmácia, SaaS ou outro |
| identificador | varchar(120) | NOT NULL | - | Valor do identificador no sistema externo |
| sistema_origem | varchar(100) | YES | NULL | Nome do sistema externo de origem |
| descricao | varchar(200) | YES | NULL | Descrição do identificador |
| principal | tinyint(1) | YES | '0' | Flag indicando se este é o identificador principal |
| ativo | tinyint(1) | YES | '1' | Flag indicando se o identificador está ativo |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP(6) | Data/hora de criação do registro |
| atualizado_em | datetime(6) | YES | NULL | Data/hora da última atualização |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o identificador pertence |

## Chaves
- Primária: id_pessoa_identificador
- Únicas: (nenhuma)
- Estrangeiras: 
  - fk_pessoa_identificador_pessoa: id_pessoa → pessoa (id_pessoa)

## Índices
- PRIMARY KEY (id_pessoa_identificador)
- KEY idx_pid_pessoa (id_pessoa)
- KEY idx_pid_tipo (tipo_identificador)
- KEY idx_pid_identificador (identificador)

## Constraints
- PRIMARY KEY: id_pessoa_identificador
- FOREIGN KEY: fk_pessoa_identificador_pessoa

## Relacionamentos e Cardinalidade
- N:1 com pessoa: Muitos identificadores pertencem a uma pessoa

## Dependências
- Esta tabela depende de: pessoa, saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para mapear identificadores de uma pessoa vindo de sistemas externos. Quando uma pessoa é importada de outro sistema, seu identificador é armazenado aqui com o tipo CODIGO_LEGADO ou CODIGO_MUNICIPAL. Permite manter a referência cruzada entre sistemas. IDs MRN são comuns em sistemas hospitalares. Permite reconciliação de registros entre diferentes bases.