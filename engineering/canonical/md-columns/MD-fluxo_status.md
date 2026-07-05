# MD-fluxo_status-colunas — Colunas

## Tabela: `fluxo_status`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_fluxo_status` | bigint | NOT NULL AUTO_INCREMENT |
| `codigo` | varchar(60) | NOT NULL |
| `descricao` | varchar(150) | NOT NULL |
| `tipo` | enum('INICIAL','OPERACIONAL','INTERMEDIARIO','FINAL') | NOT NULL |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `criado_em` | datetime(6) | NOT NULL DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_fluxo_status`),
UNIQUE KEY `uk_fluxo_status_codigo` (`codigo`)
/*!40000 ALTER TABLE `fluxo_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `fluxo_status` ENABLE KEYS */;
