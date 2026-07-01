# evento_ffa

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_evento | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| id_paciente | bigint | YES | - | (Documentar) |
| id_usuario | bigint | YES | - | (Documentar) |
| origem | enum('PAINEL_TOTEM' | NOT NULL | - | (Documentar) |
| tipo_evento | enum('GERAR_SENHA' | NOT NULL | - | (Documentar) |
| status_origem | enum('ABERTO' | YES | - | (Documentar) |
| status_destino | enum('ABERTO' | YES | - | (Documentar) |
| payload | json | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_evento)
- KEY (id_ffa)
- KEY (tipo_evento)
- KEY (origem)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

