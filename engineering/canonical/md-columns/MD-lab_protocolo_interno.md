# MD-lab_protocolo_interno-colunas — Colunas

## Tabela: `lab_protocolo_interno`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `codigo_amostra` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `tipo_material` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `status_laboratorial` | enum('COLETADO','EM_TRANSPORTE','NA_BANCADA','CONCLUIDO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `impresso` | tinyint(1) | DEFAULT '0' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
UNIQUE KEY `codigo_amostra` (`codigo_amostra`),
KEY `fk_lab_protocolo_ffa_v1` (`id_ffa`)
/*!40000 ALTER TABLE `lab_protocolo_interno` DISABLE KEYS */;
/*!40000 ALTER TABLE `lab_protocolo_interno` ENABLE KEYS */;
