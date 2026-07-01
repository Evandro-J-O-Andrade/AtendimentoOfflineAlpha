# rh_registro_profissional

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_registro | bigint | NOT NULL | - | (Documentar) |
| id_pessoa | bigint | NOT NULL | - | (Documentar) |
| conselho | enum('CRM' | NOT NULL | - | (Documentar) |
| numero | varchar(30) | NOT NULL | - | (Documentar) |
| uf | char(2) | YES | - | (Documentar) |
| uf_norm | char(2) | YES | - | (Documentar) |
| especialidade | varchar(120) | YES | - | (Documentar) |
| validade | date | YES | - | (Documentar) |
| status | enum('ATIVO' | NOT NULL | - | (Documentar) |
| origem | enum('MANUAL' | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (conselho,numero,uf_norm)

## Indices

- PRIMARY KEY (id_registro)
- KEY (conselho,numero,uf_norm)
- KEY (id_pessoa)
- KEY (status)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

