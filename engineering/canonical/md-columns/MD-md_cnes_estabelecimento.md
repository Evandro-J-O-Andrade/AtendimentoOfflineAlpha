# MD-md_cnes_estabelecimento-colunas — Colunas

## Tabela: `md_cnes_estabelecimento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `cnes` | char(7) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `competencia` | char(6) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `nome_fantasia` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `razao_social` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `cnpj` | varchar(20) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `uf` | char(2) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `municipio_ibge` | varchar(10) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `logradouro` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `numero` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `bairro` | varchar(120) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `cep` | varchar(12) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `telefone` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `tipo_gestao` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `esfera_adm` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `atualizado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`cnes`),
KEY `idx_cnes_comp` (`competencia`)
/*!40000 ALTER TABLE `md_cnes_estabelecimento` DISABLE KEYS */;
/*!40000 ALTER TABLE `md_cnes_estabelecimento` ENABLE KEYS */;
