# MD-reg_export_erro_validacao-colunas — Colunas

## Tabela: `reg_export_erro_validacao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_export_erro` | bigint | NOT NULL AUTO_INCREMENT |
| `id_export_item` | bigint | DEFAULT NULL |
| `id_export_arquivo` | bigint | DEFAULT NULL |
| `severidade` | enum('INFO','WARN','ERRO','FATAL') | NOT NULL DEFAULT 'ERRO' |
| `codigo` | varchar(60) | DEFAULT NULL |
| `campo` | varchar(120) | DEFAULT NULL |
| `mensagem` | varchar(500) | NOT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_export_erro`),
KEY `idx_reg_erro_item` (`id_export_item`),
KEY `idx_reg_erro_arquivo` (`id_export_arquivo`),
KEY `idx_reg_erro_data` (`criado_em`),
CONSTRAINT `fk_reg_erro_arquivo` FOREIGN KEY (`id_export_arquivo`) REFERENCES `reg_export_arquivo` (`id_export_arquivo`),
CONSTRAINT `fk_reg_erro_item` FOREIGN KEY (`id_export_item`) REFERENCES `reg_export_item` (`id_export_item`)
/*!40000 ALTER TABLE `reg_export_erro_validacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `reg_export_erro_validacao` ENABLE KEYS */;
