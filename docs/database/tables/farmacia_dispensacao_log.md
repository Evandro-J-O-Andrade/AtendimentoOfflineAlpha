# farmacia_dispensacao_log

Objetivo: Controle de dispensação de medicamentos

Descrição: Log detalhado de dispensação de medicamentos pela farmácia, registrando sessão do usuário, lote, quantidade e timestamp para auditoria.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id | bigint AUTO_INCREMENT | NO | — | Campo do registro |
| id_prescricao_item | bigint | NO | — | Identificador do item de prescrição |
| id_sessao_usuario | bigint | NO | — | Identificador da sessão do usuário |
| id_lote | bigint DEFAULT | YES | NULL | Identificador do lote de medicamento |
| quantidade | decimal(14,3) | NO | — | Quantidade numérica do item |
| criado_em | datetime(6) | NO | CURRENT_TIMESTAMP(6) | Data e hora do registro |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id
- Estrangeira (fk_fdl_lote): coluna id_lote -> tabela lote(id): Referencia a tabela lote (coluna id) para garantir integridade referencial
- Estrangeira (fk_fdl_prescricao_item): coluna id_prescricao_item -> tabela prescricao_item(id_item): Referencia a tabela prescricao_item (coluna id_item) para garantir integridade referencial
- Estrangeira (fk_fdl_sessao): coluna id_sessao_usuario -> tabela sessao_usuario(id_sessao_usuario): Referencia a tabela sessao_usuario (coluna id_sessao_usuario) para garantir integridade referencial

## Indices

- idx_prescricao_item (id_prescricao_item)
- idx_sessao_usuario (id_sessao_usuario)
- idx_criado_em (criado_em)
- fk_fdl_lote (id_lote)

## Constraints

- FOREIGN KEY fk_fdl_lote: id_lote references lote(id)
- FOREIGN KEY fk_fdl_prescricao_item: id_prescricao_item references prescricao_item(id_item)
- FOREIGN KEY fk_fdl_sessao: id_sessao_usuario references sessao_usuario(id_sessao_usuario)
- PRIMARY KEY (id)

## Relacionamentos e Cardinalidade

- farmacia_dispensacao_log (1) -> lote (1): campo id_lote
- farmacia_dispensacao_log (1) -> prescricao_item (1): campo id_prescricao_item
- farmacia_dispensacao_log (1) -> sessao_usuario (1): campo id_sessao_usuario

## Dependencias

- Depende de:
  - lote
  - prescricao_item
  - sessao_usuario
- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Tabela componente do módulo de atendimento e faturamento hospitalar.
- Utilizada para persistência e consulta de dados específicos do domínio.
- Associada a operações de cadastro, evolução e faturamento.
- Integrada com fluxos de auditoria e sincronização.
