# contexto_atendimento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_contexto | bigint | NOT NULL | - | (Documentar) |
| id_sistema | bigint | NOT NULL | - | (Documentar) |
| nome | varchar(100) | YES | - | (Documentar) |
| tipo | enum('PORTA' | YES | - | (Documentar) |
| usa_fila | tinyint(1) | YES | - | (Documentar) |
| usa_chamada | tinyint(1) | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_sistema -> sistema.id_sistema

## Indices

- PRIMARY KEY (id_contexto)
- KEY (id_sistema)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

