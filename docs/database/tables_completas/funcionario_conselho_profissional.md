# funcionario_conselho_profissional

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_funcionario_conselho | bigint | NOT NULL | - | (Documentar) |
| id_funcionario | bigint | NOT NULL | - | (Documentar) |
| conselho | varchar(50) | NOT NULL | - | (Documentar) |
| numero_registro | varchar(50) | NOT NULL | - | (Documentar) |
| uf | char(2) | NOT NULL | - | (Documentar) |
| situacao | enum('ATIVO' | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_funcionario -> funcionario.id_funcionario

## Indices

- PRIMARY KEY (id_funcionario_conselho)
- KEY (id_funcionario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

