# MD-hipotese_diagnostica-colunas — Colunas

## Tabela: `hipotese_diagnostica`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_hipotese` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `cid10` | varchar(10) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `principal` | tinyint(1) | DEFAULT '0' |
| `id_medico` | bigint | DEFAULT NULL |
| `data_hora` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_hipotese`),
KEY `id_atendimento` (`id_atendimento`),
KEY `id_medico` (`id_medico`),
CONSTRAINT `hipotese_diagnostica_ibfk_2` FOREIGN KEY (`id_medico`) REFERENCES `medico` (`id_usuario`)
/*!40000 ALTER TABLE `hipotese_diagnostica` DISABLE KEYS */;
/*!40000 ALTER TABLE `hipotese_diagnostica` ENABLE KEYS */;
