# atendimento_estado_ativo

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| id_local_atual | bigint | NOT NULL | - | (Documentar) |
| id_leito | bigint | YES | - | (Documentar) |
| tipo_estado | enum('FILA_ESPERA' | NOT NULL | - | (Documentar) |
| id_sessao_ultimo_movimento | bigint | NOT NULL | - | (Documentar) |
| atualizado_em | timestamp | YES | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade
- Estrangeira: id_local_atual -> local_operacional.id_local_operacional

## Indices

- PRIMARY KEY (id_ffa)
- KEY (id_local_atual)
- KEY (id_sessao_ultimo_movimento)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

