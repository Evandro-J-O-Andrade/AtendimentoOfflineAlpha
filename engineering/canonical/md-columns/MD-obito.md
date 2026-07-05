# MD-obito-colunas — Colunas

## Tabela: `obito`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_obito` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `id_local_operacional` | bigint | DEFAULT NULL |
| `data_hora_obito` | datetime | NOT NULL |
| `id_usuario_responsavel` | bigint | NOT NULL |
| `evolucao_inicial` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `evolucao_final` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `observacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `status` | enum('REGISTRADO','CANCELADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'REGISTRADO' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT NULL |
| `cancelado_em` | datetime | DEFAULT NULL |
| `cancelado_por` | bigint | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_obito`),
UNIQUE KEY `uk_obito_ffa` (`id_ffa`),
KEY `idx_obito_data` (`data_hora_obito`),
KEY `idx_obito_status` (`status`),
KEY `idx_obito_sessao` (`id_sessao_usuario`),
KEY `idx_obito_ffa_status` (`id_ffa`,`status`)
/*!40000 ALTER TABLE `obito` DISABLE KEYS */;
/*!40000 ALTER TABLE `obito` ENABLE KEYS */;
