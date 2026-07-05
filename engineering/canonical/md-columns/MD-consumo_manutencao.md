# MD-consumo_manutencao-colunas — Colunas

## Tabela: `consumo_manutencao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_consumo` | bigint | NOT NULL AUTO_INCREMENT |
| `id_chamado` | bigint | NOT NULL |
| `id_produto` | bigint | NOT NULL |
| `quantidade` | decimal(10,2) | NOT NULL |
| `unidade` | varchar(20) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `consumido_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `registrado_por` | bigint | NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_consumo`)
/*!40000 ALTER TABLE `consumo_manutencao` DISABLE KEYS */;
/*!40000 ALTER TABLE `consumo_manutencao` ENABLE KEYS */;
