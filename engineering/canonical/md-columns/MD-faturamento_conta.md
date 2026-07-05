# MD-faturamento_conta-colunas — Colunas

## Tabela: `faturamento_conta`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_conta` | bigint | NOT NULL AUTO_INCREMENT |
| `tipo_conta` | enum('FFA','INTERNACAO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `id_ffa` | bigint | DEFAULT NULL |
| `id_internacao` | bigint | DEFAULT NULL |
| `status` | enum('ABERTA','EM_REVISAO','EM_AUDITORIA','FECHADA','CANCELADA') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ABERTA' |
| `valor_total` | decimal(12,2) | DEFAULT '0.00' |
| `aberta_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `fechada_em` | datetime | DEFAULT NULL |
| `fechado_por` | bigint | DEFAULT NULL |
| `numero_conta` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `competencia` | char(7) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `id_senha` | bigint | DEFAULT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_local_operacional` | bigint | DEFAULT NULL |
| `total_bruto` | decimal(10,2) | NOT NULL DEFAULT '0.00' |
| `total_desconto` | decimal(10,2) | NOT NULL DEFAULT '0.00' |
| `total_liquido` | decimal(10,2) | NOT NULL DEFAULT '0.00' |
| `observacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `id_sessao_usuario_criacao` | bigint | DEFAULT NULL |
| `criado_por` | bigint | DEFAULT NULL |
| `atualizado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `cancelado_em` | datetime | DEFAULT NULL |
| `cancelado_por` | bigint | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_conta`),
KEY `fk_fat_conta_ffa` (`id_ffa`),
KEY `idx_fat_conta_numero` (`numero_conta`),
KEY `idx_fat_conta_comp` (`competencia`),
KEY `idx_fat_conta_senha` (`id_senha`),
KEY `idx_fat_conta_unidade` (`id_unidade`),
KEY `idx_fat_conta_local` (`id_local_operacional`),
KEY `idx_fat_conta_sessao_criacao` (`id_sessao_usuario_criacao`),
KEY `idx_fat_conta_criado_por` (`criado_por`),
KEY `idx_fat_conta_cancelado_por` (`cancelado_por`),
CONSTRAINT `fk_faturamento_conta_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `faturamento_conta` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_conta` ENABLE KEYS */;
