# MD-administracao_medicacao-colunas — Colunas

## Tabela: `administracao_medicacao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_admin` | bigint | NOT NULL AUTO_INCREMENT |
| `id_prescricao` | bigint | NOT NULL |
| `id_enfermeiro` | bigint | NOT NULL |
| `dose` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `via` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `data_hora` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `observacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_admin`),
KEY `id_prescricao` (`id_prescricao`),
KEY `id_enfermeiro` (`id_enfermeiro`),
CONSTRAINT `administracao_medicacao_ibfk_1` FOREIGN KEY (`id_prescricao`) REFERENCES `prescricao_internacao` (`id_prescricao`),
CONSTRAINT `administracao_medicacao_ibfk_2` FOREIGN KEY (`id_enfermeiro`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `administracao_medicacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `administracao_medicacao` ENABLE KEYS */;
