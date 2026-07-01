# pessoa_vinculo

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_pessoa_vinculo | bigint | NOT NULL | - | (Documentar) |
| id_pessoa_origem | bigint | NOT NULL | - | (Documentar) |
| id_pessoa_destino | bigint | NOT NULL | - | (Documentar) |
| tipo_vinculo | enum('RESPONSAVEL' | NOT NULL | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_pessoa_destino -> pessoa.id_pessoa
- Estrangeira: id_pessoa_origem -> pessoa.id_pessoa

## Indices

- PRIMARY KEY (id_pessoa_vinculo)
- KEY (id_pessoa_origem)
- KEY (id_pessoa_destino)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

