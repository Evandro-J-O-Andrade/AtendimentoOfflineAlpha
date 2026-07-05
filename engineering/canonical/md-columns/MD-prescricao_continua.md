# MD-prescricao_continua-colunas — Colunas

## Tabela: `prescricao_continua`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_prescricao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `tipo` | enum('MEDICAMENTOS','CUIDADOS_GERAIS') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `id_medico` | bigint | NOT NULL |
| `data_hora` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `ativa` | tinyint(1) | DEFAULT '1' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_prescricao`),
KEY `id_atendimento` (`id_atendimento`),
KEY `id_medico` (`id_medico`),
CONSTRAINT `prescricao_continua_ibfk_2` FOREIGN KEY (`id_medico`) REFERENCES `medico` (`id_usuario`)
/*!40000 ALTER TABLE `prescricao_continua` DISABLE KEYS */;
/*!40000 ALTER TABLE `prescricao_continua` ENABLE KEYS */;
