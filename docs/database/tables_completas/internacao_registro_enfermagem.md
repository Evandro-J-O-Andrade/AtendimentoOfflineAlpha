# internacao_registro_enfermagem

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_internacao_registro_enfermagem | bigint | NOT NULL | - | (Documentar) |
| id_internacao | bigint | NOT NULL | - | (Documentar) |
| data_hora | datetime | NOT NULL | - | (Documentar) |
| turno | enum('MANHA' | NOT NULL | - | (Documentar) |
| periodicidade | enum('2H' | NOT NULL | - | (Documentar) |
| pressao_arterial | varchar(10) | YES | - | (Documentar) |
| temperatura | decimal(4 | YES | - | (Documentar) |
| frequencia_cardiaca | int | YES | - | (Documentar) |
| frequencia_respiratoria | int | YES | - | (Documentar) |
| saturacao_o2 | int | YES | - | (Documentar) |
| glicemia | int | YES | - | (Documentar) |
| entradas_ml | int | YES | - | (Documentar) |
| saidas_ml | int | YES | - | (Documentar) |
| diurese_evacuacao | text | YES | - | (Documentar) |
| observacoes | text | YES | - | (Documentar) |
| id_usuario_responsavel | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade
- Estrangeira: id_internacao -> internacao.id_internacao
- Estrangeira: id_usuario_responsavel -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_internacao_registro_enfermagem)
- KEY (id_internacao)
- KEY (data_hora)
- KEY (id_usuario_responsavel)
- KEY (id_sessao_usuario)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

