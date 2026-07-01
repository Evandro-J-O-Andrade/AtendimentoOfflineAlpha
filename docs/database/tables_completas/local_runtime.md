# local_runtime

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_local_runtime | bigint | NOT NULL | - | (Documentar) |
| id_local | bigint | NOT NULL | - | (Documentar) |
| aceita_senha | tinyint | YES | - | (Documentar) |
| gera_fila | tinyint | YES | - | (Documentar) |
| exibe_painel | tinyint | YES | - | (Documentar) |
| emite_tts | tinyint | YES | - | (Documentar) |
| permite_triagem | tinyint | YES | - | (Documentar) |
| permite_consulta | tinyint | YES | - | (Documentar) |
| permite_procedimento | tinyint | YES | - | (Documentar) |
| dispositivo_tipo | varchar(40) | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_local -> local.id_local

## Indices

- PRIMARY KEY (id_local_runtime)
- KEY (id_local)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

