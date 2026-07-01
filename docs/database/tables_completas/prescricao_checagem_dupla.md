# prescricao_checagem_dupla

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_dupla_checagem | bigint | NOT NULL | - | (Documentar) |
| id_checagem_principal | bigint | NOT NULL | - | (Documentar) |
| id_usuario_testemunha | bigint | NOT NULL | - | (Documentar) |
| data_hora | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_checagem_principal -> prescricao_checagem.id_checagem
- Estrangeira: id_usuario_testemunha -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_dupla_checagem)
- KEY (id_checagem_principal)
- KEY (id_usuario_testemunha)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

