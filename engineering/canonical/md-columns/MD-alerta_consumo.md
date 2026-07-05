# MD-alerta_consumo-colunas — Colunas

## Tabela: `alerta_consumo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_alerta_consumo` | bigint | NOT NULL AUTO_INCREMENT |
| `id_alerta` | bigint | NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `acao` | enum('LIDO','ASSUMIDO','RESOLVIDO','CANCELADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'LIDO' |
| `observacao` | varchar(240) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_alerta_consumo`),
UNIQUE KEY `ux_alerta_consumo` (`id_alerta`,`id_usuario`),
KEY `idx_alerta_consumo_alerta` (`id_alerta`),
KEY `idx_alerta_consumo_usuario` (`id_usuario`),
KEY `idx_alerta_consumo_acao` (`acao`),
KEY `fk_alerta_consumo_sessao` (`id_sessao_usuario`),
CONSTRAINT `fk_alerta_consumo_alerta` FOREIGN KEY (`id_alerta`) REFERENCES `alerta` (`id_alerta`) ON DELETE CASCADE,
CONSTRAINT `fk_alerta_consumo_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`),
CONSTRAINT `fk_alerta_consumo_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `alerta_consumo` DISABLE KEYS */;
/*!40000 ALTER TABLE `alerta_consumo` ENABLE KEYS */;
