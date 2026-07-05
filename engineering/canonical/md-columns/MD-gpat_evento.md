# MD-gpat_evento-colunas — Colunas

## Tabela: `gpat_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_gpat_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_gpat` | bigint | NOT NULL |
| `tipo_evento` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `detalhes` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `id_usuario` | bigint | DEFAULT NULL |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_gpat_evento`),
KEY `idx_gpat_evento_gpat` (`id_gpat`),
KEY `idx_gpat_evento_tipo` (`tipo_evento`),
KEY `fk_gpat_evento_usuario` (`id_usuario`),
KEY `fk_gpat_evento_sessao` (`id_sessao_usuario`),
CONSTRAINT `fk_gpat_evento_gpat` FOREIGN KEY (`id_gpat`) REFERENCES `gpat_atendimento` (`id_gpat`) ON DELETE CASCADE,
CONSTRAINT `fk_gpat_evento_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `gpat_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `gpat_evento` ENABLE KEYS */;
