# farm_dispensacao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_dispensacao | bigint | NOT NULL | - | (Documentar) |
| id_receita | bigint | NOT NULL | - | (Documentar) |
| tipo | enum('INTERNO' | NOT NULL | - | (Documentar) |
| id_usuario_primeira_baixa | bigint | YES | - | (Documentar) |
| primeira_baixa_em | datetime | YES | - | (Documentar) |
| id_usuario_segunda_baixa | bigint | YES | - | (Documentar) |
| segunda_baixa_em | datetime | YES | - | (Documentar) |
| status | enum('ABERTA' | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_receita -> farm_receita_controlada.id_receita

## Indices

- PRIMARY KEY (id_dispensacao)
- KEY (id_receita)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

