# estoque_item

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_item | bigint | NO |  | id item |
| codigo_interno | varchar(50) | YES | NULL | codigo interno |
| codigo_barras | varchar(128) | YES | NULL | codigo barras |
| codigo_tuss | varchar(20) | YES | NULL | codigo tuss |
| nome_comercial | varchar(255) | NO |  | nome comercial |
| categoria | enum('MEDICAMENTO','MATERIAL_MEDICO','SUTURA','GASES','HIGIENE','TI','MANUTENCAO') | NO |  | categoria |
| unidade_venda | varchar(10) | NO | 'UN' | unidade venda |
| is_faturavel | tinyint(1) | YES | '1' | is faturavel |
| id_sessao_usuario | bigint | NO |  | id sessao usuario |
| criado_em | timestamp | YES | CURRENT_TIMESTAMP | criado em |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_item.
- Ãšnicas:
  - codigo_interno (codigo_interno)
  - codigo_barras (codigo_barras)

## Ãndices

- Nenhum Ã­ndice adicional.

## Constraints

- Nenhuma constraint adicional.

## Relacionamentos e Cardinalidade

- Nenhum relacionamento externo declarado.

## DependÃªncias

- Nenhuma dependÃªncia externa declarada.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.

