# pessoa_endereco

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_pessoa_endereco | bigint | NOT NULL | - | (Documentar) |
| id_pessoa | bigint | NOT NULL | - | (Documentar) |
| id_cidade | bigint | YES | - | (Documentar) |
| tipo | enum('RESIDENCIAL' | YES | - | (Documentar) |
| principal | tinyint(1) | YES | - | (Documentar) |
| cep | varchar(10) | YES | - | (Documentar) |
| logradouro | varchar(150) | YES | - | (Documentar) |
| numero | varchar(20) | YES | - | (Documentar) |
| complemento | varchar(100) | YES | - | (Documentar) |
| bairro | varchar(120) | YES | - | (Documentar) |
| referencia | varchar(200) | YES | - | (Documentar) |
| latitude | decimal(10 | YES | - | (Documentar) |
| longitude | decimal(10 | YES | - | (Documentar) |
| valido_de | date | YES | - | (Documentar) |
| valido_ate | date | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_cidade -> cidade.id_cidade
- Estrangeira: id_pessoa -> pessoa.id_pessoa

## Indices

- PRIMARY KEY (id_pessoa_endereco)
- KEY (id_pessoa)
- KEY (id_cidade)
- KEY (principal)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

