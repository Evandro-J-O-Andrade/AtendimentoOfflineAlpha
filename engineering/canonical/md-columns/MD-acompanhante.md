# MD-acompanhante-colunas — Colunas

## Tabela: `acompanhante`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_acompanhante` | bigint | NOT NULL AUTO_INCREMENT |
| `id_pessoa` | bigint | NOT NULL |
| `id_ffa` | bigint | NOT NULL |
| `tipo` | enum('PAI','MAE','RESPONSAVEL_LEGAL','ACOMPANHANTE','OUTRO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `observacao` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_acompanhante`),
UNIQUE KEY `uk_acompanhante_por_ffa` (`id_pessoa`,`id_ffa`),
KEY `id_ffa` (`id_ffa`),
CONSTRAINT `acompanhante_ibfk_1` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`)
/*!40000 ALTER TABLE `acompanhante` DISABLE KEYS */;
/*!40000 ALTER TABLE `acompanhante` ENABLE KEYS */;
