# MD-dispositivo-colunas — Colunas

## Tabela: `dispositivo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_dispositivo` | bigint | NOT NULL AUTO_INCREMENT |
| `identificador` | varchar(120) | NOT NULL |
| `descricao` | varchar(120) | DEFAULT NULL |
| `tipo` | varchar(50) | DEFAULT NULL |
| `ip_registro` | varchar(45) | DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_dispositivo`),
UNIQUE KEY `uk_dispositivo_identificador` (`identificador`)
/*!40000 ALTER TABLE `dispositivo` DISABLE KEYS */;
/*!40000 ALTER TABLE `dispositivo` ENABLE KEYS */;
