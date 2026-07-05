# MD-escala_plantao-colunas — Colunas

## Tabela: `escala_plantao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_escala` | bigint | NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_sistema` | bigint | NOT NULL |
| `data` | date | NOT NULL |
| `id_plantao_modelo` | bigint | NOT NULL |
| `observacao` | varchar(255) | DEFAULT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_escala`),
KEY `idx_escala_data` (`id_unidade`,`data`),
KEY `fk_esc_sistema` (`id_sistema`),
KEY `fk_esc_pm` (`id_plantao_modelo`),
CONSTRAINT `fk_esc_pm` FOREIGN KEY (`id_plantao_modelo`) REFERENCES `plantao_modelo` (`id_plantao_modelo`),
CONSTRAINT `fk_esc_sistema` FOREIGN KEY (`id_sistema`) REFERENCES `sistema` (`id_sistema`),
CONSTRAINT `fk_escala_plantao_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `escala_plantao` DISABLE KEYS */;
/*!40000 ALTER TABLE `escala_plantao` ENABLE KEYS */;
