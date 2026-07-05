# MD-perfil-colunas — Colunas

## Tabela: `perfil`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_perfil` | bigint | NOT NULL AUTO_INCREMENT |
| `codigo` | varchar(60) | NOT NULL |
| `nome` | varchar(120) | NOT NULL |
| `contexto` | varchar(40) | DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_perfil`),
UNIQUE KEY `uk_perfil_codigo` (`codigo`),
KEY `idx_perfil_ativo` (`ativo`)
/*!40000 ALTER TABLE `perfil` DISABLE KEYS */;
/*!40000 ALTER TABLE `perfil` ENABLE KEYS */;
