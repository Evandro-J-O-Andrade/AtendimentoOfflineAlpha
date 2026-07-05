# MD-ffa_estado-colunas — Colunas

## Tabela: `ffa_estado`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_estado` | bigint | unsigned NOT NULL AUTO_INCREMENT |
| `nome` | varchar(100) | NOT NULL |
| `descricao` | varchar(255) | DEFAULT NULL |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_estado`),
UNIQUE KEY `uk_ffa_estado_nome` (`nome`)
/*!40000 ALTER TABLE `ffa_estado` DISABLE KEYS */;
/*!40000 ALTER TABLE `ffa_estado` ENABLE KEYS */;
