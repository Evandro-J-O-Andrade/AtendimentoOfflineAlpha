# MD-sus_cid10_competencia-colunas — Colunas

## Tabela: `sus_cid10_competencia`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_cid10c` | bigint | NOT NULL AUTO_INCREMENT |
| `competencia` | char(6) | NOT NULL |
| `cid10` | varchar(10) | NOT NULL |
| `descricao` | varchar(255) | DEFAULT NULL |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_cid10c`),
UNIQUE KEY `uk_cid10c_comp` (`competencia`,`cid10`),
KEY `ix_cid10c_cid` (`cid10`)
/*!40000 ALTER TABLE `sus_cid10_competencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `sus_cid10_competencia` ENABLE KEYS */;
