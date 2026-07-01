# procedimento_protocolo_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_evento | bigint | NOT NULL | - | (Documentar) |
| id_protocolo | bigint | NOT NULL | - | (Documentar) |
| tipo_evento | varchar(30) | NOT NULL | - | (Documentar) |
| detalhe | text | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| id_usuario | bigint | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_protocolo -> procedimento_protocolo.id_protocolo
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_evento)
- KEY (id_protocolo,criado_em)
- KEY (tipo_evento,criado_em)
- KEY (id_sessao_usuario,criado_em)
- KEY (id_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

