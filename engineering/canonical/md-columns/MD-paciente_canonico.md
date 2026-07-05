# MD-paciente_canonico-colunas — Colunas

## Tabela: `paciente_canonico`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_paciente` | bigint | NOT NULL AUTO_INCREMENT |
| `uuid_paciente` | char(36) | NOT NULL |
| `hash_identidade` | char(64) | NOT NULL |
| `nome` | varchar(200) | NOT NULL |
| `data_nascimento` | date | DEFAULT NULL |
| `sexo` | char(1) | DEFAULT NULL |
| `documento_principal` | varchar(50) | DEFAULT NULL |
| `metadata_identidade` | json | DEFAULT NULL |
| `estado_paciente` | enum('ATIVO','INATIVO','BLOQUEADO','DUPLICADO_PENDENTE_RECONCILIACAO') | DEFAULT 'ATIVO' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_paciente`),
UNIQUE KEY `uk_paciente_uuid` (`uuid_paciente`),
UNIQUE KEY `uk_paciente_hash` (`hash_identidade`),
KEY `idx_paciente_nome` (`nome`)
/*!40000 ALTER TABLE `paciente_canonico` DISABLE KEYS */;
/*!40000 ALTER TABLE `paciente_canonico` ENABLE KEYS */;
