# MD-sus_sigtap_procedimento-colunas — Colunas

## Tabela: `sus_sigtap_procedimento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_sigtap` | bigint | NOT NULL AUTO_INCREMENT |
| `competencia` | char(6) | NOT NULL |
| `codigo` | varchar(30) | NOT NULL |
| `descricao` | varchar(255) | NOT NULL |
| `grupo` | varchar(80) | DEFAULT NULL |
| `subgrupo` | varchar(80) | DEFAULT NULL |
| `forma_organizacao` | varchar(80) | DEFAULT NULL |
| `complexidade` | varchar(40) | DEFAULT NULL |
| `sexo` | enum('I','M','F') | NOT NULL DEFAULT 'I' |
| `idade_min` | int | DEFAULT NULL |
| `idade_max` | int | DEFAULT NULL |
| `exige_cat_default` | tinyint(1) | NOT NULL DEFAULT '0' |
| `exige_sinan_default` | tinyint(1) | NOT NULL DEFAULT '0' |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_sigtap`),
UNIQUE KEY `uk_sigtap_comp_cod` (`competencia`,`codigo`),
KEY `ix_sigtap_codigo` (`codigo`),
KEY `ix_sigtap_comp` (`competencia`),
KEY `ix_sigtap_exige_cat` (`exige_cat_default`)
/*!40000 ALTER TABLE `sus_sigtap_procedimento` DISABLE KEYS */;
/*!40000 ALTER TABLE `sus_sigtap_procedimento` ENABLE KEYS */;
