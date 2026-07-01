# procedimento_protocolo_resultado

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_resultado | bigint | NOT NULL | - | (Documentar) |
| id_protocolo | bigint | NOT NULL | - | (Documentar) |
| categoria | varchar(30) | NOT NULL | - | (Documentar) |
| conteudo | longtext | YES | - | (Documentar) |
| versao | int | NOT NULL | - | (Documentar) |
| id_resultado_anterior | bigint | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| id_usuario | bigint | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_protocolo,categoria,versao)
- Estrangeira: id_resultado_anterior -> procedimento_protocolo_resultado.id_resultado
- Estrangeira: id_protocolo -> procedimento_protocolo.id_protocolo
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_resultado)
- KEY (id_protocolo,categoria,versao)
- KEY (id_protocolo,criado_em)
- KEY (categoria,criado_em)
- KEY (id_resultado_anterior)
- KEY (id_sessao_usuario)
- KEY (id_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

