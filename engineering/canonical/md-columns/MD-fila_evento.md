# MD-fila_evento-colunas — Colunas

## Tabela: `fila_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_fila` | bigint | NOT NULL |
| `evento` | enum('GERADA','CHAMADA','NAO_ATENDIDO','REENTRADA','ABERTURA_FFA','ENCAMINHAMENTO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `id_usuario` | bigint | DEFAULT NULL |
| `id_local` | bigint | DEFAULT NULL |
| `detalhe` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `id_fila` (`id_fila`),
CONSTRAINT `fila_evento_ibfk_1` FOREIGN KEY (`id_fila`) REFERENCES `fila_senha` (`id`)
/*!40000 ALTER TABLE `fila_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `fila_evento` ENABLE KEYS */;
