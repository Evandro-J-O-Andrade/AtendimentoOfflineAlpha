# MD-paciente_cns-colunas — Colunas

## Tabela: `paciente_cns`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_paciente_cns` | bigint | NOT NULL AUTO_INCREMENT |
| `id_paciente` | bigint | NOT NULL |
| `cns` | varchar(20) | NOT NULL |
| `status` | enum('ATIVO','INATIVO') | NOT NULL DEFAULT 'ATIVO' |
| `validado` | tinyint(1) | NOT NULL DEFAULT '0' |
| `origem` | enum('MANUAL','IMPORTADO','SUS','INTEGRACAO') | NOT NULL DEFAULT 'MANUAL' |
| `data_validacao` | datetime | DEFAULT NULL |
| `observacao` | varchar(255) | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_paciente_cns`),
UNIQUE KEY `uk_paciente_cns_ativo` (`id_paciente`,`cns`,`status`),
KEY `ix_paciente_cns_paciente` (`id_paciente`),
KEY `ix_paciente_cns_cns` (`cns`)
/*!40000 ALTER TABLE `paciente_cns` DISABLE KEYS */;
/*!40000 ALTER TABLE `paciente_cns` ENABLE KEYS */;
