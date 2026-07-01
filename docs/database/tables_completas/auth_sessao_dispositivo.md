# auth_sessao_dispositivo

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_dispositivo_confiavel | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| dispositivo_hash | varchar(255) | NOT NULL | - | (Documentar) |
| nome_dispositivo | varchar(100) | YES | - | (Documentar) |
| sistema_operacional | varchar(50) | YES | - | (Documentar) |
| navegador | varchar(50) | YES | - | (Documentar) |
| ultimo_ip | varchar(45) | YES | - | (Documentar) |
| ultimo_acesso | datetime | YES | - | (Documentar) |
| primeiro_acesso | datetime | YES | - | (Documentar) |
| confiavel | tinyint(1) | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_dispositivo_confiavel)
- KEY (id_usuario)
- KEY (dispositivo_hash)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

