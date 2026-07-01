# pessoa_telefone

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_pessoa_telefone | bigint | NOT NULL | - | (Documentar) |
| id_pessoa | bigint | NOT NULL | - | (Documentar) |
| numero | varchar(20) | NOT NULL | - | (Documentar) |
| tipo | enum('CELULAR' | YES | - | (Documentar) |
| principal | tinyint(1) | YES | - | (Documentar) |
| whatsapp | tinyint(1) | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| valido_de | date | YES | - | (Documentar) |
| valido_ate | date | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_pessoa -> pessoa.id_pessoa

## Indices

- PRIMARY KEY (id_pessoa_telefone)
- KEY (id_pessoa)
- KEY (principal)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

