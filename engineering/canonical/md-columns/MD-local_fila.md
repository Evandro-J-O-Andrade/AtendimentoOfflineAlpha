# MD-local_fila-colunas — Colunas

## Tabela: `local_fila`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_local_fila` | bigint | NOT NULL AUTO_INCREMENT |
| `id_local` | bigint | NOT NULL |
| `codigo_fila` | varchar(40) | DEFAULT NULL |
| `nome_fila` | varchar(120) | DEFAULT NULL |
| `prioridade` | int | DEFAULT '0' |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_local_fila`),
KEY `idx_fila_local` (`id_local`),
CONSTRAINT `fk_fila_local` FOREIGN KEY (`id_local`) REFERENCES `local` (`id_local`)
/*!40000 ALTER TABLE `local_fila` DISABLE KEYS */;
/*!40000 ALTER TABLE `local_fila` ENABLE KEYS */;
