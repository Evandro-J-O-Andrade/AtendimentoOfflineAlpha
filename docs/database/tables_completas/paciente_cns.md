# paciente_cns

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_paciente_cns | bigint | NOT NULL | - | (Documentar) |
| id_paciente | bigint | NOT NULL | - | (Documentar) |
| cns | varchar(20) | NOT NULL | - | (Documentar) |
| status | enum('ATIVO' | NOT NULL | - | (Documentar) |
| validado | tinyint(1) | NOT NULL | - | (Documentar) |
| origem | enum('MANUAL' | NOT NULL | - | (Documentar) |
| data_validacao | datetime | YES | - | (Documentar) |
| observacao | varchar(255) | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_paciente,cns,status)

## Indices

- PRIMARY KEY (id_paciente_cns)
- KEY (id_paciente,cns,status)
- KEY (id_paciente)
- KEY (cns)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

