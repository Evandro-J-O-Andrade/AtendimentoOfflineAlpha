# MD-prescricao_medica-colunas — Colunas

## Tabela: `prescricao_medica`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | NOT NULL |
| `id_usuario_medico` | bigint | NOT NULL |
| `item_nome` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `dose` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `via` | enum('EV','IM','VO','SC','TOPICA','INALATORIA') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `frequencia` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `status` | enum('ATIVA','SUSPENSA','CONCLUIDA') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'ATIVA' |
| `data_prescricao` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`)
/*!40000 ALTER TABLE `prescricao_medica` DISABLE KEYS */;
/*!40000 ALTER TABLE `prescricao_medica` ENABLE KEYS */;
