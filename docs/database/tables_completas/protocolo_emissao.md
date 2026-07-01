# protocolo_emissao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_emissao | bigint | NOT NULL | - | (Documentar) |
| tipo | varchar(30) | NOT NULL | - | (Documentar) |
| chave | varchar(80) | NOT NULL | - | (Documentar) |
| codigo | varchar(50) | NOT NULL | - | (Documentar) |
| ano | int | YES | - | (Documentar) |
| data_ref | date | YES | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| id_usuario | bigint | YES | - | (Documentar) |
| id_paciente | bigint | YES | - | (Documentar) |
| id_ffa | bigint | YES | - | (Documentar) |
| id_senha | bigint | YES | - | (Documentar) |
| id_cliente | bigint | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (codigo)
- Estrangeira: id_cliente -> cliente.id_cliente
- Estrangeira: id_paciente -> paciente.id
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_emissao)
- KEY (codigo)
- KEY (tipo,ano,data_ref,criado_em)
- KEY (id_paciente)
- KEY (id_ffa)
- KEY (id_senha)
- KEY (id_cliente)
- KEY (id_sessao_usuario)
- KEY (id_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

