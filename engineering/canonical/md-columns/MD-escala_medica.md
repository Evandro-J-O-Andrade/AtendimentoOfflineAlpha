# MD-escala_medica-colunas — Colunas

## Tabela: `escala_medica`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario_medico` | bigint | NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `data_plantao` | date | NOT NULL |
| `turno` | enum('MANHA','TARDE','NOITE','24H') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `status_presenca` | enum('PREVISTO','CONFIRMADO','FALTOU','SUBSTITUIDO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'PREVISTO' |
| `id_substituto` | bigint | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `idx_escala_dia` (`data_plantao`,`id_unidade`),
KEY `fk_escala_medica_unidade` (`id_unidade`),
CONSTRAINT `fk_escala_medica_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `escala_medica` DISABLE KEYS */;
/*!40000 ALTER TABLE `escala_medica` ENABLE KEYS */;
