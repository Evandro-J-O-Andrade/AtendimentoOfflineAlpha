# prescricao_kit_master

Objetivo: Armazenar os kits de prescrição pré-definidos como templates para protocolos clínicos padronizados.

Descrição: Tabela mestre que define kits de prescrição médica, funcionando como templates ou protocolos pré-definidos para situações clínicas recorrentes. Permite criar protocolos como "PROTOCOLO DENGUE" ou "PROTOCOLO SEPSE" para agilizar a prescrição médica em emergências.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id | int | NOT NULL | - | Chave primária da tabela, identificador único do kit master |
| nome_kit | varchar(100) | NOT NULL | - | Nome do kit de prescrição (ex: PROTOCOLO DENGUE, PROTOCOLO SEPSE) |
| descricao | varchar(255) | YES | NULL | Descrição do propósito ou aplicação do kit |
| ativo | tinyint(1) | - | '1' | Flag indicando se o kit está ativo e pode ser utilizado |
| id_entidade | bigint unsigned | YES | NULL | Identificador da entidade/organização onde o kit é utilizado |

## Chaves
- Primária: id
- Únicas: -
- Estrangeiras: -

## Índices
- PRIMARY KEY (id)

## Constraints
- -

## Relacionamentos e Cardinalidade
- 1:N com prescricao_kit_itens (um kit master tem vários itens)

## Dependências
- Tabelas que dependem desta: prescricao_kit_itens
- Esta tabela depende de: -

## Fluxo de utilização dentro do sistema
- Criado como template para protocolos clínicos recorrentes
- Associado a itens específicos na tabela prescricao_kit_itens
- Utilizado pela equipe clínica para prescrição rápida em emergências
- Permite padronização de tratamentos para condições específicas