# prescricao_item

Objetivo: Gerenciar os itens individuais de uma prescrição contínua, detalhando medicamentos, doses, posologias e status de dispensação.

Descrição: Tabela que representa os itens específicos de uma prescrição contínua, armazenando informações detalhadas sobre medicamentos prescritos, incluindo dose, via de administração, posologia, observações, e controle de dispensação com vínculo ao lote e ao usuário que realizou a dispensação.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_item | bigint | NOT NULL | - | Chave primária da tabela, identificador único do item da prescrição |
| id_prescricao | bigint | NOT NULL | - | Referência ao id da prescrição contínua à qual o item pertence |
| descricao | text | NOT NULL | - | Descrição do item prescrito |
| dose | varchar(100) | YES | NULL | Informação sobre a dose do medicamento |
| via | varchar(50) | YES | NULL | Via de administração do medicamento |
| posologia | varchar(100) | YES | NULL | Informações sobre a posologia/frequência do medicamento |
| observacao | text | YES | NULL | Observações adicionais sobre a prescrição do item |
| id_lote | bigint | YES | NULL | Referência ao id do lote do medicamento na dispensação |
| dispensado_em | datetime(6) | YES | NULL | Data e hora da dispensação do medicamento |
| id_usuario_dispensacao | bigint | YES | NULL | Referência ao id do usuário que realizou a dispensação |
| status | varchar(20) | - | 'PENDENTE' | Status do item: PENDENTE, DISPENSADO, APLICADO, etc. |
| id_entidade | bigint unsigned | NOT NULL | - | Identificador da entidade/organização onde o item foi prescrito |

## Chaves
- Primária: id_item
- Únicas: -
- Estrangeiras: prescricao_item_ibfk_1 (id_prescricao → prescricao_continua.id_prescricao) - vincula o item à prescrição contínua

## Índices
- PRIMARY KEY (id_item)
- KEY id_prescricao (id_prescricao)

## Constraints
- CONSTRAINT prescricao_item_ibfk_1 FOREIGN KEY (id_prescricao) REFERENCES prescricao_continua (id_prescricao)

## Relacionamentos e Cardinalidade
- N:1 com prescricao_continua (uma prescrição contínua pode ter vários itens)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: prescricao_continua

## Fluxo de utilização dentro do sistema
- Criado quando um item é adicionado a uma prescrição contínua
- Controla o ciclo de vida desde a prescrição até a dispensação
- Vinculado ao lote para controle de estoque
- Usado pela farmácia para gestão de medicamentos