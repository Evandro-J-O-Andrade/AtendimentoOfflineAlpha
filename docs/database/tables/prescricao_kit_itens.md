# prescricao_kit_itens

Objetivo: Armazenar os itens individuais que compõem um kit de prescrição pré-definido, permitindo a reutilização de protocolos clínicos.

Descrição: Tabela que representa os itens de um kit de prescrição médica, sendo parte do mecanismo de protocolos pré-definidos. Cada kit master pode ter múltiplos itens, cada um com nome, dose, via de administração e frequência.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id | int | NOT NULL | - | Chave primária da tabela, identificador único do item do kit |
| id_kit | int | NOT NULL | - | Referência ao id do kit master ao qual o item pertence |
| item_nome | varchar(255) | NOT NULL | - | Nome do item medicamentoso ou produto do kit |
| dose | varchar(50) | YES | NULL | Dose recomendada do item no kit |
| via | varchar(20) | YES | NULL | Via de administração do item: EV, IM, VO, SC, etc. |
| frequencia | varchar(50) | YES | NULL | Frequência de aplicação ou uso do item |
| id_entidade | bigint unsigned | YES | NULL | Identificador da entidade/organização onde o kit é utilizado |

## Chaves
- Primária: id
- Únicas: -
- Estrangeiras: fk_kit_master_link (id_kit → prescricao_kit_master.id) - vincula o item ao kit master

## Índices
- PRIMARY KEY (id)
- KEY fk_kit_master_link (id_kit)

## Constraints
- CONSTRAINT fk_kit_master_link FOREIGN KEY (id_kit) REFERENCES prescricao_kit_master (id)

## Relacionamentos e Cardinalidade
- N:1 com prescricao_kit_master (um kit master pode ter vários itens)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: prescricao_kit_master

## Fluxo de utilização dentro do sistema
- Usado como base para protocolos clínicos pré-definidos
- Permite padronizar prescrições para condições específicas (ex: protocolo DENGUE, protocolo SEPSE)
- Itens podem incluir medicamentos, soluções e até procedimentos como coleta de exames
- Facilita a prescrição rápida durante emergências