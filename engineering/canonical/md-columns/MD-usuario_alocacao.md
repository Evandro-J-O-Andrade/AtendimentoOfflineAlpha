# MD-usuario_alocacao-colunas — Colunas

## Tabela: `usuario_alocacao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_alocacao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | NOT NULL |
| `id_sala` | int | NOT NULL |
| `id_especialidade` | bigint | DEFAULT NULL |
| `inicio` | datetime | NOT NULL |
| `fim` | datetime | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_alocacao`),
KEY `fk_usuario_alocacao_usuario` (`id_usuario`),
KEY `fk_usuario_alocacao_especialidade` (`id_especialidade`),
CONSTRAINT `fk_usuario_alocacao_especialidade` FOREIGN KEY (`id_especialidade`) REFERENCES `especialidade` (`id_especialidade`) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT `fk_usuario_alocacao_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE
/*!40000 ALTER TABLE `usuario_alocacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_alocacao` ENABLE KEYS */;
