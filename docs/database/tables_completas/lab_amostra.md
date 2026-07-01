# lab_amostra

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_amostra | bigint | NOT NULL | - | (Documentar) |
| id_protocolo | bigint | NOT NULL | - | (Documentar) |
| codigo_amostra | varchar(50) | NOT NULL | - | (Documentar) |
| tipo_material | varchar(50) | YES | - | (Documentar) |
| status | enum('GERADO' | NOT NULL | - | (Documentar) |
| impresso | tinyint(1) | NOT NULL | - | (Documentar) |
| coletado_em | datetime | YES | - | (Documentar) |
| id_sessao_coleta | bigint | YES | - | (Documentar) |
| id_usuario_coleta | bigint | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (codigo_amostra)
- Estrangeira: id_protocolo -> lab_protocolo.id_protocolo
- Estrangeira: id_protocolo -> procedimento_protocolo.id_protocolo
- Estrangeira: id_usuario_coleta -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_amostra)
- KEY (codigo_amostra)
- KEY (status,criado_em)
- KEY (id_sessao_coleta)
- KEY (id_usuario_coleta)
- KEY (id_protocolo,id_ffa)
- KEY (id_ffa)
- KEY (id_protocolo)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

