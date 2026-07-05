# MD-produto-colunas — Colunas

## Tabela: `produto`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_produto` | bigint | NOT NULL AUTO_INCREMENT |
| `tipo_produto` | varchar(40) | NOT NULL |
| `categoria` | varchar(120) | DEFAULT NULL |
| `subcategoria` | varchar(120) | DEFAULT NULL |
| `nome` | varchar(255) | NOT NULL |
| `unidade_medida` | varchar(20) | DEFAULT NULL |
| `codigo_barras` | varchar(100) | DEFAULT NULL |
| `codigo_interno` | varchar(100) | DEFAULT NULL |
| `codigo_sigtap` | varchar(50) | DEFAULT NULL |
| `codigo_gpat` | varchar(50) | DEFAULT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_produto`)
/*!40000 ALTER TABLE `produto` DISABLE KEYS */;
/*!40000 ALTER TABLE `produto` ENABLE KEYS */;
