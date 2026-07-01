# internacao_dispositivos

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_dispositivo | bigint | NOT NULL | - | (Documentar) |
| id_internacao | bigint | NOT NULL | - | (Documentar) |
| tipo | enum('CVC' | NOT NULL | - | (Documentar) |
| localizacao | varchar(100) | YES | - | (Documentar) |
| data_insercao | datetime | YES | - | (Documentar) |
| prazo_troca_dias | int | YES | - | (Documentar) |
| data_prevista_troca | datetime | YES | - | (Documentar) |
| id_usuario_insercao | bigint | NOT NULL | - | (Documentar) |
| status | enum('ATIVO' | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_internacao -> internacao.id_internacao

## Indices

- PRIMARY KEY (id_dispositivo)
- KEY (id_internacao)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

