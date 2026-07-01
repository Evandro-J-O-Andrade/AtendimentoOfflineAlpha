# atendimento_evolucao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| escala_dor | int | YES | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| tipo_profissional | enum('MEDICO' | NOT NULL | - | (Documentar) |
| texto_evolucao | text | NOT NULL | - | (Documentar) |
| hash_seguranca | char(64) | YES | - | (Documentar) |
| ip_origem | varchar(45) | YES | - | (Documentar) |
| device_info | varchar(255) | YES | - | (Documentar) |
| criado_em | datetime(6) | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_unidade -> unidade.id_unidade
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id)
- KEY (id_ffa)
- KEY (id_usuario)
- KEY (id_sessao_usuario)
- KEY (id_atendimento)
- KEY (id_unidade)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

