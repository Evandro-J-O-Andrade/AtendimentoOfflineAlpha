# MD-prescricao_checagem_dupla-colunas — Colunas

## Tabela: `prescricao_checagem_dupla`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_dupla_checagem` | bigint | NOT NULL AUTO_INCREMENT |
| `id_checagem_principal` | bigint | NOT NULL |
| `id_usuario_testemunha` | bigint | NOT NULL |
| `data_hora` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_dupla_checagem`),
KEY `fk_dupla_principal` (`id_checagem_principal`),
KEY `fk_dupla_testemunha` (`id_usuario_testemunha`),
CONSTRAINT `fk_dupla_principal` FOREIGN KEY (`id_checagem_principal`) REFERENCES `prescricao_checagem` (`id_checagem`),
CONSTRAINT `fk_dupla_testemunha` FOREIGN KEY (`id_usuario_testemunha`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `prescricao_checagem_dupla` DISABLE KEYS */;
/*!40000 ALTER TABLE `prescricao_checagem_dupla` ENABLE KEYS */;
