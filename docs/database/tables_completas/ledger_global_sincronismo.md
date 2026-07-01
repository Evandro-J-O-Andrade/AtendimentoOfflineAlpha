# ledger_global_sincronismo

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| ulid_evento | binary(16) | NOT NULL | - | (Documentar) |
| id_tenant | bigint | NOT NULL | - | (Documentar) |
| id_sistema | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_local_operacional | bigint | YES | - | (Documentar) |
| origem_runtime | varchar(40) | NOT NULL | - | (Documentar) |
| contexto_origem | varchar(50) | YES | - | (Documentar) |
| tipo_evento | varchar(60) | NOT NULL | - | (Documentar) |
| subtipo_evento | varchar(60) | YES | - | (Documentar) |
| payload_json | json | NOT NULL | - | (Documentar) |
| hash_integridade | char(64) | NOT NULL | - | (Documentar) |
| data_evento_local | datetime(6) | NOT NULL | - | (Documentar) |
| data_evento_central | datetime(6) | YES | - | (Documentar) |
| versao_schema | int | NOT NULL | - | (Documentar) |
| estado_processamento | enum('PENDENTE' | YES | - | (Documentar) |
| tentativas_sync | int | YES | - | (Documentar) |
| criado_por | bigint | YES | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (ulid_evento)
- KEY (id_tenant)
- KEY (id_unidade)
- KEY (id_local_operacional)
- KEY (estado_processamento)
- KEY (tipo_evento)
- KEY (origem_runtime)
- KEY (versao_schema)
- KEY (data_evento_local)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

