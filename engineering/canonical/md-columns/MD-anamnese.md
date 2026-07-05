# MD-anamnese-colunas — Colunas

## Tabela: `anamnese`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_anamnese` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned DEFAULT NULL |
| `descricao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `id_usuario` | bigint | DEFAULT NULL |
| `data_hora` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_anamnese`),
KEY `id_atendimento` (`id_atendimento`),
KEY `id_usuario` (`id_usuario`),
CONSTRAINT `anamnese_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`),
CONSTRAINT `fk_anamnese_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE RESTRICT ON UPDATE CASCADE
/*!40000 ALTER TABLE `anamnese` DISABLE KEYS */;
/*!40000 ALTER TABLE `anamnese` ENABLE KEYS */;
