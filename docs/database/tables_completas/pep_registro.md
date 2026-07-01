# pep_registro

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_pep_registro | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| id_gpat | bigint | NOT NULL | - | (Documentar) |
| id_usuario_autor | bigint | NOT NULL | - | (Documentar) |
| id_local_operacional | bigint | YES | - | (Documentar) |
| tipo_registro | enum('EVOLUCAO' | NOT NULL | - | (Documentar) |
| texto | mediumtext | YES | - | (Documentar) |
| payload_json | json | YES | - | (Documentar) |
| assinado | tinyint(1) | NOT NULL | - | (Documentar) |
| assinado_em | datetime | YES | - | (Documentar) |
| hash_assinatura | varchar(128) | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_pep_registro)
- KEY (id_ffa)
- KEY (id_gpat)
- KEY (tipo_registro)
- KEY (id_usuario_autor)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

