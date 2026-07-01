# farmacia_atendimento_externo_item

Objetivo: Gestão de medicamentos, movimentações e auditoria

Descrição: Itens de prescrição para atendimento externo de farmácia, com posologia, quantidade, status e vínculo a lote e local de estoque.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_item | bigint AUTO_INCREMENT | NO | — | Identificador do item |
| id_atendimento | bigint | NO | — | Identificador do atendimento |
| id_farmaco | bigint | NO | — | Identificador do medicamento |
| quantidade_total | decimal(10,2) | NO | — | Quantidade total prescrita |
| posologia | text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | YES | — | Posologia e forma de uso do medicamento |
| dias | int DEFAULT | YES | NULL | Quantidade de dias |
| status | enum('ATIVO','SUSPENSO','CONCLUIDO') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci | NO | 'ATIVO' | Status atual conforme enumeração definida |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | Data e hora do registro |
| criado_por | bigint | NO | — | Usuário responsável pela criação |
| atualizado_em | datetime DEFAULT | YES | NULL | Data e hora do registro |
| atualizado_por | bigint DEFAULT | YES | NULL | Usuário responsável pela última atualização |
| id_lote | bigint | NO | — | Identificador do lote de medicamento |
| id_local_estoque | bigint | NO | — | Identificador do local de estoque |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_item
- Estrangeira (fk_faei_atend): coluna id_atendimento -> tabela farmacia_atendimento_externo(id_atendimento): Referencia a tabela farmacia_atendimento_externo (coluna id_atendimento) para garantir integridade referencial
- Estrangeira (fk_faei_farmaco): coluna id_farmaco -> tabela farmaco(id_farmaco): Referencia a tabela farmaco (coluna id_farmaco) para garantir integridade referencial

## Indices

- idx_faei (id_atendimento, status)
- fk_faei_farmaco (id_farmaco)

## Constraints

- FOREIGN KEY fk_faei_atend: id_atendimento references farmacia_atendimento_externo(id_atendimento)
- FOREIGN KEY fk_faei_farmaco: id_farmaco references farmaco(id_farmaco)
- PRIMARY KEY (id_item)

## Relacionamentos e Cardinalidade

- farmacia_atendimento_externo_item (1) -> farmacia_atendimento_externo (1): campo id_atendimento
- farmacia_atendimento_externo_item (1) -> farmaco (1): campo id_farmaco

## Dependencias

- Depende de:
  - farmacia_atendimento_externo
  - farmaco
- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Tabela componente do módulo de atendimento e faturamento hospitalar.
- Utilizada para persistência e consulta de dados específicos do domínio.
- Associada a operações de cadastro, evolução e faturamento.
- Integrada com fluxos de auditoria e sincronização.
