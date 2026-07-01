# profissional_registro

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_profissional_registro | bigint | NOT NULL | - | (Documentar) |
| id_funcionario | bigint | NOT NULL | - | (Documentar) |
| tipo_conselho | enum('CRM' | NOT NULL | - | (Documentar) |
| numero_registro | varchar(50) | NOT NULL | - | (Documentar) |
| uf_registro | char(2) | NOT NULL | - | (Documentar) |
| data_emissao | date | YES | - | (Documentar) |
| data_validade | date | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_funcionario -> funcionario.id_funcionario

## Indices

- PRIMARY KEY (id_profissional_registro)
- KEY (id_funcionario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

