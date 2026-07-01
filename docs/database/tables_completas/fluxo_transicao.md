# fluxo_transicao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_fluxo_transicao | bigint | NOT NULL | - | (Documentar) |
| id_contrato | bigint | NOT NULL | - | (Documentar) |
| id_status_origem | bigint | NOT NULL | - | (Documentar) |
| id_status_destino | bigint | NOT NULL | - | (Documentar) |
| id_perfil_requerido | bigint | NOT NULL | - | (Documentar) |
| obriga_justificativa | tinyint(1) | NOT NULL | - | (Documentar) |
| bloqueia_retrocesso | tinyint(1) | NOT NULL | - | (Documentar) |
| ativo | tinyint(1) | NOT NULL | - | (Documentar) |
| criado_em | datetime(6) | NOT NULL | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_contrato,id_status_origem,id_status_destino,id_perfil_requerido)
- Estrangeira: id_status_destino -> fluxo_status.id_fluxo_status
- Estrangeira: id_status_origem -> fluxo_status.id_fluxo_status
- Estrangeira: id_perfil_requerido -> perfil.id_perfil

## Indices

- PRIMARY KEY (id_fluxo_transicao)
- KEY (id_contrato,id_status_origem,id_status_destino,id_perfil_requerido)
- KEY (id_contrato)
- KEY (id_status_origem)
- KEY (id_status_destino)
- KEY (id_perfil_requerido)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

