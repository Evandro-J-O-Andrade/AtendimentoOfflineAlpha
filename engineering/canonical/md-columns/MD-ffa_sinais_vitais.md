# MD-ffa_sinais_vitais-colunas — Colunas

## Tabela: `ffa_sinais_vitais`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_sinais` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `id_fila` | bigint | DEFAULT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `id_local_operacional` | bigint | DEFAULT NULL |
| `id_usuario` | bigint | NOT NULL |
| `data_coleta` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `pressao_sistolica` | int | DEFAULT NULL |
| `pressao_diastolica` | int | DEFAULT NULL |
| `freq_cardiaca` | int | DEFAULT NULL |
| `freq_respiratoria` | int | DEFAULT NULL |
| `temperatura` | decimal(4,1) | DEFAULT NULL |
| `saturacao` | int | DEFAULT NULL |
| `glicemia` | int | DEFAULT NULL |
| `observacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_sinais`),
KEY `idx_ffa_sinais_ffa` (`id_ffa`,`data_coleta`),
KEY `idx_ffa_sinais_sessao` (`id_sessao_usuario`),
KEY `idx_ffa_sinais_usuario` (`id_usuario`,`data_coleta`),
KEY `fk_ffa_sinais_local` (`id_local_operacional`),
CONSTRAINT `fk_ffa_sinais_local` FOREIGN KEY (`id_local_operacional`) REFERENCES `local_operacional` (`id_local_operacional`),
CONSTRAINT `fk_ffa_sinais_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `ffa_sinais_vitais` DISABLE KEYS */;
/*!40000 ALTER TABLE `ffa_sinais_vitais` ENABLE KEYS */;
