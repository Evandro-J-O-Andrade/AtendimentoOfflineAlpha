# MD-triagem-colunas — Colunas

## Tabela: `triagem`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_triagem` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_risco` | int | NOT NULL |
| `queixa` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `sinais_vitais` | json | DEFAULT NULL |
| `observacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `id_enfermeiro` | bigint | NOT NULL |
| `data_hora` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_triagem`),
UNIQUE KEY `uk_triagem_atendimento` (`id_atendimento`),
KEY `id_risco` (`id_risco`),
KEY `id_enfermeiro` (`id_enfermeiro`),
KEY `idx_tri_ent` (`id_entidade`),
CONSTRAINT `fk_triagem_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_triagem_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `triagem_ibfk_2` FOREIGN KEY (`id_risco`) REFERENCES `classificacao_risco` (`id_risco`),
CONSTRAINT `triagem_ibfk_3` FOREIGN KEY (`id_enfermeiro`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `triagem` DISABLE KEYS */;
/*!40000 ALTER TABLE `triagem` ENABLE KEYS */;
