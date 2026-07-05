# MD-chamado_evento-colunas — Colunas

## Tabela: `chamado_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_chamado_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_chamado` | bigint | NOT NULL |
| `evento` | varchar(80) | NOT NULL |
| `id_usuario` | bigint | DEFAULT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_chamado_evento`),
KEY `idx_chev_chamado` (`id_chamado`),
KEY `fk_chev_user` (`id_usuario`),
CONSTRAINT `fk_chev_chamado` FOREIGN KEY (`id_chamado`) REFERENCES `chamado` (`id_chamado`),
CONSTRAINT `fk_chev_user` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `chamado_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `chamado_evento` ENABLE KEYS */;
