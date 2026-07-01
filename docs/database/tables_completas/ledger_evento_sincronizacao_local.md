# ledger_evento_sincronizacao_local

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_evento | char(36) | NOT NULL | - | (Documentar) |
| id_tenant | bigint | NOT NULL | - | (Documentar) |
| id_sistema | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_local_operacional | bigint | YES | - | (Documentar) |
| tipo_evento | varchar(50) | NOT NULL | - | (Documentar) |
| subtipo_evento | varchar(50) | YES | - | (Documentar) |
| payload_json | json | NOT NULL | - | (Documentar) |
| hash_integridade | char(64) | NOT NULL | - | (Documentar) |
| origem_contexto | enum('LOCAL_EDGE' | NOT NULL | - | (Documentar) |
| estado_sincronizacao | enum('PENDENTE' | YES | - | (Documentar) |
| tentativas_sync | int | YES | - | (Documentar) |
| timestamp_evento | datetime(6) | NOT NULL | - | (Documentar) |
| timestamp_registro | datetime(6) | YES | - | (Documentar) |
| versao_schema | int | NOT NULL | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id_evento)
- KEY (id_tenant)
- KEY (id_unidade)
- KEY (id_local_operacional)
- KEY (estado_sincronizacao)
- KEY (timestamp_evento)
- KEY (tipo_evento)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

