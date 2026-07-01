# alerta_regra

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_alerta_regra | bigint | NOT NULL | - | (Documentar) |
| codigo | varchar(60) | NOT NULL | - | (Documentar) |
| id_sistema_destino | bigint | NOT NULL | - | (Documentar) |
| id_perfil_destino | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (codigo,id_sistema_destino,id_perfil_destino)
- Estrangeira: id_perfil_destino -> perfil.id_perfil
- Estrangeira: id_sistema_destino -> sistema.id_sistema

## Indices

- PRIMARY KEY (id_alerta_regra)
- KEY (codigo,id_sistema_destino,id_perfil_destino)
- KEY (id_sistema_destino)
- KEY (id_perfil_destino)
- KEY (id_unidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

