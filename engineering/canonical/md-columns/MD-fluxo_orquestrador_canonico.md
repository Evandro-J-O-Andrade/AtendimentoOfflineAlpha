# MD-fluxo_orquestrador_canonico-colunas — Colunas

## Tabela: `fluxo_orquestrador_canonico`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_orquestrador` | bigint | NOT NULL AUTO_INCREMENT |
| `dominio_fluxo` | varchar(50) | NOT NULL |
| `estado_atual` | varchar(50) | NOT NULL |
| `estado_proximo` | varchar(50) | NOT NULL |
| `regra_execucao` | json | NOT NULL |
| `exige_assinatura_digital` | tinyint(1) | DEFAULT '0' |
| `timeout_execucao_segundos` | int | DEFAULT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(6) |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_orquestrador`),
UNIQUE KEY `uk_ffa_orquestrador_fluxo` (`dominio_fluxo`,`estado_atual`,`estado_proximo`),
KEY `fk_fluxo_orquestrador_canonico_atendimento` (`id_atendimento`),
KEY `idx_foc_ent` (`id_entidade`),
CONSTRAINT `fk_fluxo_orquestrador_canonico_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_fluxo_orquestrador_canonico_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `fluxo_orquestrador_canonico` DISABLE KEYS */;
/*!40000 ALTER TABLE `fluxo_orquestrador_canonico` ENABLE KEYS */;
