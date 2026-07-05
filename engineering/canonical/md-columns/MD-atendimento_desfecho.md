# MD-atendimento_desfecho-colunas — Colunas

## Tabela: `atendimento_desfecho`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_desfecho` | bigint | unsigned NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `tipo_desfecho` | enum('ALTA','TRANSFERENCIA','OBITO','REMOCAO','CONVENIO') | COLLATE utf8mb4_unicode_ci NOT NULL |
| `observacao` | text | COLLATE utf8mb4_unicode_ci |
| `criado_em` | datetime(6) | NOT NULL DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_desfecho`),
KEY `idx_desfecho_atendimento` (`id_atendimento`),
KEY `idx_adesf_ent` (`id_entidade`),
CONSTRAINT `fk_atendimento_desfecho_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_atendimento_desfecho_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_desfecho_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`)
/*!40000 ALTER TABLE `atendimento_desfecho` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_desfecho` ENABLE KEYS */;
