# MD-ffa_procedimento-colunas — Colunas

## Tabela: `ffa_procedimento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_procedimento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `tipo` | enum('RX','ECG','LABORATORIO','MEDICACAO','OBSERVACAO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `status` | enum('SOLICITADO','EM_FILA','EM_EXECUCAO','CONCLUIDO','CRITICO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'SOLICITADO' |
| `prioridade` | enum('NORMAL','EMERGENCIA') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'NORMAL' |
| `id_usuario_solicitante` | bigint | DEFAULT NULL |
| `id_usuario_execucao` | bigint | DEFAULT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `iniciado_em` | datetime | DEFAULT NULL |
| `finalizado_em` | datetime | DEFAULT NULL |
| `observacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_procedimento`),
KEY `idx_ffa` (`id_ffa`),
KEY `idx_status` (`status`)
/*!40000 ALTER TABLE `ffa_procedimento` DISABLE KEYS */;
/*!40000 ALTER TABLE `ffa_procedimento` ENABLE KEYS */;
