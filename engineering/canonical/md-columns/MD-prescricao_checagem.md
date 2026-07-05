# MD-prescricao_checagem-colunas — Colunas

## Tabela: `prescricao_checagem`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_checagem` | bigint | NOT NULL AUTO_INCREMENT |
| `id_prescricao_item` | bigint | NOT NULL |
| `id_usuario_enfermeiro` | bigint | NOT NULL |
| `data_hora_checagem` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `status` | enum('ADMINISTRADO','RECUSADO','PACIENTE_AUSENTE','JEJUM') | DEFAULT 'ADMINISTRADO' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_checagem`),
KEY `fk_checagem_item` (`id_prescricao_item`),
KEY `fk_checagem_usuario` (`id_usuario_enfermeiro`),
CONSTRAINT `fk_checagem_item` FOREIGN KEY (`id_prescricao_item`) REFERENCES `prescricao_item` (`id_item`),
CONSTRAINT `fk_checagem_usuario` FOREIGN KEY (`id_usuario_enfermeiro`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `prescricao_checagem` DISABLE KEYS */;
/*!40000 ALTER TABLE `prescricao_checagem` ENABLE KEYS */;
