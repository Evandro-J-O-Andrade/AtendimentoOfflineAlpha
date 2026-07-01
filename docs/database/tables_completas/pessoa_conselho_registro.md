# pessoa_conselho_registro

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_pessoa_conselho | bigint | NOT NULL | - | (Documentar) |
| id_pessoa | bigint | NOT NULL | - | (Documentar) |
| id_conselho | int | NOT NULL | - | (Documentar) |
| uf_registro | char(2) | NOT NULL | - | (Documentar) |
| registro | varchar(30) | NOT NULL | - | (Documentar) |
| eh_principal | tinyint(1) | NOT NULL | - | (Documentar) |
| ativo | tinyint(1) | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_pessoa,id_conselho,uf_registro,registro)
- Estrangeira: id_conselho -> conselho_profissional.id_conselho
- Estrangeira: id_pessoa -> pessoa.id_pessoa

## Indices

- PRIMARY KEY (id_pessoa_conselho)
- KEY (id_pessoa,id_conselho,uf_registro,registro)
- KEY (id_pessoa,eh_principal,ativo)
- KEY (id_conselho,uf_registro,registro)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

