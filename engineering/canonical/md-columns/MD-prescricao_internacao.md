# MD-prescricao_internacao-colunas — Colunas

## Tabela: `prescricao_internacao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_prescricao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_internacao` | bigint | NOT NULL |
| `tipo` | enum('MEDICAMENTO','CUIDADO','DIETA','OUTROS') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `descricao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `id_medico` | bigint | NOT NULL |
| `ativa` | tinyint(1) | DEFAULT '1' |
| `data_hora` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_prescricao`),
KEY `id_internacao` (`id_internacao`),
KEY `id_medico` (`id_medico`),
CONSTRAINT `prescricao_internacao_ibfk_1` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
CONSTRAINT `prescricao_internacao_ibfk_2` FOREIGN KEY (`id_medico`) REFERENCES `medico` (`id_usuario`)
/*!40000 ALTER TABLE `prescricao_internacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `prescricao_internacao` ENABLE KEYS */;
