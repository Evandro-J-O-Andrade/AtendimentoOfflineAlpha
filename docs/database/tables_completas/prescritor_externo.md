# prescritor_externo

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_prescritor_externo | bigint | NOT NULL | - | (Documentar) |
| nome | varchar(150) | NOT NULL | - | (Documentar) |
| conselho | enum('CRM' | NOT NULL | - | (Documentar) |
| numero_conselho | varchar(30) | NOT NULL | - | (Documentar) |
| uf | char(2) | YES | - | (Documentar) |
| documento | varchar(30) | YES | - | (Documentar) |
| telefone | varchar(30) | YES | - | (Documentar) |
| ativo | tinyint(1) | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (conselho,numero_conselho,uf)

## Indices

- PRIMARY KEY (id_prescritor_externo)
- KEY (conselho,numero_conselho,uf)
- KEY (nome)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

