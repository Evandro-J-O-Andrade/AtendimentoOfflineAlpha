# fluxo_transicao_matriz

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_fluxo_transicao | bigint | NOT NULL | - | (Documentar) |
| dominio_fluxo | varchar(40) | NOT NULL | - | (Documentar) |
| acao | varchar(100) | NOT NULL | - | (Documentar) |
| estado_origem | varchar(40) | NOT NULL | - | (Documentar) |
| estado_destino | varchar(40) | NOT NULL | - | (Documentar) |
| id_perfil | bigint | YES | - | (Documentar) |
| tipo_local | varchar(40) | YES | - | (Documentar) |
| exige_painel | tinyint | YES | - | (Documentar) |
| exige_sessao_ativa | tinyint | YES | - | (Documentar) |
| prioridade | int | YES | - | (Documentar) |
| ativo | tinyint | YES | - | (Documentar) |
| criado_em | datetime(6) | NOT NULL | - | (Documentar) |
| id_entidade | bigint | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_fluxo_transicao)
- KEY (dominio_fluxo,estado_origem,estado_destino)
- KEY (acao)
- KEY (ativo)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

