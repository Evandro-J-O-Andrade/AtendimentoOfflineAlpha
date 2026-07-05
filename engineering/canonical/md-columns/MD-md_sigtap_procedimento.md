# MD-md_sigtap_procedimento-colunas — Colunas

## Tabela: `md_sigtap_procedimento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `competencia` | char(6) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `codigo` | varchar(10) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `nome` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `complexidade` | enum('BASICA','MEDIA','ALTA') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `sexo_restricao` | enum('A','M','F') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'A' |
| `idade_min_meses` | int | DEFAULT NULL |
| `idade_max_meses` | int | DEFAULT NULL |
| `valor_sa` | decimal(10,2) | DEFAULT NULL |
| `valor_sh` | decimal(10,2) | DEFAULT NULL |
| `valor_sus` | decimal(10,2) | DEFAULT NULL |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `atualizado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`competencia`,`codigo`),
KEY `idx_sigtap_codigo` (`codigo`)
/*!40000 ALTER TABLE `md_sigtap_procedimento` DISABLE KEYS */;
/*!40000 ALTER TABLE `md_sigtap_procedimento` ENABLE KEYS */;
