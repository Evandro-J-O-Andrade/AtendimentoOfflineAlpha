# MD-atendimento_transicao_ledger-colunas — Colunas

## Tabela: `atendimento_transicao_ledger`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `uuid_transacao` | char(64) | NOT NULL |
| `estado_origem` | varchar(60) | DEFAULT NULL |
| `estado_destino` | varchar(60) | DEFAULT NULL |
| `fingerprint_hash` | char(64) | DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
UNIQUE KEY `uk_transacao_uuid` (`uuid_transacao`),
KEY `idx_transicao_hash` (`fingerprint_hash`),
KEY `fk_atendimento_transicao_ledger_atendimento` (`id_atendimento`),
KEY `idx_atrans_ent` (`id_entidade`),
CONSTRAINT `fk_atendimento_transicao_ledger_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_atendimento_transicao_ledger_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `atendimento_transicao_ledger` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_transicao_ledger` ENABLE KEYS */;
