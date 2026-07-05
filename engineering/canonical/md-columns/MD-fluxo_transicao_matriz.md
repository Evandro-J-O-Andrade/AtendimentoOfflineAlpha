# MD-fluxo_transicao_matriz-colunas — Colunas

## Tabela: `fluxo_transicao_matriz`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_fluxo_transicao` | bigint | NOT NULL AUTO_INCREMENT |
| `dominio_fluxo` | varchar(40) | NOT NULL |
| `acao` | varchar(100) | NOT NULL |
| `estado_origem` | varchar(40) | NOT NULL |
| `estado_destino` | varchar(40) | NOT NULL |
| `id_perfil` | bigint | DEFAULT NULL |
| `tipo_local` | varchar(40) | DEFAULT NULL |
| `prioridade` | int | DEFAULT '0' |
| `criado_em` | datetime(6) | NOT NULL DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_fluxo_transicao`),
KEY `idx_fluxo` (`dominio_fluxo`,`estado_origem`,`estado_destino`),
KEY `idx_acao` (`acao`),
KEY `idx_ativo` (`ativo`)
/*!40000 ALTER TABLE `fluxo_transicao_matriz` DISABLE KEYS */;
/*!40000 ALTER TABLE `fluxo_transicao_matriz` ENABLE KEYS */;
