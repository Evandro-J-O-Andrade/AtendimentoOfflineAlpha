# MD-totem-colunas — Colunas

## Tabela: `totem`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_totem` | bigint | NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned NOT NULL |
| `codigo` | varchar(50) | NOT NULL |
| `descricao` | varchar(150) | DEFAULT NULL |
| `ip` | varchar(45) | DEFAULT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_totem`),
UNIQUE KEY `uk_totem` (`id_unidade`,`codigo`),
CONSTRAINT `fk_totem_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `totem` DISABLE KEYS */;
/*!40000 ALTER TABLE `totem` ENABLE KEYS */;
