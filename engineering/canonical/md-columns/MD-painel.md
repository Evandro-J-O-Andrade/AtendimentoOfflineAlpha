# MD-painel-colunas — Colunas

## Tabela: `painel`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_painel` | bigint | NOT NULL AUTO_INCREMENT |
| `codigo` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL |
| `tipo` | enum('PAINEL','TOTEM','TV') | CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'PAINEL' |
| `nome` | varchar(120) | CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL |
| `descricao` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_local_operacional` | bigint | DEFAULT NULL |
| `tts_habilitado` | tinyint(1) | NOT NULL DEFAULT '0' |
| `piscada_seg` | int | NOT NULL DEFAULT '20' |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT NULL |
| `intervalo_segundos` | int | NOT NULL DEFAULT '120' |
| `id_sistema` | bigint | DEFAULT NULL |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_painel`),
UNIQUE KEY `uk_painel_codigo` (`codigo`),
KEY `idx_painel_unidade` (`id_unidade`),
KEY `idx_painel_local` (`id_local_operacional`),
CONSTRAINT `fk_painel_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `painel` DISABLE KEYS */;
/*!40000 ALTER TABLE `painel` ENABLE KEYS */;
