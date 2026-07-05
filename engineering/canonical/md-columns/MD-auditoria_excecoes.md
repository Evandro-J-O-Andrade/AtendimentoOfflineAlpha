# MD-auditoria_excecoes-colunas — Colunas

## Tabela: `auditoria_excecoes`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `id_paciente` | bigint | NOT NULL |
| `motivo` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `chamado_por` | varchar(200) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`)
/*!40000 ALTER TABLE `auditoria_excecoes` DISABLE KEYS */;
/*!40000 ALTER TABLE `auditoria_excecoes` ENABLE KEYS */;
