# tenant_registry

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_tenant | bigint | NOT NULL | - | (Documentar) |
| uuid_tenant | char(36) | NOT NULL | - | (Documentar) |
| nome_fantasia | varchar(200) | NOT NULL | - | (Documentar) |
| razao_social | varchar(300) | NOT NULL | - | (Documentar) |
| cnpj | varchar(20) | YES | - | (Documentar) |
| cnes | varchar(20) | YES | - | (Documentar) |
| instancia_primary | tinyint(1) | YES | - | (Documentar) |
| regiao | varchar(50) | YES | - | (Documentar) |
| pais | varchar(50) | YES | - | (Documentar) |
| status | enum('ATIVO' | YES | - | (Documentar) |
| created_at | datetime(6) | YES | - | (Documentar) |
| updated_at | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (uuid_tenant)
- Unica: UNIQUE KEY (cnes)

## Indices

- PRIMARY KEY (id_tenant)
- KEY (uuid_tenant)
- KEY (cnes)
- KEY (status)
- KEY (regiao)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

