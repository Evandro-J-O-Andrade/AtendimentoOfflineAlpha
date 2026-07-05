# MD-auditoria_visualizacao_prontuario-colunas — Colunas

## Tabela: `auditoria_visualizacao_prontuario`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | NOT NULL |
| `id_atendimento` | bigint | NOT NULL |
| `ip_acesso` | varchar(45) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `data_hora` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `contexto` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`)
/*!40000 ALTER TABLE `auditoria_visualizacao_prontuario` DISABLE KEYS */;
/*!40000 ALTER TABLE `auditoria_visualizacao_prontuario` ENABLE KEYS */;
