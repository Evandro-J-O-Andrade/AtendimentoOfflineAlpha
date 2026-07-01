# evento_geral

Objetivo: Registro de eventos e fluxos do sistema

Descrição: Ledger canônico que registra todos os eventos gerais do sistema HIS/PA, permitindo auditoria e rastreabilidade de ações por domínio, tipo e referência.

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao/Descricao |
|---------|------|----------|---------|------------------|
| id_evento | bigint AUTO_INCREMENT | NO | — | Identificador único de evento |
| id_usuario | bigint | NO | — | Identificador único de usuario |
| id_unidade | bigint unsigned | NO | — | Identificador da unidade de saúde |
| dominio | varchar(50) | NO | — | Campo do registro |
| tipo_evento | varchar(100) | NO | — | Endereço IP de origem da requisição |
| id_referencia | bigint DEFAULT | YES | NULL | Identificador único de referencia |
| payload | json DEFAULT | YES | NULL | Dados complementares no formato JSON |
| metadata | json DEFAULT | YES | NULL | Metadados adicionais em formato JSON |
| criado_em | datetime(6) | NO | — | Data e hora do registro |
| id_entidade | bigint unsigned | NO | — | Identificador da entidade multitenant |

## Chaves

- Primaria: id_evento
- Estrangeira (fk_evento_geral_unidade): coluna id_unidade -> tabela unidade(id_unidade): Referencia a tabela unidade (coluna id_unidade) para garantir integridade referencial

## Indices

- idx_usuario (id_usuario)
- idx_unidade (id_unidade)
- idx_dominio_tipo (dominio, tipo_evento)
- idx_referencia (id_referencia)

## Constraints

- FOREIGN KEY fk_evento_geral_unidade: id_unidade references unidade(id_unidade)
- PRIMARY KEY (id_evento)

## Relacionamentos e Cardinalidade

- evento_geral (1) -> unidade (1): campo id_unidade

## Dependencias

- Depende de:
  - unidade
- Dependencias diretas: Nenhuma tabela listada depende diretamente desta tabela com base nas FKs encontradas.

## Fluxo de utilizacao dentro do sistema

- Tabela componente do módulo de atendimento e faturamento hospitalar.
- Utilizada para persistência e consulta de dados específicos do domínio.
- Associada a operações de cadastro, evolução e faturamento.
- Integrada com fluxos de auditoria e sincronização.
