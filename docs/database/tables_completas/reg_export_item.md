# reg_export_item

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_export_item | bigint | NOT NULL | - | (Documentar) |
| id_export_lote | bigint | NOT NULL | - | (Documentar) |
| entidade_ref | varchar(80) | NOT NULL | - | (Documentar) |
| id_ref | bigint | NOT NULL | - | (Documentar) |
| status | enum('PENDENTE' | NOT NULL | - | (Documentar) |
| payload_hash | char(64) | YES | - | (Documentar) |
| protocolo_externo | varchar(80) | YES | - | (Documentar) |
| tentativas | int | NOT NULL | - | (Documentar) |
| ultima_tentativa_em | datetime | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_export_lote,entidade_ref,id_ref)
- Estrangeira: id_export_lote -> reg_export_lote.id_export_lote

## Indices

- PRIMARY KEY (id_export_item)
- KEY (id_export_lote,entidade_ref,id_ref)
- KEY (status)
- KEY (entidade_ref,id_ref)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

