# lab_resultado

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_resultado | bigint | NOT NULL | - | (Documentar) |
| protocolo_interno | varchar(100) | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| resultado_link | text | YES | - | (Documentar) |
| resultado_texto | text | YES | - | (Documentar) |
| critico | tinyint(1) | NOT NULL | - | (Documentar) |
| recebido_em | datetime | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| id_usuario | bigint | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_resultado)
- KEY (protocolo_interno)
- KEY (id_ffa)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

