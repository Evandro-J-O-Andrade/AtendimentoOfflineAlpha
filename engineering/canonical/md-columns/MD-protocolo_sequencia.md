# MD-protocolo_sequencia-colunas — Colunas

## Tabela: `protocolo_sequencia`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `chave` | varchar(80) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `ultimo_numero` | int | NOT NULL DEFAULT '0' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`chave`)
/*!40000 ALTER TABLE `protocolo_sequencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `protocolo_sequencia` ENABLE KEYS */;
