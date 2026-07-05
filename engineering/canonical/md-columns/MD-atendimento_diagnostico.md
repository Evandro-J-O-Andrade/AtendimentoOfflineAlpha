# MD-atendimento_diagnostico-colunas — Colunas

## Tabela: `atendimento_diagnostico`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_diagnostico` | bigint | unsigned NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `codigo_cid` | varchar(10) | COLLATE utf8mb4_unicode_ci NOT NULL |
| `descricao` | varchar(255) | COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `principal` | tinyint(1) | DEFAULT '0' |
| `criado_em` | datetime(6) | NOT NULL DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_diagnostico`),
KEY `idx_diag_atendimento` (`id_atendimento`),
KEY `idx_adiag_ent` (`id_entidade`),
CONSTRAINT `fk_atendimento_diagnostico_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_atendimento_diagnostico_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_diagnostico_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`)
/*!40000 ALTER TABLE `atendimento_diagnostico` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_diagnostico` ENABLE KEYS */;
