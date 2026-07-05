# MD-estoque_produto-colunas — Colunas

## Tabela: `estoque_produto`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_produto` | bigint | NOT NULL AUTO_INCREMENT |
| `id_codigo_universal` | bigint | DEFAULT NULL |
| `sku_interno` | varchar(60) | NOT NULL |
| `barcode` | varchar(60) | DEFAULT NULL |
| `nome` | varchar(255) | NOT NULL |
| `categoria` | enum('MEDICAMENTO','MATERIAL','OPME','INSUMO','LABORATORIO','OUTRO') | NOT NULL |
| `subcategoria` | varchar(120) | DEFAULT NULL |
| `marca` | varchar(120) | DEFAULT NULL |
| `id_unidade_medida` | binary(16) | NOT NULL |
| `exige_lote` | tinyint(1) | NOT NULL DEFAULT '1' |
| `controlado` | tinyint(1) | NOT NULL DEFAULT '0' |
| `exige_receita` | tinyint(1) | NOT NULL DEFAULT '0' |
| `controlado_anvisa` | tinyint(1) | NOT NULL DEFAULT '0' |
| `registro_anvisa` | varchar(50) | DEFAULT NULL |
| `curva_abc` | enum('A','B','C') | DEFAULT NULL |
| `estoque_minimo` | decimal(15,4) | DEFAULT NULL |
| `estoque_maximo` | decimal(15,4) | DEFAULT NULL |
| `ponto_reposicao` | decimal(15,4) | DEFAULT NULL |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `id_sessao_usuario` | bigint | NOT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_produto`),
UNIQUE KEY `uk_sku` (`sku_interno`),
UNIQUE KEY `uk_barcode` (`barcode`),
KEY `fk_prod_sessao` (`id_sessao_usuario`)
/*!40000 ALTER TABLE `estoque_produto` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_produto` ENABLE KEYS */;
