# MD-estoque_produto_codigo_externo-colunas — Colunas

## Tabela: `estoque_produto_codigo_externo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_codigo_ext` | bigint | NOT NULL AUTO_INCREMENT |
| `id_produto` | bigint | NOT NULL |
| `sistema_externo` | enum('SIGTAP','TUSS','SIMPRO','BRASINDICE','OUTRO') | NOT NULL |
| `codigo_externo` | varchar(80) | NOT NULL |
| `preferencial` | tinyint(1) | NOT NULL DEFAULT '0' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_sessao_usuario` | bigint | NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_codigo_ext`),
UNIQUE KEY `uk_prod_sistema` (`id_produto`,`sistema_externo`,`codigo_externo`),
KEY `fk_cod_ext_sessao` (`id_sessao_usuario`),
CONSTRAINT `fk_cod_ext_prod` FOREIGN KEY (`id_produto`) REFERENCES `estoque_produto` (`id_produto`)
/*!40000 ALTER TABLE `estoque_produto_codigo_externo` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_produto_codigo_externo` ENABLE KEYS */;
