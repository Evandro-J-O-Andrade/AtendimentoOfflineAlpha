# MD-lab_resultado-colunas — Colunas

## Tabela: `lab_resultado`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_resultado` | bigint | NOT NULL AUTO_INCREMENT |
| `protocolo_interno` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `id_ffa` | bigint | NOT NULL |
| `resultado_link` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `resultado_texto` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `critico` | tinyint(1) | NOT NULL DEFAULT '0' |
| `recebido_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `id_usuario` | bigint | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_resultado`),
KEY `idx_lab_res_protocolo` (`protocolo_interno`),
KEY `idx_lab_res_ffa` (`id_ffa`)
/*!40000 ALTER TABLE `lab_resultado` DISABLE KEYS */;
/*!40000 ALTER TABLE `lab_resultado` ENABLE KEYS */;
