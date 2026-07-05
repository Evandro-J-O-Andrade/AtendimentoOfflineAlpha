# MD-tipo_local-colunas — Colunas

## Tabela: `tipo_local`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_tipo_local` | bigint | NOT NULL AUTO_INCREMENT |
| `codigo` | varchar(40) | NOT NULL |
| `nome` | varchar(120) | NOT NULL |
| `categoria` | varchar(40) | NOT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `categoria_operacional` | varchar(40) | DEFAULT NULL |
| `atualizado_em` | datetime(6) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_tipo_local`),
UNIQUE KEY `uk_tipo_local_codigo` (`codigo`)
/*!40000 ALTER TABLE `tipo_local` DISABLE KEYS */;
/*!40000 ALTER TABLE `tipo_local` ENABLE KEYS */;
