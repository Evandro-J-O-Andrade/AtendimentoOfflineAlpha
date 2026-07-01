# assistencial_runtime_federado

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_snapshot | bigint | NOT NULL | - | (Documentar) |
| id_sistema | bigint | NOT NULL | - | (Documentar) |
| hash_runtime | char(64) | YES | - | (Documentar) |
| payload_json | json | YES | - | (Documentar) |
| sincronizado | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_snapshot)
- KEY (id_sistema,sincronizado)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

