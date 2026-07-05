# MD-fila_painel_runtime-colunas — Colunas

## Tabela: `fila_painel_runtime`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | NOT NULL |
| `id_local` | bigint | DEFAULT NULL |
| `id_senha` | bigint | DEFAULT NULL |
| `codigo_visual` | varchar(20) | DEFAULT NULL |
| `status` | varchar(50) | DEFAULT NULL |
| `prioridade` | int | DEFAULT NULL |
| `atualizado_em` | datetime(6) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `idx_unidade` (`id_unidade`),
KEY `idx_local` (`id_local`),
KEY `idx_status` (`status`)
/*!40000 ALTER TABLE `fila_painel_runtime` DISABLE KEYS */;
/*!40000 ALTER TABLE `fila_painel_runtime` ENABLE KEYS */;
