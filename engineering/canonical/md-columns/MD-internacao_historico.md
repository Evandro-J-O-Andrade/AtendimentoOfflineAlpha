# MD-internacao_historico-colunas — Colunas

## Tabela: `internacao_historico`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_internacao` | bigint | NOT NULL |
| `evento` | enum('ENTRADA','TROCA_LEITO','ALTA','TRANSFERENCIA','OBITO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `descricao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `id_usuario` | bigint | DEFAULT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `id_local_operacional` | bigint | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `idx_internacao` (`id_internacao`),
KEY `idx_intern_hist_internacao_data` (`id_internacao`,`criado_em`)
/*!40000 ALTER TABLE `internacao_historico` DISABLE KEYS */;
/*!40000 ALTER TABLE `internacao_historico` ENABLE KEYS */;
