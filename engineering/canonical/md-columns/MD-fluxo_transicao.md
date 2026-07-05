# MD-fluxo_transicao-colunas — Colunas

## Tabela: `fluxo_transicao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_fluxo_transicao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_contrato` | bigint | NOT NULL |
| `id_status_origem` | bigint | NOT NULL |
| `id_status_destino` | bigint | NOT NULL |
| `id_perfil_requerido` | bigint | NOT NULL |
| `obriga_justificativa` | tinyint(1) | NOT NULL DEFAULT '0' |
| `bloqueia_retrocesso` | tinyint(1) | NOT NULL DEFAULT '0' |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `criado_em` | datetime(6) | NOT NULL DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_fluxo_transicao`),
UNIQUE KEY `uk_fluxo_regra` (`id_contrato`,`id_status_origem`,`id_status_destino`,`id_perfil_requerido`),
KEY `idx_fluxo_contrato` (`id_contrato`),
KEY `idx_fluxo_origem` (`id_status_origem`),
KEY `idx_fluxo_destino` (`id_status_destino`),
KEY `idx_fluxo_perfil` (`id_perfil_requerido`),
CONSTRAINT `fk_fluxo_destino` FOREIGN KEY (`id_status_destino`) REFERENCES `fluxo_status` (`id_fluxo_status`),
CONSTRAINT `fk_fluxo_origem` FOREIGN KEY (`id_status_origem`) REFERENCES `fluxo_status` (`id_fluxo_status`),
CONSTRAINT `fk_fluxo_perfil` FOREIGN KEY (`id_perfil_requerido`) REFERENCES `perfil` (`id_perfil`)
/*!40000 ALTER TABLE `fluxo_transicao` DISABLE KEYS */;
/*!40000 ALTER TABLE `fluxo_transicao` ENABLE KEYS */;
