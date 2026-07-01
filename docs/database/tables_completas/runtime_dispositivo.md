# runtime_dispositivo

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_runtime_dispositivo | bigint | NOT NULL | - | (Documentar) |
| id_dispositivo | bigint | NOT NULL | - | (Documentar) |
| uuid_runtime | varchar(120) | NOT NULL | - | (Documentar) |
| tipo_runtime | varchar(40) | NOT NULL | - | (Documentar) |
| versao_runtime | varchar(40) | YES | - | (Documentar) |
| ip_runtime | varchar(45) | YES | - | (Documentar) |
| status_runtime | varchar(30) | YES | - | (Documentar) |
| ultimo_heartbeat | datetime(6) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (uuid_runtime)
- Estrangeira: id_dispositivo -> dispositivo.id_dispositivo

## Indices

- PRIMARY KEY (id_runtime_dispositivo)
- KEY (uuid_runtime)
- KEY (id_dispositivo)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

