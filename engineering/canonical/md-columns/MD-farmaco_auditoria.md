# MD-farmaco_auditoria-colunas — Colunas

## Tabela: `farmaco_auditoria`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_auditoria` | bigint | NOT NULL AUTO_INCREMENT |
| `tabela` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `id_registro` | bigint | DEFAULT NULL |
| `acao` | enum('INSERT','UPDATE','DELETE') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `dados_antes` | json | DEFAULT NULL |
| `dados_depois` | json | DEFAULT NULL |
| `id_usuario` | bigint | DEFAULT NULL |
| `data_evento` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_auditoria`)
/*!40000 ALTER TABLE `farmaco_auditoria` DISABLE KEYS */;
/*!40000 ALTER TABLE `farmaco_auditoria` ENABLE KEYS */;
