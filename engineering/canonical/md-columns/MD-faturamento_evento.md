# MD-faturamento_evento-colunas — Colunas

## Tabela: `faturamento_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_conta` | bigint | NOT NULL |
| `evento` | enum('ABERTURA','FECHAMENTO','REABERTURA','CANCELAMENTO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `observacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `tipo` | enum('ABRIR','ADICIONAR_ITEM','CANCELAR_ITEM','FECHAR','REABRIR','CANCELAR_CONTA','OBS') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `detalhe` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
KEY `idx_conta` (`id_conta`),
KEY `idx_fat_evt_sessao` (`id_sessao_usuario`),
KEY `idx_fat_evt_tipo` (`tipo`)
/*!40000 ALTER TABLE `faturamento_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_evento` ENABLE KEYS */;
