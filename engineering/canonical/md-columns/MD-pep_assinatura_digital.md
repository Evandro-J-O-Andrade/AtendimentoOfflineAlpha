# MD-pep_assinatura_digital-colunas — Colunas

## Tabela: `pep_assinatura_digital`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | NOT NULL |
| `hash_conteudo` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `assinatura_base64` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `data_assinatura` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `idx_pep_assinatura` (`id_atendimento`)
/*!40000 ALTER TABLE `pep_assinatura_digital` DISABLE KEYS */;
/*!40000 ALTER TABLE `pep_assinatura_digital` ENABLE KEYS */;
