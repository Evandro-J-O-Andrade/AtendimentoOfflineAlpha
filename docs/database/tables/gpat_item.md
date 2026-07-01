# gpat_item

Objetivo: Gerenciar os itens (medicamentos) de um GPAT.

Descrição: Tabela que armazena os medicamentos/fármacos prescritos em um GPAT, incluindo quantidade, unidade, posologia, dias e status. Utilizada para detalhar a prescrição terapêutica.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_gpat_item | bigint | NOT NULL | - | Identificador único do item, chave primária auto incrementada |
| id_gpat | bigint | NOT NULL | - | Referência ao GPAT ao qual o item pertence |
| id_farmaco | bigint | NOT NULL | - | Referência ao fármaco/medicamento prescrito |
| quantidade_total | decimal(10,2) | NOT NULL | - | Quantidade total prescrita |
| unidade_medida | varchar(20) | DEFAULT NULL | - | Unidade de medida (ex: mg, ml, comprimido) |
| posologia | text | DEFAULT NULL | - | Posologia completa (como tomar, frequência, duração) |
| dias | int | DEFAULT NULL | - | Número de dias da prescrição |
| observacao | text | DEFAULT NULL | - | Observações sobre o item |
| status | enum('ATIVO','SUSPENSO','ENCERRADO') | NOT NULL | 'ATIVO' | Status do item: ativo, suspenso ou encerrado |
| criado_em | datetime | NOT NULL DEFAULT | CURRENT_TIMESTAMP | Data e hora de criação do registro |
| atualizado_em | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE | CURRENT_TIMESTAMP | Data e hora da última atualização |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_gpat_item
- Únicas: -
- Estrangeiras: fk_gpat_item_farmaco (id_farmaco → farmaco.id_farmaco); fk_gpat_item_gpat (id_gpat → gpat_atendimento.id_gpat ON DELETE CASCADE)

## Índices
- idx_gpat_item_gpat (id_gpat)
- idx_gpat_item_farmaco (id_farmaco)

## Constraints
- CONSTRAINT fk_gpat_item_farmaco FOREIGN KEY (id_farmaco) REFERENCES farmaco (id_farmaco)
- CONSTRAINT fk_gpat_item_gpat FOREIGN KEY (id_gpat) REFERENCES gpat_atendimento (id_gpat) ON DELETE CASCADE

## Relacionamentos e Cardinalidade
- gpat_item.id_gpat → gpat_atendimento (id_gpat): N:1 (vários itens podem pertencer ao mesmo GPAT)
- gpat_item.id_farmaco → farmaco (id_farmaco): N:1 (vários itens podem referenciar o mesmo fármaco)

## Dependências
- Tabelas que dependem desta: gpat_dispensacao
- Esta tabela depende de: gpat_atendimento, farmaco

## Fluxo de utilização dentro do sistema
1. Item é adicionado ao GPAT com id_farmaco e quantidade
2. posologia define como o medicamento deve ser usado
3. dias indica duração da tratamento
4. Status inicia como 'ATIVO'
5. Se suspenso: status muda para 'SUSPENSO'
6. Ao finalizar: status muda para 'ENCERRADO'
7. ON DELETE CASCADE remove itens se GPAT for excluído