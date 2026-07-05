# MD-local-colunas — Colunas

## Tabela: `local`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_local` | bigint | NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_tipo_local` | bigint | NOT NULL |
| `codigo` | varchar(40) | DEFAULT NULL |
| `nome` | varchar(120) | NOT NULL |
| `andar` | varchar(20) | DEFAULT NULL |
| `bloco` | varchar(20) | DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_local`),
KEY `idx_local_unidade` (`id_unidade`),
KEY `idx_local_tipo` (`id_tipo_local`),
KEY `idx_local_entidade` (`id_entidade`),
CONSTRAINT `fk_local_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_local_tipo` FOREIGN KEY (`id_tipo_local`) REFERENCES `tipo_local` (`id_tipo_local`),
CONSTRAINT `fk_local_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `local` DISABLE KEYS */;
/*!40000 ALTER TABLE `local` ENABLE KEYS */;
