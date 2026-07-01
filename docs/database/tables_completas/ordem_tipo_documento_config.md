# ordem_tipo_documento_config

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| tipo_ordem | varchar(50) | NOT NULL | - | (Documentar) |
| tipo_documento | varchar(60) | NOT NULL | - | (Documentar) |
| somente_controlado | tinyint(1) | NOT NULL | - | (Documentar) |
| somente_nao_controlado | tinyint(1) | NOT NULL | - | (Documentar) |
| ativo | tinyint(1) | NOT NULL | - | (Documentar) |
| id_entidade | bigint | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: tipo_documento -> documento_tipo_config.codigo

## Indices

- KEY (tipo_documento)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

