# documento_emissao

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_documento | bigint | NO |  | id documento |
| id_ffa | bigint | YES | NULL | id ffa |
| id_paciente | bigint | YES | NULL | id paciente |
| id_senha | bigint | YES | NULL | id senha |
| gpat | varchar(30) | YES | NULL | gpat |
| tipo_documento | varchar(60) | NO |  | tipo documento |
| entidade_ref | varchar(30) | YES | NULL | entidade ref |
| id_ref | bigint | YES | NULL | id ref |
| numero_documento | varchar(40) | YES | NULL | numero documento |
| hash_documento | varchar(64) | YES | NULL | hash documento |
| status | enum('GERADO','IMPRESSO','CANCELADO') | NO | 'GERADO' | status |
| id_sessao_usuario | bigint | NO |  | id sessao usuario |
| id_usuario | bigint | NO |  | id usuario |
| id_unidade | bigint unsigned | NO |  | id unidade |
| id_local_operacional | bigint | YES | NULL | id local operacional |
| observacao | text | YES |  | observacao |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | criado em |
| atualizado_em | datetime | YES | CURRENT_TIMESTAMP | atualizado em |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_documento.
- Estrangeiras:
  - id_unidade referencia unidade.id_unidade

## Ãndices

- idx_doc_ffa em (id_ffa)
- idx_doc_paciente em (id_paciente)
- idx_doc_tipo em (tipo_documento)
- idx_doc_status em (status)
- idx_doc_gpat em (gpat)
- idx_doc_data em (criado_em)
- fk_doc_sessao em (id_sessao_usuario)
- fk_documento_emissao_unidade em (id_unidade)

## Constraints

- FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade)

## Relacionamentos e Cardinalidade

- documento_emissao (id_unidade) -> unidade (id_unidade): N:1

## DependÃªncias

- Depende de: unidade.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.

