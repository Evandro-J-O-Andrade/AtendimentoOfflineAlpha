# MD-painel_mensagem_consumo-colunas — Colunas

## Tabela: `painel_mensagem_consumo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_consumo` | bigint | NOT NULL AUTO_INCREMENT |
| `id_mensagem` | bigint | NOT NULL |
| `id_painel` | bigint | NOT NULL |
| `consumido_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `consumido_por` | varchar(80) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_consumo`),
UNIQUE KEY `uk_msg_consumo` (`id_mensagem`,`id_painel`),
KEY `idx_consumo_painel` (`id_painel`,`consumido_em`),
CONSTRAINT `fk_consumo_msg` FOREIGN KEY (`id_mensagem`) REFERENCES `painel_mensagem` (`id_mensagem`),
CONSTRAINT `fk_consumo_painel` FOREIGN KEY (`id_painel`) REFERENCES `painel` (`id_painel`)
/*!40000 ALTER TABLE `painel_mensagem_consumo` DISABLE KEYS */;
/*!40000 ALTER TABLE `painel_mensagem_consumo` ENABLE KEYS */;
