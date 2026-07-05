# MD-observacoes_eventos-colunas — Colunas

## Tabela: `observacoes_eventos`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `entidade` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'FILA_SENHA |
| `id_entidade` | bigint | unsigned NOT NULL |
| `contexto` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'MEDICO |
| `tipo` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'OBSERVACAO |
| `texto` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |

---

## Índices

PRIMARY KEY (`id`),
KEY `id_usuario` (`id_usuario`),
KEY `idx_entidade` (`entidade`,`id_entidade`),
KEY `fk_observacoes_eventos_entidade` (`id_entidade`),
CONSTRAINT `fk_observacoes_eventos_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `observacoes_eventos_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `observacoes_eventos` DISABLE KEYS */;
/*!40000 ALTER TABLE `observacoes_eventos` ENABLE KEYS */;
