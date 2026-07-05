# MD-erro_catalogo-colunas — Colunas

## Tabela: `erro_catalogo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_erro_catalogo` | bigint | NOT NULL AUTO_INCREMENT |
| `codigo` | varchar(20) | NOT NULL |
| `dominio` | varchar(50) | NOT NULL |
| `descricao` | varchar(255) | NOT NULL |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `criado_em` | datetime(6) | NOT NULL DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_erro_catalogo`),
UNIQUE KEY `codigo` (`codigo`),
KEY `idx_erro_catalogo_dominio` (`dominio`)
/*!40000 ALTER TABLE `erro_catalogo` DISABLE KEYS */;
/*!40000 ALTER TABLE `erro_catalogo` ENABLE KEYS */;
