# MD-usuario_setor-colunas — Colunas

## Tabela: `usuario_setor`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_usuario_setor` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | NOT NULL |
| `id_setor` | int | NOT NULL |
| `pode_operar` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_usuario_setor`),
UNIQUE KEY `uk_usuario_setor` (`id_usuario`,`id_setor`),
KEY `idx_us_setor_usuario` (`id_usuario`),
KEY `idx_us_setor_setor` (`id_setor`)
/*!40000 ALTER TABLE `usuario_setor` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_setor` ENABLE KEYS */;
