# pessoa_contato

Objetivo: Registrar meios de contato de uma pessoa (email, telefone, WhatsApp).
Descrição: Tabela que armazena contatos de uma pessoa, podendo ser do tipo email, telefone ou WhatsApp. Permite múltiplos contatos por pessoa.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id | bigint | NOT NULL | - | Identificador único do contato (chave primária, auto incremento) |
| id_pessoa | bigint | NOT NULL | - | ID da pessoa à qual o contato está vinculado |
| tipo | enum('EMAIL','TELEFONE','WHATSAPP') | YES | NULL | Tipo de contato: email, telefone ou WhatsApp |
| valor | varchar(150) | YES | NULL | Valor do contato (endereço de email ou número de telefone) |
| principal | tinyint(1) | YES | '0' | Flag indicando se este é o contato principal da pessoa |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o contato pertence |

## Chaves
- Primária: id
- Únicas: (nenhuma)
- Estrangeiras: 
  - pessoa_contato_ibfk_1: id_pessoa → pessoa (id_pessoa)

## Índices
- PRIMARY KEY (id)
- KEY id_pessoa (id_pessoa)

## Constraints
- PRIMARY KEY: id
- FOREIGN KEY: pessoa_contato_ibfk_1

## Relacionamentos e Cardinalidade
- N:1 com pessoa: Muitos contatos pertencem a uma pessoa

## Dependências
- Esta tabela depende de: pessoa, saas_entidade
- Não há tabelas que dependem desta tabela

## Fluxo de utilização dentro do sistema
Utilizada para armazenar contatos de pessoas no sistema. Embora existam tabelas específicas para email (pessoa_email) e telefone (pessoa_telefone), esta tabela provê uma visão unificada de todos os tipos de contato. O contato principal é usado como prioridade para comunicações. Permite buscas rápidas por contato independente do tipo.