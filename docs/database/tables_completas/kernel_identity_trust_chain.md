# kernel_identity_trust_chain

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_chain | bigint | NOT NULL | - | (Documentar) |
| id_tenant | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_sessao | bigint | YES | - | (Documentar) |
| id_dispositivo | bigint | YES | - | (Documentar) |
| ip_origem | varchar(45) | YES | - | (Documentar) |
| user_agent | varchar(500) | YES | - | (Documentar) |
| fingerprint_runtime | char(64) | NOT NULL | - | (Documentar) |
| fingerprint_behavior | char(64) | YES | - | (Documentar) |
| fingerprint_device | char(64) | YES | - | (Documentar) |
| estado_runtime | varchar(60) | NOT NULL | - | (Documentar) |
| score_risco | int | YES | - | (Documentar) |
| limite_risco | int | YES | - | (Documentar) |
| tentativas | int | YES | - | (Documentar) |
| janela_tentativa | int | YES | - | (Documentar) |
| bloqueado | tinyint | YES | - | (Documentar) |
| ativo | tinyint | YES | - | (Documentar) |
| nonce_runtime | char(64) | YES | - | (Documentar) |
| lineage_hash | char(64) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (nonce_runtime)

## Indices

- PRIMARY KEY (id_chain)
- KEY (nonce_runtime)
- KEY (fingerprint_runtime)
- KEY (fingerprint_behavior)
- KEY (fingerprint_device)
- KEY (id_usuario)
- KEY (id_tenant,id_usuario)
- KEY (id_sessao)
- KEY (id_dispositivo)
- KEY (bloqueado,ativo)
- KEY (score_risco)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

