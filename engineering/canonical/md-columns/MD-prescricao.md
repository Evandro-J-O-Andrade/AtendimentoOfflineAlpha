# MD-prescricao-colunas — Colunas

## Tabela: `prescricao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_prescricao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `tipo` | enum('INTERNA','CONTROLADA','CASA') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `descricao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `id_medico` | bigint | DEFAULT NULL |
| `data_hora` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `bloqueada` | tinyint(1) | DEFAULT '0' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_prescricao`),
KEY `id_atendimento` (`id_atendimento`),
KEY `id_medico` (`id_medico`),
CONSTRAINT `prescricao_ibfk_2` FOREIGN KEY (`id_medico`) REFERENCES `medico` (`id_usuario`)
/*!40000 ALTER TABLE `prescricao` DISABLE KEYS */;
/*!40000 ALTER TABLE `prescricao` ENABLE KEYS */;
