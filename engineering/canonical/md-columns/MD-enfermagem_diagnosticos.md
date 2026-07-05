# MD-enfermagem_diagnosticos-colunas — Colunas

## Tabela: `enfermagem_diagnosticos`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `diagnostico_selecionado` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `tipo` | enum('HISTORICO','EXAME_FISICO','DIAGNOSTICO','PRESCRICAO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `observacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `id_usuario` | bigint | NOT NULL |
| `data_hora` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `idx_ffa_diagnostico` (`id_ffa`)
/*!40000 ALTER TABLE `enfermagem_diagnosticos` DISABLE KEYS */;
/*!40000 ALTER TABLE `enfermagem_diagnosticos` ENABLE KEYS */;
