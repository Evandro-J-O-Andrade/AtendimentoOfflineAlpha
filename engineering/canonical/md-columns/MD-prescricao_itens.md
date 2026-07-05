# MD-prescricao_itens-colunas — Colunas

## Tabela: `prescricao_itens`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | NOT NULL |
| `id_usuario_prescritor` | bigint | NOT NULL |
| `tipo_item` | enum('MEDICAMENTO','DIETA','CUIDADO','OXIGENOTERAPIA','SOLUCAO_EV') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `descricao` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `posologia_detalhada` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `frequencia_horario` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `via_administracao` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `observacao_enfermagem` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `data_inicio` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `data_suspensao` | datetime | DEFAULT NULL |
| `status` | enum('ATIVO','SUSPENSO','CONCLUIDO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'ATIVO' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `idx_presc_tipo` (`id_atendimento`,`tipo_item`)
/*!40000 ALTER TABLE `prescricao_itens` DISABLE KEYS */;
/*!40000 ALTER TABLE `prescricao_itens` ENABLE KEYS */;
