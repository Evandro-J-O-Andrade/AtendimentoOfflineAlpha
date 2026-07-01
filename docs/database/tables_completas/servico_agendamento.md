# servico_agendamento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_servico | bigint | NOT NULL | - | (Documentar) |
| id_sistema | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| codigo | varchar(50) | NOT NULL | - | (Documentar) |
| nome | varchar(120) | NOT NULL | - | (Documentar) |
| duracao_minutos | int | NOT NULL | - | (Documentar) |
| categoria | varchar(30) | YES | - | (Documentar) |
| tipo | enum('CONSULTA' | NOT NULL | - | (Documentar) |
| exige_profissional | tinyint(1) | NOT NULL | - | (Documentar) |
| ativo | tinyint(1) | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_sistema,id_unidade,codigo)
- Estrangeira: id_unidade -> unidade.id_unidade
- Estrangeira: id_sistema -> sistema.id_sistema

## Indices

- PRIMARY KEY (id_servico)
- KEY (id_sistema,id_unidade,codigo)
- KEY (id_sistema,id_unidade)
- KEY (id_unidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

