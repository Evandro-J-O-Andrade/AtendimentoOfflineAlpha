# MD-evolucao_medica-colunas — Colunas

## Tabela: `evolucao_medica`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evolucao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_internacao` | bigint | NOT NULL |
| `descricao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `id_medico` | bigint | NOT NULL |
| `data_hora` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evolucao`),
KEY `id_internacao` (`id_internacao`),
KEY `id_medico` (`id_medico`),
CONSTRAINT `evolucao_medica_ibfk_1` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
CONSTRAINT `evolucao_medica_ibfk_2` FOREIGN KEY (`id_medico`) REFERENCES `medico` (`id_usuario`)
/*!40000 ALTER TABLE `evolucao_medica` DISABLE KEYS */;
/*!40000 ALTER TABLE `evolucao_medica` ENABLE KEYS */;
