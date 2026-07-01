# pessoa_documento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_pessoa_documento | bigint | NOT NULL | - | (Documentar) |
| id_pessoa | bigint | NOT NULL | - | (Documentar) |
| tipo_documento | enum('CPF' | NOT NULL | - | (Documentar) |
| numero | varchar(50) | NOT NULL | - | (Documentar) |
| orgao_emissor | varchar(50) | YES | - | (Documentar) |
| uf_emissor | char(2) | YES | - | (Documentar) |
| data_emissao | date | YES | - | (Documentar) |
| data_validade | date | YES | - | (Documentar) |
| principal | tinyint(1) | YES | - | (Documentar) |
| observacao | varchar(300) | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_pessoa -> pessoa.id_pessoa

## Indices

- PRIMARY KEY (id_pessoa_documento)
- KEY (id_pessoa)
- KEY (tipo_documento)
- KEY (numero)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

