# MD-estoque_item-colunas — Colunas

## Tabela: `estoque_item`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_item` | bigint | NOT NULL AUTO_INCREMENT |
| `codigo_interno` | varchar(50) | DEFAULT NULL |
| `codigo_barras` | varchar(128) | DEFAULT NULL |
| `codigo_tuss` | varchar(20) | DEFAULT NULL |
| `nome_comercial` | varchar(255) | NOT NULL |
| `categoria` | enum('MEDICAMENTO','MATERIAL_MEDICO','SUTURA','GASES','HIGIENE','TI','MANUTENCAO') | NOT NULL |
| `unidade_venda` | varchar(10) | NOT NULL DEFAULT 'UN' |
| `is_faturavel` | tinyint(1) | DEFAULT '1' |
| `id_sessao_usuario` | bigint | NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_item`),
UNIQUE KEY `codigo_interno` (`codigo_interno`),
UNIQUE KEY `codigo_barras` (`codigo_barras`)
/*!40000 ALTER TABLE `estoque_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_item` ENABLE KEYS */;
