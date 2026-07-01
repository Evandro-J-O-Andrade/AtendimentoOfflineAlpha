# ffa_item

Objetivo: Gerenciar os itens (medicações/produtos) prescritos dentro de um episódio assistencial FFA (Fast Track Attendance).

Descrição: Tabela que armazena os itens farmacêuticos ou produtos prescritos para pacientes durante um atendimento FFA. Controla o ciclo de vida da prescrição desde o estado inicial até a dispensação total ou cancelamento, mantendo controle de quantidades autorizadas e dispensadas.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_ffa_item | bigint | NOT NULL | - | Identificador único do item FFA, chave primária auto incrementada |
| id_ffa | bigint | NOT NULL | - | Referência ao episódio assistencial FFA ao qual o item pertence |
| id_paciente | bigint | NOT NULL | - | Referência ao paciente associado ao item |
| id_produto | bigint | NOT NULL | - | Referência ao produto/medicamento da farmácia |
| dose_prescrita | decimal(15,4) | NOT NULL | - | Quantidade da dose prescrita do produto |
| unidade_prescrita | varchar(20) | NOT NULL | - | Unidade de medida da dose prescrita (ex: mg, ml, comprimido) |
| quantidade_autorizada | decimal(15,4) | NOT NULL | - | Quantidade total autorizada para o item |
| quantidade_dispensada | decimal(15,4) | NOT NULL | '0.0000' | Quantidade já dispensada do item, inicia com zero |
| status | enum('PRESCRITO','AUTORIZADO','DISPENSADO_PARCIAL','DISPENSADO_TOTAL','CANCELADO') | NOT NULL | 'PRESCRITO' | Estado atual do item no fluxo: prescrito, autorizado, dispensado parcialmente, dispensado totalmente ou cancelado |
| id_unidade | bigint unsigned | NOT NULL | - | Referência à unidade onde o item foi prescrito |
| id_sessao_usuario | bigint | NOT NULL | - | Referência à sessão do usuário que criou o registro |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_ffa_item
- Únicas: -
- Estrangeiras: fk_ffa_item_unidade (id_unidade → unidade.id_unidade); fk_ffa_produto (id_produto → estoque_produto.id_produto)

## Índices
- KEY fk_ffa_produto (id_produto)
- KEY fk_ffa_sessao (id_sessao_usuario)
- KEY fk_ffa_item_unidade (id_unidade)

## Constraints
- CONSTRAINT fk_ffa_item_unidade FOREIGN KEY (id_unidade) REFERENCES unidade (id_unidade)
- CONSTRAINT fk_ffa_produto FOREIGN KEY (id_produto) REFERENCES estoque_produto (id_produto)

## Relacionamentos e Cardinalidade
- ffa_item.id_ffa → ffa (id_ffa): N:1 (vários itens pertencem a um FFA)
- ffa_item.id_paciente → paciente (id_paciente): N:1 (vários itens podem referenciar o mesmo paciente)
- ffa_item.id_produto → estoque_produto (id_produto): N:1 (vários itens podem referenciar o mesmo produto)
- ffa_item.id_unidade → unidade (id_unidade): N:1 (vários itens podem referenciar a mesma unidade)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: unidade, estoque_produto, ffa, paciente

## Fluxo de utilização dentro do sistema
1. Medico/Farmacêutico prescreve um medicamento/produto para paciente em atendimento FFA
2. Sistema cria registro com status 'PRESCRITO', quantidade_dispensada = 0
3. Farmácia autoriza o uso e status muda para 'AUTORIZADO'
4. Durante dispensação, quantidade_dispensada é incrementada
5. Quando total atingido: status alterado para 'DISPENSADO_TOTAL'
6. Se cancelado: status alterado para 'CANCELADO'