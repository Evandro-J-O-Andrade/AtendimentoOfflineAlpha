# MD-tv_rotativo-colunas — Colunas

## Tabela: `tv_rotativo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_tv_rotativo` | bigint | NOT NULL AUTO_INCREMENT |
| `nome` | varchar(80) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `intervalo_seg` | int | NOT NULL DEFAULT '120' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `criado_por` | bigint | DEFAULT NULL |
| `atualizado_em` | datetime | DEFAULT NULL |
| `atualizado_por` | bigint | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_tv_rotativo`),
UNIQUE KEY `uk_tv_rotativo_nome` (`nome`),
KEY `fk_tv_rotativo_unidade` (`id_unidade`),
CONSTRAINT `fk_tv_rotativo_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `tv_rotativo` DISABLE KEYS */;
/*!40000 ALTER TABLE `tv_rotativo` ENABLE KEYS */;
