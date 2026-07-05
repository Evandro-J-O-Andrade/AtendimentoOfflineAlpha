# MD-intercorrencia-colunas — Colunas

## Tabela: `intercorrencia`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_intercorrencia` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_internacao` | bigint | DEFAULT NULL |
| `descricao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `gravidade` | enum('LEVE','MODERADA','GRAVE') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'LEVE' |
| `id_usuario` | bigint | NOT NULL |
| `data_hora` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_intercorrencia`),
KEY `id_usuario` (`id_usuario`),
KEY `idx_intercorrencia_atendimento` (`id_atendimento`),
KEY `idx_intercorrencia_internacao` (`id_internacao`),
CONSTRAINT `intercorrencia_ibfk_2` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
CONSTRAINT `intercorrencia_ibfk_3` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `intercorrencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `intercorrencia` ENABLE KEYS */;
