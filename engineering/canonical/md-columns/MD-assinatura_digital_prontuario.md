# MD-assinatura_digital_prontuario-colunas — Colunas

## Tabela: `assinatura_digital_prontuario`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa_evolucao` | bigint | NOT NULL COMMENT 'FK para atendimento_evolucao' |
| `hash_assinatura` | text | NOT NULL |
| `certificado_serial` | varchar(255) | DEFAULT NULL |
| `data_assinatura` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_usuario` | bigint | NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `idx_ass_evolucao` (`id_ffa_evolucao`),
KEY `idx_ass_usuario` (`id_usuario`),
CONSTRAINT `fk_ass_digital_evolucao` FOREIGN KEY (`id_ffa_evolucao`) REFERENCES `atendimento_evolucao` (`id`) ON DELETE CASCADE,
CONSTRAINT `fk_ass_digital_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `assinatura_digital_prontuario` DISABLE KEYS */;
/*!40000 ALTER TABLE `assinatura_digital_prontuario` ENABLE KEYS */;
