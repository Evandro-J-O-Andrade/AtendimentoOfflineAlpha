# MD-sus_competencia-colunas — Colunas

## Tabela: `sus_competencia`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_competencia` | bigint | NOT NULL AUTO_INCREMENT |
| `competencia` | char(6) | NOT NULL |
| `descricao` | varchar(120) | DEFAULT NULL |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_competencia`),
UNIQUE KEY `uk_sus_competencia` (`competencia`)
/*!40000 ALTER TABLE `sus_competencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `sus_competencia` ENABLE KEYS */;
