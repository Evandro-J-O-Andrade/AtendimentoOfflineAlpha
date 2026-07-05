# MD-escala_plantao_atual-colunas — Colunas

## Tabela: `escala_plantao_atual`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_setor` | int | DEFAULT NULL |
| `registro_profissional` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `data_inicio` | datetime | DEFAULT NULL |
| `data_fim` | datetime | DEFAULT NULL |
| `status_plantao` | enum('ATIVO','ENCERRADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'ATIVO' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `idx_plantao_ativo` (`id_usuario`,`status_plantao`),
KEY `fk_escala_plantao_atual_unidade` (`id_unidade`),
CONSTRAINT `fk_escala_plantao_atual_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `escala_plantao_atual` DISABLE KEYS */;
/*!40000 ALTER TABLE `escala_plantao_atual` ENABLE KEYS */;
