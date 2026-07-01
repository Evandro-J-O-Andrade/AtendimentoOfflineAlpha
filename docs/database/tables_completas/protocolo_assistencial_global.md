# protocolo_assistencial_global

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_protocolo | bigint | NOT NULL | - | (Documentar) |
| dominio_fluxo | varchar(50) | NOT NULL | - | (Documentar) |
| versao_protocolo | bigint | NOT NULL | - | (Documentar) |
| hash_protocolar | char(64) | NOT NULL | - | (Documentar) |
| payload_protocolo | json | NOT NULL | - | (Documentar) |
| estado_protocolo | enum('ATIVO' | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (hash_protocolar)
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_protocolo)
- KEY (hash_protocolar)
- KEY (dominio_fluxo,versao_protocolo)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

