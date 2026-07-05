# MD-medico_especialidade-colunas — Colunas

## Tabela: `medico_especialidade`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_usuario` | bigint | NOT NULL |
| `id_especialidade` | bigint | NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_usuario`,`id_especialidade`),
KEY `fk_medico_especialidade_assoc` (`id_especialidade`),
CONSTRAINT `fk_medico_especialidade_assoc` FOREIGN KEY (`id_especialidade`) REFERENCES `especialidade` (`id_especialidade`) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT `fk_medico_especialidade_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE
/*!40000 ALTER TABLE `medico_especialidade` DISABLE KEYS */;
/*!40000 ALTER TABLE `medico_especialidade` ENABLE KEYS */;
