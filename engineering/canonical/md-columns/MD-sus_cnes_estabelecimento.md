# MD-sus_cnes_estabelecimento-colunas — Colunas

## Tabela: `sus_cnes_estabelecimento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_cnes` | bigint | NOT NULL AUTO_INCREMENT |
| `competencia` | char(6) | NOT NULL |
| `cnes` | varchar(20) | NOT NULL |
| `nome` | varchar(255) | DEFAULT NULL |
| `municipio` | varchar(120) | DEFAULT NULL |
| `uf` | char(2) | DEFAULT NULL |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT NULL |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_cnes`),
UNIQUE KEY `uk_cnes_comp_cnes` (`competencia`,`cnes`),
KEY `ix_cnes_cnes` (`cnes`)
/*!40000 ALTER TABLE `sus_cnes_estabelecimento` DISABLE KEYS */;
/*!40000 ALTER TABLE `sus_cnes_estabelecimento` ENABLE KEYS */;
