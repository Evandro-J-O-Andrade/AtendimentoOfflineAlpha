# pessoa_identificador

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_pessoa_identificador | bigint | NOT NULL | - | (Documentar) |
| id_pessoa | bigint | NOT NULL | - | (Documentar) |
| tipo_identificador | enum('MRN' | NOT NULL | - | (Documentar) |
| identificador | varchar(120) | NOT NULL | - | (Documentar) |
| sistema_origem | varchar(100) | YES | - | (Documentar) |
| descricao | varchar(200) | YES | - | (Documentar) |
| principal | tinyint(1) | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_pessoa -> pessoa.id_pessoa

## Indices

- PRIMARY KEY (id_pessoa_identificador)
- KEY (id_pessoa)
- KEY (tipo_identificador)
- KEY (identificador)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

