# MD-assinatura_digital_documentos-colunas — Colunas

## Tabela: `assinatura_digital_documentos`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_registro_clinico` | bigint | NOT NULL |
| `tipo_documento` | enum('EVOLUCAO','RECEITA','LAUDO','ALTA') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `hash_assinatura` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `certificado_serial` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `data_assinatura` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`)
/*!40000 ALTER TABLE `assinatura_digital_documentos` DISABLE KEYS */;
/*!40000 ALTER TABLE `assinatura_digital_documentos` ENABLE KEYS */;
